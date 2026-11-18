Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049765;
	b=wTMtVT3MtNFG0QJuQpnwtyuEZxLHqF8TUJ/wiKnfVkij6FaRhDrCIWn87mCN4iPPkr6S
	 bHXJ2hod4MYVlsHem6HzPwbYMKCOFfRE7FKzLsz82nBrmxYdLa58QFfUhwpTWeFpZFriJ
	 trPX8PSHej9M3f0fWZW4Uixc5rNcLkDcAvKMOAqd2ahRuLuU8i2feS8FjDePsmBLeuUmN
	 f2WhpvUafpAWxWRE220/8qkfyM79OrCLreTW3O8w1oWni/lTqb8l8YDgpOjoikooIoO4m
	 IlBxgwyQb+DhAgYSTkJDgwdHCzOiqeC9bNAqsrotOwnapa8skx3OshXEuLg87E5QjWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X6aQrX+3tTz/AdpCLe1Wu1yvEzR9dq4CgI05SO2LU/s=;
	b=EvptIJzXjVuZXVBdGyBZa9OWi2Tod3vN+Gn6By3tnNjDr1dFgohof0m8ethVIMQw77RU
	 SnGtp3UOGwHSS3KX/jwe0ysTHewFBRgogUJzJ7p3TGwNnW1fPumWcbaf39QmL9f6OMdK5
	 ZqRiLtl0PLVMk5bhOhXUssfS3eMCptpfio426/c+qJy8oSyQCFglZBPpyuaMMG4QnKnV5
	 8s2gNHGJSR/az6Eu1mXSO6mi5RgIWf2Iri94beuXoq6exwMDCghZhkXprK7WKOa99VnOV
	 W9qA/YO3TcN8RrLou1lY2OYmP2NZn/p/v5AOXJDcFA1tYxuZa2rd0rpqvZ6MoRp2l9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiVaOYUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96366606A320;
	Thu, 19 Nov 2026 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiVaOYUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D51F000C4;
	Thu, 19 Nov 2026 00:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049765;
	bh=X6aQrX+3tTz/AdpCLe1Wu1yvEzR9dq4CgI05SO2LU/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiVaOYUe7JBTMHovmuyS2wly4BJVvGpLmS7lMndM71Vp7aLVMFpwwxzthHeabJOg6
	 nKp7S1ZioHmEYuogOstlrmg2a5FtjrgES/IC9mSgUSHpbnKA78HXoyZgLxJIpVj7jT
	 hhViaX4zPWxgdd+NL93HLPBZOksl8+TgZQwYm8dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2468/2857] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:58:22 +0100
Message-ID: <20261118150330.429139685@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 75e0b607e3456c9eb15dfb783984f814a89cbcaf ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87b3bfa7711b61d89c21044d02fb3242dd934385.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 7ab849f41ad67..a28da451a065e 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -112,7 +112,7 @@ SOC_SINGLE_TLV("LOMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER5,
 SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
 	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
 SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
-	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
+	WM8990_LLBLOVOL_SHIFT, WM8990_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 /* ROMIX */
 SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER4,
-- 
2.53.0



