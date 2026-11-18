Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020328;
	b=4COG3783IDtkouCkR2ZR3juakz4iI8paEue8mpbN+jgeHjNF+ptHvcz/aqOyc1YDZPBd
	 LEn0hA4wE593jRustwT02cdrdvIAmNWMmAy/K/EYaE+tj8L9+K7J3FiVCqWy5LWrUcR+m
	 e5gyWx7TK0vhX5iZd3fV54H4eVQOq/xIIRYU8eHypACj5COsMqXqwf5RAQkKu2Q075jhI
	 uqzuoZjWHgJr3DkjsTM3GvwqyedycjVWWoAkmcaoDxdRf/7mBBwbDD2XOi2M2odKxcitX
	 PXgVxmE4LP5XRn90lNHN2S01QkcsAC9xrPrfTmXorPHnsvcZcwtWCU7wXvgYUIBaqxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+I0vzpImm6r2TVO5+SX7n4C1vOrZYm7NEtQPHuK2JU=;
	b=eI0f20oE79V6yU/1NIiWTo/0vtrXIQmHOV7ODFxORUc59naZslFI0tBh0E/uYwJDy6Kh
	 5m1vfC5ohW+9sboWvgasCgPjmJRxAnNFaxMd+81QriDzAc5Q774FkhI11AjF08ORkKJCb
	 A3JIeFL3e1XCjk0j1EUA46NDqKfhJ8bBJrhKHRS1n9mfd/lbmUkYm7mHJiVL9YWcez0Yp
	 5vfBMbGECclDNPq2i8HWs5sCEjrP96xFvATP5DSeK08qPVAUeTg2yOL9CVgiowP31W8ih
	 1ovnJ33lNeJ5l084FTYLZrTF8JjWKXc0C0mo6Lu0Tubff3IHFMn4a3G+YzqYNe9cuwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqEHWcdT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FD606A325;
	Wed, 18 Nov 2026 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqEHWcdT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6531F000C4;
	Wed, 18 Nov 2026 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020327;
	bh=L+I0vzpImm6r2TVO5+SX7n4C1vOrZYm7NEtQPHuK2JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqEHWcdTY+ZR3tXuBEA7zZGWfp1PI5Bza04NXpxjcaJTz6YZGiIVnmyqnxRGejSyO
	 uUkXgh6YLR7DFwYAMP80cwmvxUe/2zPlaSc2TAQYhadrybdZEy5X5lLOsusAKHIO1Z
	 Y9/PqiLtpQqWmLz/DnQrJUrVHx15IJ8cf9+SwFPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1911/2651] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150355.583305069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit a7a89019bac0e8810bde7f1419f4adf9adc23d41 ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index c485217ba880c..6c01fdb6667e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -262,7 +262,7 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



