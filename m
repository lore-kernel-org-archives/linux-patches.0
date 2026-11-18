Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031852;
	b=3iymL1iXEmXuRS9zfh5hoStl5zyUa45XbmaBMs6Citqb9NDOPXXweuRViUBjNnxU8olF
	 yIYh+TL7RZD4cJfKfwWIA3aOrlbHLqjONWUfZtniADLRSz44iwoEz5bplbAJMK+d03tCI
	 1Nb8vkJqNGAV2gxFlfrAR4OuGwv33jmAsxE0mnZkFnqVgwsykR4CMTzslHXE1qFQEQ/Aa
	 Zhm94ig/pVgvYVlOeYeOR3mZ67AI29sl2Nk1eviHZphkGNOzlw6px8UQwiXkRS/pEzAXn
	 S/awLvyC7d28MHIJnaAYMYaYa4/dtiopgRRtnJuq+xeKn59t7xMFwckVbwgL+PJf1ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IvHS/UHmPu8aKVbBbNFAFLmJnAK6mkNkvdJ76BrAaEQ=;
	b=pDZ01qtk/w6ejvb0c2P162uJL72TQoeLFQWs230wYpi4ceSXX/vuzVcibfYbViGrOQLT
	 izNa4CV9cI+/a4BYNSzAgj6rzs9mPiw/KF86t9qQL8qD25qE6sOTcG0mfttsiSX5VyYEd
	 ac5sjnZUg0NdaSAKBZHQNy7d2XNWxdKhVWcQ0JehE2ufgSMg2bko82hgvRgkKwkDdDe4Z
	 XeQcs9Vw/z0YFD5XWCGLy5Xisy9IX9NSZZmBlAzCsJl+8SU+Hl371m56RjgycAC300vUu
	 uP9HLkTGeW++4OM5KY/rs7B+vpM3rlLwOCTZOBqtvorC7mGvm42yuqTklA+yXgCb2Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eL0MIP1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98CE606A320;
	Wed, 18 Nov 2026 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eL0MIP1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C216F1F000C4;
	Wed, 18 Nov 2026 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031852;
	bh=IvHS/UHmPu8aKVbBbNFAFLmJnAK6mkNkvdJ76BrAaEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL0MIP1B4bgHjtV0V+idDFag0zH2UYWxxU2h0cN4eMVepOsFqs4erBYMTyD758Z29
	 JCrfK1pp0ydjaa78VbGhMZ+heOPLe9LlrStnTDMlJtWq9zUEq10f7U8WRdSmvsFx8p
	 RwI9UhFa7oHryV8z5S4kfjw9WWB8v0oeCMsa2M4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1205/1756] ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control
Date: Wed, 18 Nov 2026 15:55:32 +0100
Message-ID: <20261118150057.795335937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 96d30816a9a4fa6b3cc470f82d0f53e8a6425ab9 ]

The EQ3 band 1 gain is in WM5100_EQ3_1, not in WM5100_EQ1_1, which
holds the EQ1 band 1 gain.

Fixes: 6d4baf084f4d ("ASoC: Add WM5100 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/d7f690e391feda7a6d8f38d0b238b165bc1f4fe2.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 11bbc94a282c7..227b45dc1b1c9 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -658,7 +658,7 @@ SOC_SINGLE_TLV("EQ2 Band 4 Volume", WM5100_EQ2_2, WM5100_EQ2_B4_GAIN_SHIFT,
 SOC_SINGLE_TLV("EQ2 Band 5 Volume", WM5100_EQ2_2, WM5100_EQ2_B5_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 
-SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ1_1, WM5100_EQ3_B1_GAIN_SHIFT,
+SOC_SINGLE_TLV("EQ3 Band 1 Volume", WM5100_EQ3_1, WM5100_EQ3_B1_GAIN_SHIFT,
 	       24, 0, eq_tlv),
 SOC_SINGLE_TLV("EQ3 Band 2 Volume", WM5100_EQ3_1, WM5100_EQ3_B2_GAIN_SHIFT,
 	       24, 0, eq_tlv),
-- 
2.53.0



