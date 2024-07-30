Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682431A616E;
	Tue, 30 Jul 2024 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356014; cv=none; b=OzvAeuXAJlCJ4LD0MNZcX6HdDD89SXVokg4f9vvqQ7gL5ELQKnupatIaMofqF2krTYrMCG2qTkOUuzoF2jSGrMSeu1iWmDqJ5/YZL5rtbd+6PVv6bN0D2WPcWpX2v6Ert89R/86bMiRDr1pwg6wlfSkE5/OlRrjc8ZNYaNKACyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356014; c=relaxed/simple;
	bh=VRnaoADRi3EXh9uef5oLRW1U8Ty/oxkcB5E5uru2fRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjaWs5g6CyNJ4BwtsD6YQkAiRa7u7/Ep9D1YlWWi83Y/cmxyfnnXA5mot11UYueU2qZ/v9CrskqwSIh3ZcRUe1j80JFaVfxS1JErE5JGd++R09Dnqf0lxh76iu9bnk/2eVLh7aT49GkiWHdXHkNTDEu03hZoGaJcbYmBsDTTfmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4Cbn3i7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4Cbn3i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5503C32782;
	Tue, 30 Jul 2024 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356014;
	bh=VRnaoADRi3EXh9uef5oLRW1U8Ty/oxkcB5E5uru2fRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4Cbn3i7/rIE83sNcD3vQMfP4URhxbE3G4sPZIKdpT7LaSNFJ0BpxbSnqmYY9kSsf
	 lYfTEX2+KkV+71nqtODJ8vlLpv9ajgv6oOL+ZMALNxWx5wPRQ3eL57KlY/Nyn1Hiwf
	 vspUKtQVukNtzALWmY+YEtrHq/IKQ6yol35hHEP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/440] media: rcar-csi2: Cleanup subdevice in remove()
Date: Tue, 30 Jul 2024 17:46:21 +0200
Message-ID: <20240730151621.661495712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

[ Upstream commit f6d64d0d2897ed4e85ac00afe43e45c8b8fc0c44 ]

Cleanup the V4L2 subdevice in the driver's remove function to
ensure its async connection are freed, and guarantee in future that
the subdev active state is cleaned up.

Fixes: 769afd212b16 ("media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver")
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20240617161135.130719-4-jacopo.mondi@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rcar-vin/rcar-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/renesas/rcar-vin/rcar-csi2.c b/drivers/media/platform/renesas/rcar-vin/rcar-csi2.c
index 001c4b7c59758..3b6657d4877a5 100644
--- a/drivers/media/platform/renesas/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-csi2.c
@@ -1583,6 +1583,7 @@ static int rcsi2_remove(struct platform_device *pdev)
 	v4l2_async_nf_unregister(&priv->notifier);
 	v4l2_async_nf_cleanup(&priv->notifier);
 	v4l2_async_unregister_subdev(&priv->subdev);
+	v4l2_subdev_cleanup(&priv->subdev);
 
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.43.0



