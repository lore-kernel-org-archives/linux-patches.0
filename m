Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329287D3F7;
	Mon,  8 Apr 2024 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582828; cv=none; b=VOYH7uZo9ORQYXtCrnFrHvlX7gDmJIVIngZTVRRrRiHkTwna/VKeHnGXwf/1lhWVnHQkwHk6TQLyhJxmll3C/iT9bYaF/kUku6b5/95robgWg7eFUkFR879mQhaFuCJmkBxPOKe12KgufrCmGMkBEZOe78DAvCx2PK1KKgNw7hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582828; c=relaxed/simple;
	bh=sM1sIl563BEP+ismBOHzlBSjxo6AhSyC7SrYq2hAl3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9HP+xyXx3GAvFQGMP8mFwkeu0HvX7if8LtpCRh4E5RGEpixZb6ZqZ0t9Ak7I/XW+41uJdfUzjMcrPli8vkJWuGkoB+CkrBlOKRW5v/z/cUc1Vr/ZwKH6bVphjHAcoFcBu00c7hDNJLXux/upDPHsV0Cg7VUYAbzKAK3Mi4+7Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBe7gkhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBe7gkhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DA6C433C7;
	Mon,  8 Apr 2024 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582828;
	bh=sM1sIl563BEP+ismBOHzlBSjxo6AhSyC7SrYq2hAl3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBe7gkhU2aJ/RggmMBZb18ZQLdEhxTHM3MR+/4DHNhU5CUM/Au4lNqmW4QBKQ2+dB
	 2/FG1yAwVIWJwZ6u/n8aZaDTuwBxv9PQ3r5Rk6VR8UfsvKnnMXCuyyy71bwzYOruTQ
	 OPYtDBBn5gRAfmPQnAXriH+VddNgr1UheP5mjV5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 127/252] octeontx2-pf: check negative error code in otx2_open()
Date: Mon,  8 Apr 2024 14:57:06 +0200
Message-ID: <20240408125310.564788039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

commit e709acbd84fb6ef32736331b0147f027a3ef4c20 upstream.

otx2_rxtx_enable() return negative error code such as -EIO,
check -EIO rather than EIO to fix this problem.

Fixes: c926252205c4 ("octeontx2-pf: Disable packet I/O for graceful exit")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://lore.kernel.org/r/20240328020620.4054692-1-suhui@nfschina.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1933,7 +1933,7 @@ int otx2_open(struct net_device *netdev)
 	 * mcam entries are enabled to receive the packets. Hence disable the
 	 * packet I/O.
 	 */
-	if (err == EIO)
+	if (err == -EIO)
 		goto err_disable_rxtx;
 	else if (err)
 		goto err_tx_stop_queues;


