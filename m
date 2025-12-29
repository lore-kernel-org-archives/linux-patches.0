Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51143093C1;
	Mon, 29 Dec 2025 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025274; cv=none; b=mfYp7dyCJ5g36C2z9QiCbOreEvornUuWdngd5qCPCqleb7LrnSwbpAHtK/40bCXNiGWzTSBcASzJKOLq4zhe/DGgdYG8YmHUSObjhycl2M64NdPh03g6wce5kIEx66OYWxjihdvUNhHj5Qh3qpnOmHk0m9TJQLAGARZm+kHaS/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025274; c=relaxed/simple;
	bh=xvEv0EnRSX9o9GM6xnXRTF4pqIOyRhVpZZjMLxoNy7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI1w/NPUmaKpiMsTT4GlpCIMtI0lUNTC8d2szGTx9r/l8K3DlxoMMbrNbCliMrJUG9iFoWrb5KyhjfSfonSSgpVRdmHX6Dv9/tgfmVTD5PS4mwnYE8+SEJTiChlAe9toe3GVrAdXwr3dOkdodJy65SA7NZ3PUnzjmZm36kd5nH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3vXgqcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3vXgqcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECCAC4CEF7;
	Mon, 29 Dec 2025 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025273;
	bh=xvEv0EnRSX9o9GM6xnXRTF4pqIOyRhVpZZjMLxoNy7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3vXgqcYkIX/7SYw2A3JEGnd2AhR7xI1W4heeo8pw3JmUVKSqUfUFirIooqAmbPjc
	 /v7k0ol7ucg8x7BiDiHzULsmWqirw/bImOzCKqmO8v7s9XkB4rH9Xv8t7CqkVCOz9X
	 0NpxU19ORyfcN4GtlcjMlx2AX2P/iRw+LRcvmpWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.18 155/430] soc/tegra: fuse: Do not register SoC device on ACPI boot
Date: Mon, 29 Dec 2025 17:09:17 +0100
Message-ID: <20251229160730.063900048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

commit c87f820bc4748fdd4d50969e8930cd88d1b61582 upstream.

On Tegra platforms using ACPI, the SMCCC driver already registers the
SoC device. This makes the registration performed by the Tegra fuse
driver redundant.

When booted via ACPI, skip registering the SoC device and suppress
printing SKU information from the Tegra fuse driver, as this information
is already provided by the SMCCC driver.

Fixes: 972167c69080 ("soc/tegra: fuse: Add ACPI support for Tegra194 and Tegra234")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/tegra/fuse/fuse-tegra.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/soc/tegra/fuse/fuse-tegra.c
+++ b/drivers/soc/tegra/fuse/fuse-tegra.c
@@ -182,8 +182,6 @@ static int tegra_fuse_probe(struct platf
 		}
 
 		fuse->soc->init(fuse);
-		tegra_fuse_print_sku_info(&tegra_sku_info);
-		tegra_soc_device_register();
 
 		err = tegra_fuse_add_lookups(fuse);
 		if (err)


