Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3639277C98;
	Tue, 21 Oct 2025 20:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077351; cv=none; b=R+q2W7+LPOsipa06gyXAUeyY48eAZaNzeUoD2p+vrdEwAc0RMFaTZs+4QB/wfKr6yPmmMD1WXikDiNOhLilskzn41HuYgC/plSjSmv7+OkkrH2fIIaQ+hOWVLXRAXvp50etRKuAjUodmnS3jeXrk1Twt90BKjWlreLN6nAwt2b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077351; c=relaxed/simple;
	bh=Km+YzzUw/ehZgXCp0XdrZHHi8amfQvYDxrBMqvGraws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tdw4dsICI1ICklRLhJL+DVbZ1K7yFTGI1oY+QJS8sG5FZXNWsxitUMSqm7rU5axTqEvuPSJyUtnz9EEXPSoo7NTqOk4Hu8tCjTp/o0UlQleAkSsMBFSTuk8jQA2fRdIXW4VWCtWUtalbYMVtMAlGSYW+WlBXNxTUdOuD1LSM2BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmfFnGqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmfFnGqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FB5C4CEF1;
	Tue, 21 Oct 2025 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077351;
	bh=Km+YzzUw/ehZgXCp0XdrZHHi8amfQvYDxrBMqvGraws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmfFnGqQKlC0XpSSOr48P1hpf8uN15NvBJOur5aQB2S2vhkrMCA0ZXGaTF50iBdow
	 aDR+uiA6gTMWX6HUzaFYXI83YFtLgPoacGutz+owPjOp61gjjFhLhZ+4pXHsT7L6t1
	 6crq48q2MtRobV1EJcOOfTjXXgzSzy+J2oRwz8Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 077/159] Octeontx2-af: Fix missing error code in cgx_probe()
Date: Tue, 21 Oct 2025 21:50:54 +0200
Message-ID: <20251021195045.049590357@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit c5705a2a4aa35350e504b72a94b5c71c3754833c ]

When CGX fails mapping to NIX, set the error code to -ENODEV, currently
err is zero and that is treated as success path.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aLAdlCg2_Yv7Y-3h@stanley.mountain/
Fixes: d280233fc866 ("Octeontx2-af: Fix NIX X2P calibration failures")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251010204239.94237-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 69324ae093973..31310018c3cac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1981,6 +1981,7 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	    !is_cgx_mapped_to_nix(pdev->subsystem_device, cgx->cgx_id)) {
 		dev_notice(dev, "CGX %d not mapped to NIX, skipping probe\n",
 			   cgx->cgx_id);
+		err = -ENODEV;
 		goto err_release_regions;
 	}
 
-- 
2.51.0



