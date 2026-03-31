Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB8C28D8DB
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 21:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994263; cv=none; b=Qsf1/x+0YKxwSRrqTmg4yoFyO8pl2dAT993BrSiU2GuqEGaB1HlgClYtjRDeMbsyovcHsGjfyoWlIhHVHUYXNcGlhStvQ6N86eSTiUHctdXn5XhpmZ3Keu1uy0A3AUrEMCizl4hs0kVBF+8Ct7ldWBX1D5OPDlPco7m1UnxEm48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994263; c=relaxed/simple;
	bh=osHKNBJnoAssK6sgDBH0zR07D+BOTdyaNa/D8nRPko8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3ETrlyfUH5+NXbZeVRAQlzTYMcoawFCGOCxVFQtbXBSi5qgjP/cRmSb9GrDT0HF4LkfTDGX67KLqmiXrdI/76SGIV0fEfUeXjciFycquJ2S36ytwkA0z9eq7wBKcid2ahV67zFAmFsa/Dp40VNhMcJx0hrjytSnAB2G7h/KmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HVAK1/km; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HVAK1/km"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774994262; x=1806530262;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=osHKNBJnoAssK6sgDBH0zR07D+BOTdyaNa/D8nRPko8=;
  b=HVAK1/km7UnGs39z00nn/ps2Kju39lQZr7ZGgffA0Lh7Q092JLHrwzz9
   l4I8/Uv0yLYFi+CPz7T7VhWUhxt34zpI7TC1zVeyQDV2JZ6kHC4nL8VGL
   sry+VuhZDRzxnbKiZNfMT8bFDiJDl2WXFR0ebI9wFiu8uU3JwYXHWECi+
   A51/HDk6Y5233q8TaoSAKUzW24JUna8O3H2cC8LhpjRhDGTnekNJjVwMo
   1iR8b58QjeuGaKOdz221edSfYI40jVjIbh+NGvjeuDKr27Qoa6eC+W9ij
   9qz4efrN98/uVk9ProfuZIIkDiRU7To9AjLvcBQ1bX93X9zL6Qflt4gV3
   g==;
X-CSE-ConnectionGUID: 8dHphy0BSLaEBCkSpj8XgA==
X-CSE-MsgGUID: 8ymey02jSVOuvbU9xHaz/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="86720840"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="86720840"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 14:57:41 -0700
X-CSE-ConnectionGUID: ygebbQbFSsGxN9E27mM+cQ==
X-CSE-MsgGUID: QMsDLU5DScizyhOrzfPPQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="222091722"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.56]) ([10.125.111.56])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 14:57:40 -0700
Message-ID: <b0269343-6dc4-4b46-8d78-5edf85fed9a8@intel.com>
Date: Tue, 31 Mar 2026 14:57:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] dax/hmem: Add tests for the dax_hmem takeover
 capability
To: Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, stable@vger.kernel.org
References: <20260327052821.440749-1-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260327052821.440749-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 10:28 PM, Dan Williams wrote:
> Given all the cross subsystem dependencies needed to make this solution
> work, it needs to have a unit test to keep it functional.
> 
> On the path to writing that, several fixes fell out, but not to Smita's
> code, to mine. One use-after-free has been there since the original
> automatic region assembly code.
> 
> Here is a preview of the core of the test I will submit to the cxl-cli project:
> 
> ---
> modprobe cxl_mock_mem && modprobe cxl_test hmem_test=1
> 
> dax=$(find_dax_cxl)
> [[ "$dax" == "" ]] && err $LINENO
> dax=$(find_dax_hmem)
> [[ "$dax" != "" ]] && err $LINENO
> 
> unload
> 
> modprobe cxl_mock_mem && modprobe cxl_test fail_autoassemble hmem_test=1
> 
> dax=$(find_dax_cxl)
> [[ "$dax" != "" ]] && err $LINENO
> dax=$(find_dax_hmem)
> [[ "$dax" == "" ]] && err $LINENO
> 
> unload
> ---
> 
> This builds on Smita's series [1] pushed out to for-7.1/dax-hmem in
> cxl.git [2].
> 
> [1]: http://lore.kernel.org/20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-7.1/dax-hmem
> 
> Dan Williams (9):
>   cxl/region: Fix use-after-free from auto assembly failure
>   dax/cxl: Fix HMEM dependencies
>   cxl/region: Limit visibility of cxl_region_contains_resource()
>   cxl/region: Constify cxl_region_resource_contains()
>   dax/hmem: Reduce visibility of dax_cxl coordination symbols
>   dax/hmem: Fix singleton confusion between dax_hmem_work and hmem
>     devices
>   dax/hmem: Parent dax_hmem devices
>   tools/testing/cxl: Simulate auto-assembly failure
>   tools/testing/cxl: Test dax_hmem takeover of CXL regions
> 
>  drivers/dax/Kconfig                |   6 +-
>  drivers/cxl/cxl.h                  |  11 ++-
>  drivers/dax/bus.h                  |  15 +++-
>  include/cxl/cxl.h                  |  15 ----
>  tools/testing/cxl/test/mock.h      |   8 ++
>  drivers/cxl/core/region.c          |  68 +++++++++++++++--
>  drivers/dax/hmem/device.c          |  28 ++++---
>  drivers/dax/hmem/hmem.c            | 115 +++++++++++++++--------------
>  tools/testing/cxl/test/cxl.c       |  66 +++++++++++++++++
>  tools/testing/cxl/test/hmem_test.c |  47 ++++++++++++
>  tools/testing/cxl/test/mem.c       |   3 +
>  tools/testing/cxl/test/mock.c      |  50 +++++++++++++
>  tools/testing/cxl/Kbuild           |   7 ++
>  tools/testing/cxl/test/Kbuild      |   1 +
>  14 files changed, 344 insertions(+), 96 deletions(-)
>  delete mode 100644 include/cxl/cxl.h
>  create mode 100644 tools/testing/cxl/test/hmem_test.c
> 
> 
> base-commit: 51d2fa02c0e4b3b23c4484f2af9b6d65c35471e8

Applied to cxl/next
fe5dfc24e003 tools/testing/cxl: Test dax_hmem takeover of CXL regions
de121c377f88 tools/testing/cxl: Simulate auto-assembly failure
a515eb335f51 dax/hmem: Parent dax_hmem devices
841e96c053f1 dax/hmem: Fix singleton confusion between dax_hmem_work and hmem devices
6c96c76597cc dax/hmem: Reduce visibility of dax_cxl coordination symbols
069a54fd21e8 cxl/region: Constify cxl_region_resource_contains()
b95c14f0dc79 cxl/region: Limit visibility of cxl_region_contains_resource()
6c7077d5ca81 dax/cxl: Fix HMEM dependencies
16413cc33cfd cxl/region: Fix use-after-free from auto assembly failure

