Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052624;
	b=LuiP+HGQjU+QcmNqkA86FuDTwEindHWk4yCJhHp2yHTsmVs9AMYMybogdhN6uPFUs/F6
	 HSmr0DqEkeSrRt9q5CRD4Y0WC4m0kY20mxHFfrQUIPEgVb41XSrKKWBKZ43BCrEKndgqy
	 slQotNnXRZVCHAyFS4V+tUT674WELm6JOjvj8up20T820zakI2g6c/D/FPvztZfeyX3bI
	 RJ35T+jilBcUkZ9BhrRdFg2DRP07RH0WmM5/xWrmo+df140ATCUOCqVtB2AFK9l+XQxWD
	 ShgDSuDIstkN/TvNKXILZXuML8RBoOotLriTTymGJZ7h9D/FgA7fnh+37hePaoi0yiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OymcvUreHGdo4VWNohR7Ns7URExRZfGn6E/yyoIE0cQ=;
	b=o+GA4QbwbKc5cmUKbLRAZdeuvKL7YFDtSuEhZfRZArr5mFcZ9OVPNZFZZGkhRIlX7r25
	 XMC4NHLdfnWcwsJJ+FdQqK8ZQa0D/FhvQHt7WC0vFRGx6IUzF3ULoRumiLgPXoPQ7kdCC
	 vmWjL8nR2GwTzyyMKVyzzQx6jpEg6HpDBPGz/DToSoZzN3jgAM/q0dWUv6GtCeY9zU2/b
	 VzGY1Xov2PM55hN5Pz+eYr/p4bCuVW6L5yvW37hvXTXNd2thrFaA2bPxovY44OIZijBFh
	 PIsnIk+sLjP+R5V9iEjW/s2ViVwCrDJvNSLo7mFZ646vdgvWg31NGye+7FFlgUu26Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geOnhUB+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C5D606A320;
	Thu, 19 Nov 2026 01:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geOnhUB+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C710E1F000C4;
	Thu, 19 Nov 2026 01:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052624;
	bh=OymcvUreHGdo4VWNohR7Ns7URExRZfGn6E/yyoIE0cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geOnhUB+Yg/KYuNKEd6KwanpZ9QqiJrT+VqqQYMu06wyG4RILW1x27LHtkUgzX5iT
	 rCZllmtNojy0ScSnzeA3CoFSGMgcIgJdzfwWBG3ulPqQrp7L520T4HvKjgPfLIBYm+
	 EzX29sT8F84dBFj0pu/mI5dnmXoqjdAHoAroYzyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0580/2214] wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz
Date: Wed, 18 Nov 2026 15:37:36 +0100
Message-ID: <20261118150034.137727083@linuxfoundation.org>
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



