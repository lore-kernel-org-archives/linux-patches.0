Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045328;
	b=5G/smKZEu0WEpvfzJeocFW9/YNiNx1BykkbWPrPDxvgeVgyHO8TunFDkeSnIQRFz7ePu
	 Qv5tbCHkInT7Hqh2iyHMLonbJniRYNnNvRl3Ko/ACgjQHTx48b7Pc98okRgdaPn+syycl
	 qjoQWD44/782gnfc/wEExPcljCjWFY9fFWK5OGsoWGPo4sqAEEX4xDZbqxfV5604R0652
	 tCsKVFR7Kdxha8oCshC1vrqEK4gAXdKhJkukOhRpXVQYcNmSrWXFIq3UWvYOdbon/R5Vp
	 wWyPzNQrjfcIh1zSRGsInKi5r5NUnkXUm+YonQ6y+FPlTZNQC1+QF5gKvTdx6XVQBEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ffUZtDhkj48EbnaxOXUnuyK1NxvoLxdQofIuVuVPAI=;
	b=BpGBBM7/k9IgQdr5vPXPXt9kyK7SRuKbZGehvqdh8TDxEaSmA3ZemfxYoAQCjOAJmHzC
	 EqzqKjzel6wCnLEEFPWZAvV49mq9xRhpbcdIQe4VNv1jF897bHgpekuqFHaEeF9eeZFXd
	 ntiO79Nps8q4tFUr/zEqfVtl+nbY1ZvwoVNw8ryGyIi6PaJgA3au5Lv/MdIOYhQssp5B4
	 oxnzzFyLz9Hgpr78ouuXl2W0ap8/YqOQnFnfByMLbqU5CjLhTE5DB+nurSxf3qXs1808l
	 jp/Wv2x34gFpehmMAmQT3GI2XYmUbtIb5J0YfDYFv+90nFye1KawUk5eDI+3/dUu5Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueh0v3jm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2DC606A320;
	Wed, 18 Nov 2026 23:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueh0v3jm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1421F000C4;
	Wed, 18 Nov 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045328;
	bh=4ffUZtDhkj48EbnaxOXUnuyK1NxvoLxdQofIuVuVPAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueh0v3jmczO7CrjMPqCVMIUBwZIj/32+GzIoCL9MP0lqyBHpkzUY8PsbSfjbsd1E4
	 mb5IiuleLXsasq5Pg28ajUrnT4mZlw6vSKdOgCQcEDesekX2OumuxLg6R+KqMWVYGC
	 Cw+EcMAcMRtFjpyrC52HL2aIQf7pfTGNFNl6H9tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0882/2857] wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz
Date: Wed, 18 Nov 2026 15:31:56 +0100
Message-ID: <20261118150233.316647923@linuxfoundation.org>
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
index 42e7bc67e9143..930f22418a4c4 100644
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



