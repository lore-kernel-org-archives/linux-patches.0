Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266482BE7B8;
	Tue, 11 Nov 2025 01:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824020; cv=none; b=tpwNUzgLFPa93Ek8EfYP+5z6O61Ro3MuCIf1gCRSr8ASkDza9JvBYEmJurbTcYlSoS9bB3l+0oh+1D3KGmyHLHQPjgCCh/5ybhSh+W6ufw+K5N6idpQLFOdGiyj2iiZETRmCYo2Vp9m4pjndHoQFg2MHxLGJbN38VkKw5LjBBqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824020; c=relaxed/simple;
	bh=uzLJeing1bwJwjYFgA9Eg2DEYZT4ri1IoBkJtG1H6f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAOOKjgu7+R/FhYN8M4URjPFCMWA9mGlLS+TG26QNX3+MO0omB4h0WRjaGjzucDT7XVtbBqK4UUWqDwSzlALdyYEiSlXJ8WucZNP0L1yrORR4/iwTjLj9QY8ptPejynfHHNNIj92M8xqYccytUMlCbNdo0FTnvl/jsqM5FFdzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgcBkSpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgcBkSpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B892BC4CEFB;
	Tue, 11 Nov 2025 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824020;
	bh=uzLJeing1bwJwjYFgA9Eg2DEYZT4ri1IoBkJtG1H6f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgcBkSpUPmWRnv3C6EYyOD+B2SyfOSJ3n+KbwWVmzHgwLJZR3ifubrN0Z4NYiT6OX
	 3DX5kj6qk2bIXYk67hVO4WqlerZsas6EchDZsLVEQf/9Y+jrfVtl1SvV2KM3lFVeUM
	 qqElz68wjlvCIfXp4cMawbTubOCUmzMQ6BqJlwE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nai-Chen Cheng <bleach1827@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/565] selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency
Date: Tue, 11 Nov 2025 09:43:48 +0900
Message-ID: <20251111004535.235825913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 85c5f39131d34..a9e363b7f489f 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -296,7 +296,7 @@ gen_tar: install
 	@echo "Created ${TAR_PATH}"
 
 clean:
-	@for TARGET in $(TARGETS); do \
+	@for TARGET in $(TARGETS) $(INSTALL_DEP_TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
 	done;
-- 
2.51.0



