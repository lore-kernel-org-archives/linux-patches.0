Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F046612D7;
	Tue, 20 Feb 2024 21:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463950; cv=none; b=mqexAxkWMCN1ZMZkT3Nduzxx1WnWpUDyFFs0Vhtr8smKZm4Uz0OusMGoFvuihL22JTfAKwf99SUFOyf7IZBTeScE4jV+q/WGHrofbSQbNGCVN1W+I8u52irtE3itWV8/PEYshT/xoDHcsTiXrRECypRF/3/0SyeRLzFHvxj6IZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463950; c=relaxed/simple;
	bh=v9hbHlzA3p9okFQve/MDSKKJ0zi1hs3G7qmCNeI7dno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE6IEAdeRPVbBMlziBpgxop5dURM34UCMehwT1mwefmwyFSyqEu6D+bnWT9Tl+D24Pi6VIsiZv6ayWeCyCquVKUGzHWwD9/QFfpRhr7D0JcAC5zmmSgDLK9UV1vR7yUkx3qrbxNMWWpGC0VM5sfxjhJmDW+Xt6J2Gr3V5LD7rhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwUfPdRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwUfPdRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8185CC433C7;
	Tue, 20 Feb 2024 21:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463950;
	bh=v9hbHlzA3p9okFQve/MDSKKJ0zi1hs3G7qmCNeI7dno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwUfPdRq4jVVKHbd+K9/1ZclPjAq2mCq0FHUvhk+fI0+2KQn0kgAh8fC5du7FPR19
	 dWNXyoUAhvnxk2jcaVsGVj6z5LzuoLpEKnO10FD9f2LTwliM88K5T6LS9Q/Gf03ssR
	 saK9j4YOpdjz9qJaIUrYYpJWlzi3HlftkvxVooaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hershaw <james.hershaw@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 204/331] nfp: enable NETDEV_XDP_ACT_REDIRECT feature flag
Date: Tue, 20 Feb 2024 21:55:20 +0100
Message-ID: <20240220205644.080284922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: James Hershaw <james.hershaw@corigine.com>

commit 0f4d6f011bca0df2051532b41b596366aa272019 upstream.

Enable previously excluded xdp feature flag for NFD3 devices. This
feature flag is required in order to bind nfp interfaces to an xdp
socket and the nfp driver does in fact support the feature.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Cc: stable@vger.kernel.org # 6.3+
Signed-off-by: James Hershaw <james.hershaw@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2588,6 +2588,7 @@ static void nfp_net_netdev_init(struct n
 	case NFP_NFD_VER_NFD3:
 		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
 		netdev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
+		netdev->xdp_features |= NETDEV_XDP_ACT_REDIRECT;
 		break;
 	case NFP_NFD_VER_NFDK:
 		netdev->netdev_ops = &nfp_nfdk_netdev_ops;


