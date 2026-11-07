Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063149;
	b=gv6aY+ciUBhm69+27CI4z86naJdWIjsVRQ8V8OFnKR9WE4WhXZrlFaVaUxN88JVvs0aY
	 76/GQncgRp0WXpKXmum4/c4x3OlkRGd0Pnb5m0kj1mqTcvhrsS98IRKV2Xs2+rFG8GEe3
	 Yj66JVPXBHOWRzkvms57CcCV4WVpc2aZ/wlBOjhl6GdspE4s1WiGqQHCcrbAKOtM0sWoU
	 dZ6KmkYROCnY53tiKtvQM8xBramM2FI2N6dsGPX2DvnV8ORh17hQ+059Y0NxeLlJfyptA
	 Lc4Jt3N8N5+ngGg40eY5ESpssS4yMiwnPN5oQsCHI6Hloq5OtciQS+GjMQj2bsah8Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zH3Gm3Jc6DRc/FvgKce2F+WZf3N10QveKpZ0aS+b/pU=;
	b=Iytnmm0YI65labbRC1zwy/yN54SMEzNVsnmDWdURvadIOJ/PAFXasJdD/rqpEDgfbiWZ
	 PbrnpZdW7toLP2K2L32goRXJU5P7zW/G5bZ1eRdJZUamVFUhlr2DuiY0UijaGgOO3SIOs
	 VLJ2OnX6UScCYRocMOu6LteslFjzDN1uFlWJjQxG6ynmu+HoXTTF++TZIbp4X+9+OXPID
	 vG01QAHEtL0bcP8McSOzQ4PKaBckh6Xxx4eDfnQA8HU8BE9BCQZI21i2LDRgC/PrtXnEm
	 8navW1keOuxCU+czGOlKHJMhqmvLvP/09vwyvMRUI6vy8jI0jl2Y72o3FQ+kR06Xgag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAHu2HAC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47064606A331;
	Sat,  7 Nov 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WAHu2HAC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2041F0089F;
	Sat,  7 Nov 2026 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063148;
	bh=zH3Gm3Jc6DRc/FvgKce2F+WZf3N10QveKpZ0aS+b/pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WAHu2HACrO9IkKVDMXJLArckxEo8Kuev3QapC11lyDifeui+/hrDDnBSRwSMAbSnt
	 GbNobnD8j7UpU1Z9/GdYvBn4lA3wzqshiZPwqvtUC4LkxEc219TE62TaRRC87rcKdQ
	 IWIRcj0gcn9lSr0JOGtIpdtGl8IzFYQsQkQ52h30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/869] wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz
Date: Sat,  7 Nov 2026 08:50:56 -0500
Message-ID: <20261107134905.680205633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f7463a9c99a506b3308a852f9aaaf2a26b659e95 ]

After a recent change in clang to warn on signed char conversions within
array initializers [1], there is a warning (or error with
CONFIG_WERROR=y / W=e) from nphy_ipa_rxcal_gaintbl_2GHz:

  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:224:18: error: implicit conversion from 'int' to 's8' (aka 'signed char') changes value from 128 to -128 [-Werror,-Wconstant-conversion]
    224 |         {0, 0, 0, 0, 0, 128},
        |         ~               ^~~
  1 error generated.

This value was introduced in the original staging merge of brcmsmac in
commit a9533e7ea3c4 ("Staging: Add initial release of brcm80211 - Broadcom
802.11n wireless LAN driver.") and it is the same in the proprietary
driver [2]. Presumably it is correct since there have been no reported issues,
so update the value to '-128' to be type correct and clear up the warning.

Cc: stable@vger.kernel.org
Fixes: a9533e7ea3c4 ("Staging: Add initial release of brcm80211 - Broadcom 802.11n wireless LAN driver.")
Link: https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e [1]
Link: https://lore.kernel.org/1a107e21b08.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com/ [2]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20261005-brcmsmac-clang-24-constant-conversion-v1-1-a30c5692d582@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index b03d5a1f1a936..7fd3e018affe2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -221,7 +221,7 @@ static const struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = {
 };
 
 static const struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = {
-	{0, 0, 0, 0, 0, 128},
+	{0, 0, 0, 0, 0, -128},
 	{0, 0, 0, 0, 0, 70},
 	{0, 0, 0, 0, 0, 20},
 	{0, 0, 0, 3, 0, 20},
-- 
2.53.0



