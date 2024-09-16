Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5BF15665C;
	Mon, 16 Sep 2024 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488193; cv=none; b=m8WYb1H91qKG4d+69m4N+efyQg7j/YWcP0NVl9Nb2qUXj4ln+OdLLBmy9FuZTkWIc87I83cTLpapRPUTe10Ex0ZR6FfoFlIyuivI5qYoy21K3owSn2pKO8KpQEjRIGpZ1MGzNDaoAss119ag+38Rw4O1+iDg8BmSp4PnMFXeqcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488193; c=relaxed/simple;
	bh=lUc18jC58A2gDlOkS7Ob030JkkUA1ScA3HXWeF5oRQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eh3m4usa/z7vUdCV2sQqE68ig53yZoPYcYiJuYdAWVuuDkpKzQRQgBL7iLRroXrrfEgNyLViB48kV11VOJMpjjemUMS6/v/QnVclW1jXwjJz63dfPLRrkDsy3WAWdFqEtIg/gfnkbGJbUhg6xJlMcZGVg0ar55vr0HXQolu5yu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UscQxeZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UscQxeZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76B3C4CEC4;
	Mon, 16 Sep 2024 12:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488193;
	bh=lUc18jC58A2gDlOkS7Ob030JkkUA1ScA3HXWeF5oRQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UscQxeZRsf6TL34xwt0BE5PEnHVyO0C077/mDAsjcmiMmOuUBl46WrcFXHBVF/78R
	 a8wBTc6W1JETO/VUK3L8SeSbX0seN9X6nJso0O+7/JH/MqE/52g7zRLYihZLNFQokM
	 AvVqION4F1CvgZo8wKfFWJRumYp2W4ZC1lAtQedg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 027/121] platform/surface: aggregator_registry: Add Support for Surface Pro 10
Date: Mon, 16 Sep 2024 13:43:21 +0200
Message-ID: <20240916114229.929164095@linuxfoundation.org>
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
index 1c4d74db08c9..fa5b896e5f4e 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -324,7 +324,7 @@ static const struct software_node *ssam_node_group_sp8[] = {
 	NULL,
 };
 
-/* Devices for Surface Pro 9 */
+/* Devices for Surface Pro 9 and 10 */
 static const struct software_node *ssam_node_group_sp9[] = {
 	&ssam_node_root,
 	&ssam_node_hub_kip,
@@ -365,6 +365,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Pro 9 */
 	{ "MSHW0343", (unsigned long)ssam_node_group_sp9 },
 
+	/* Surface Pro 10 */
+	{ "MSHW0510", (unsigned long)ssam_node_group_sp9 },
+
 	/* Surface Book 2 */
 	{ "MSHW0107", (unsigned long)ssam_node_group_gen5 },
 
-- 
2.43.0



