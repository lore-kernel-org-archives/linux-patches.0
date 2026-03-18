Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB94137F010;
	Wed, 18 Mar 2026 08:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773822611; cv=none; b=i9FHEOTDcrDNwULXty4hhXq6aFMEJ4QNfZRj4aDkwLA82deas0hdWfdhzH1XnffVkFKvYqtJhOpId5VkEkpQnRrXEnISAK9NjCOnOIBdPL64+6+4vzZ9aZD3b2JCLXdLBwkjIkivpz7Y6Xtzi6k9uhtqz5HEFmXjg1JOv24uBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773822611; c=relaxed/simple;
	bh=pbu9KEAN9Hjk7Pq5R2AzvD1WO2KA8RROdjID5ZgfhYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lPowhnBuOMZKE+StQqIYAsZSgHRWC3nCDPd4oYBwnTZaCG+A8Pvtb7l4pkxRU256MLrenIAUAVT6fvIj5GYLcHIaP+miwkcRCZLKStESn33tlJiB5gXCI+Pv7F8mt+QZJ4QUMn3Q9MK6FAjwOTwXfN0jjWUL71vsr34x76wQKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=VzP7SnHF; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="VzP7SnHF"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4fbMHS3NcTz83rd;
	Wed, 18 Mar 2026 09:21:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1773822100;
	bh=pbu9KEAN9Hjk7Pq5R2AzvD1WO2KA8RROdjID5ZgfhYQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VzP7SnHF+aT9NS7TLGS0JL3rk5q3PovIVv3t3gZPmZ/8dAyNswVBlyoKiN7zDOygd
	 qcp4UjZjIMchG37VWfA3lpidn0UEs5LJZj4rM9FbznRCco8bUCpH5gahlOxJvlg5Kx
	 4aKcm/XUJXKo3VURweOqmVZHv/uwiPM0+Ot6nndFmJWigQaPcsSrOSnhatf3Ae59kx
	 EzHdpdCOD1rPBRXIQu1rR6QPC7VHIfI9gCpVn9eG504Leq/hmjvkU7/9tMUunDn6dM
	 FkDEX8vmV48mRPE27wzEP1ViLOYNZPNShIXA6lzqKKUDdaQzgJYml+qu1O8si3tpSM
	 IHhuGekxcnk+Q==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4fbMHS2fLVz4xCr;
	Wed, 18 Mar 2026 09:21:40 +0100 (CET)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fbMHR1HYwz8svC;
	Wed, 18 Mar 2026 09:21:39 +0100 (CET)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 148C7633B6;
	Wed, 18 Mar 2026 09:21:38 +0100 (CET)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <2c30f181-ffc6-4d63-a64e-763cf4528f48@leemhuis.info>
Date: Wed, 18 Mar 2026 09:21:36 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.19-5.10] PCI: Enable ACS after configuring IOMMU
 for OF platforms
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Naresh Kamboju <naresh.kamboju@linaro.org>, linux-pci@vger.kernel.org,
 alan@norbauer.com,
 Linux kernel regressions list <regressions@lists.linux.dev>,
 Greg KH <gregkh@linuxfoundation.org>
References: <20260214212452.782265-1-sashal@kernel.org>
 <20260214212452.782265-68-sashal@kernel.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20260214212452.782265-68-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: 
 <177382209852.2934913.14798143036584702580@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 148C7633B6
X-NC-CID: ge0qpM+7utFeGIpCuQGrK6rqRJMrglAGThCOhcdVBPKUVMtItzU=

On 2/14/26 22:23, Sasha Levin wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> [ Upstream commit c41e2fb67e26b04d919257875fa954aa5f6e392e ]
> 
> Platform, ACPI, or IOMMU drivers call pci_request_acs(), which sets
> 'pci_acs_enable' to request that ACS be enabled for any devices enumerated
> in the future.
> 
> OF platforms called pci_enable_acs() for the first device before
> of_iommu_configure() called pci_request_acs(), so ACS was never enabled for
> that device (typically a Root Port).
> 
> Call pci_enable_acs() later, from pci_dma_configure(), after
> of_dma_configure() has had a chance to call pci_request_acs().

Alan (CCed) reported a regression (see below for details) since 6.12.75
bisected to this change that a revert can fix. The change made it to
v6.18.16, v6.6.128, v6.1.165, v5.15.202, v5.10.252, too. But 6.18.17
works fine for Alan.

Is there maybe something missing in older series that causes this
problem? And if not: should this be reverted

Anyway, here is the report:
https://bugzilla.kernel.org/show_bug.cgi?id=221234

"""
Alan Norbauer 2026-03-15 05:56:05 UTC

Created attachment 309662 [details]
iommu group captures across multiple kernels

OVERVIEW:

I isolated a regression in IOMMU groups to Linux Kernel 6.12.75. I use
GPU passthrough and need my two GPUs to be in IOMMU groups that can be
passed-through. If the GPUs are collapsed into group 0 they can no
longer be passed-through to a VM.

STEPS TO REPRODUCE:

I captured my iommu groups on various kernels using this script:
```
kernel=$(uname -r)
echo "Kernel: $kernel"
echo ""
for g in /sys/kernel/iommu_groups/*/devices/*; do
  group=$(echo "$g" | grep -oP 'iommu_groups/\K[0-9]+')
  device=$(basename "$g")
  desc=$(${pkgs.pciutils}/bin/lspci -nns "$device" 2>/dev/null || echo
"unknown")
  echo "Group $group: $device $desc"
done | sort -t' ' -k2 -n
```

If the GPUs are in Group 0 then my VMs break.

RESULTS on Kernel 6.12.74 ✅:

Group 14: 0000:01:00.0 01:00.0 VGA compatible controller [0300]: NVIDIA
Corporation AD107GL [RTX 2000 / 2000E Ada Generation] [10de:28b0] (rev a1)
...
Group 18: 0000:05:00.0 05:00.0 VGA compatible controller [0300]: Intel
Corporation DG2 [Arc A310] [8086:56a6] (rev 05)

RESULTS on Kernel 6.12.75 ❌:

Group 0: 0000:01:00.0 01:00.0 VGA compatible controller [0300]: NVIDIA
Corporation AD107GL [RTX 2000 / 2000E Ada Generation] [10de:28b0] (rev a1)
...
Group 0: 0000:05:00.0 05:00.0 VGA compatible controller [0300]: Intel
Corporation DG2 [Arc A310] [8086:56a6] (rev 05)

I also tested:
Kernel 6.12.75 with the following patch reverted and the issue was fixed
and my groups were correct again:

"PCI: Enable ACS after configuring IOMMU for OF platforms"
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7a126c1b6cfa2c4b5a7013164451ecddd210110d

I also tested:
kernel 6.12.76 => broken ❌
kernel 6.18.17 => good ✅
kernel 6.19.7  => good ✅

You can find the full script output for all the above kernels in the
attached captures.zip

TEST HARDWARE:

- Motherboard = Supermicro H13SAE-MF
- CPU = AMD EPYC 4545P CPU
- GPU1 = Intel Arc A310
- GPU2 = NVIDIA RTX 2000 Ada
"""

Ciao, Thorsten


> Here's the call path, showing the move of pci_enable_acs() from
> pci_acs_init() to pci_dma_configure(), where it always happens after
> pci_request_acs():
> 
>     pci_device_add
>       pci_init_capabilities
>         pci_acs_init
>  -        pci_enable_acs
>  -          if (pci_acs_enable)                <-- previous test
>  -            ...
>       device_add
>         bus_notify(BUS_NOTIFY_ADD_DEVICE)
>           iommu_bus_notifier
>             iommu_probe_device
>               iommu_init_device
>                 dev->bus->dma_configure
>                   pci_dma_configure            # pci_bus_type.dma_configure
>                     of_dma_configure
>                       of_iommu_configure
>                         pci_request_acs
>                           pci_acs_enable = 1   <-- set
>  +                  pci_enable_acs
>  +                    if (pci_acs_enable)      <-- new test
>  +                      ...
>         bus_probe_device
>           device_initial_probe
>             ...
>               really_probe
>                 dev->bus->dma_configure
>                   pci_dma_configure            # pci_bus_type.dma_configure
>                     ...
>                       pci_enable_acs
> 
> Note that we will now call pci_enable_acs() twice for every device, first
> from the iommu_probe_device() path and again from the really_probe() path.
> Presumably that's not an issue since we also call dev->bus->dma_configure()
> twice.
> 
> For the ACPI platforms, pci_request_acs() is called during ACPI
> initialization time itself, independent of the IOMMU framework.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> [bhelgaas: commit log]
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Link: https://patch.msgid.link/20260102-pci_acs-v3-1-72280b94d288@oss.qualcomm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> The commit under review builds on the existing `pci_enable_acs()`
> infrastructure. The key dependency is on `f3c3ccc4fe49d` ("PCI: Fix
> pci_enable_acs() support for the ACS quirks") from v6.12 era, which
> restructured `pci_enable_acs()` and `pci_dev_specific_enable_acs()`. The
> code structure in the diff matches what's in current mainline,
> suggesting this applies to the current code layout which includes the
> ACS refactoring from 6.11/6.12.
> 
> ### 6. STABLE KERNEL ASSESSMENT
> 
> **Meets stable criteria:**
> - **Fixes a real bug**: ACS not being enabled on the first PCI device on
>   OF platforms
> - **Obviously correct**: Simply moves a function call to after its
>   dependency is satisfied
> - **Small and contained**: ~30 lines changed across 3 files, all in PCI
>   subsystem
> - **No new features**: Just reorders existing functionality
> - **Tested**: Two Tested-by tags
> - **Written by subsystem experts**: PCI maintainer involvement
> 
> **Concerns:**
> - The commit depends on the `pci_enable_acs()` refactoring from
>   `47c8846a49ba` ("PCI: Extend ACS configurability") and its fix
>   `f3c3ccc4fe49d`. These are from v6.11/v6.12 timeframe, so they should
>   be in recent stable trees but may not be in older LTS trees (5.15,
>   5.10). The backport would need to be adapted for trees where
>   `pci_enable_acs()` has a different structure.
> - For recent stable trees (6.6+, 6.12+) this should apply cleanly or
>   with minor adjustments.
> 
> ### 7. CONCLUSION
> 
> This is a real bug fix for OF/DT platforms where ACS is never enabled on
> the first PCI device (Root Port). This impacts IOMMU isolation, device
> passthrough, and security. The fix is small, surgical, well-understood,
> and tested. It moves an existing function call to the correct point in
> the initialization sequence. The risk is low — the function is
> idempotent and the change doesn't alter any logic, only timing.
> 
> The primary concern is dependency on ACS refactoring in newer kernels,
> but for stable trees that have that infrastructure, this is a clear
> backport candidate.
> 
> **YES**
> 
>  drivers/pci/pci-driver.c |  8 ++++++++
>  drivers/pci/pci.c        | 10 +---------
>  drivers/pci/pci.h        |  1 +
>  3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 7c2d9d5962586..301a9418e38e0 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -1650,6 +1650,14 @@ static int pci_dma_configure(struct device *dev)
>  		ret = acpi_dma_configure(dev, acpi_get_dma_attr(adev));
>  	}
>  
> +	/*
> +	 * Attempt to enable ACS regardless of capability because some Root
> +	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
> +	 * the standard ACS capability but still support ACS via those
> +	 * quirks.
> +	 */
> +	pci_enable_acs(to_pci_dev(dev));
> +
>  	pci_put_host_bridge_device(bridge);
>  
>  	/* @drv may not be valid when we're called from the IOMMU layer */
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b99ad5f50f30d..479887ece9e7a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1015,7 +1015,7 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
>   * pci_enable_acs - enable ACS if hardware support it
>   * @dev: the PCI device
>   */
> -static void pci_enable_acs(struct pci_dev *dev)
> +void pci_enable_acs(struct pci_dev *dev)
>  {
>  	struct pci_acs caps;
>  	bool enable_acs = false;
> @@ -3648,14 +3648,6 @@ bool pci_acs_path_enabled(struct pci_dev *start,
>  void pci_acs_init(struct pci_dev *dev)
>  {
>  	dev->acs_cap = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
> -
> -	/*
> -	 * Attempt to enable ACS regardless of capability because some Root
> -	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
> -	 * the standard ACS capability but still support ACS via those
> -	 * quirks.
> -	 */
> -	pci_enable_acs(dev);
>  }
>  
>  /**
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 0e67014aa0013..4592ede0ebcc6 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -939,6 +939,7 @@ static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
>  }
>  
>  void pci_acs_init(struct pci_dev *dev);
> +void pci_enable_acs(struct pci_dev *dev);
>  #ifdef CONFIG_PCI_QUIRKS
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
>  int pci_dev_specific_enable_acs(struct pci_dev *dev);

