Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1644155730;
	Mon, 16 Sep 2024 12:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488542; cv=none; b=emUozNmj6aFgKC/Bhjk1zNFcc8ZlO4cWqT5zbm6I7qvSelrk1/dbanDttQhum02R1yZ8Vda13f/VL6BacN15kg2P4Fmol2d9DeOP/Ti0fcxwIMbGGK9XtgaWkF4FoqftLmuNEKj7Y0vYNIytVlsz18F++CrAr7wVpnZaqhbh5lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488542; c=relaxed/simple;
	bh=1san2o4+8uOU4aeTCe9w/mmdQ4gRMjjiV45or9w9kR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YM2NNrdXMihigRLIGfiwIMMjzipBu1dHhHmPppRvWb2S3t16parxXZRjXRU/fpbKQJZ/ULhA87IUSmmT3iGqLSOgaml/itobVST2UzCT4aPQNrpP8jCu+CbTB9jHmg/SbnxaSje17UsyJM+0F1ZTRXRNAlIXPHXhkEa/1DU3v3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1MQG5It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1MQG5It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB27C4CEC4;
	Mon, 16 Sep 2024 12:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488541;
	bh=1san2o4+8uOU4aeTCe9w/mmdQ4gRMjjiV45or9w9kR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1MQG5ItQCqsYL6HGXmaLSkXRWPv/ZtPb1V+oK4S0KAUpfsbNM8GBWT8jBS7HCLpa
	 t0RlhIIiJbUINDNf7B8LYfXI27K3M8Fr1VjjbbzwFKf7/rTotwhB8KWZX/Dl2uZM1q
	 QzYJfpDmhBBNcDiciI3g5/e1UQPY+LJu+xPG3WyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/91] platform/surface: aggregator_registry: Add Support for Surface Pro 10
Date: Mon, 16 Sep 2024 13:44:04 +0200
Message-ID: <20240916114225.441013872@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 9c8e022567bbec53bee8ae75c44b3d6cd2080d42 ]

Add SAM client device nodes for the Surface Pro 10. It seems to use the
same SAM client devices as the Surface Pro 9, so re-use its node group.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20240811131948.261806-2-luzmaximilian@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 0fe5be539652..c2651599685e 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -298,7 +298,7 @@ static const struct software_node *ssam_node_group_sp8[] = {
 	NULL,
 };
 
-/* Devices for Surface Pro 9 */
+/* Devices for Surface Pro 9 and 10 */
 static const struct software_node *ssam_node_group_sp9[] = {
 	&ssam_node_root,
 	&ssam_node_hub_kip,
@@ -337,6 +337,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Pro 9 */
 	{ "MSHW0343", (unsigned long)ssam_node_group_sp9 },
 
+	/* Surface Pro 10 */
+	{ "MSHW0510", (unsigned long)ssam_node_group_sp9 },
+
 	/* Surface Book 2 */
 	{ "MSHW0107", (unsigned long)ssam_node_group_gen5 },
 
-- 
2.43.0



