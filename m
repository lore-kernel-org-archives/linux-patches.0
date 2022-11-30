Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E36B79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ABAC433D7;
	Wed, 30 Nov 2022 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834435;
	bh=znc0If7JFePg/TEqZgP5shflQAtQju0aieCF0mrA9AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjy+QvivoKTs8YG5g2sj+ss0yIaZ2AFB7NgJU5B/4vAXPEcDvgFxQsA0G4+kbdGGb
	 7wI2Bgq8cA8OCVs0qBkFRJIazeGCgfwte694tjsFPneYQlgCAuFLGVbPZ71Isc2iRk
	 qga07ABVjx+AkleTaYb4aHqsHcheFIP5kQo6hYHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 252/289] platform/surface: aggregator_registry: Add support for Surface Laptop 5
Date: Wed, 30 Nov 2022 19:23:57 +0100
Message-Id: <20221130180549.818205036@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 4a567d164d0e0c57e7b694b988db86361f130cb7 ]

Add device nodes to enable support for battery and charger status, the
ACPI platform profile, as well as internal HID devices (including
touchpad and keyboard) on the Surface Laptop 5.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221115231440.1338142-1-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../surface/surface_aggregator_registry.c        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index db82c2a7c567..023f126121d7 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -234,6 +234,19 @@ static const struct software_node *ssam_node_group_sl3[] = {
 	NULL,
 };
 
+/* Devices for Surface Laptop 5. */
+static const struct software_node *ssam_node_group_sl5[] = {
+	&ssam_node_root,
+	&ssam_node_bat_ac,
+	&ssam_node_bat_main,
+	&ssam_node_tmp_pprof,
+	&ssam_node_hid_main_keyboard,
+	&ssam_node_hid_main_touchpad,
+	&ssam_node_hid_main_iid5,
+	&ssam_node_hid_sam_ucm_ucsi,
+	NULL,
+};
+
 /* Devices for Surface Laptop Studio. */
 static const struct software_node *ssam_node_group_sls[] = {
 	&ssam_node_root,
@@ -345,6 +358,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop 4 (13", Intel) */
 	{ "MSHW0250", (unsigned long)ssam_node_group_sl3 },
 
+	/* Surface Laptop 5 */
+	{ "MSHW0350", (unsigned long)ssam_node_group_sl5 },
+
 	/* Surface Laptop Go 1 */
 	{ "MSHW0118", (unsigned long)ssam_node_group_slg1 },
 
-- 
2.35.1



