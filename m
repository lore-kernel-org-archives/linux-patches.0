Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79D148313
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712949242; cv=none; b=NpyB+9SlSWp7+IIGHjGPJ7jtGD6rRBI2LusYwzf3NrDMXGgVrx5BrohRlZV+lSq4aDKKq2gcDJoE3bCviI9907LJPcEp28UtUxGLLgB56ukvUGXZgLoFZ2mNstdP2DN1Q3gfiQ3/kDb4XHUaIKkxnBmg/H6HTbqC5PTidA5UbDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712949242; c=relaxed/simple;
	bh=Eu3ZcZPFL16HSzXgIdXanfvswaxE9WSR58W60oCYX1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4aCK8cN+RI0kQjnYPZu336b/jS0AVZUkE1XKeI0qqXehs2TStR/CIyg+7zgGx40wkxnEH4Ynu75p/7mwRzLIlr4GrZbjnwdj5o6oAfnQr1yi3rvvmeIl6PGMs9XLymWO+SRWMS0f9FwT8oJJxk8r+Fv7LZXUNqO7YXt9sJgvdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1kHyLw9; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1kHyLw9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712949240; x=1744485240;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Eu3ZcZPFL16HSzXgIdXanfvswaxE9WSR58W60oCYX1A=;
  b=h1kHyLw9jG1mSlPE9pRxS8PO1Ol8XraPcLvUWYI3+oHW7hq4SeLnPDkJ
   PWkYbsQ4dxkWqt5zdZQ0+rJ9KQXnRqJm7TOeve1WWz5lWBFbXGKOne5k3
   XANrRS1tsW4UDvPXRtWGRUr6jzBsUrykUa0tAx6yGUX7k7zg4S/UjAEuh
   LLzUPq9ekbAL6qmxA+gzmYolj3tFyWDwPr6hXg1S1AD4FMxBISVW/o3kd
   dcpsGByryf5XtT4N45WXu9amMXw1vVXBrh5tXs7b0/9GjGXbTNLJI+Yth
   7m7cbotxLZZgzChAfiHAocJA3TMLY7rqryraPG9ISBCdk0NLHxEO6pPW6
   w==;
X-CSE-ConnectionGUID: ArQFRXQpTCuamPyochNlPg==
X-CSE-MsgGUID: ZY8/FvOwTSeMIoeLbaK/lw==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12200340"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="12200340"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 12:13:59 -0700
X-CSE-ConnectionGUID: VQj/SEm1QCagNhACyRVF7w==
X-CSE-MsgGUID: vJ5c31aURduo5abfjbOttw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="26107097"
Received: from zchen24-mobl1.amr.corp.intel.com (HELO [10.209.67.36]) ([10.209.67.36])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 12:13:59 -0700
Message-ID: <156e1b5b-0f19-4993-b46c-7b67b91317a4@linux.intel.com>
Date: Fri, 12 Apr 2024 12:13:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] platform/x86/intel/ifs: Disable irq during one load
 stage
To: Jithu Joseph <jithu.joseph@intel.com>, ilpo.jarvinen@linux.intel.com,
 hdegoede@redhat.com, markgross@kernel.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 ravi.v.shankar@intel.com, patches@lists.linux.dev
References: <20240412172349.544064-1-jithu.joseph@intel.com>
 <20240412172349.544064-4-jithu.joseph@intel.com>
Content-Language: en-US
From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20240412172349.544064-4-jithu.joseph@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 4/12/24 10:23 AM, Jithu Joseph wrote:
> One of the stages in IFS image loading process involves loading individual
> chunks (test patterns) from test image file to secure memory.
>
> Driver issues a WRMSR(MSR_AUTHENTICATE_AND_COPY_CHUNK) operation to do
> this. This operation can take up to 5 msec, and if an interrupt occurs
> in between, the AUTH_AND_COPY_CHUNK u-code implementation aborts the
> operation.
>
> Interrupt sources such as NMI or SMI are handled by retrying. Regular
> interrupts may occur frequently enough to prevent this operation from ever
> completing. Disable irq on local cpu around the aforementioned WRMSR to
> allow the operation to complete.
>
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Ashok Raj <ashok.raj@intel.com>
> ---


Looks good to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>


>  drivers/platform/x86/intel/ifs/load.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index 584c44387e10..39f19cb51749 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -233,7 +233,9 @@ static int copy_hashes_authenticate_chunks_gen2(struct device *dev)
>  		chunk_table[0] = starting_chunk_nr + i;
>  		chunk_table[1] = linear_addr;
>  		do {
> +			local_irq_disable();
>  			wrmsrl(MSR_AUTHENTICATE_AND_COPY_CHUNK, (u64)chunk_table);
> +			local_irq_enable();
>  			rdmsrl(MSR_CHUNKS_AUTHENTICATION_STATUS, chunk_status.data);
>  			err_code = chunk_status.error_code;
>  		} while (err_code == AUTH_INTERRUPTED_ERROR && --retry_count);

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer

