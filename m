Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318EE125CA
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694797207; x=1726333207;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=TkyxTjmo4j+T1tGFjWBvv1CU6NTsv9h5dOWGiYDUv3o=;
  b=gZ/V19TiVe6VYjCsRP//fY9dqrYBd1hfwSAW+d2hwvIWAl8fr+sS8PMQ
   Xs0OvFJU9YnMskF4WvOIGkW5+ECWlObPOmidBc3W2llLtG9YDQodI6yiw
   4X51ugxS9hy59QHWe3XCCm5Ol67qIUfv/w3cIjyqQ/u2gdcHnh2GrEomC
   Rh4K+FKhHDzX/GJRErhdhchA4EVASjUrFSRQotgNVIbfOzogkd37WE6Xj
   rZGhBMCFas3shjUocvUQZ3bXzLDXM/NeGUOqBQwu0jTVQZLaYDv3KPC2/
   /0VafO69AyqUlvfvQPmbL+jlJRCoIXXcMfQ/jN20IzAbPPNxmfqCnE4sc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="378208050"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="378208050"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 10:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="835268158"
X-IronPort-AV: E=Sophos;i="6.02,149,1688454000"; 
   d="scan'208";a="835268158"
Received: from srdoo-mobl1.ger.corp.intel.com ([10.252.38.99])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 10:00:01 -0700
Date: Fri, 15 Sep 2023 19:59:59 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, rostedt@goodmis.org, ashok.raj@intel.com, 
    tony.luck@intel.com, linux-kernel@vger.kernel.org, 
    platform-driver-x86@vger.kernel.org, patches@lists.linux.dev, 
    ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH 07/10] platform/x86/intel/ifs: Metadata validation for
 start_chunk
In-Reply-To: <20230913183348.1349409-8-jithu.joseph@intel.com>
Message-ID: <3dc5207d-37b7-52fe-954-889d5456192d@linux.intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com> <20230913183348.1349409-8-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 13 Sep 2023, Jithu Joseph wrote:

> Add an additional check to validate IFS image metadata field
> prior to loading the test image.
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
> index 778a3b89a24d..88630366a23c 100644
> --- a/drivers/platform/x86/intel/ifs/load.c
> +++ b/drivers/platform/x86/intel/ifs/load.c
> @@ -292,6 +292,13 @@ static int validate_ifs_metadata(struct device *dev)
>  		return ret;
>  	}
>  
> +	if (ifs_meta->chunks_per_stride &&
> +	    (ifs_meta->starting_chunk % ifs_meta->chunks_per_stride)) {

While this is not incorrect, it would make the code easier to understand 
if you add != 0.

> +		dev_warn(dev, "Starting chunk num %d not a multiple of chunks_per_stride %d\n",
> +			 ifs_meta->starting_chunk, ifs_meta->chunks_per_stride);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>  
> 

-- 
 i.

