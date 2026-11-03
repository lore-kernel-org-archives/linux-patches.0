Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723262;
	b=yUag9TBPeDilIcAdeO8vMe5lGdY4KdoIs4H+O0tcSfzVRv+jRyRNyxCR68VcRQPGBwpC
	 ncGdSauYJKQldPsUi79c17LTGe/KRycbbGXIXQ5Efah167bLrgseuiK/ACnyDLb8Xgk8o
	 4QE4Y5+kKTpumoNFPc5KiebS+/BS0z90gZrx0fMZJPKBdd1UElawRDY7VFADisfuC67Rl
	 xaFNLCX+u0KVZ7O496pFy6WXZoX3XdiPgIis1w4r8wEeZQemODC2WE+EqRnhBQ8BbKcwY
	 rmNw9kzLUTCt3R8ZvYw3WKsLjw7zBMOC3fXDAv4FtbpWjAkm621mSUV1/eNzaGa2bWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723262;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+5PLFHNYvI6hooOQPVoYk381jXL7ECOUIpIdtIa4bbI=;
	b=QhBYOx0UO5qUEkU5c9G+DPR2IV1+4duJJz3IPYhoij8ePzOz+NKaTm7uSSq/714yONRM
	 GqI39PTKaDLPx5Ikd68/+OrVeqRnUXNLVVkdbNwiHPlAA999Lx2V3ubKPKpFeNh4HAcIN
	 xNl8GdTJA7MHwwzzMHk/3iFxCj3kq7gnQT/BOi9J/1Co79f9g3PDfF4qswajKKfvz9miE
	 d+AYA2tIEkV/qP9tYSFhlOHRs+8lnWyM/FGz1bkZNjKiqWjgJ0L7vRGrQHh4Ib32t6xLq
	 1MPDoFDjehYNOd3zBowJ0wt70iM8Csi002tf1oGAKicJy1CRaIJAeXuv8BtehdcPusA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XJDplvXf;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AE1606A326
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 16:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5AE1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XJDplvXf
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC42C1595;
	Tue,  3 Nov 2026 08:27:37 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.89.242])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 518803F628;
	Tue,  3 Nov 2026 08:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793723261; bh=T+7vmJQXaSpuHN4NQcYqhOks+C9X4fCqNSJv3hn3SJg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XJDplvXfcxus5djwB5e/QMx9m4tfrZNnG1V5cRyKth8kDvHRIvrvWAXpsNvpvd5ty
	 gnNGddgyxQrKzm4RMlH4m+Uv6h0DteyPhHf6sYl/9zOrwV9nVoO939XosBkh6Ea1xj
	 jTS1txaXomlx1M9HpXVL/VtBbecU8GUpTQOguISc=
Message-ID: <c7f180d1-f81e-495e-91be-b76a4c4df21d@arm.com>
Date: Tue, 3 Nov 2026 16:27:37 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [RFC PATCH v2 10/10] arm_mpam: resctrl: Update the comment on
 monitoring domain setup
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <f6080eca2696f4a06777725854447a563aa29696.1792443633.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <f6080eca2696f4a06777725854447a563aa29696.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 19/10/2026 23:07, Reinette Chatre wrote:
> The comment in mpam_resctrl_setup_mon_domain() explains that the L3
> component IDs need to be used for a monitoring domain because there may
> be no control component for the L3. It also describes searching each
> event's class for a component with overlapping CPUs.
> 
> Neither matches the code. The monitoring domain has its own structure
> and is set up independently of the control domain, so whether a control
> component exists has no bearing on it. Each event's class must have a
> component that contains the CPU, and all components of the domain must
> cover the same CPUs, which is stricter than overlapping.
> 
> Rewrite the comment to say where the domain's ID comes from and what is
> required of the components that back the domain's events.
> 
> No functional change.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to maintainers: This comment update is kept as a separate patch to
> make it easy to review. It can be folded into "arm_mpam: resctrl: Give
> the monitoring domain its own structure" and "arm_mpam: resctrl: Require
> monitoring components to cover the same CPUs" if preferred.

Yes, I think squashing those 3 patches together would be good.

Thanks,

Ben

> ---
>  drivers/resctrl/mpam_resctrl.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index c3ea61a40bb2..61fbde9c0960 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -1647,11 +1647,12 @@ static int mpam_resctrl_setup_mon_domain(unsigned int cpu,
>  	int err;
>  
>  	/*
> -	 * Even if the monitor domain is backed by a different
> -	 * component, the L3 component IDs need to be used... only
> -	 * there may be no ctrl_comp for the L3.
> -	 * Search each event's class list for a component with
> -	 * overlapping CPUs and set up the dom->mon_comp array.
> +	 * The monitoring domain takes the L3 cache ID as its ID even when its
> +	 * events are backed by components of other classes, see
> +	 * mpam_resctrl_pick_domain_id().
> +	 * Find the component of each event's class that contains the CPU and
> +	 * set up the dom->mon_comp array. All these components must cover the
> +	 * same CPUs.
>  	 */
>  
>  	for_each_mpam_resctrl_mon(mon, eventid) {

