Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036445;
	b=GQsP3FAVNsYhpnSMhDKOZDn4vFBl+OJqLTM5ETEzzv3UZvlIw2N430jU4u1DV2gvFeVG
	 4kLXuF8wfuiVDik6F7UkX7udx5K6929nVKYjlXchUS9Po1Xv9rEwBtp/5KAfQtVJYPaCH
	 KWN+9IlSByc6vo4CNTd7toxi/tcsGm8vBRTaHerbvCF+0Y/7wq1DBjU1FhQT2d36z/wiu
	 h99LZNz2JdvLxfYtIkY/8kMsRdr8xb8u14A+eu6Yv2HJh3dDn4+Fn5SdOII0gn75wD75c
	 WmzQ8sUrF2zYjOcLUsKsP0qGl+D7sGr1cuI4Wiv0WIIuk3BI06KOBEVoBlrGYPTHIEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3rTaPCtHfSrQgQjGpUlIq/eeCAOwC2GetghhwdfjiJQ=;
	b=O/qYUWI9LzXguxblykAKk+0HCMirHt1sIB9QJV9JlxFdKdhyM0iOexcWKkyuoU1AEC/D
	 tJAWnxIjy/ec2aDHeSIwiruUmAvTw2zazFlwyLC41QwtQU9C8vsVNxntJWDQ5BbVTd8zb
	 5nrpxk9NSQFEGZ51O8vrqqYDX5MmQ3s41bHJS5KD7ldOxlAeY/MBJuIwXK1ojFA/lt32t
	 xUitrhV6u84YrBYsormwgAs44Yv+7uD7lPEWbY97YJ2jQ183psY8HETc8DB9huVwpFyb7
	 02+250xxq4S0SW5m6vJ/cPaa9CkPBT/U5dzNjJdnHrOOorkhUrXw+0lBDS1h99VGlxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4tL+M9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08F9606A32C;
	Wed, 18 Nov 2026 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4tL+M9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5441F000C4;
	Wed, 18 Nov 2026 21:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036444;
	bh=3rTaPCtHfSrQgQjGpUlIq/eeCAOwC2GetghhwdfjiJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4tL+M9Yu79nVv0JZ64s5h0RGW82qpeYxWSRM3qaXoEdkRQNBbdx5z1k4hrVDS2ju
	 bqNu3DaZ8PN5er89O6fMHFXV4zdn3YKyBUJGdU4wDIM0JibMe1XBL/2uulBETn0l6S
	 wkl7XkEEmzVy1WD1JYnvVm/KbVmI0/92WemklGE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1018/3318] wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz
Date: Wed, 18 Nov 2026 15:27:20 +0100
Message-ID: <20261118150350.423895167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



