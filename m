Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037291;
	b=d1YEnr/cxqA+zKG5p+RlYpYrYPGwg4sJvQxR6u1LYxrDQRV11zOqSg1/H9lU1MDyWqc/
	 CjRnI7z3j2emcGTVAnX7QezhvjIZ7BRYShJ6g1ik1K0xmiK7Un8FrXSzEG4f7EG1Op+/i
	 xuwe/Bq8aN2I95LyQji3WBGO7LCaPZdKdNAijGxaOmOMQD/nsq87XKgp2GZaYsAF/dUNT
	 wvHiyvt1bYsD9qgjzp4b6B8Re11VJthgN836Sstu0Gw7/z1WUb2uQgzwXnv+ustXM1yMA
	 Uq8ShjDX2ccvxZAxDqxiWwtTMo8tRt7OQ4GdioT6inDAEEzPgpwnsbSC42dWgQrwvgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qPeN1tbfW9vNkR887/KBkz9bXwK2ONnhxz49z6h3yDw=;
	b=qi/+oOkpDTHAoUQzhGKnIL0oI650U8qNVSEfZU1pj4JI7s2X7I2cS2wN7rjDdaPU/4pk
	 RP8Zhp70FMeTSkitdw+0cl+uzcba1BC7AFx+G+KMi23prlpQLZdTbC+bF3iJmK0pzVHjZ
	 CbXH8xL+ZRwC6AFyBwUtdPtS2IKbTL1YmXfTtyIWDzIdVWuBQLS6sKtktXema7Wr5DTEm
	 2Vbub7g8K864YOiNMZXo44YSn8t7Ph7bWD0RV2sWXfJR003/gmLOr3Zxn0hYpzrFkxLRq
	 Pbz6TRekPhKwbsLjNfZixTEhczXSZF2a5DnZo3Klwc4Cpf+9nb85OuqX3gN/N8NPuFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olfZ2qnh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311DF606A32F;
	Wed, 18 Nov 2026 21:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=olfZ2qnh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D51F1F000C4;
	Wed, 18 Nov 2026 21:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037290;
	bh=qPeN1tbfW9vNkR887/KBkz9bXwK2ONnhxz49z6h3yDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olfZ2qnh6LL3RFAuL9R4hKja3Mw5W3Bb92/roRWE0lpvDA9K/p94KBIGmB4v+yub2
	 ZcD4JRdN96SsnvxmiNnYAQeywiz7GpaZALJHzMg0TWTzOGqvAwTMctKTigadMNzFZI
	 GrGcjh2JgGz2NyR0aMWJbmsexekCYPtOfFs3Z8fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Christian Schmidbauer <opensource@grische.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1355/3318] vxlan: Remove generic .ndo_get_stats64
Date: Wed, 18 Nov 2026 15:32:57 +0100
Message-ID: <20261118150401.078710039@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 195f88c57737f16217b5dece054a4cfd74c33550 ]

Commit 3e2f544dd8a33 ("net: get stats64 if device if driver is
configured") moved the callback to dev_get_tstats64() to net core, so,
unless the driver is doing some custom stats collection, it does not
need to set .ndo_get_stats64.

Since this driver is now relying in NETDEV_PCPU_STAT_TSTATS, then, it
doesn't need to set the dev_get_tstats64() generic .ndo_get_stats64
function pointer.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20240311112437.3813987-2-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Christian Schmidbauer <opensource@grische.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 355337d428e52..c3e2d78d2dd12 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3195,7 +3195,6 @@ static const struct net_device_ops vxlan_netdev_ether_ops = {
 	.ndo_open		= vxlan_open,
 	.ndo_stop		= vxlan_stop,
 	.ndo_start_xmit		= vxlan_xmit,
-	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_rx_mode	= vxlan_set_multicast_list,
 	.ndo_change_mtu		= vxlan_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
@@ -3218,7 +3217,6 @@ static const struct net_device_ops vxlan_netdev_raw_ops = {
 	.ndo_open		= vxlan_open,
 	.ndo_stop		= vxlan_stop,
 	.ndo_start_xmit		= vxlan_xmit,
-	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_change_mtu		= vxlan_change_mtu,
 	.ndo_fill_metadata_dst	= vxlan_fill_metadata_dst,
 };
-- 
2.53.0



