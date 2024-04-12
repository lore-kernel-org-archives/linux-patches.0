Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA513AC16
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 20:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712954810; cv=none; b=bjGb9vSdDMDXUY/7DZdGFGduFE9/OCB8T2PqFYjmght6jzS6a7gP0d4v/r1prtLE8qfhbFmzcrvJDYX/3dXYufOlrOnBZ5mz2WiaQmQjQ2ub35gR9Vr+5HWxF33L10F/xyOOoCi9Qk5zUut2GqxROym9RQUJpxFGIf+lk+1pi+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712954810; c=relaxed/simple;
	bh=NaJW1CpbCmMiu1vp/LaOL7R6yRq69skyK1KPbmyNeKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPyR9Kq53dJR9agYyEveR35iFj5sYYZBKYU1jktIlkW0ZenV4xDDDjrB6b+zQPiDe01TB1XttjCWlB0LMCg9kLQF9wS/rIbjsVbv0f1zusauf+Fjr+X1CrKmFodnuXZNNICL1INDVc/AYpoVEKXyeYgFpTNy/qU+azOuuELKfv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lXeDWohx; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lXeDWohx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712954810; x=1744490810;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NaJW1CpbCmMiu1vp/LaOL7R6yRq69skyK1KPbmyNeKc=;
  b=lXeDWohx382qblvyj4kOiN+PWa60YVla0aovhf8gTqA5U1RI0fpM6Tmh
   y0EkOeVW2PBNwWykbMLtJBOn3WJungCleotUcFa1qGFjSvet2IhwpXsLq
   F7vLiixm+tBpOIOzMA2Eve38UqAPCB9M/VRk+jwqczs4zRAs9mneg+lAC
   Y0jWqZExIa14qv+A/Qp09cfG+40Nsfc8fYCMrle4kFq5uZB2NMvMfTFE4
   +/8NWQAtUUY1+8wjST9yAObfiTL/3GAP2FuJXajxbGd0npdw+65X3fjif
   033Nt+ii6pZbFdLFbHqFoT4THedCrguEDcczFLgnLlPSCTTsQD2tnxBTx
   w==;
X-CSE-ConnectionGUID: qzrYzKbDSxuNF8GbhHkjqQ==
X-CSE-MsgGUID: 9zAV4p+4Rvewp+rBwkyaCQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="19573912"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="19573912"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:46:50 -0700
X-CSE-ConnectionGUID: 1iPPyoFhTQe/FM5dMMTWNA==
X-CSE-MsgGUID: Du7LdhHjQwqOJ/+EwN/dog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21834145"
Received: from zchen24-mobl1.amr.corp.intel.com (HELO [10.209.67.36]) ([10.209.67.36])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:46:49 -0700
Message-ID: <e640e6eb-be63-4749-ba04-eb1835527800@linux.intel.com>
Date: Fri, 12 Apr 2024 13:46:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] platform/x86/intel/ifs: Classify error scenarios
 correctly
To: "Joseph, Jithu" <jithu.joseph@intel.com>, ilpo.jarvinen@linux.intel.com,
 hdegoede@redhat.com, markgross@kernel.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 ravi.v.shankar@intel.com, patches@lists.linux.dev
References: <20240412172349.544064-1-jithu.joseph@intel.com>
 <20240412172349.544064-2-jithu.joseph@intel.com>
 <69d360fc-85e4-4a6d-8f08-9f90dd7ec583@linux.intel.com>
 <57c32cfd-136d-4c72-9f4d-12599b508fb8@intel.com>
Content-Language: en-US
From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <57c32cfd-136d-4c72-9f4d-12599b508fb8@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/12/24 12:31 PM, Joseph, Jithu wrote:
> Sathya,
>
> Thanks for reviewing this
>
> On 4/12/2024 11:32 AM, Kuppuswamy Sathyanarayanan wrote:
>> On 4/12/24 10:23 AM, Jithu Joseph wrote:
>>> Based on inputs from hardware architects, only "scan signature failures"
>>> should be treated as actual hardware/cpu failure.
>> Instead of just saying input from hardware architects, it would be better
>> if you mention the rationale behind it.
> I can reword the first para as below:
>
> "Scan controller error" means that scan hardware encountered an error
> prior to doing an actual test on the target CPU. It does not mean that
> there is an actual cpu/core failure. "scan signature failure" indicates
> that the test result on the target core did not match the expected value
> and should be treated as a cpu failure.
>
> Current driver classifies both these scenarios as failures. Modify ...

Looks good to me.

>>> Current driver, in addition, classifies "scan controller error" scenario
>>> too as a hardware/cpu failure. Modify the driver to classify this situation
>>> with a more appropriate "untested" status instead of "fail" status.
>>>
>>> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
>>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>>> Reviewe
>> Code wise it looks good to me.
>>
>> Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
>>
>
> Jithu

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer

