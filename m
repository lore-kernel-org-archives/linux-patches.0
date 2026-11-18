Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026773;
	b=fHc5GwpDs/seUnFQiTg4EvBmkDK6UwG1PiVQDnEuBRlD/PidOpA3fvPywSeHN7GNypS8
	 nZp0+6WiuxurhCGF4MfonxPAZmPHOl5f/EsTaHZ8Bbwkyx7szbntn8dtJpbuqQArP7kmS
	 DK4fHvX5Fd+0VLyRu1TVs+fQ8X0KJeukpOUMg4KjI+g8aWGcl3CZDONNziHgYDFtfUsdT
	 NgfC7iCskuTv1Oq2GdY6K7gmF/LNPilo6c9v632behov06AEL4hTMs7I1OgsetLnBIFoL
	 HO07JbQhXbXVRl3hfQVNqV2rzgmYmiWp/9OhODqmTqGLNMjErDI9wYq28ZCfbZEACXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBA1oponkJUp+im6RK0Bjeu9f0AOJUzIyJQCI4hV30M=;
	b=hRxiS3XO6d4ZqqiGkjwY4Sc4nmfWcMvdbLm08+4mk53yiPwMXzaO2ynlZfRonvi3nTtL
	 X5Pib1P3FpK2bGildZK2PxR/ZKTqDuQVmTRH5MahYR56f/eME30Qo5UOITjaZSY2Dl01a
	 Ba9xSL3EVC2u8CaFLIl7xwiiJsCQzqEPgjW5yHgr/ByyOaLDmZ9TI1Jp63DRVU5OwDSIi
	 2ziDZduBLzeD5aDFptB5/4nRExBRsp+SGnVYH8Zs2LeFmn1Vuk4Ad5/AUsHv0A0v5QX50
	 155ALivXel43SLExlT4GTREdb2qDSPnMcPL+cwMJFdCC3hcR+TvSdVg9SPe6ieuy0yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zL+BSuJz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F7A606A320;
	Wed, 18 Nov 2026 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zL+BSuJz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE3D1F000C4;
	Wed, 18 Nov 2026 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026773;
	bh=hBA1oponkJUp+im6RK0Bjeu9f0AOJUzIyJQCI4hV30M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zL+BSuJzkvdw0oaT0zk1zmHa+Q/7rWvBBRv63cEOZi84QuJq0EnJEExKoWFUxDGMv
	 d2RNoddp+gsfDVqEKA1z6BtMU/YRBKvT99VMrJSruworwpJiWMfDUkwnIodHUZ0Pm3
	 JftG7Z1I94yTZa8Le8mD1Xzrpdla5kZtN6DLCjfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1552/2151] net: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:54:47 +0100
Message-ID: <20261118150218.439781201@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit fbd3a301b1378423a5cfc23a42e3c0b04e26192c ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 3d79133a91a61..cdff8c310f825 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -205,7 +205,7 @@ static int net_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



