Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC4538757C
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772624912; cv=none; b=e0iG6IQEhsbXVO6wDOU9WbOtfprBWGVWKtqqslEgqxos6MVAti6o8d6Lv7/VU8nQkphecba1lIab9JMTlg7XLlDNCgv7p+s5pqpWxuyjlovq2++z8Lg4N1cR5HZKmx8K+vyjqmnHaMC/2G4brgZ2aS7hSjN2S05QS9XcHXAKZdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772624912; c=relaxed/simple;
	bh=z1a5l68yoDxmYfw9O1osS8dXL3lLXq73SkkBasKV4fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gst7gmpxwerj4tcYiKD8GJQ479ljhHA6rqhWT7rAaDndF+dayENrqjRjRxr4XHOh9Dy04LYErA8eGrAa96AP9aEEaQWnhbjpzYpRxtqEog3Tv6V9c30bm/jNMrOv7WxQplu91RgbfoXtLqxYe11NmMc8QcZg8QtFB5dNfbIENJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1B0C339;
	Wed,  4 Mar 2026 03:48:23 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F18E3F694;
	Wed,  4 Mar 2026 03:48:27 -0800 (PST)
Message-ID: <9f8aab1f-6e2e-4dad-9d6d-e70f5f909f04@arm.com>
Date: Wed, 4 Mar 2026 11:48:26 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: "Luck, Tony" <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>
Cc: james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com,
 bp@alien8.de, tglx@linutronix.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <aaYfSTppsqwgMz1d@agluck-desk3>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aaYfSTppsqwgMz1d@agluck-desk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Tony,

On 3/2/26 23:37, Luck, Tony wrote:
> On Mon, Mar 02, 2026 at 10:46:06AM -0800, Reinette Chatre wrote:
>> Hi Everybody,
>>
>> This is a collection of resctrl cleanups assembled together for convenience
>> and simpler tracking. I'd be happy to split them up if it makes review and/or
>> handling easier.
> 
> If it is time for spring cleaning in the rescctrl code, maybe fix some
> bad fir tree declarations too?
> 
> Note resctrl_arch_pseudo_lock_fn() needs help too, but complicated by
> having #ifdef CONFIG_KASAN mixed in with declarations. It might need
> to remain an exception.
> 
> -Tony
> 
> 
> From dd9c2ad1a1361b34e25fc10d18d3ceb3ba57fb92 Mon Sep 17 00:00:00 2001
> From: Tony Luck <tony.luck@intel.com>
> Date: Mon, 2 Mar 2026 15:28:36 -0800
> Subject: [PATCH] fs/resctrl: Clean up some bad "fir tree" declarations
> 
> Sort local variables by length (longest first) per TIP tree.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/pseudo_lock.c | 2 +-
>  fs/resctrl/rdtgroup.c    | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
> index e1e9134474f4..cd57d862e0cf 100644
> --- a/fs/resctrl/pseudo_lock.c
> +++ b/fs/resctrl/pseudo_lock.c
> @@ -797,10 +797,10 @@ static const struct file_operations pseudo_measure_fops = {
>  int rdtgroup_pseudo_lock_create(struct rdtgroup *rdtgrp)
>  {
>  	struct pseudo_lock_region *plr = rdtgrp->plr;
> +	char *kn_name __free(kfree) = NULL;
>  	struct task_struct *thread;
>  	unsigned int new_minor;
>  	struct device *dev;
> -	char *kn_name __free(kfree) = NULL;

If you are changing this, I would expect either the declaration to come
lower at the allocation or alternatively drop the __free and do an
explict kfree. This is based on the guidance in include/linux/cleanup.h

""
 * Given that the "__free(...) = NULL" pattern for variables defined at
 * the top of the function poses this potential interdependency problem
 * the recommendation is to always define and assign variables in one
 * statement and not group variable definitions at the top of the
 * function when __free() is used.
 *
 * Lastly, given that the benefit of cleanup helpers is removal of
 * "goto", and that the "goto" statement can jump between scopes, the
 * expectation is that usage of "goto" and cleanup helpers is never
 * mixed in the same function. I.e. for a given routine, convert all
 * resources that need a "goto" cleanup to scope-based cleanup, or
 * convert none of them.
""

>  	int ret;
>  
>  	ret = pseudo_lock_region_alloc(plr);
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 0e93cecf6f30..b2ca6394714a 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -3423,8 +3423,8 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
>  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
>  					   struct rdt_domain_hdr *hdr)
>  {
> -	struct kernfs_node *parent_kn;
>  	struct rdtgroup *prgrp, *crgrp;
> +	struct kernfs_node *parent_kn;
>  	struct list_head *head;
>  
>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> @@ -3559,9 +3559,9 @@ static int __init_one_rdt_domain(struct rdt_ctrl_domain *d, struct resctrl_schem
>  	struct resctrl_staged_config *cfg;
>  	struct rdt_resource *r = s->res;
>  	u32 used_b = 0, unused_b = 0;
> +	u32 peer_ctl, ctrl_val;
>  	unsigned long tmp_cbm;
>  	enum rdtgrp_mode mode;
> -	u32 peer_ctl, ctrl_val;
>  	int i;
>  
>  	cfg = &d->staged_config[t];


Thanks,

Ben

