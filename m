Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEDA425CFF;
	Tue, 31 Mar 2026 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975239; cv=none; b=sxkuZiw+fpQ2fMSWeDYeupYBS+4Yf8ThIHFQVLSjd55viW4i0HcT0BLQNISaO1/pWtEU5HzZkGHGWlyzju73Oksk5Gpdm4FZZo6CZOkbHFAoUi3WgVoK4dGdO5pUQnh9OHxYRJf8bsbHxTy//jz7Iqjoq5KF/62LxbzjtHxcyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975239; c=relaxed/simple;
	bh=cJyHQtG7UFZuPeajUCcxsp9RIeYShhE+PgVzwrWYMXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cis4fdndWNCb6lrBva6pVH6wc0tVC3kP21E9ZNjV8cr0JBomQTu3+eaBeBvjau1GqyLiEEGiWLCD16osC9JMKQ0pnNzTCtAk3hFoOaFXWK05jCEiwKxMRHz+cJQOHA6TIli7ugUZ7zbrY7+7znA/+W5SWsEp/B45/KHqfGTkGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxPn7RhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxPn7RhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E6CC19423;
	Tue, 31 Mar 2026 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975239;
	bh=cJyHQtG7UFZuPeajUCcxsp9RIeYShhE+PgVzwrWYMXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxPn7RhD4TltMfjqHWz1HVZLMpKaY9yPeyPMmVMIUkUgJecgzIEHNs7hEmiB8Oixj
	 TVZs9zVkAV1LpuQOmT+Dkx16oZ+VHNnfAKFxULzxiK6tF0ltOG7tni6XAyCPg8OzIV
	 OpCG5THCou7cJeu6jy8zAo7M00keRRYcw3+ILMac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Mirabile <cmirabil@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.19 217/342] kbuild: Delete .builtin-dtbs.S when running make clean
Date: Tue, 31 Mar 2026 18:20:50 +0200
Message-ID: <20260331161806.961922776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Mirabile <cmirabil@redhat.com>

commit a76e30c2479ce6ffa2aa6c8a8462897afc82bc90 upstream.

The makefile tries to delete a file named ".builtin-dtb.S" but the file
created by scripts/Makefile.vmlinux is actually called ".builtin-dtbs.S".

Fixes: 654102df2ac2a ("kbuild: add generic support for built-in boot DTBs")
Cc: stable@vger.kernel.org
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260308044338.181403-1-cmirabil@redhat.com
[nathan: Small commit message adjustments]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1622,7 +1622,7 @@ CLEAN_FILES += vmlinux.symvers modules-o
 	       modules.builtin.ranges vmlinux.o.map vmlinux.unstripped \
 	       compile_commands.json rust/test \
 	       rust-project.json .vmlinux.objs .vmlinux.export.c \
-               .builtin-dtbs-list .builtin-dtb.S
+               .builtin-dtbs-list .builtin-dtbs.S
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \


