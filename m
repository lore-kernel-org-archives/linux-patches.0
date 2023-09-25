Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041611C91
	for <patches@lists.linux.dev>; Mon, 25 Sep 2023 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695657080; x=1727193080;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=qF20BBdT8u8Kt0n7qjGTVojCZP3GnpWNE8ebYJ3/L9w=;
  b=oGgdkoBUR54yV1arrAeQoiFAn8IHPh1TqHK10weDpLnNwOEXtW8cVLZH
   j9km9Mihart90eHXxfIPPlXA4x899JQKVP2qevSEeTV7YLw4qxOYy70Zs
   eGPbjfsHKKcWg3r9JYCJ83v72ew2I4U319c7Yx7GJ6VsRAt27FMkwF9UU
   CPaj3jHaA1sC1IgDpGmT14rlZyB+V6RNRsmLOh1hJ2gRZx7t1nCK7KkI8
   eT8IpGH6oZ1ySBzZMg1BBkCCUPuH7a8jYYELYW99cAaiC5MYnR1kJUB5G
   ZiAIyNn7imAnfvThzffzMwmsev9iLMuHbrygE+TVwpWvfNYiSmug4Xe89
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="385122880"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="385122880"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 08:51:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="777706393"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="777706393"
Received: from stamengx-mobl1.ger.corp.intel.com ([10.249.32.149])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 08:51:13 -0700
Date: Mon, 25 Sep 2023 18:51:11 +0300 (EEST)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Jithu Joseph <jithu.joseph@intel.com>
cc: Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    rostedt@goodmis.org, ashok.raj@intel.com, tony.luck@intel.com, 
    LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    patches@lists.linux.dev, ravi.v.shankar@intel.com, pengfei.xu@intel.com
Subject: Re: [PATCH v2 7/9] platform/x86/intel/ifs: Add new CPU support
In-Reply-To: <20230922232606.1928026-8-jithu.joseph@intel.com>
Message-ID: <ce1891e-3b37-782f-965f-981c43ac62c@linux.intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com> <20230922232606.1928026-1-jithu.joseph@intel.com> <20230922232606.1928026-8-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2031727069-1695657078=:2147"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2031727069-1695657078=:2147
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 22 Sep 2023, Jithu Joseph wrote:

> Add Granite Rapids(GNR) and Sierra Forest(SRF) cpuids to x86 match table
> so that IFS driver can be loaded for those.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Pengfei Xu <pengfei.xu@intel.com>
> ---
>  drivers/platform/x86/intel/ifs/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
> index 4ff2aa4b484b..0c8927916373 100644
> --- a/drivers/platform/x86/intel/ifs/core.c
> +++ b/drivers/platform/x86/intel/ifs/core.c
> @@ -18,6 +18,9 @@
>  static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
>  	X86_MATCH(SAPPHIRERAPIDS_X),
>  	X86_MATCH(EMERALDRAPIDS_X),
> +	X86_MATCH(GRANITERAPIDS_X),
> +	X86_MATCH(GRANITERAPIDS_D),
> +	X86_MATCH(ATOM_CRESTMONT_X),
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
> 

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

-- 
 i.

--8323329-2031727069-1695657078=:2147--
