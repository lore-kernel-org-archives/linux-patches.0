Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFA7313538;
	Wed,  3 Dec 2025 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776232; cv=none; b=nsAGVK4Im7+NItXif3qJ2t0f4FzfSjtZGNtu0zPU8b23fl5//M26FNNZmiU8awftLXRPvmaxKAe3xux7ataPpeAfcRWTM4XfXdytdeObnb5txwPOGstqu7RTAvAKyZXrnQEDJwZso6hLH75ji7YF9p7JVxvY2XEJMqdVK9R8mOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776232; c=relaxed/simple;
	bh=K/pnlAbI45SqbXM8YUVdLiMw6bj+RhLxaAviVyHsl98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmBsZQqwTB5EOznFZObHoOPvNW4jYoREgzaDLf92LJnmLc9s7fBoAu60N0FUpl2BQ65aJdJJSW5crdTUVqtCCeOt8i7sLOi9E3Nq1O1L674gWOe0PkMjMSqSnnT/J5HPd8r0dOhrS8CPXJK68cmgc5vB/MfYHX840VwPbLOAfz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGxIjJRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGxIjJRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30A3C4CEF5;
	Wed,  3 Dec 2025 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776232;
	bh=K/pnlAbI45SqbXM8YUVdLiMw6bj+RhLxaAviVyHsl98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGxIjJRZltVqWNY08q94cayDgMaZDqPaj2VHs/YebIemPf9Trv4FCfEqHPCBa7TDd
	 p0Z+sUmXUwYdZkMAHTeBGq4iLEgdIzaS4bsVLKR5T78hwu/WHU6Tm8c/hpDvNSibaM
	 Gnuz47DcvJLn41tGO0atCrMGsuaybtIzpXhhrdzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nai-Chen Cheng <bleach1827@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/300] selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency
Date: Wed,  3 Dec 2025 16:25:24 +0100
Message-ID: <20251203152405.062951873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nai-Chen Cheng <bleach1827@gmail.com>

[ Upstream commit d3f7457da7b9527a06dbcbfaf666aa51ac2eeb53 ]

The selftests 'make clean' does not clean the net/lib because it only
processes $(TARGETS) and ignores $(INSTALL_DEP_TARGETS). This leaves
compiled objects in net/lib after cleaning, requiring manual cleanup.

Include $(INSTALL_DEP_TARGETS) in clean target to ensure net/lib
dependency is properly cleaned.

Signed-off-by: Nai-Chen Cheng <bleach1827@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/20250910-selftests-makefile-clean-v1-1-29e7f496cd87@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index db1e24d7155fa..1d33d2d298dfc 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -257,7 +257,7 @@ gen_tar: install
 	@echo "Created ${TAR_PATH}"
 
 clean:
-	@for TARGET in $(TARGETS); do \
+	@for TARGET in $(TARGETS) $(INSTALL_DEP_TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
 	done;
-- 
2.51.0



