Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4622A44160D
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 11:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260971; cv=none; b=Y4BRtLucMVg4UvdBvXmL8Nr8jEoCZHk7njpnqlX916lcyIHNtL++s0DUZIiTXA3bvjiY8kv2q1H4f0+/wKePNn2pEKIMyDaGCHqs5cmsWMifr4egYXJlLu/JfbXKHKfKJ0EgmBfTh0SlFY8qxSz3bxG+Nj2asR5MLZoF7RDpwZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260971; c=relaxed/simple;
	bh=PT6U7N8m7Ox53yKiw8eE7Vpbd12EUaxfbGezLlwIumo=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=B93mWbjLy3NWTEv3RJ1THiDtKLHFZXm+rIMShZ6gJZrS4mOniYjIdoLdw6msKygTm31KzoLds3vuCJXJ3+1beNRiaWjE/UqwzsKRUOblIeZR2RcwjPthwpB2lOikSEGGGLlh3OGODr8gYtTkBTy8A2SQDUMH5k4LcaiRhb9ToUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I+HbyIL3; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I+HbyIL3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788260970; x=1819796970;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=PT6U7N8m7Ox53yKiw8eE7Vpbd12EUaxfbGezLlwIumo=;
  b=I+HbyIL3OarREq+SQkdsvJ7gyPzWpzBgqYg8Zt3kNQX8QItmw8oAqm/v
   VA7Y6x2C0taouIU3eNgia65Nk8oBJSp1Q0sKy7oQlJ/S3gBopd5W9d32t
   /1AqRvHQ91NVGdJVuxjlzoVUjhREvVaNTTlA6xsUzEJAg93oSw7tWds42
   GOnPjtjyrPkf/smeELyE/Os9xZKfnZqsf4P2EfyOcE0rQQGqhxKl0sDcP
   1KBIgqO1M6coKKvCF9zEZ3SqjCvNTf3EiiLn3Y/S0Z+ioH81cHyZWZ8w1
   u0PFHqQRvLdGW2dSLYqnBlSiJ3f1BtXU4L+25g4JrkK2EMnO4gg+NII4T
   Q==;
X-CSE-ConnectionGUID: /dSZFEqsQ6eCNN9/T/vIrw==
X-CSE-MsgGUID: //O5W+MBQzq6Tqj2HEHbuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="92381516"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="92381516"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 04:09:30 -0700
X-CSE-ConnectionGUID: MZOOJboeQ+GgmiGLODi3hA==
X-CSE-MsgGUID: DHcRUdbuT8m70L5cHql2cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="266483210"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.37])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 04:09:24 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 1 Sep 2026 14:09:20 +0300 (EEST)
To: Tony Luck <tony.luck@intel.com>
cc: Fenghua Yu <fenghuay@nvidia.com>, 
    Reinette Chatre <reinette.chatre@intel.com>, 
    Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
    Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>, 
    Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, 
    Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, 
    David E Box <david.e.box@intel.com>, x86@kernel.org, 
    Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, 
    patches@lists.linux.dev
Subject: Re: [PATCH v11 20/23] platform/x86/intel/pmt: Inform resctrl when
 MMIO maps are being removed
In-Reply-To: <20260831174421.13921-21-tony.luck@intel.com>
Message-ID: <e71b9661-0a38-0b61-6250-c0ec58a1979b@linux.intel.com>
References: <20260831174421.13921-1-tony.luck@intel.com> <20260831174421.13921-21-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 31 Aug 2026, Tony Luck wrote:

> Before destroying devices, tell resctrl that the virtual addresses
> supplied by an earlier call to intel_pmt_get_regions_by_feature()
> are about to be invalidated and should not be used again.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v11:
> 	Unbind/remove operations can't cross package boundaries.
> 	Psss package_id instead of bitmap of package IDs.
> 	Use dev_warn() to report failure to find package_id.
> 
>  drivers/platform/x86/intel/pmt/telemetry.c | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
> index 2d2282c636b2..92871ce51c57 100644
> --- a/drivers/platform/x86/intel/pmt/telemetry.c
> +++ b/drivers/platform/x86/intel/pmt/telemetry.c
> @@ -366,11 +366,43 @@ pmt_telem_find_and_register_endpoint(struct device *dev, u32 guid, u16 pos)
>  }
>  EXPORT_SYMBOL_NS_GPL(pmt_telem_find_and_register_endpoint, "INTEL_PMT_TELEMETRY");
>  
> +static int pmt_telem_get_package_id(struct pmt_telem_priv *priv)
> +{
> +	u32 ret = -1;
> +	int i;
> +
> +	mutex_lock(&ep_lock);
> +	for (i = 0; i < priv->num_entries; i++) {
> +		struct intel_pmt_entry *entry = &priv->entry[i];
> +		struct pci_dev *pdev = to_pci_dev(entry->ep->dev);
> +		struct oobmsm_plat_info *plat_info;
> +
> +		plat_info = intel_vsec_get_mapping(pdev);
> +		if (!IS_ERR(plat_info)) {
> +			ret = plat_info->package_id;

Use guard() and a direct return, no need to complicate code flow anymore 
just for handling unlocking.

> +			break;
> +		}
> +	}
> +	mutex_unlock(&ep_lock);
> +
> +	return ret;
> +}

> +
>  static void pmt_telem_remove(struct auxiliary_device *auxdev)
>  {
>  	struct pmt_telem_priv *priv = auxiliary_get_drvdata(auxdev);
> +	int package_id = pmt_telem_get_package_id(priv);
>  	int i;
>  
> +	/*
> +	 * Tell resctrl/AET that virtual mappings for MMIO space in a CPU
> +	 * packages are about to be torn down.
> +	 */
> +	if (package_id != -1)
> +		intel_aet_invalidate(package_id);
> +	else
> +		dev_warn(&auxdev->dev, "Unable to determine package ID for removed device\n");

Why to print this? To me it looks like dev_dbg() material at most, if even 
that.

> +
>  	mutex_lock(&ep_lock);
>  	for (i = 0; i < priv->num_entries; i++) {
>  		struct intel_pmt_entry *entry = &priv->entry[i];
> 

-- 
 i.

