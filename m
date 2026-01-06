Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E534D3B9;
	Tue,  6 Jan 2026 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720053; cv=none; b=aoWG/i2TtV4OrfyAG11V5apnyNed52gWh5CR0nA/nsZOTvRwQkNV5t7H5JIdwydRxoChnRAjIz0tdMK+sAzhlT+DtI8KWe/HCT3JDAQEXpM4RTyM+TYEmJ4Si8eaSkZKOzOEi5HtqKEmo0nE2R+EPcvQMJVMLPE8vrdJ4I5bwvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720053; c=relaxed/simple;
	bh=jWwZENcqcTuRM66GvopzIacFEjWhRDJyv1G3tDfqBVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHTtqQbk94J9H5t8nnzgHhwgqmGfbeB8MHDfvcIVunr+sk93FxRPCCLs6a4f6n0qe7CE6JpWMjNHr5A3i/wy+O/o+Kqda9btZmFhSjmEdyzF8DwYxMKSpHT3vM8IWRis8B5xWf5UzD7ODVTCIeKilkut56nLhqK1WSBz1wCyVu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IATdmDkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IATdmDkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D9AC116C6;
	Tue,  6 Jan 2026 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720053;
	bh=jWwZENcqcTuRM66GvopzIacFEjWhRDJyv1G3tDfqBVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IATdmDkZkpBE9TToU6bheAt5OwOdXA1WAtlfvUZboS84lb8xe9nB2axVb93ipZchy
	 nan9KqnJ+RI1HaAmcjfAusjPTsqTJiAuZQURI2jjuh3EkXk5Cpbsar4Gu4MpreK7KG
	 SUMgaCsN3RFtsManjcCkFxgTZHTxgoRJWcl83AVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 103/567] soc/tegra: fuse: Do not register SoC device on ACPI boot
Date: Tue,  6 Jan 2026 17:58:05 +0100
Message-ID: <20260106170455.139721468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


