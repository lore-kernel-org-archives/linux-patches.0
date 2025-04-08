Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7610263F4D;
	Tue,  8 Apr 2025 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115190; cv=none; b=FARAUYdDCsz4GmsUeM+Fkuy/kdnKzUaFURDyWefC2+Q8lvqLKKbzoQTFVtbqz4UAs5ZgLP0hPiAhgccYarSR3FjWTc+HVtTQKymYKfndDHyKITAMgQo/V+Fp4X+hpd1eDXbjwsW5O4MHsh/bgQoTDXQptmzAnZIxNOIog64Wud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115190; c=relaxed/simple;
	bh=O5c4FFOv3dRprQ2rwx91uoTRLFaHqzQKZvfWe2SQ/WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oT0f5a6jfB+7xRkmvbzwLzGqxZ5c5ilObuNA0QRoOdPHln4A8Y2slMatm/VpZgctyOdUjwqLIk2K9rKYEXxM2c+i1MP5eSjCNBugwooBVo4ZpjbawG5R1iSPI9MqSpZnjaRxB3zYclOBhtT7O5PSlmSsa5Vfuk58gtR3qLuMJOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQdOebH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQdOebH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597B3C4CEE5;
	Tue,  8 Apr 2025 12:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115190;
	bh=O5c4FFOv3dRprQ2rwx91uoTRLFaHqzQKZvfWe2SQ/WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQdOebH/eOCHJruAMVZ5iEr6Fh6gilGHNQwSuSjGGPr9HfwrckDmcWiATnRaL5HuW
	 ErD2kzTFdj9DseW622Ew56sOdk8t9ngBFIva6UXVnu7zsXQF7A9B82eCwwTUMz0Bb9
	 aJEV6rIcjqMn1+3jLPjRTiJVY2qYrNuDLHsqT4Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Hetzenecker <lukas@hetzenecker.me>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 344/499] platform/surface: aggregator_registry: Add Support for Surface Pro 11
Date: Tue,  8 Apr 2025 12:49:16 +0200
Message-ID: <20250408104859.803564402@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Hetzenecker <lukas@hetzenecker.me>

[ Upstream commit a05507cef0ee6a0af402c0d7e994115033ff746b ]

Add SAM client device nodes for the Surface Pro 11 (Intel).
Like with the Surface Pro 10 already, the node group
is compatible, so it can be reused.

Signed-off-by: Lukas Hetzenecker <lukas@hetzenecker.me>
Link: https://lore.kernel.org/r/20250310232803.23691-1-lukas@hetzenecker.me
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index d4f32ad665305..a594d5fcfcfd1 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -371,7 +371,7 @@ static const struct software_node *ssam_node_group_sp8[] = {
 	NULL,
 };
 
-/* Devices for Surface Pro 9 (Intel/x86) and 10 */
+/* Devices for Surface Pro 9, 10 and 11 (Intel/x86) */
 static const struct software_node *ssam_node_group_sp9[] = {
 	&ssam_node_root,
 	&ssam_node_hub_kip,
@@ -430,6 +430,9 @@ static const struct acpi_device_id ssam_platform_hub_acpi_match[] = {
 	/* Surface Pro 10 */
 	{ "MSHW0510", (unsigned long)ssam_node_group_sp9 },
 
+	/* Surface Pro 11 */
+	{ "MSHW0583", (unsigned long)ssam_node_group_sp9 },
+
 	/* Surface Book 2 */
 	{ "MSHW0107", (unsigned long)ssam_node_group_gen5 },
 
-- 
2.39.5



