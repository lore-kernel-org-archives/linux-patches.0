Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F1432D7C7
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 10:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774263202; cv=none; b=jXCPaLrhYq3IlmsHPnYr/FHt6dnl4ZRp6uH0RbuSFTQ5TJ6iTSHxbSsAWnkcyW2JwBMp/hRzMrA6+wSL8Nz9uhbSJS+1ifSQVf9kJA3YbcPUv6YNwyUE+SExOQgSXaSIWRflQnV+ECMx3ewu2f/X+J/tCJcb9k2Hp5e+TfQgSwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774263202; c=relaxed/simple;
	bh=1JYUsGD5o6Bt/Vnxfudm791S46U/W7Oh1L/E6O6aRC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XyX7aQRdraQ1W3YSobqiTi51IbqehIiWt9PDlldHPbl4/LZpB7yD/c8gDsMBth7poS/06jhX6rDFaWonDXWcES7LypgERaO7fj05ZGgc4SfJbmPmvqrPz3JdTtAesD6jjxrn4rcdmeBrDUG9o6iGUxotHn4s/SJTlNcbteipxDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 201281516;
	Mon, 23 Mar 2026 03:53:15 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 206393F73B;
	Mon, 23 Mar 2026 03:53:19 -0700 (PDT)
Message-ID: <879a19df-f054-4448-a981-206afe0b1ac9@arm.com>
Date: Mon, 23 Mar 2026 10:53:17 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v2 06/14] fs/resctrl: Change pattern used to track number
 of entries in enum
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1774043709.git.reinette.chatre@intel.com>
 <24b86569a2d3428f7fddf3572adebaec909e696e.1774043709.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <24b86569a2d3428f7fddf3572adebaec909e696e.1774043709.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/20/26 22:03, Reinette Chatre wrote:
> CDP_NUM_TYPES tracks the number of different configuration types that can
> be applied to a resource. CDP_NUM_TYPES is required to iterate over the
> different configurations but is not a member of enum resctrl_conf_type to
> avoid the warning generated with -Wswitch when CDP_NUM_TYPES lacks a case.
> 
> Add a new CDP_LAST enum entry used in CDP_NUM_TYPES definition to simplify
> adding a new enum entry. Do this to create a cleaner pattern for tracking
> the number of enum entries in resctrl in preparation for other enums
> needing to do so.

LGTM

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

> 
> Suggested-by: Ben Horgan <ben.horgan@arm.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  include/linux/resctrl.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 006e57fd7ca5..0b28049378c8 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -69,9 +69,10 @@ enum resctrl_conf_type {
>  	CDP_NONE,
>  	CDP_CODE,
>  	CDP_DATA,
> +	CDP_LAST = CDP_DATA
>  };
>  
> -#define CDP_NUM_TYPES	(CDP_DATA + 1)
> +#define CDP_NUM_TYPES	(CDP_LAST + 1)
>  
>  /*
>   * struct pseudo_lock_region - pseudo-lock region information

