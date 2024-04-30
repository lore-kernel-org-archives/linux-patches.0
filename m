Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E5512D74B;
	Tue, 30 Apr 2024 11:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475285; cv=none; b=cAzraBhUrkFRusTNKhxmsjFpHUlUIpIWBNjQdGcgaiGNsAcMZfCPoOQKklAfVVpocYhgcjP8f+btPeGANNy40TWCFJ4W9B0OT8cr8FaJKiDQLyJLcB11jcC68xhGloeAdhgjyq0Qb4I3oTOrkXDL2PGvKrYxCbfBRwUtOSkdHHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475285; c=relaxed/simple;
	bh=WCseeRhWhXWP87jlpZJROJZtvb0m/LBpUbvYxT9r51M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=statAY7nHblCwpnbobv/V6QkyvlACTkmljWV5dr7mTzaT/aBKqkJGcSU+P215LPpfNu07af5jqe83WEUsu4gAvmF7uX8sNLEJk+TVz1O9sP4ri6yTodrfD/TAhMIzIUkSVqTpucu8U3gxuB3gldM/xIskhRmcitLllLWB7V7k7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeDgUEMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeDgUEMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CA7C2BBFC;
	Tue, 30 Apr 2024 11:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475284;
	bh=WCseeRhWhXWP87jlpZJROJZtvb0m/LBpUbvYxT9r51M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeDgUEMbveiU9iQy0G1sLQsgcnoeogmzgbrUVpaBKliryPWrVQzlKgvNy5KjaTKCr
	 lZxNyqOyh3czuXpMPJZp9+AxL8rZoUBaD9EABGaZH54tr2OAD9+WAbphFPTpOGjsMU
	 BVgylzgQdg3i7YQ26eo3KBpvyw0iewalgSYGT5lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/186] bridge/br_netlink.c: no need to return void function
Date: Tue, 30 Apr 2024 12:38:23 +0200
Message-ID: <20240430103059.513326514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4fd1edcdf13c0d234543ecf502092be65c5177db ]

br_info_notify is a void function. There is no need to return.

Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 10f0d33d8ccf2..65e9ed3851425 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -666,7 +666,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 {
 	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
 
-	return br_info_notify(event, br, port, filter);
+	br_info_notify(event, br, port, filter);
 }
 
 /*
-- 
2.43.0



