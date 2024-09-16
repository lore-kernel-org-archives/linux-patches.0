Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D5A156C72;
	Mon, 16 Sep 2024 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488199; cv=none; b=EHq1E51Y928hmEHZaKQHuGsOoFbKyr/TMgKJ2sGHbYTbon7+41HVXtiV6c3uWq/EHua11YWy1U5j+aRLmC5Fz5EYmFpNV8lK73er584w0vieyquMk7sEjM/zi++gP1vb2BfjldgB+6Lf1OmPWO5oIZV6oHbDqSOTO00/+uMrNPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488199; c=relaxed/simple;
	bh=9kF7VKiyBH5msLuP4BRy1g0VKcLTL+q4sAXuPP4TLTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KmltWFdiBjArmZoXzxNXkB/PhDjNNzCtlZjRC7BehVFWhHDjjt9+2f5Y93NSuVEhwKcqa8gIlLIi0g2bkF4x6RI68gcst+fppT2mHwZtooukb8h1mxYddUyai9JR9f6m/yd+Q3TfuLIl4bEmFoWc2CNU0Fi64vy40GF4l02cUEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJX7JEcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJX7JEcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B37C4CEC7;
	Mon, 16 Sep 2024 12:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488198;
	bh=9kF7VKiyBH5msLuP4BRy1g0VKcLTL+q4sAXuPP4TLTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJX7JEcZfZdPYSlnl/NSDq0CiEhvVpLmBwHCj20ASl0sFoHQkxJWeDJPBgdpcpQcj
	 HalhRc/4Mt+IozFy5kSew67BjM1hMKtUSrTOZ+OKYrPZAoy/38sd4zwZ49yZFSHodE
	 s1DuiLp23EWyjcY2A855yCHS1/3xjwO0bQxx/3vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 029/121] platform/surface: aggregator_registry: Add support for Surface Laptop Studio 2
Date: Mon, 16 Sep 2024 13:43:23 +0200
Message-ID: <20240916114229.996538126@linuxfoundation.org>
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

[ Upstream commit 28d04b4a2cc20981c95787f9c449e6fc51d904f9 ]

Add SAM client device nodes for the Surface Laptop Studio 2 (SLS2). The
SLS2 is quite similar to the SLS1, but it does not provide the touchpad
as a SAM-HID device. Therefore, add a new node group for the SLS2 and
update the comments accordingly. In addition, it uses the new fan
control interface.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20240811131948.261806-4-luzmaximilian@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../surface/surface_aggregator_registry.c     | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 4d36810c2308..892ba9549f6a 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -273,8 +273,8 @@ static const struct software_node *ssam_node_group_sl5[] = {
 	NULL,
 };
 
-/* Devices for Surface Laptop Studio. */
-static const struct software_node *ssam_node_group_sls[] = {
+/* Devices for Surface Laptop Studio 1. */
+static const struct software_node *ssam_node_group_sls1[] = {
 	&ssam_node_root,
 	&ssam_node_bat_ac,
 	&ssam_node_bat_main,
@@ -289,6 +289,22 @@ static const struct software_node *ssam_node_group_sls[] = {
 	NULL,
 };
 
+/* Devices for Surface Laptop Studio 2. */
+static const struct software_node *ssam_node_group_sls2[] = {
+	&ssam_node_root,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_perf_profile_with_fan,
+	&ssam_node_tmp_sensors,
+	&ssam_node_fan_speed,
+	&ssam_node_pos_tablet_switch,
+	&ssam_node_hid_sam_keyboard,
+	&ssam_node_hid_sam_penstash,
+	&ssam_node_hid_sam_sensors,
+	&ssam_node_hid_sam_ucm_ucsi,
+	NULL,
+};
+
 /* Devices for Surface Laptop Go. */
 static const struct software_node *ssam_node_group_slg1[] = {
 	&ssam_node_root,
@@ -401,8 +417,11 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 3 */
 	{ "MSHW0440", (unsigned long)ssam_node_group_slg1 },
 
-	/* Surface Laptop Studio */
-	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
+	/* Surface Laptop Studio 1 */
+	{ "MSHW0123", (unsigned long)ssam_node_group_sls1 },
+
+	/* Surface Laptop Studio 2 */
+	{ "MSHW0360", (unsigned long)ssam_node_group_sls2 },
 
 	{ },
 };
-- 
2.43.0



