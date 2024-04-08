Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1587BAF3;
	Mon,  8 Apr 2024 13:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582136; cv=none; b=oJsd5QbT93b84r5sPK8vhJxpaR9hLZ7g4ePoZHSAhbuK6YCiIkzmAmxkquI2A/oCbwxtJggey1PfaN/BgUs0/ZMh8fk7cvapAvdpfPwAeTb/Ic7fc7cSL/WrhonNGs1TQcVAUr4MQCefnC0OMXf1GxFtb9BHL8W0AijMwCrt4/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582136; c=relaxed/simple;
	bh=OxTeuryQn4BTfYXbiUWj2Z2x+xeRt/06jcYwRw20O6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dicazmNNJQ2+6ixI4DNUdD8I8p2OtV82thkITPPDkHF8w8RcnDXE9s/ZId0QexNn2s0e3MLC+SCI9XTFaVu8sOCkUL1n0LJgS2Wz6ItPqz9IWTElcyL6MCtmx+gMBQe3M03p5r+Nmnbw4oR1RaLJA1PFLBTMGstzqhhIN/gTOZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cz3UsdNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cz3UsdNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA33C433C7;
	Mon,  8 Apr 2024 13:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582136;
	bh=OxTeuryQn4BTfYXbiUWj2Z2x+xeRt/06jcYwRw20O6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cz3UsdNaRiPXxoQVK6WV535a2UEMc/1zoh+dykno0D/Lt+Brahqo03Z0RpFNIan9R
	 OmnBJrBUCwn2luCUKInTk65lbt69Yj0alXEJyOg2T/Lpj/j8hKiYEQ52dP8k/Sh4dw
	 V/1PxV+DotAQr8wiObBcwLBa3l+un2t4maydU4WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 065/138] octeontx2-pf: check negative error code in otx2_open()
Date: Mon,  8 Apr 2024 14:57:59 +0200
Message-ID: <20240408125258.241986492@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1914,7 +1914,7 @@ int otx2_open(struct net_device *netdev)
 	 * mcam entries are enabled to receive the packets. Hence disable the
 	 * packet I/O.
 	 */
-	if (err == EIO)
+	if (err == -EIO)
 		goto err_disable_rxtx;
 	else if (err)
 		goto err_tx_stop_queues;


