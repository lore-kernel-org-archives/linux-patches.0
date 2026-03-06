Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A3733B6D1
	for <patches@lists.linux.dev>; Fri,  6 Mar 2026 10:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792346; cv=none; b=HnL7uBKyk6CUQmuUmZ03Bnh4Zh48Ur5IADpcKsKu+drHTW88lBhYftRaaPMCU3K1lxJutYlKd58vj3XELR7ygvY3S0HI+IULBGaBkNaofw9eC9Dr2BoNkIb3fFSMJXMUKzKJbVkfYwoWQzFfWPnlgyhAaK5r3rBcwE8E36W6GMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792346; c=relaxed/simple;
	bh=XFe6wciYCgNoELPjTXDDirLpfaqSjHbe29PzaMoMb6w=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cQK4in24EvUBKgnNTyutvVvVutmhVVxUIGzWI8SfNoS8ozv7X0trUyGTSV2n/r0E878MbCtjQLRnSLuacGcUsXuwX7vEYGSmuS/bwHNHxPTAmbM7uY+57gZ7c2++VQmzHNWSR370xQXkfRFOfH1Fq4s/bUS53si2jLlA18yswPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GirehXt3; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GirehXt3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772792345; x=1804328345;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=XFe6wciYCgNoELPjTXDDirLpfaqSjHbe29PzaMoMb6w=;
  b=GirehXt3ZiKEIfY6pSCZ+zrsbqrh7EXz+qT7BEX1u4wHvVDB6neopdW6
   tkqYLwnTf9tUtdBNPy4DbV3Aopqj4fWlPvi2G2ScABw+CSuqgOrrPKd9G
   oZiL51I9uNhz5n8mFk8qzCmSwY3jtLes1oCFddwSFsg800zZaBLzLivwc
   uzfGXSySYddyPn2KirttrbzIqGqlDK0fR046aBZWhRWO5qOVWrd138nKF
   JIKKsyS0bxNKidKDeGoZFqAbeR+zc0wkrGf3NIstTobngPjYV9seTo1xU
   pV4x7JX14N3UIOZbVeqiU07oV8xAjGdTFg9tosawOps6W8BD2iDZrXPEP
   g==;
X-CSE-ConnectionGUID: 33I5nOqBRj2n4fjb9iJe2w==
X-CSE-MsgGUID: BNVEwkMgRUijp0Jhfx9GuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="74086641"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="74086641"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 02:19:05 -0800
X-CSE-ConnectionGUID: I4zkZ78vQpq2o4D6+V27Ew==
X-CSE-MsgGUID: eBJ5kQ7/TJqMsz8T/gnZ5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="219104320"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.235])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 02:18:59 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 6 Mar 2026 12:18:55 +0200 (EET)
To: Reinette Chatre <reinette.chatre@intel.com>
cc: shuah@kernel.org, Dave.Martin@arm.com, james.morse@arm.com, 
    tony.luck@intel.com, babu.moger@amd.com, fenghuay@nvidia.com, 
    peternewman@google.com, zide.chen@intel.com, dapeng1.mi@linux.intel.com, 
    ben.horgan@arm.com, yu.c.chen@intel.com, linux-kselftest@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 4/9] selftests/resctrl: Support multiple events
 associated with iMC
In-Reply-To: <ac8d183679c70f5ff5b3aabb4e19df7bf98d3380.1772582958.git.reinette.chatre@intel.com>
Message-ID: <a0536a31-a8da-2232-67ca-91c60eb714c2@linux.intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com> <ac8d183679c70f5ff5b3aabb4e19df7bf98d3380.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 3 Mar 2026, Reinette Chatre wrote:

> The resctrl selftests discover needed parameters to perf_event_open() via
> sysfs. The PMU associated with every memory controller (iMC) is discovered
> via the /sys/bus/event_source/devices/uncore_imc_N/type file while
> the read memory bandwidth event type and umask is discovered via
> /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read.
> 
> Newer systems may have multiple events that expose read memory bandwidth.
> For example,
>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch0
>  /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch1
> 
> Support parsing of iMC PMU properties when the PMU may have multiple events
> to measure read memory bandwidth. The PMU only needs to be discovered once.
> Split the parsing of event details from actual PMU discovery in order to
> loop over all events associated with the PMU. Match all events with the
> cas_count_read prefix instead of requiring there to be one file with that
> name.
> 
> Make the parsing code more robust. With strings passed around to create
> needed paths, use snprintf() instead of sprintf() to ensure there is
> always enough space to create the path. Ensure there is enough room in
> imc_counters_config[] before attempting to add an entry.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Zide Chen <zide.chen@intel.com>
> ---
> Changes since v1:
> - Add Zide Chen's RB tag.
> ---
>  tools/testing/selftests/resctrl/resctrl_val.c | 112 ++++++++++++++----
>  1 file changed, 90 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
> index 25c8101631e0..7aae0cc5aee9 100644
> --- a/tools/testing/selftests/resctrl/resctrl_val.c
> +++ b/tools/testing/selftests/resctrl/resctrl_val.c
> @@ -11,10 +11,10 @@
>  #include "resctrl.h"
>  
>  #define UNCORE_IMC		"uncore_imc"
> -#define READ_FILE_NAME		"events/cas_count_read"
> +#define READ_FILE_NAME		"cas_count_read"
>  #define DYN_PMU_PATH		"/sys/bus/event_source/devices"
>  #define SCALE			0.00006103515625
> -#define MAX_IMCS		20
> +#define MAX_IMCS		40
>  #define MAX_TOKENS		5
>  
>  #define CON_MBM_LOCAL_BYTES_PATH		\
> @@ -109,21 +109,102 @@ static int open_perf_read_event(int i, int cpu_no)
>  	return 0;
>  }
>  
> +static int parse_imc_read_bw_events(char *imc_dir, unsigned int type,
> +				    unsigned int *count)
> +{
> +	char imc_events[1024], imc_counter_cfg[1024], cas_count_cfg[1024];

The first two are paths, right? PATH_MAX should be used instead of the 
literals.

> +	unsigned int org_count = *count;

orig_count is less ambiguous name.

> +	struct dirent *ep;
> +	int path_len;
> +	int ret = -1;
> +	FILE *fp;
> +	DIR *dp;
> +
> +	path_len = snprintf(imc_events, sizeof(imc_events), "%sevents", imc_dir);
> +	if (path_len >= sizeof(imc_events)) {
> +		ksft_print_msg("Unable to create path to %sevents\n", imc_dir);
> +		return -1;
> +	}
> +	dp = opendir(imc_events);
> +	if (dp) {
> +		while ((ep = readdir(dp))) {
> +			/*
> +			 * Parse all event files with READ_FILE_NAME
> +			 * prefix that contain the event number and umask.
> +			 * Skip files containing "." that contain unused
> +			 * properties of event.
> +			 */
> +			if (!strstr(ep->d_name, READ_FILE_NAME) ||
> +			    strchr(ep->d_name, '.'))
> +				continue;
> +
> +			path_len = snprintf(imc_counter_cfg, sizeof(imc_counter_cfg),
> +					    "%s/%s", imc_events, ep->d_name);
> +			if (path_len >= sizeof(imc_counter_cfg)) {
> +				ksft_print_msg("Unable to create path to %s/%s\n",
> +					       imc_events, ep->d_name);
> +				goto out_close;
> +			}
> +			fp = fopen(imc_counter_cfg, "r");
> +			if (!fp) {
> +				ksft_perror("Failed to open iMC config file");
> +				goto out_close;
> +			}
> +			if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
> +				ksft_perror("Could not get iMC cas count read");
> +				fclose(fp);
> +				goto out_close;
> +			}
> +			fclose(fp);

I'd prefer:

	xx = fscanf(...);
	fclose(fp);
	if (xx) {
		...

...But it is up to you ("ret" cannot be used as xx as is).

> +			if (*count >= MAX_IMCS) {
> +				ksft_print_msg("Maximum iMC count exceeded\n");
> +				goto out_close;
> +			}
> +
> +			imc_counters_config[*count].type = type;
> +			get_read_event_and_umask(cas_count_cfg, *count);
> +			/* Do not fail after incrementing *count. */
> +			*count += 1;
> +		}
> +		if (*count == org_count) {
> +			ksft_print_msg("Unable to find events in %s\n", imc_events);
> +			goto out_close;
> +		}
> +	} else {
> +		ksft_perror("Unable to open PMU events directory");
> +		goto out;

Reverse the logic (handle error first), it reduces the indentation level 
of the loop.

> +	}
> +	ret = 0;
> +out_close:
> +	closedir(dp);
> +out:
> +	return ret;
> +}
> +
>  /* Get type and config of an iMC counter's read event. */
>  static int read_from_imc_dir(char *imc_dir, unsigned int *count)
>  {
> -	char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[1024];
> +	char imc_counter_type[1024];
> +	unsigned int type;
> +	int path_len;
>  	FILE *fp;
> +	int ret;
>  
>  	/* Get type of iMC counter */
> -	sprintf(imc_counter_type, "%s%s", imc_dir, "type");
> +	path_len = snprintf(imc_counter_type, sizeof(imc_counter_type),
> +			    "%s%s", imc_dir, "type");
> +	if (path_len >= sizeof(imc_counter_type)) {
> +		ksft_print_msg("Unable to create path to %s%s\n",
> +			       imc_dir, "type");
> +		return -1;
> +	}
>  	fp = fopen(imc_counter_type, "r");
>  	if (!fp) {
>  		ksft_perror("Failed to open iMC counter type file");
>  
>  		return -1;
>  	}
> -	if (fscanf(fp, "%u", &imc_counters_config[*count].type) <= 0) {
> +	if (fscanf(fp, "%u", &type) <= 0) {
>  		ksft_perror("Could not get iMC type");
>  		fclose(fp);
>  
> @@ -131,24 +212,11 @@ static int read_from_imc_dir(char *imc_dir, unsigned int *count)
>  	}
>  	fclose(fp);
>  
> -	/* Get read config */
> -	sprintf(imc_counter_cfg, "%s%s", imc_dir, READ_FILE_NAME);
> -	fp = fopen(imc_counter_cfg, "r");
> -	if (!fp) {
> -		ksft_perror("Failed to open iMC config file");
> -
> -		return -1;
> -	}
> -	if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
> -		ksft_perror("Could not get iMC cas count read");
> -		fclose(fp);
> -
> -		return -1;
> +	ret = parse_imc_read_bw_events(imc_dir, type, count);
> +	if (ret) {
> +		ksft_print_msg("Unable to parse bandwidth event and umask\n");
> +		return ret;
>  	}
> -	fclose(fp);
> -
> -	get_read_event_and_umask(cas_count_cfg, *count);
> -	*count += 1;
>  
>  	return 0;
>  }
> 

-- 
 i.

