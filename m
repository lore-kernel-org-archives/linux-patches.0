Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514702D7810;
	Wed, 25 Feb 2026 06:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002743; cv=none; b=Da3VIGJldQy252zFmR2QXbKeROMiSmyVPW9JEfrsjo+Qh/LR5g08291GzZ0npbVdpBptAyCLaxC36gA2liIVOUauKSgZ+l9ZpJyTeRtg/ZmQBpKB45Ci62m6bDbEY4MqwDYC/78ATH3c/hMJcbNYFGF2oZvvunfXKdrudDE22TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002743; c=relaxed/simple;
	bh=jex9Ei0nmfFGAOLhld1BIMidnuNgVddqgRna7BwLQcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skoW3EuGVOm650SIeMPbILkh/zlWd/W37ut/DeSvBucBGGo0N1Xg8N/uvchMjlWKcDgBb2Y5vaF6PX9yt5yy3nTQavhutCUneEIhMoPpGnhM10gVEfqbhX7gj5EGzJhHzmAbqauYacManlI1aKpFilif1roOsj71dve/O3VGqXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8URnOT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8URnOT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2792EC116D0;
	Wed, 25 Feb 2026 06:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002743;
	bh=jex9Ei0nmfFGAOLhld1BIMidnuNgVddqgRna7BwLQcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8URnOT6AsXad/SzAGcXIGF769ZTYIi55q1WGSG+UMiRC9AGp3p8sIjXnwAT6/y7a
	 QceFM/waA2dOafpDGf+1HWEDURgSHP7IUX8Ii/1IJYWab9aJCQ/3FC2XVHtu1VSlV1
	 doNL/MwsiUXvBjFbiU4HTOeqJnVLrLEJEoUlSB88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/641] eth: fbnic: Advertise supported XDP features.
Date: Tue, 24 Feb 2026 17:24:42 -0800
Message-ID: <20260225012401.995429508@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>

[ Upstream commit e977fcb3a318b53b47f23b44ac237fceb1b731fe ]

Drivers are supposed to advertise the XDP features they support. This was
missed while adding XDP support.

Before:
$ ynl --family netdev --dump dev-get
...
 {'ifindex': 3,
  'xdp-features': set(),
  'xdp-rx-metadata-features': set(),
  'xsk-features': set()},
...

After:
$ ynl --family netdev --dump dev-get
...
 {'ifindex': 3,
  'xdp-features': {'basic', 'rx-sg'},
  'xdp-rx-metadata-features': set(),
  'xsk-features': set()},
...

Fixes: 168deb7b31b2 ("eth: fbnic: Add support for XDP_TX action")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260218030620.3329608-1-dimitri.daskalakis1@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 5cbf3ad175a54..cbedaa037cfa8 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -808,6 +808,8 @@ struct net_device *fbnic_netdev_alloc(struct fbnic_dev *fbd)
 	netdev->hw_enc_features |= netdev->features;
 	netdev->features |= NETIF_F_NTUPLE;
 
+	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_RX_SG;
+
 	netdev->min_mtu = IPV6_MIN_MTU;
 	netdev->max_mtu = FBNIC_MAX_JUMBO_FRAME_SIZE - ETH_HLEN;
 
-- 
2.51.0



