Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D559238D49;
	Tue, 17 Jun 2025 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177642; cv=none; b=Xkg0CnmEG5tIA+tCzmmv11j7O7bui1qTTCn40oJUSvvzIHSox7v7Mum1Vbb2BbRvxkF+X1UT2WiPgfXXrRWR9a1YCwVqt3zQqNH1avMtUiFXNgQrgtPNcuI8+abiFyEl18paiTSwThRw3Nu0bZxiGzEmgR2WBOqP/76xeoEGfG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177642; c=relaxed/simple;
	bh=kC41xfiBHYrZiApes72HNeWPjchn8JJjzeCT7MPpob4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL1yQKDRQjbMwu5I6cFJaZUD95z87K3ofTS/eQO3eKWf8vLnxOCVgYMDEQvWbfPIJQu2NirEU6y/2t20pJz1jnUgxdGAEf6FPAmlMwNVdKjanrR5oYbCzr7iu1sxeJvpcTCo+Ec2JbQKZu0SQri7DlHCWpf2Nf6C2OPWoKVh8i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E76xZlvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E76xZlvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AEDC4CEE3;
	Tue, 17 Jun 2025 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177642;
	bh=kC41xfiBHYrZiApes72HNeWPjchn8JJjzeCT7MPpob4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E76xZlvrEcMM5T/8EmtHg5/Rp5YPUoW4LNbKwvPeauei1QAeC1OZR3KIJZoNcNUTJ
	 DKg3GCNvTeRU7/qTWG9rqmRh7cffb77uX4hh6lop/9rmdBZvaG0BCY0MdBUs04AgP1
	 w6UdWWCQ24484oIb4yauzAKJewW0w/yD92c9a7zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/512] drm/panel-simple: fix the warnings for the Evervision VGG644804
Date: Tue, 17 Jun 2025 17:25:41 +0200
Message-ID: <20250617152434.788676101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 5dc1ea903588a73fb03b3a3e5a041a7c63a4bccd ]

The panel lacked the connector type which causes a warning. Adding the
connector type reveals wrong bus_flags and bits per pixel. Fix all of
it.

Fixes: 1319f2178bdf ("drm/panel-simple: add Evervision VGG644804 panel entry")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250520074110.655114-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index d041ff542a4ee..82db3daf4f81a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2141,13 +2141,14 @@ static const struct display_timing evervision_vgg644804_timing = {
 static const struct panel_desc evervision_vgg644804 = {
 	.timings = &evervision_vgg644804_timing,
 	.num_timings = 1,
-	.bpc = 8,
+	.bpc = 6,
 	.size = {
 		.width = 115,
 		.height = 86,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
-	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_SAMPLE_NEGEDGE,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
 static const struct display_timing evervision_vgg804821_timing = {
-- 
2.39.5



