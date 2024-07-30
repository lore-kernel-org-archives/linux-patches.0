Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86E41A616E;
	Tue, 30 Jul 2024 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356978; cv=none; b=RSx5bcjLXy7n8g/RDyPLWixEWpGDNBIdtbnVqjqWD8VD/7N5VhqFv6rvkYFMLaU2EDQvZwZXGEE69DsjwvOsAoTKxfhMCzHShqGxZOCji3GhHwMKOQKg/4kD5RSpmIyj+zqjUzApsbHFfB3No0q4kZwW2Im4fa+iiVD4AV/a4f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356978; c=relaxed/simple;
	bh=mWlqL2V0lev3yt8VPURIunx+Lz0G178hk6RtAhvKPkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gR8T3hgW5Q1xmS9hfCdZWQhmi0mwIjN6oFCPindTAIUKuDoaCR9EEuZwtOMvW4AwXuO+uB+EE/ll/78CClXpzfjkYq64aJOLkCtRdlmIs/Og7EmKytgtqDxVcEZ+fBLQpTDwxzhKYGH6sHKWW5mNYlSy7BE/Mapvgsae8c9wvHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrICEk/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrICEk/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6D2C4AF0A;
	Tue, 30 Jul 2024 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356977;
	bh=mWlqL2V0lev3yt8VPURIunx+Lz0G178hk6RtAhvKPkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrICEk/zMw3Sb8fT+JgwuuVeNloG36fsc6aZA1DlXwSYXFLUkCYA9Sk5MFCuFg70j
	 zN5NcIFDtlvcWK0rmZ2ioiqGCU0Skfq2IZSCfl5fSxNXD2zfzC4iUX1s9lTfp5ZMNZ
	 LA7DGlE6bGbxNGTU3/EGpFnYFpUtMmcpb0J5XCRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sean Anderson <sean.anderso@linux.dev>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/568] drm: zynqmp_dpsub: Fix an error handling path in zynqmp_dpsub_probe()
Date: Tue, 30 Jul 2024 17:45:13 +0200
Message-ID: <20240730151647.925225341@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4ea3deda1341fef7b923ad9cfe5dd46b1b51bfa8 ]

If zynqmp_dpsub_drm_init() fails, we must undo the previous
drm_bridge_add() call.

Fixes: be3f3042391d ("drm: zynqmp_dpsub: Always register bridge")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Sean Anderson <sean.anderso@linux.dev>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/974d1b062d7c61ee6db00d16fa7c69aa1218ee02.1716198025.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
index face8d6b2a6fb..f5781939de9c3 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -269,6 +269,7 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	return 0;
 
 err_disp:
+	drm_bridge_remove(dpsub->bridge);
 	zynqmp_disp_remove(dpsub);
 err_dp:
 	zynqmp_dp_remove(dpsub);
-- 
2.43.0



