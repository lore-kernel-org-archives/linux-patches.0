Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D39111A5
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 11:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696247236; x=1727783236;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=nGT64aLj6aCAR4SxHGB4G+zMfkc71+hJeH9BwNHnCK8=;
  b=Nk43VerSl3loaxABamCHAIuVQfExtNZm1mT4nYX9yNxVLjtsIreBk7e/
   apq+f8UNV6ub9x24pyGa0tS1ucFMs/lYPokLmJRKj7WXxtp5lh2n/FVMr
   KjrKndbV6a029Vd/AVjFCGWZMeLAPKaNPgHGCtQub4T6U17fwRAPtYZye
   dohlWy4m2h8RF8crVJr5gjRkTNtfsEr4nDkaXdap4qIWbP1bnv20fr9FK
   flbv4a8b3kOyidStJjyLN5Ue/hiMOQQMNn6ABnzWLCc6aHYsJu7v9uP3e
   ZAJY9z52VfXNKOmzyKxkBIotnSs2hkLGb3N4R3LDbQjNiJ9wbRfJ/Scfe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="381509007"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="381509007"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="1495707"
Received: from roliveir-mobl1.ger.corp.intel.com ([10.251.222.16])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 04:46:31 -0700
Date: Mon, 2 Oct 2023 14:47:08 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v3 6/9] platform/x86/intel/ifs: Metadata validation for
 start_chunk
In-Reply-To: <20230929202436.2850388-7-jithu.joseph@intel.com>
Message-ID: <e8bcbdcc-8cba-57ec-b0fc-4d66305d5aed@linux.intel.com>
References: <20230922232606.1928026-1-jithu.joseph@intel.com> <20230929202436.2850388-1-jithu.joseph@intel.com> <20230929202436.2850388-7-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 29 Sep 2023, Jithu Joseph wrote:

> Add an additional check to validate IFS image metadata field prior to
> loading the test image.
> 
> If start_chunk is not a multiple of chunks_per_stride error out.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/load.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
> index da54fd060878..6f8abb4729e9 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -291,6 +291,13 @@ static int validate_ifs_metadata(struct device *dev)
>  		return ret;
>  	}
>  
> +	if (ifs_meta->chunks_per_stride &&
> +	    (ifs_meta->starting_chunk % ifs_meta->chunks_per_stride != 0)) {
> +		dev_warn(dev, "Starting chunk num %d not a multiple of chunks_per_stride %d\n",
> +			 ifs_meta->starting_chunk, ifs_meta->chunks_per_stride);

Please use %u as both are u32s.

-- 
 i.

> +		return ret;
> +	}
> +
>  	return 0;
>  }
>  
> 

