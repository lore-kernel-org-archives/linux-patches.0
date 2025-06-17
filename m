Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528012ED855;
	Tue, 17 Jun 2025 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177615; cv=none; b=C0S5R6lA4U5rf3nO95HhS4FPd7hEkbgc11eOLIirSNh2HTxxabZdDzoOwo9jYAOFw6gvSDs4891SL8rAl8kzs5zI/DddTi/eBH6eEfIalXWezWAZblv6WH7R0k2550BYEAugQl8sCsCQAYutGP1YcXVT+AV2lU4yfhBaG9TCFas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177615; c=relaxed/simple;
	bh=JDleZXXE9v1/hS+3wMmS9M3ZMzGiwJBcTIaFBIKpL3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFPHuY+yEx0fkyGIVYzjDVV2hzDGZ/xSoKBjv4mKP4lzCZXIL3Ch4WkI1Il1NZLEDEY9r10mRaOovueZ9WxB1NPu063IxcO3GpX1tGIvy9EzO1IFyaDwnv+o8GsZR/VRHG8xwbZnqhwsCchXhkERp1m/H0bxzUr8pgIwbvlIHWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzqeHv6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzqeHv6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DB3C4CEE3;
	Tue, 17 Jun 2025 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177613;
	bh=JDleZXXE9v1/hS+3wMmS9M3ZMzGiwJBcTIaFBIKpL3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzqeHv6ktheW/MsTbdkqweUPqbByjCIio6s8jOicIa1THLvDCUi5t9ltzmp9KJJ3Q
	 1Yp4OoFJATNEbD05vm+qv2mU+1rezm2RrgtQ8LehkUjPATloXsj3PhPC+vOB02qYsH
	 mzFxGzjVKaOYFFSUC73hemkpXgNXyuzFYDUBXPBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/512] selftests: net: build net/lib dependency in all target
Date: Tue, 17 Jun 2025 17:25:37 +0200
Message-ID: <20250617152434.623002031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit d3f2a9587ebe68f5067f9ff624f9a83dfb911f60 ]

We have the logic to include net/lib automatically for net related
selftests. However, currently, this logic is only in install target
which means only `make install` will have net/lib included. This commit
adds the logic to all target so that all `make`, `make run_tests` and
`make install` will have net/lib included in net related selftests.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://patch.msgid.link/20250601142914.13379-1-minhquangbui99@gmail.com
Fixes: b86761ff6374 ("selftests: net: add scaffolding for Netlink tests in Python")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 9cf769d415687..85c5f39131d34 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -196,7 +196,7 @@ export KHDR_INCLUDES
 
 all:
 	@ret=1;							\
-	for TARGET in $(TARGETS); do				\
+	for TARGET in $(TARGETS) $(INSTALL_DEP_TARGETS); do	\
 		BUILD_TARGET=$$BUILD/$$TARGET;			\
 		mkdir $$BUILD_TARGET  -p;			\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET	\
-- 
2.39.5



