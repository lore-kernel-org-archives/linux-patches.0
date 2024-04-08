Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3290E8172A;
	Mon,  8 Apr 2024 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585160; cv=none; b=J9FVsKoaGvWVGQmJVKu6XEZoEuvUEt94PV4HKfENipq9Ulz5W3OIFT1Bu2/1031TzhurMw+ZiQTd8rDdTX/6I+OiXrKkKcTl6M26isUpkcwfk+FnJ4Etp5FIYuhzfeHYSvCozaKkilHbA1fWbHVa41G45ro6kk6eVTokNHrJ2Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585160; c=relaxed/simple;
	bh=Z2TRkrOBCeZt3NukXqjKJON2FKB/lZ9Y/C8pckbjxM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAjqNb6+jYdt7wzogAjL86FBSj5OPsLoib7rzSrbzo6DJbi03ZRsApvOJEFakIERCjs+wv5tev8U80HGhy8StRJzcdbJQwfJ7te4fkC0pqiSfJzjkhD6jGHCESzVWs3s5Gu+o160ILJG8IiIfnYazk5THi8293k/xscMsanq7x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjbMytoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjbMytoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A03C433F1;
	Mon,  8 Apr 2024 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585159;
	bh=Z2TRkrOBCeZt3NukXqjKJON2FKB/lZ9Y/C8pckbjxM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjbMytoEhPuUJohKTyOh++0bnWES4wQAGavdMXB7qXmkorrq9tCJ4nobHpvSCtjA5
	 vForoQLx3z/TBWC87rLBICONIcLCA0QIa6Of2AHBIKJB2vw0xk1cq+PhkplTkPyWdG
	 P5WRhgoSr38enl1aNlABHQkvjTMECeZcCXbFldK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 653/690] octeontx2-pf: check negative error code in otx2_open()
Date: Mon,  8 Apr 2024 14:58:39 +0200
Message-ID: <20240408125423.304327086@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1795,7 +1795,7 @@ int otx2_open(struct net_device *netdev)
 	 * mcam entries are enabled to receive the packets. Hence disable the
 	 * packet I/O.
 	 */
-	if (err == EIO)
+	if (err == -EIO)
 		goto err_disable_rxtx;
 	else if (err)
 		goto err_tx_stop_queues;


