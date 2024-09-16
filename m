Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7962C14B946;
	Mon, 16 Sep 2024 12:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488054; cv=none; b=HGJk3aRUpmVuZAg4/HlBECKtGz6UJxyl1bu17fa7Y4xXlUqzRdYBnqLyUQtrDB6EvcwOc56FEflM6BBG+UZYRfG99oZRcxw7UuAL3CdEK2GQFT2ZnpRFkjWzdyYKwMLXveTQJGnIOSvwdGRR28gO1rhFWo2UQGatnRcTlvrTND0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488054; c=relaxed/simple;
	bh=oj2jFaP4S1gkyKnRNelLoW4roGHrWA5imHTQxEb/Pdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dvy+zlRdhoZRqjWz2hQWMMLoLtm54uGV8mFIUfu/XYeCy7SE9EFIJhMggVnIvNj7rIRrPht7WMToznD7+Y8nWGcjWomwGBxVPYxpFFK6+ePPLPQVHZU6oYUae1vtUaF9eyw7ASQeGq2FlBSAq+Ibrp7mirwLSJ4ZPQmaPmnZwdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=By88SxwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="By88SxwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DB6C4CEC4;
	Mon, 16 Sep 2024 12:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488054;
	bh=oj2jFaP4S1gkyKnRNelLoW4roGHrWA5imHTQxEb/Pdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=By88SxwPlGQqZ6882dpuX54vTFsDq8vWQDT5AQV8l+ogKLxhWv7pJ0y93jzfQKRRH
	 zAPYEUjdAcEEvWomYMBIxEkVfpHU/twykAIyT9bmYT6jhPLyaQ7EUxKIhi9RQ6itoQ
	 Vzzzkb0PwX9FkjG2LdvT1U4J+O3GNu7pJ9y32SOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/63] platform/surface: aggregator_registry: Add support for Surface Laptop Go 3
Date: Mon, 16 Sep 2024 13:43:54 +0200
Message-ID: <20240916114221.594705771@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit ed235163c3f02329d5e37ed4485bbc39ed2568d4 ]

Add SAM client device nodes for the Surface Laptop Go 3. It seems to use
the same SAM client devices as the Surface Laptop Go 1 and 2, so re-use
their node group.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20240811131948.261806-3-luzmaximilian@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 6882f32d239d..fafb0bb49f7f 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -370,6 +370,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 2 */
 	{ "MSHW0290", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Go 3 */
+	{ "MSHW0440", (unsigned long)ssam_node_group_slg1 },
+
 	/* Surface Laptop Studio */
 	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
 
-- 
2.43.0



