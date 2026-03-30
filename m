Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E039C00F
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905479; cv=none; b=li8YD3IRGnEH207tjpHpO37kqOmhjC8UHM8FCURBVjFjZBcEacVlo9HA/nPkYgO7qwMreLEmnUk5D3Ct65sDA4NuQwoQ3zDSP75aQOlI3dDzqSYyi740Cl9SW5k2LfcTuUs6+I8+YJzVRcQfPfcgjzUK3X7m0GfiXOfG6OkFD94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905479; c=relaxed/simple;
	bh=Ko3oY/4SMQQ3vctYvOoRtCHmDsI7gmvMiwOZXIW0VIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z20xNQG1kiK4sdpmYg97y69qNPXkRhL1xljRxekiGWzevwDH+IAFvH8Zb3fwV9IcvzNirCML710WKaTw+4IVNliKlYjk/2pRxBQPpwWUOG7BorZFs02DxCJmqi1LqFCx/XN+Z7BubxBcA5F7W8jACQ5w7WoFgsJbBSkDZQ1oaIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FpM0/DH3; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FpM0/DH3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774905477; x=1806441477;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ko3oY/4SMQQ3vctYvOoRtCHmDsI7gmvMiwOZXIW0VIo=;
  b=FpM0/DH3APg4OxWSKFNcaiGZr9Mn6HHkXppMZm/bFhXfQzWwlIS23dBz
   HQhQyeRmV2w752OIa6FussyPPeMLUmwNLV76UpSTFQi5tRB7rdILj00Hq
   0D70jNFAVHI5IHp1+S7jOgPnrndfHpytpxHGcCQevjTVfN/4E1sE3XXyr
   pPaEKrF1x6Jpe/+Yyj49Gsa2ZBPPNwJPSG/+Mpm0tVpZFtTXuFnRKkFup
   rr3JX4Dbv/HcLNkH9e+cYZ1k2THFZDrf+yJ74OeG05o7T6W8MJu7nIsww
   FipFmh7+Bxq+6roJr4Qqk9+3maHNuI9zgDUcAwLU+CKEjhUXRrYRSgNir
   A==;
X-CSE-ConnectionGUID: ePotPG4TQwmEAwPtoUZdNw==
X-CSE-MsgGUID: P/b5CA7KQ3GRHKd80bbRjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="63461220"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="63461220"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:17:56 -0700
X-CSE-ConnectionGUID: 0kq6degtRP2d1e+YRNIl5Q==
X-CSE-MsgGUID: OYuXu2cXQMuMp1jX6vzh7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="223289941"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.111.4]) ([10.125.111.4])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:17:56 -0700
Message-ID: <9de8883d-0252-4d2c-9fe3-2d2464432334@intel.com>
Date: Mon, 30 Mar 2026 14:17:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] dax/hmem: Add tests for the dax_hmem takeover
 capability
To: "Koralahalli Channabasappa, Smita" <skoralah@amd.com>,
 Dan Williams <dan.j.williams@intel.com>
Cc: patches@lists.linux.dev, linux-cxl@vger.kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, stable@vger.kernel.org
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <f1adf0ee-fdd2-43b8-91e1-1102643afa49@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <f1adf0ee-fdd2-43b8-91e1-1102643afa49@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 3/30/26 2:12 PM, Koralahalli Channabasappa, Smita wrote:
> On 3/26/2026 10:28 PM, Dan Williams wrote:
>> Given all the cross subsystem dependencies needed to make this solution
>> work, it needs to have a unit test to keep it functional.
>>
>> On the path to writing that, several fixes fell out, but not to Smita's
>> code, to mine. One use-after-free has been there since the original
>> automatic region assembly code.
>>
>> Here is a preview of the core of the test I will submit to the cxl-cli project:
>>
>> ---
>> modprobe cxl_mock_mem && modprobe cxl_test hmem_test=1
>>
>> dax=$(find_dax_cxl)
>> [[ "$dax" == "" ]] && err $LINENO
>> dax=$(find_dax_hmem)
>> [[ "$dax" != "" ]] && err $LINENO
>>
>> unload
>>
>> modprobe cxl_mock_mem && modprobe cxl_test fail_autoassemble hmem_test=1
>>
>> dax=$(find_dax_cxl)
>> [[ "$dax" != "" ]] && err $LINENO
>> dax=$(find_dax_hmem)
>> [[ "$dax" == "" ]] && err $LINENO
>>
>> unload
>> ---
>>
>> This builds on Smita's series [1] pushed out to for-7.1/dax-hmem in
>> cxl.git [2].
>>
>> [1]: http://lore.kernel.org/20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com
>> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-7.1/dax-hmem
>>
>> Dan Williams (9):
>>    cxl/region: Fix use-after-free from auto assembly failure
>>    dax/cxl: Fix HMEM dependencies
>>    cxl/region: Limit visibility of cxl_region_contains_resource()
>>    cxl/region: Constify cxl_region_resource_contains()
>>    dax/hmem: Reduce visibility of dax_cxl coordination symbols
>>    dax/hmem: Fix singleton confusion between dax_hmem_work and hmem
>>      devices
>>    dax/hmem: Parent dax_hmem devices
>>    tools/testing/cxl: Simulate auto-assembly failure
>>    tools/testing/cxl: Test dax_hmem takeover of CXL regions
>>
>>   drivers/dax/Kconfig                |   6 +-
>>   drivers/cxl/cxl.h                  |  11 ++-
>>   drivers/dax/bus.h                  |  15 +++-
>>   include/cxl/cxl.h                  |  15 ----
>>   tools/testing/cxl/test/mock.h      |   8 ++
>>   drivers/cxl/core/region.c          |  68 +++++++++++++++--
>>   drivers/dax/hmem/device.c          |  28 ++++---
>>   drivers/dax/hmem/hmem.c            | 115 +++++++++++++++--------------
>>   tools/testing/cxl/test/cxl.c       |  66 +++++++++++++++++
>>   tools/testing/cxl/test/hmem_test.c |  47 ++++++++++++
>>   tools/testing/cxl/test/mem.c       |   3 +
>>   tools/testing/cxl/test/mock.c      |  50 +++++++++++++
>>   tools/testing/cxl/Kbuild           |   7 ++
>>   tools/testing/cxl/test/Kbuild      |   1 +
>>   14 files changed, 344 insertions(+), 96 deletions(-)
>>   delete mode 100644 include/cxl/cxl.h
>>   create mode 100644 tools/testing/cxl/test/hmem_test.c
>>
>>
>> base-commit: 51d2fa02c0e4b3b23c4484f2af9b6d65c35471e8
> 
> I tested this series. Its working as expected for me. Thanks for the incremental.

Hi Smita. Can you provide a tested-by tag pls?

> 
> Thanks
> Smita
> 

