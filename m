Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056322;
	b=O2tk7NSWnptjKYw36tsJB6jhI78ohbXlpLDyNScJnstV7DMbjKhFkISZX6UlBXsH71an
	 MIEPAyNqB2seL7wS1dmwG358xwGQYpbk9/7vgd/rX+tbxmTNqE9KfyIt+a8byF32YuBxY
	 jUgEhBkC9TH86yv+QvmUaBT3Byk4iv+OZgZT3iLmhWyDXwhRUrX7OFCO3MI9QlpECmZ1x
	 2dfManyg3Wa0K9xEEBck/Gqs5w3lbktr5oUwYwaN6JF0X0EAq/ZATE7BumOz5SDHEifGi
	 ehEDOvG9iIEXMlTfg4vhmiZFdOHaCygmSiUi7kQESbFFGvizFRgsXXKFwbS+M/4QmSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PcuAR5FJ1+V+29VnexdNs9p8yHiKNiHEKAjZ9Yz4Az8=;
	b=vhnsPnxp2/crybbmYd797uDsMI5vk6LvK6X13CaFZErXdbDEdhGYHPTfKZWUCIfoutXy
	 2NNHiB4At7woD3Yg9R5P5IMgV4x2BqB5QfDGzMR0Eybz9AHX4zTjY0OJBgPtz3G/53Yl3
	 fHWzG/VwYtRM/LXQwpmmdXSSMr3EOmxS1tccRfHJuajlfooJSgwO4cZSo3DXN7BS+ot4S
	 5xx/vujZ6qRGu2JbxDeK5tfQgnS9r9itwAhx90ciUdyQDl+fnAmPhnaxI79o6l+WqOBnq
	 hO5SSc/fyXQmkVdmXcqxgeqZPDy8X5+VSxmqT53t5W7aeM7isFJmWUa1TH/nqgqD4Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E9P+QWfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09796606A320;
	Thu, 19 Nov 2026 02:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E9P+QWfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7331F000C4;
	Thu, 19 Nov 2026 02:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056321;
	bh=PcuAR5FJ1+V+29VnexdNs9p8yHiKNiHEKAjZ9Yz4Az8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9P+QWfl1i31iPMr3zenZQesAysDOSsJskwhWG/FhrspM99/OkZecYs1qIGmumIZh
	 pYfVTO9+zVI18JACXSGBx8pOaSxReWGGAmRIQMDcrzi359eWbRedTIj44Y3MFYpOyj
	 I6nYfVSFiqtDscthmRwx57ADeg0eulUj0PceY0k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1944/2214] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150128.774796160@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 16fb7aa6955a0af9f67ca42a61d9be58dfc9382a ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_linearize() on a non-linear frame then hits
BUG_ON(skb_shared()).

Call skb_share_check() before linearizing the skb.

Fixes: 95b9606b15bb ("net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index c380340b81665..1d132614ae44b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -188,6 +188,10 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
 	struct udphdr *udph;
 	struct iphdr *iph;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
 	if (skb_linearize(skb))
 		goto out;
 
-- 
2.53.0



