Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175019;
	b=hDV2+ZoB7q7HYXs9+H+NRWqMiVuSvBMi2J+tkY++TiL78QpC9IvuUIFh7t0W3VFpoDTG
	 7c1SWsCbrKoUt2xpjWUYejBNflAH9FQceOhdSs4cP9HXxmEQD3WKok24Kg1s7QeqxrK3D
	 56TgjCf5MJ6jPezxqbbi/SEQ+iIJiIvRXHT8KenQ5AE/2YaJFohHuYY1Drd+bFp7XAFH2
	 kHJghHdEVzLLGOfXpCUXKplw+WJuNo82IJUw7LoN/9QOIDQc7vQOeTydxJa21DGnfsiAQ
	 FZd90rUkqEu/7aEMypho5nXe1ZesCnwgIBMw3ywb1ObYUqCLlC3B5uLeLGhLSDiUVNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175019;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=VesvHE2NCs2cycQn+5+nrmTvzccPzdufxO3TqLOF7RY=;
	b=x5OY0rcDiPygVIisaLvVZ+2YKQz00emlfcNC2Li7VuhQYe9vUMSTRE4we+mW8FD9VQJB
	 Sk8bpvIUey+UvUTdfkJzCZdfkTdo5etpl7zz49PpDk68L4UJHfu+vG111sv3/lBaKogtf
	 N+JZOwzigwIdx8adjUiBIgjmryOFb/N5t+0VriYjRk3SBKVzeoaTp/cwBmjPyiH6hBRdX
	 3CPpXsBHhS7KE/eFWcS+9Zo/oXzR5H/8MSJj5dS9I54PBWdZqFiK/P+MbsCpa2m85rGRJ
	 6XsqqJ0tVkpMjWM1tKeSJOT6AYC/Q07ZaxHhEOjDvj+lcblcEFrRNhIBIPlOrUp2NYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aAuJeIeQ;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317460A3803
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 11:43:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C317460A3803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aAuJeIeQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795175019; x=1826711019;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KhjkRsM4o73kxPUE3AzwWYfbcjkFWJVajXiB+PsF+pk=;
  b=aAuJeIeQosIIFvpnqOJ4ZC4FboafBbJE2VHiHklz93PFQAALb0KlnIbp
   jsMCIX/M7Yow8l3AHRGD/tvrHBzcSmDH7tx4zwCnFEG/ePu3qmSFlSngF
   ymTqMXcU4z4NRXrO+Y5TH2+mDFy0KDOUU20aMlHA7yzNei+FTt3FvL5hK
   rA8sSqHpCieMDqGVOnOc+KZ0bxKn7nuiRxlLvOnuVnSFjkxF3ssypgSlk
   37Pc1Z8rcS+Pu0vLHS8FUk3o7htcW5zlN0DuefdRNjwNv8iXU0WTH8g4H
   EECdoJzq5XCnbRzI9R9E2E+KrKA7vUqQtz3mo32PilDPYyyFJnkDNdbod
   Q==;
X-CSE-ConnectionGUID: R346PfoBSAue4ldWxQaLiw==
X-CSE-MsgGUID: jzyfDwk1QuedJeoxdeIoRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4083655"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="4083655"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 03:43:38 -0800
X-CSE-ConnectionGUID: EzPnGSoHSMemkSFgfwVa2A==
X-CSE-MsgGUID: nq+i4X5lRMOGq6kExUW+aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="11044210"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.9]) ([10.124.240.9])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 03:43:36 -0800
Message-ID: <5f94f0aa-80ad-4aac-8b91-5e1aba36ca2c@intel.com>
Date: Fri, 20 Nov 2026 19:43:32 +0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, Sean Christopherson <seanjc@google.com>,
 stable@vger.kernel.org, patches@lists.linux.dev,
 Nikolay Borisov <nik.borisov@suse.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20261104211043.516122098@linuxfoundation.org>
 <20261104211109.504581890@linuxfoundation.org>
 <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com>
 <2026110539-lived-blast-ef64@gregkh> <auyRq2HXJIfMXgBh@google.com>
 <20261106-re-kvm-tdx-bus-lock-drop@kernel.org>
 <6e48bcc5-8f7c-4e5a-9e34-1cab1c53dd92@intel.com>
 <2026112012-hardener-radish-1583@gregkh>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <2026112012-hardener-radish-1583@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/2026 2:38 PM, Greg Kroah-Hartman wrote:
> On Fri, Nov 20, 2026 at 02:23:41PM +0800, Xiaoyao Li wrote:
>> On 11/6/2026 9:19 PM, Sasha Levin wrote:
>>> On Thu, Nov 05, 2026, Sean Christopherson wrote:
>>>> Yes, please drop it.  Thanks!
>>>
>>> Dropped from the 6.18 queue only: 7.3 has the prerequisites.
>>
>> Can you pick this patch for 6.18 queue now? I check the linux-6.18.y, which now
>> has all the prerequisite patches now.
> 
> What is "this patch"?
> 
> You dropped the context...

Exactly this one:
https://lore.kernel.org/all/20261104211109.504581890@linuxfoundation.org/
