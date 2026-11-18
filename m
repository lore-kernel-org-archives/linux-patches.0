Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054649;
	b=HKsodChhUtuuRBO4/RXVFFAyKO2ppFgp8+f8rrMz+GKo1GakW91XhlEb2/7xSK2pcSgr
	 PHmO/u6jbUwUs1I9TriFwO1ElbMnSComazmVPKGNreUf9CKGvob3TYE+QyqCzod20dXNP
	 qUFOpKB2dc5HQpoFCxUtqdy7Q92kunNENwL88Yi3jp1bwKShStSavSOcaT2ccvXG1OJtA
	 0/iaAphBeeIJjyNGFwA2Cu1dHwLmyFTC1XNYtdSB5rvy4R8xk7erp4Bn//caax5o+0UQZ
	 m+7jwvB45xMkxWXPdTOq/68jXjorTbXrmrY9DHIvUk9zulqBiwSgWbcBmaxsx9SGrUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D+pMe6+NHq/iZ612C3pbhRXV9Jq/GRu80NZkrvExN08=;
	b=sLPxiGLOxtmyVKoZdRmlHRwfCNfNPN1uoz1cPMnJSeaXNXGCtQ/UshTIX5xLWNWfcp3Q
	 9uTLWss6NmbiaxKypnZbyqK7CPeuzoR8pNCn+1n4nKGgyNdi028g36DTZJAklSDqjVJ2w
	 zprUuxmnqt4Ii+rpNLu2n5QVzeBl3vgnjCJGp+KAbhBtkax8RHz4pj1wxP8NhxYMpYZMQ
	 6g3qJdcTfXhpEKq7PO3roya2cskCugQBFY2fvAXA2kJeuMpVfpv2Nb9eQoWV77FO57U5v
	 dJzzElv3lY6jWxOeco++KxEqNoVFsK7Unn5puiXOXSKue/FI1f1yuTfktf4UaKQXWHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjISV4oq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB02606A31C;
	Thu, 19 Nov 2026 02:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjISV4oq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E71C1F000C4;
	Thu, 19 Nov 2026 02:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054649;
	bh=D+pMe6+NHq/iZ612C3pbhRXV9Jq/GRu80NZkrvExN08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjISV4oqVSrozj/+nUuDvjyswlhIigjfGVLtRb1fQr/88Naj1brX29rFFZSKtVU0d
	 KPxTRkM9jQicuGkALMzMrF/lmtO1Qfh3/9GwFhx8ie8oaXSJaeGcE09hkKUszy60px
	 456YFtF1bYgExSBjnSWYWnxeAEq4s0cAJSMWzVs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrishikesh Suresh <hrishikesh123s@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1350/2214] perf: replace strcpy() with strncpy() in util/jitdump.c
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118150105.457622571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hrishikesh Suresh <hrishikesh123s@gmail.com>

[ Upstream commit 9bef5cead63d5d8fad3ba7ebaf26f3f4ee172c82 ]

Usage of strcpy() can lead to buffer overflows. Therefore, it has been
replaced with strncpy(). The output file path is provided as a parameter
and might be restricted by command-line by default. But this defensive
patch will prevent any potential overflow, making the code more robust
against future changes in input handling.

Testing:
- ran perf test from tools/perf and did not observe any regression with
  the earlier code

Signed-off-by: Hrishikesh Suresh <hrishikesh123s@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 4eddf7d9e341 ("perf jitdump: Use dirname() return value in jit_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index cd15b6704485f..eb9e01faa721c 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -245,7 +245,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	/*
 	 * keep dirname for generating files and mmap records
 	 */
-	strcpy(jd->dir, name);
+	strncpy(jd->dir, name, PATH_MAX);
+	jd->dir[PATH_MAX - 1] = '\0';
 	dirname(jd->dir);
 	free(buf);
 
-- 
2.53.0



