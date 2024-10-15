Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041451E907D;
	Tue, 15 Oct 2024 11:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992119; cv=none; b=XBQsm0jUj7SCn9ubKbi9xX2ZGz2rPtoIH2iNbriZX+2qgXoGUSelSqN7tI6WNJrOlnSKI1xsP3XtBapN2F+Yp9PjjWvHWq9Win8yK1pdwGqa8lX17NtI8PeYxZqndVJGCCnz4kIm18LQeuYBacvwxflBLAINAA4btpCDT6XVA9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992119; c=relaxed/simple;
	bh=elkCSGZyraN4nraFj29Dor9eCPvcqt/0k8XfjS58/oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5cnEf2ItjQSAYh4q16SNzTgmVzLCCXczvYymBGRNs3QaagoBLbg8USq7SYlFyAm6nN4Tj6ttHqxrGeP09TvEFiaRzDM60GH5uUaNep4k9aSkC2q/CYB97mF/fYKca34Nk3sSTQS4crEajt+qjn/PXpvStW368glaiZw4ZyjIno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opJQCZDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opJQCZDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37275C4CEC6;
	Tue, 15 Oct 2024 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992118;
	bh=elkCSGZyraN4nraFj29Dor9eCPvcqt/0k8XfjS58/oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opJQCZDYhnQ5ejufUNAnW3o8YVxnXGRP74cybX2iOjN4SKB8V5FlD+oYDplZbsvLw
	 UC2ebh70iAP4+rAnvLIJKBJWayZFkDnDcvo/LbxN40ERoFgVIScWZkR/TosSK7qejw
	 OotWQina/j5lDYBZGQ4+fVGHBpjaHzJhVWyVXZC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/691] platform/surface: aggregator_registry: Add support for Surface Laptop Go 3
Date: Tue, 15 Oct 2024 13:19:32 +0200
Message-ID: <20241015112441.294043843@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5c0451c56ea8..04dd212f73ae 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -561,6 +561,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 2 */
 	{ "MSHW0290", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Go 3 */
+	{ "MSHW0440", (unsigned long)ssam_node_group_slg1 },
+
 	/* Surface Laptop Studio */
 	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
 
-- 
2.43.0



