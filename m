Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7898D14B946;
	Mon, 16 Sep 2024 12:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488196; cv=none; b=ayjO+4yJRcfQYe78mUK7nWp0VtLEeV6roo21hiOoELSftP5RCV/p22KokZXDPA1wvjAIoU1YGcgYveTaYYudojGYvCnS7AyOjE0LVUgD3eQGjr64gc4yYFfNKkYL6/G5P7AUgXSDeIpCytW5vCFVKvRRhWFIzAaiY3PoztSMBrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488196; c=relaxed/simple;
	bh=S2EIe1FZN4vES57L8VbimXFbtKEkrHvuCGsNFZ21XNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHDUGzQJKiQeF03OBN17h53Hm+RpqEw5lRioBKx/gp17XTS5ds0Ec1o42poyh77P08qRyBUbaSoDK1bTKp34GwGvzAswEeK204JKTfFLCgvoFBbrKU2JkBDr0INa1sB6IX8ZaXZRYyCLOY/ZQeAFCN4aFw3EDv9WbzRYAC9iEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD6VeL54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD6VeL54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC38C4CEC4;
	Mon, 16 Sep 2024 12:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488196;
	bh=S2EIe1FZN4vES57L8VbimXFbtKEkrHvuCGsNFZ21XNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD6VeL545xQLlz4+X50dUekM27DSrWzAlgaXghSrOzeyIBcnvYsKqQN9+kCp360dp
	 zRXQBJjQRGGqF0W2c2dJCqJz40kDKz740eYUi7o3l3H9LLaMMZyeZTqH5eX7Snelj9
	 AwD7/Pges077OBT5cFjVkw9gPi2C9p/cPkYVEsgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 028/121] platform/surface: aggregator_registry: Add support for Surface Laptop Go 3
Date: Mon, 16 Sep 2024 13:43:22 +0200
Message-ID: <20240916114229.962513164@linuxfoundation.org>
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
index fa5b896e5f4e..4d36810c2308 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -398,6 +398,9 @@ static const struct acpi_device_id ssam_platform_hub_match[] = {
 	/* Surface Laptop Go 2 */
 	{ "MSHW0290", (unsigned long)ssam_node_group_slg1 },
 
+	/* Surface Laptop Go 3 */
+	{ "MSHW0440", (unsigned long)ssam_node_group_slg1 },
+
 	/* Surface Laptop Studio */
 	{ "MSHW0123", (unsigned long)ssam_node_group_sls },
 
-- 
2.43.0



