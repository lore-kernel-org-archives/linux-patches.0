Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405E73446C8;
	Wed,  3 Dec 2025 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779349; cv=none; b=OB0opXvUSQztgtydyUnkTjlJC46SYhl7B0brkNNSV5Xe9JRMdFKfFHX6NlWgeoYJYORJnGtuWcUSuSkGdUyBvYvUCBlDw4roKBIdwROCz1z7AnhzQDfXf9NiLeEJGSrVmPUT9bJUTs90utPw3nm37T6b7LU/Hxv8e1C05U+zBQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779349; c=relaxed/simple;
	bh=VteeuswbGr88K/PlCqPf74slkToVzu7DWSVZs78s4U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXQuiAT5gm4Qo2CjkpFc81cMcO5TbV0ro4i3A1YCvZrQej4fKBSnDNTHm9M+Lpkk+Z/rc9YFKMVoyV/LxTR9HBwid0fS9nH0vW6mRJakIvQnVnXlJOlYUnhD7uRFs8VBk2d2QV+z3A+w9RGzvloXOH3t7TXlAb5p3MsdaSDMqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUfMuOlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUfMuOlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4794C116B1;
	Wed,  3 Dec 2025 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779349;
	bh=VteeuswbGr88K/PlCqPf74slkToVzu7DWSVZs78s4U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUfMuOlBVYp58DsfbEGOnYSzdGx+5sTWaX38grlChbAoCncgp9Pi2BCnXyVVieb5q
	 bNVk4XecBccjV04wWUTylg2AUblpYs9ySTbM8kVU0XVNmbgFpJxH++zJA5gMCMaaD6
	 wzSWIjjHx3Xki/Ex1LIDedjXslUjo7N/UzwQTzn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nai-Chen Cheng <bleach1827@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 231/568] selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency
Date: Wed,  3 Dec 2025 16:23:53 +0100
Message-ID: <20251203152449.182333744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aae64eb2ae737..bf34fa443b233 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -250,7 +250,7 @@ gen_tar: install
 	@echo "Created ${TAR_PATH}"
 
 clean:
-	@for TARGET in $(TARGETS); do \
+	@for TARGET in $(TARGETS) $(INSTALL_DEP_TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
 	done;
-- 
2.51.0



