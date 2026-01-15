Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AC93624C4;
	Thu, 15 Jan 2026 16:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496032; cv=none; b=MDrI34cXEAJfIwINRDCU1N0gE6JppUD7LjSE706DwMhS70IwU4+bbDSg7ntww4Nj+OL68u5rdLHn65jpA3eVCTHCkBGxMIzkOKjGig0ktPW/eAMyOW3GqupTqFJ13Q2gOxxqnbO0Y67ul4eIl70YsZb+Zz8wq632JXPZl7xdSPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496032; c=relaxed/simple;
	bh=/ZcsqsvOsCKowyVHm/AjgjqhAMGzhWrJfvJXJxFqwnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sze/EzeUxwOXkpEjfUmHLykSyD1pBuXhg4kYji/htGwO3HOw4bgCOnGka8U6Tojj/o8DS/OlpYB88XgeyR9ofN4TsvR1KZ1W6gpzHKVQs9gxwT/zwLu9Gj7fuCq+I9t34kl6EeKG6kq1Fm2f37xicgXmnuOnlEAXC+FoCCFG7Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0QTBfEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0QTBfEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B997AC19421;
	Thu, 15 Jan 2026 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496032;
	bh=/ZcsqsvOsCKowyVHm/AjgjqhAMGzhWrJfvJXJxFqwnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0QTBfEqXChby/JFMeYatNjMsSySPrrFvRRXwUPqGj5K5sEW4nf4PUt5YjqOzGdyl
	 Q/di7Wt9MTF4cP5LbAzaseWJPyld+dQgrMuwf1O4O51e0VNUlEqgcLGS+rYbwQkREa
	 CT9btAWmWLCbXwZMkSoejkRaTxLmumOyHMecbLHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 036/181] Revert "drm/mediatek: dsi: Fix DSI host and panel bridge pre-enable order"
Date: Thu, 15 Jan 2026 17:46:13 +0100
Message-ID: <20260115164203.632184368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 33e8150bd32d7dc25c977bb455f1f5d54bfd5241 upstream.

This reverts commit f5b1819193667bf62c3c99d3921b9429997a14b2.

As the original commit (c9b1150a68d9 ("drm/atomic-helper: Re-order
bridge chain pre-enable and post-disable")) causing the issue has been
reverted, let's revert the fix for mediatek.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc: stable@vger.kernel.org # v6.17+
Fixes: c9b1150a68d9 ("drm/atomic-helper: Re-order bridge chain pre-enable and post-disable")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20251205-drm-seq-fix-v1-2-fda68fa1b3de@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -1002,12 +1002,6 @@ static int mtk_dsi_host_attach(struct mi
 			return PTR_ERR(dsi->next_bridge);
 	}
 
-	/*
-	 * set flag to request the DSI host bridge be pre-enabled before device bridge
-	 * in the chain, so the DSI host is ready when the device bridge is pre-enabled
-	 */
-	dsi->next_bridge->pre_enable_prev_first = true;
-
 	drm_bridge_add(&dsi->bridge);
 
 	ret = component_add(host->dev, &mtk_dsi_component_ops);


