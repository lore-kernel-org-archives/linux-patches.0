Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C66156F4C;
	Mon, 16 Sep 2024 12:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488204; cv=none; b=rgbUnfBR/gxbIjFRR/1CLwUUJh7pxpizk9GZTVAvVjJmMcw9YBwlS9IUPU0oQ7p4AsW58iVxedm8XgCWRNrTSX262g/EIJZ4Yu6a8qtEwgP31YymI/8ezHy4QGvkRdevTV1L2NsNtpdTQPKxRZz4JNPMAkKEVwwnjzZSoIF4Tq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488204; c=relaxed/simple;
	bh=3ftxa2iSL+gbuyAA4hVOLso8OJ4dSSjSnbNeY2bPR1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpjuvlRUzYz2ZQ8spimE5UQhjzEk1FmwBf3I9nZIec/SAUF+/C9/cnwoiKTl2O/Wdp1/PYhVcY1qf21Zr9WMmf+/cY4HMxey1c26lnllm/tK4VVDgdfIK3+OXvabjdQ0VRY4hpv+yJEE2BGY2qBat0V5uLY8VDtvyyk1QcFfmgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnbLob2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnbLob2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A344C4CEC4;
	Mon, 16 Sep 2024 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488204;
	bh=3ftxa2iSL+gbuyAA4hVOLso8OJ4dSSjSnbNeY2bPR1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnbLob2/s5SLVaVzKmeISY1jN9PTHlLXiJQbsekeEltQUv/tOceqdNKGQq7j8Ckur
	 /+4KosQfdWtVdZPc47tbDLTfo3yi08WEDy6BwXvt2y4lTruW6sLYp+OXC/wEaBOyGn
	 MszQZzyvvRDTOV/KXXb1qWzU8YlVKJVE2jj0RB1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 031/121] platform/surface: aggregator_registry: Add support for Surface Laptop 6
Date: Mon, 16 Sep 2024 13:43:25 +0200
Message-ID: <20240916114230.059668406@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 99ae7b9ba047ad029a0a23b2bd51608ce79c8e97 ]

Add SAM client device nodes for the Surface Laptop Studio 6 (SL6). The
SL6 is similar to the SL5, with the typical battery/AC, platform
profile, and HID nodes. It also has support for the newly supported fan
interface.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20240811131948.261806-6-luzmaximilian@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../surface/surface_aggregator_registry.c     | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 4d3f5b3111ba..a23dff35f8ca 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -275,6 +275,22 @@ static const struct software_node *ssam_node_group_sl5[] = {
 	NULL,
 };
 
+/* Devices for Surface Laptop 6. */
+static const struct software_node *ssam_node_group_sl6[] = {
+	&ssam_node_root,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_perf_profile_with_fan,
+	&ssam_node_tmp_sensors,
+	&ssam_node_fan_speed,
+	&ssam_node_hid_main_keyboard,
+	&ssam_node_hid_main_touchpad,
+	&ssam_node_hid_main_iid5,
+	&ssam_node_hid_sam_sensors,
+	&ssam_node_hid_sam_ucm_ucsi,
+	NULL,
+};
+
 /* Devices for Surface Laptop Studio 1. */
 static const struct software_node *ssam_node_group_sls1[] = {
 	&ssam_node_root,
@@ -410,6 +426,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop 5 */
 	{ "MSHW0350", (unsigned long)ssam_node_group_sl5 },
 
+	/* Surface Laptop 6 */
+	{ "MSHW0530", (unsigned long)ssam_node_group_sl6 },
+
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
-- 
2.43.0



