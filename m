Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DB7151CCC;
	Tue, 20 Feb 2024 21:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465139; cv=none; b=r57Gkw/l4DO86KkPL7fwzspewBpAfY/Pvc/511qv8Xmmy0cmn0KEJcKqPudm3nmGjJXjT1h5SmjtVG548iXnzgEkd7fa3OKKwA10ITI0NoEnISvGvlETaTMyxuya+Zu17SD22GsfGsdUqouuAwZt5aRKosiSOPEhDF29O0JC/2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465139; c=relaxed/simple;
	bh=fbWFov8CXxnWva4JaAyryI+RbEA3eZk+Wf6HRloRBNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3DcfznrJHYYcX1/TQ606IAcJfJWnln49NqdL1Xwy2YjYRD5sZfZsbecuBH5U9xjqgk3dLlRAfkaIp3cOaiXnM0wHYCmJNphjK/hqWPiHQ2a7t49zMVG3SayhCNcwIwr/p35nDPSeMboU6AdtDnmTcyfIZ351T27HX8C8idUuv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmF+wfkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmF+wfkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7E1C433F1;
	Tue, 20 Feb 2024 21:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465139;
	bh=fbWFov8CXxnWva4JaAyryI+RbEA3eZk+Wf6HRloRBNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmF+wfkbfyULNENUkNKOs4yBQELtoC5mVun3ys8PrMspsIfZ5GI6m8uX+1bLAw6V8
	 +OMiiE4kLrHw9ttsmQzcliPjgJi5HZ5hyM69vOvJssDWy7cwo0nvMfr++drBDz8Sa7
	 nO0oyrO3zBVsJPnF5eTIEvd6l0UMYzifqRjYTkkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hershaw <james.hershaw@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 248/309] nfp: enable NETDEV_XDP_ACT_REDIRECT feature flag
Date: Tue, 20 Feb 2024 21:56:47 +0100
Message-ID: <20240220205640.928314723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


