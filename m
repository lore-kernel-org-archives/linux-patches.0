Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022873;
	b=zzcQ55O/HSkVB3nX4J512fKDjJ7h3LBTxBoDDtaNHpjm4gEPonu7HA5yxdvGY2Ycuc+X
	 3gAAndmeNiXYKLi8iIScZaLs6P+IS2anAZCl2qZ8fas00UOGGnEsH4U31ivMVGbmHBigb
	 MSWiYTryIPeXhAQuiuX3HvwompjZlBSdbSGNEvFqkJF+mKSI/KpzG5wPFs64kRs0m1qeq
	 8IBQpKlJDnwCRybXyxYBPjPz+q+tl1nbBPhhkqSgc4klt55KLo2hVycaB9QzP50ZM3SG/
	 d2kKIwTto1vwviBnJXvtAXhODvcwB9QageW7f6KuVRW2tWSz+Rpc/4+hbM4R0hYJCZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9We0RRI4sdvPseW6o/WYi0Mbxtt3YZxO+20iy7X0hk=;
	b=dJfXYxSNUyC1rsI91AmA76U11aM797tNZxgoxGWbNO9/Zx0zFIa2qxuPHPsv/BoaDEdJ
	 Upuz3fgypbihdH/zRlG/KPrb20AxWOm3S3ya898blciYpD98j4etct5FndXA5hBpO85xf
	 zZ3qYZNtHFc+24KcvWtxaSPiLX1Ek3DI8czUziwIvzSMsd+dAPjcZWiA5+AqexuGYb+r+
	 KyLhBoKen98WtbmtKBXM+Zp29VFcomyysX2d0oloM0Qh4HHcA+XZ3v3YdKdYbEYBC9cGb
	 L4HpNOTR43rhCfucsalDbXGR4T2Zt/3iwcXZEERv1WnzcTU0aBcIRZE93c/o4DnZksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnRDNbvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7835A606B5FB;
	Wed, 18 Nov 2026 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnRDNbvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD141F000C5;
	Wed, 18 Nov 2026 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022873;
	bh=Y9We0RRI4sdvPseW6o/WYi0Mbxtt3YZxO+20iy7X0hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnRDNbvm21x5A5zrBByyPx8Q58tWUefAJibMKzXaf65b68EKm2PW/DrTjXsS2K/hE
	 EvTFx8pdYTDSrtm7PWeIek4hRk9ylgjvUqcvZYv3NhuQ6tjgHeuDiyPUYhpi58RCK8
	 Gu1gyHutKvgpPcaQH1T+buWwPyWecZuDMsE1uF1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrishikesh Suresh <hrishikesh123s@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0167/2151] perf: replace strcpy() with strncpy() in util/jitdump.c
Date: Wed, 18 Nov 2026 15:31:42 +0100
Message-ID: <20261118150127.830337590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5f4af5d890ac6..343ee182b946e 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -239,7 +239,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



