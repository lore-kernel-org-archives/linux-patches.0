Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5F1FF1AE
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770853045; cv=none; b=r79mPA2FYRFjq9Tm746mZWuTCWUAVjoS9OYzozwBVY5kqxJZgUwDTWGdPokxqc2xljCIZDmHraLseAItB5Dhp9y41hHq3sHqHn5EO7Og7Ni4+tsqyXreRbF272RocJzmDI/FRNUcqT/nQERkh+EoZzn9YOOIh1N6V19xIH9CMFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770853045; c=relaxed/simple;
	bh=d70P8BgJWrM5BS94U7Avsj0AtcFvIYcVY1eR1EEIOes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UeXUA3Dpygpg8r/o3Q1z4NKFqM+kVLh0ew70yG2UfYwWhe7EhTN2BnskMzRGc8xcLy7n0CumErvz/NcHZh+TCgchgrdy+AajOf/0HozReztbw1Szpf+hX/Ao4U2A8jsWNhy31bRCXaPUkkElADxBqRlaPg6SNknf0kOKeZvVvzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAImxoY8; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAImxoY8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770853043; x=1802389043;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d70P8BgJWrM5BS94U7Avsj0AtcFvIYcVY1eR1EEIOes=;
  b=NAImxoY8PICYL6OG45/UlUqa7mYcQkDDkKyAw+EZx19vjkWcZp7Cx5OX
   DF7ELH9yJ1FDpDJo1vjw4t4s5AeBcw78RsUreVjBHI3woyl6Levn+6gSi
   dLIIwyJLl4XWdpeIDmTIVSlkWkvo+jqrfZzZhFSrovIfWdOq1Fq3T7UUs
   nn9MasB2y/2ZFAcCOGP8g9eIq0Y75qiiY2A7A93VArriu5FzltFQiL6kV
   uS+xxU/KgAVGz1TGXo1FZ7bvhullgCLRBPlapOV+ho2qVwNo0rukXKnlE
   lfNtC3rfPreRdcg/PpfimkruWh69m8vbkyrHB+gdqUS68e6JdYt1eC+dS
   Q==;
X-CSE-ConnectionGUID: Jh/f3AeYRmms6jcKaRHn7g==
X-CSE-MsgGUID: WD2/YNoYTwaU9bdjATc3fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="71916630"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="71916630"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 15:37:22 -0800
X-CSE-ConnectionGUID: eAVK927PRtSoHd7raM2/xA==
X-CSE-MsgGUID: rpuR4iAmSu+DsZRBmGNIkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="212495883"
Received: from unknown (HELO [10.241.241.163]) ([10.241.241.163])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 15:37:23 -0800
Message-ID: <ae46c7fb-dbc4-4f62-89b9-0cb003e65547@intel.com>
Date: Wed, 11 Feb 2026 15:37:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] selftests/resctrl: Prepare for parsing multiple
 events per iMC
To: Reinette Chatre <reinette.chatre@intel.com>, shuah@kernel.org,
 Dave.Martin@arm.com, james.morse@arm.com, tony.luck@intel.com,
 peternewman@google.com, babu.moger@amd.com, ilpo.jarvinen@linux.intel.com
Cc: dapeng1.mi@linux.intel.com, fenghuay@nvidia.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1770406608.git.reinette.chatre@intel.com>
 <3ab21be3fcd9a85e1e204d4e28443fbe984998e1.1770406608.git.reinette.chatre@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <3ab21be3fcd9a85e1e204d4e28443fbe984998e1.1770406608.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/10/2026 8:50 AM, Reinette Chatre wrote:
> The events needed to read memory bandwidth are discovered by iterating
> over every memory controller (iMC) within /sys/bus/event_source/devices.
> Each iMC's PMU is assumed to have one event to measure read memory
> bandwidth that is represented by the sysfs cas_count_read file. The event's
> configuration is read from "cas_count_read" and stored as an element of
> imc_counters_config[] by read_from_imc_dir() that receives the
> index of the array where to store the configuration as argument.
> 
> It is possible that an iMC's PMU may have more than one event that should
> be used to measure memory bandwidth.
> 
> Change semantics to not provide the index of the array to
> read_from_imc_dir() but instead a pointer to the index. This enables
> read_from_imc_dir() to store configurations for more than one event by
> incrementing the index to imc_counters_config[] itself.
> 
> Ensure that the same type is consistently used for the index as it is
> passed around during counter configuration.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>


> ---
>  tools/testing/selftests/resctrl/resctrl_val.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
> index 2cc22f61a1f8..25c8101631e0 100644
> --- a/tools/testing/selftests/resctrl/resctrl_val.c
> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
> @@ -73,7 +73,7 @@ static void read_mem_bw_ioctl_perf_event_ioc_disable(int i)
>   * @cas_count_cfg:	Config
>   * @count:		iMC number
>   */
> -static void get_read_event_and_umask(char *cas_count_cfg, int count)
> +static void get_read_event_and_umask(char *cas_count_cfg, unsigned int count)
>  {
>  	char *token[MAX_TOKENS];
>  	int i = 0;
> @@ -110,7 +110,7 @@ static int open_perf_read_event(int i, int cpu_no)
>  }
>  
>  /* Get type and config of an iMC counter's read event. */
> -static int read_from_imc_dir(char *imc_dir, int count)
> +static int read_from_imc_dir(char *imc_dir, unsigned int *count)
>  {
>  	char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[1024];
>  	FILE *fp;
> @@ -123,7 +123,7 @@ static int read_from_imc_dir(char *imc_dir, int count)
>  
>  		return -1;
>  	}
> -	if (fscanf(fp, "%u", &imc_counters_config[count].type) <= 0) {
> +	if (fscanf(fp, "%u", &imc_counters_config[*count].type) <= 0) {
>  		ksft_perror("Could not get iMC type");
>  		fclose(fp);
>  
> @@ -147,7 +147,8 @@ static int read_from_imc_dir(char *imc_dir, int count)
>  	}
>  	fclose(fp);
>  
> -	get_read_event_and_umask(cas_count_cfg, count);
> +	get_read_event_and_umask(cas_count_cfg, *count);
> +	*count += 1;
>  
>  	return 0;
>  }
> @@ -196,13 +197,12 @@ static int num_of_imcs(void)
>  			if (temp[0] >= '0' && temp[0] <= '9') {
>  				sprintf(imc_dir, "%s/%s/", DYN_PMU_PATH,
>  					ep->d_name);
> -				ret = read_from_imc_dir(imc_dir, count);
> +				ret = read_from_imc_dir(imc_dir, &count);
>  				if (ret) {
>  					closedir(dp);
>  
>  					return ret;
>  				}
> -				count++;
>  			}
>  		}
>  		closedir(dp);

