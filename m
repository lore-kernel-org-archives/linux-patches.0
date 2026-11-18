Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047757;
	b=3nAdY5Gz7RWgg8qVE4BTOn1xs7XZeal/JLvt899G4LnrYvzsy3iDee0YVEio7gMoAwZG
	 kbnrpPJ184Y/L9MuSXwnYDoNFk8XbtoWzEkJSig3mPpx7sR6YUeNJTy+suuWmjuv0qlfq
	 oAG1BWlnanZkFJA4b2ISzwYgtM3i9Xkeu92EfxfjuNmaTqO3otEfTXMj717mjUi++C7iV
	 gXSVKQbw8Utd2anInxROUnArmdcf9m6KmVeqOLDfAJwohCnpkK5azMs+CX7/hdt8MDEBp
	 KPb6VisSDq+5EpjFY5LPRqAMDKY166uJkKy6IkamfzqFjkRS5PcdYeeFV7vw92QRVwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nWvTyxVIaIWdqyoao0x4p07FPJCT38878dSP3S8yJ7E=;
	b=hrSHyYVLBB4xVIsSENLCYVZMpZ6vHns9oN7VI6X2cnktKklmTCsqJF9Atrxk9+B/brQu
	 26GaWH4oFYFXLkUMaY326eLr1PbQYk3ijvFVEkwpNLYwQ2upzFZQUjrQ1f1uSZ/EEY6pH
	 U4lFgHslp401lrrZlUSBLbq8i/TdwzfBU0D95k1XG2M9D2JD/Puye1RC6pmV1tHPH1/VE
	 PvVD/DztD7+CsMvnCeGjcezEzjkXDuIQVXqNPo0+V1rp8N1262LFms1CwncJf9BD9Wscp
	 xUvnuUUSqLkHJXS7ra8BuhMEPQsw4tx8XC6p+cC0kmbvfSeaSSLtpPvVLV+uCr3tt0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0YlX/QPD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763C6606A31C;
	Thu, 19 Nov 2026 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YlX/QPD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9CE1F000C4;
	Thu, 19 Nov 2026 00:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047757;
	bh=nWvTyxVIaIWdqyoao0x4p07FPJCT38878dSP3S8yJ7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YlX/QPDYtatPAylei8Ib4EyUAsdD0xBuP3FahJngMPtIMVvs4ZJp/EZ/d+e3kTX3
	 5rE5S4d2bf9QRfmLJmCdZLeaDbh7bJ/Edv8BdSE6JElH7DTc+TCLOXfqt+ar8OKWpf
	 7HDNVqYYFLk3O2hVvgpvd3hW6opCd5PjuoqvUfgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrishikesh Suresh <hrishikesh123s@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1753/2857] perf: replace strcpy() with strncpy() in util/jitdump.c
Date: Wed, 18 Nov 2026 15:46:27 +0100
Message-ID: <20261118150304.415274398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e8fff117364e..c5e9be11473ae 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -238,7 +238,8 @@ jit_open(struct jit_buf_desc *jd, const char *name)
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



