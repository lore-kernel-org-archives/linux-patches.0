Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019292;
	b=1yl/Yj2nheMLNKnP73k/UKWm7Yd45biqPSW86xUoImtB76stxpU7PyRvV/2ZZCJu7ylW
	 dt6MnFAoGkb/IFn1ovL68NHNkXbXIq58q2ZMOTOXz+4HG+pGAG9t2uZuP962nM2kTi40F
	 TSFIkxrs4jrLkuqXCpda4voHmlCEB867JoQ5GLBu5d5Sb/He3LzTQQ8rHro20wVSsSo2N
	 +QHVpEzqoX4/Z2FTeXkMrQXIXK4EASqCk1dn9ugCg1Op4YvH/I8OqErLvWY22a9X+DJEG
	 8UDEGv1gvfgysYlIDuFdSAuYv5EJcPejKbonX596LsvUKl8p1oRFdvPc2OequyKs96Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019292;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=QuOoANZ8hChXmnk+D4HOljpYAuIPsGom8C5JI4EqOIA=;
	b=FPZoOfj/5M9V0Tb2Fxym8wx4AakKp5VAoan3wexqXEHoYbuu1EKofOFF46BYkuq4bRnQ
	 makvPsfCDeDDAQtrrrgQfEzTEL+HE2p69bn79p3g2Vwvha/udjC3QWX9/UiASjg5nQzrl
	 U393mAbGbcCt+R2eOOlAGYgrrsl19DLz6xZgh/QmAZRYhcxTZDvNCmwzXfaGQDENBS+ra
	 EE8pmueWk9LxaEheW3C6ukAV00HURHZtxZ61dfKO1IXBBYnXfXhGX2KxGwNHNW45WtaxP
	 y9VqhECrBi6r5lijSRbYzw+RElobj0Z7AmEwOGZ/AeezHl5eoDzKGRDMSstvqz/syrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=upju8KOf;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0186D60A261A
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 16:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0186D60A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=upju8KOf
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AFA9143D;
	Wed, 18 Nov 2026 08:28:03 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42FBA3F673;
	Wed, 18 Nov 2026 08:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795019286; bh=6Cc3/L/EkFsV4cpEwdGr/GoAJIUVzESLRiO77LL1sto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=upju8KOfyoRVKgl0BNh8Kg4gn4vcnI6W9Zq3xt8ufdl6cGJpJz3j018OQ29r9Slrd
	 f1pFw8KEspQx/CW+vz67JWDyyyRGj8lcUgbvqppKIoF3XtMukExy8P689/SMhLuTiK
	 AeSNpHz/FZC3QKxoZWzS3SvtO5aB8yVOVB3aJCiQ=
Message-ID: <691a76a5-7b22-4c2a-8861-3581791a01c0@arm.com>
Date: Wed, 18 Nov 2026 16:28:02 +0000
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
Subject: Re: [PATCH v3 1/8] arm_mpam: resctrl: Add a helper to find the
 component counting an event
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com, ruanjinjie@huawei.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, tan.shaopeng@fujitsu.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1794283825.git.reinette.chatre@intel.com>
 <8635f50f938afbe3f58dcd69966c2dd45e2394cd.1794283825.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <8635f50f938afbe3f58dcd69966c2dd45e2394cd.1794283825.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 10/11/2026 04:19, Reinette Chatre wrote:
> resctrl_arch_cntr_read() and resctrl_arch_reset_cntr() both drive the
> monitors MPAM pre-allocated for bandwidth counting. Each starts with the
> same sequence: check that MPAM is enabled, reject cache occupancy and
> events without a class, then take the component counting the event from
> the monitoring domain.
> 
> The duplicated sequence has to be kept in sync by hand. Only the failure
> handling differs: one reports the failure to its caller while the other
> has no way to do so.
> 
> Add find_mbwu_mon_comp() to locate the component, returning an error
> pointer on the failures both callers test for. Ignore that error in
> resctrl_arch_reset_cntr(), which cannot report it.
> 
> No functional change intended.
> 
> Suggested-by: Jinjie Ruan <ruanjinjie@huawei.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since RFC v2:
> - New patch.
> ---
>  drivers/resctrl/mpam_resctrl.c | 62 ++++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 5468367776e2..1b1e724ae040 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -7,6 +7,7 @@
>  #include <linux/cacheinfo.h>
>  #include <linux/cpu.h>
>  #include <linux/cpumask.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/limits.h>
>  #include <linux/list.h>
> @@ -541,26 +542,51 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
>  				 closid, rmid, val);
>  }
>  
> -/* MBWU counters when in ABMC mode */
> -int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
> -			   u32 closid, u32 rmid, int mon_idx,
> -			   enum resctrl_event_id eventid, u64 *val)
> +/*
> + * find_mbwu_mon_comp() - Find the component counting @eventid in a domain
> + * @d:		The monitoring domain to search.
> + * @eventid:	The event to find the counting component for.
> + *
> + * The counters reached through this component are the monitors MPAM
> + * pre-allocated for bandwidth counting. Cache occupancy is not counted by> + * those monitors, it is read on demand via resctrl_arch_rmid_read().
> + *
> + * Return: the component counting @eventid in @d, or an error pointer when
> + * MPAM is disabled, when @eventid is cache occupancy, or when no class was
> + * picked to count @eventid.
> + */
> +static struct mpam_component *find_mbwu_mon_comp(struct rdt_l3_mon_domain *d,
> +						 enum resctrl_event_id eventid)

I find this a somewhat strange helper. It's operation is not mbwu specific except for its rejection
of CSU events and it doesn't support the similar code in resctrl_arch_rmid_read(). Something a bit
more general that just finds the monitoring component is easier to understand for me.

What do you think of something like the change below? (The baseline is unhelpful, as it's your
series with the first patch removed and the build fixed but hopefully it illustrates the idea well
enough.)

$ git diff
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index c14343fb5a95..343b4fd351f6 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -510,12 +510,20 @@ static int read_mon_cdp_safe(struct mpam_resctrl_mon *mon, struct mpam_component
                          CDP_NONE, closid, rmid, val);
 }

+static struct mpam_component * find_mon_comp(struct rdt_domain_hdr *hdr,
+                                            enum resctrl_event_id eventid)
+{
+       struct mpam_resctrl_mon_dom *l3_dom;
+
+       l3_dom = container_of(hdr, struct mpam_resctrl_mon_dom, resctrl_mon_dom.hdr);
+       return l3_dom->mon_comp[eventid];
+}
+
 /* MBWU when not in ABMC mode (not supported), and CSU counters. */
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
                           u32 closid, u32 rmid, enum resctrl_event_id eventid,
                           void *arch_priv, u64 *val, void *arch_mon_ctx)
 {
-       struct mpam_resctrl_mon_dom *l3_dom;
        struct mpam_component *mon_comp;
        u32 mon_idx = *(u32 *)arch_mon_ctx;
        enum mpam_device_features mon_type;
@@ -529,8 +537,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
        if (eventid >= QOS_NUM_EVENTS || !mon->class)
                return -EINVAL;

-       l3_dom = container_of(hdr, struct mpam_resctrl_mon_dom, resctrl_mon_dom.hdr);
-       mon_comp = l3_dom->mon_comp[eventid];
+       mon_comp = find_mon_comp(hdr, eventid);

        if (eventid != QOS_L3_OCCUP_EVENT_ID)
                return -EINVAL;
@@ -547,7 +554,6 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
                           enum resctrl_event_id eventid, u64 *val)
 {
        struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
-       struct mpam_resctrl_dom *l3_dom;
        struct mpam_component *mon_comp;

        if (!mpam_is_enabled())
@@ -556,8 +562,7 @@ int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
        if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
                return -EINVAL;

-       l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
-       mon_comp = l3_dom->mon_comp[eventid];
+       mon_comp = find_mon_comp(&d->hdr, eventid);

        return read_mon_cdp_safe(mon, mon_comp, mpam_feat_msmon_mbwu,
                                 USE_PRE_ALLOCATED, closid, rmid, val);
@@ -604,7 +609,6 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
                             enum resctrl_event_id eventid)
 {
        struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
-       struct mpam_resctrl_dom *l3_dom;
        struct mpam_component *mon_comp;

        if (!mpam_is_enabled())
@@ -613,8 +617,7 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
        if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
                return;

-       l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
-       mon_comp = l3_dom->mon_comp[eventid];
+       mon_comp = find_mon_comp(&d->hdr, eventid);

        reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
 }


Thanks,

Ben

>  {
> -	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
>  	struct mpam_resctrl_dom *l3_dom;
> -	struct mpam_component *mon_comp;
> +	struct mpam_resctrl_mon *mon;
>  
>  	if (!mpam_is_enabled())
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>  
> +	mon = &mpam_resctrl_counters[eventid];
>  	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>  
>  	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
> -	mon_comp = l3_dom->mon_comp[eventid];
>  
> -	return read_mon_cdp_safe(mon, mon_comp, mpam_feat_msmon_mbwu,
> -				 USE_PRE_ALLOCATED, closid, rmid, val);
> +	return l3_dom->mon_comp[eventid];
> +}
> +
> +/* MBWU counters when in ABMC mode */
> +int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
> +			   u32 closid, u32 rmid, int mon_idx,
> +			   enum resctrl_event_id eventid, u64 *val)
> +{
> +	struct mpam_component *mon_comp;
> +
> +	mon_comp = find_mbwu_mon_comp(d, eventid);
> +	if (IS_ERR(mon_comp))
> +		return PTR_ERR(mon_comp);
> +
> +	return read_mon_cdp_safe(&mpam_resctrl_counters[eventid], mon_comp,
> +				 mpam_feat_msmon_mbwu, USE_PRE_ALLOCATED,
> +				 closid, rmid, val);
>  }
>  
>  static void __reset_mon(struct mpam_resctrl_mon *mon, struct mpam_component *mon_comp,
> @@ -603,20 +629,14 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_l3_mon_domain *d
>  			     u32 closid, u32 rmid, int cntr_id,
>  			     enum resctrl_event_id eventid)
>  {
> -	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
> -	struct mpam_resctrl_dom *l3_dom;
>  	struct mpam_component *mon_comp;
>  
> -	if (!mpam_is_enabled())
> +	mon_comp = find_mbwu_mon_comp(d, eventid);
> +	if (IS_ERR(mon_comp))
>  		return;
>  
> -	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
> -		return;
> -
> -	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
> -	mon_comp = l3_dom->mon_comp[eventid];
> -
> -	reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
> +	reset_mon_cdp_safe(&mpam_resctrl_counters[eventid], mon_comp,
> +			   USE_PRE_ALLOCATED, closid, rmid);
>  }
>  
>  /*

