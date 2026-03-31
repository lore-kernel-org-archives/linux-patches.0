Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207C72FF669;
	Tue, 31 Mar 2026 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976704; cv=none; b=kJHKB66OVdQnTwycrgjOntoCaPIelqCp/H1Fdm8xcBBD2jfdFsrIBNt4YmS+GxkmHegF1IoolSTOQ5AFa22ZACIX/hRnTdqaHuu46QsoxqdSl9wI02NjKf6STym/u6U4mVD9iekqlaTUMJXd9Nd5cr8hhOxSIVgY+NeiYnditWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976704; c=relaxed/simple;
	bh=KPZL/qVPu7alVUDGVdnWxmInHAwlITxsr17kg2limeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WufvZ/w4Do3r+osjrCsaLLqOlUnURi635oox1tFWFkrYhGmeDIbE8gJB8wfeMFmbpIHvNeeLN9KnouEmOjT1c+7bKkxY09VLxWMcOvfvmJpVVWcxbK/yY3wssYJwpPesh3+GzL5VChfRAt/yAkgEuQiJ21QB4v5nslxXqvI8RPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bqu05KCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bqu05KCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B4CC19423;
	Tue, 31 Mar 2026 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976703;
	bh=KPZL/qVPu7alVUDGVdnWxmInHAwlITxsr17kg2limeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bqu05KCKoOoxo7VYuyFGUS2BeXOCxzCo2igScZFwiI2z0axlfieO9QY4PWZwdSdx7
	 xdLvvOxEvfcbRk8cV/NAE6dezexS+6eWcffpUtPkUvFl585NL1YO2fvgFYddSg0iDf
	 qozbkqXkQulxRMfWJU/Z5nMxoet6XsuFqL32IHgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Mirabile <cmirabil@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.18 194/309] kbuild: Delete .builtin-dtbs.S when running make clean
Date: Tue, 31 Mar 2026 18:21:37 +0200
Message-ID: <20260331161800.596541916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1588,7 +1588,7 @@ CLEAN_FILES += vmlinux.symvers modules-o
 	       modules.builtin.ranges vmlinux.o.map vmlinux.unstripped \
 	       compile_commands.json rust/test \
 	       rust-project.json .vmlinux.objs .vmlinux.export.c \
-               .builtin-dtbs-list .builtin-dtb.S
+               .builtin-dtbs-list .builtin-dtbs.S
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_FILES += include/config include/generated          \


