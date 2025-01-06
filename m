Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90488635E;
	Mon,  6 Jan 2025 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176927; cv=none; b=apSndgenEtv+vIZVe0Da9RqITlZ5UaPqWsB59CC4yBJqIH1WG1GuQm/NJCSOImhlqndKgTKoY/Yxe86bPHfp+ddr9bWriJqYt69z0R2P48FPNr3uWSShaYxR/gQepsiJu840errSZ9IoRmx5s6ODNqED42T+cxQrbCysgSfgMwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176927; c=relaxed/simple;
	bh=Dw7a2V2ESboMgppSxVgCTaB0J/TUo6pU/zu3axZp2X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoEjW0FCKOO/CGGVBU5preteFPBQvHEn8zfG4reQfqx9pMFJP9XEzyCEnmpqZtsO3NuIN+VPGGX9j9e94ntrZhnEhUWnkXMw9VIvZZwm2CJojlgg3WydbJDSDFBXvhwpQ7RA775Nm1+8mFknRPUJSPrA37BMt/ZGyWrzhrXWCew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4tVDRis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4tVDRis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D7C4CED2;
	Mon,  6 Jan 2025 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176927;
	bh=Dw7a2V2ESboMgppSxVgCTaB0J/TUo6pU/zu3axZp2X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4tVDRisHT3wcN6Xl7TxAze/mdsv8pNfoUsGbx39W0VGxxBFZL0V9GdfLLVdHlR3O
	 jeiTymwQCzG58ZoQwVhz21JGB8SGzOjpox1JefTtxNexdhkk6RNEV8PjhQhJT3f/Ee
	 SzQo6sGfQnfsSUEU81WpEK7EA+TzWsO7Sg0GEhkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Adam Ford <aford173@gmail.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.1 75/81] drm: adv7511: Drop dsi single lane support
Date: Mon,  6 Jan 2025 16:16:47 +0100
Message-ID: <20250106151132.259875386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 79d67c499c3f886202a40c5cb27e747e4fa4d738 upstream.

As per [1] and [2], ADV7535/7533 supports only 2-, 3-, or 4-lane. Drop
unsupported 1-lane.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7535.pdf
[2] https://www.analog.com/media/en/technical-documentation/data-sheets/ADV7533.pdf

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Reported-by: Hien Huynh <hien.huynh.px@renesas.com>
Cc: stable@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241119192040.152657-4-biju.das.jz@bp.renesas.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7533.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
@@ -179,7 +179,7 @@ int adv7533_parse_dt(struct device_node
 
 	of_property_read_u32(np, "adi,dsi-lanes", &num_lanes);
 
-	if (num_lanes < 1 || num_lanes > 4)
+	if (num_lanes < 2 || num_lanes > 4)
 		return -EINVAL;
 
 	adv->num_dsi_lanes = num_lanes;


