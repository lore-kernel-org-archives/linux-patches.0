Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794308435;
	b=yRuZeDY/2q/PnRVKc0XeS82GE02Y23wmvINe0a3hWYvqMPmSmYhiKmf4Yjy4NjUBL5UX
	 yh6dT4cSq3vfZ6NU8YpDNtDwzO9OF+GfrY8aF9wOIjuZOcEsaJ92UB1XIsddXauDCGJ00
	 G8Z79euS71vjS5QFcwzUW/7lHBzmqCsqvpiuYxaX2fqh6vu6/SUlRvApEPJB5xu0m9bid
	 M8ZAGgt9TnyOGfP9JSKtHCOg4GN2sudWZ7VtNIDGtI3qNCo5jyoBr4Gazac+rTfGl9NEz
	 YlSTQVG0nsbBMv0Clej6s/Mhw68abB17H+YxA9uJrbK5jqI26lRtZigrCkct7mb9IJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794308435;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mr+oYs8/abSZSj4lJ4PMIllB4JnBFwVNz1SRvIolKDk=;
	b=FB2LywtsMBSFc+LiNQcCzeMkpRg5ajHvcPNXLLnuMJauKIoRbS6PWC0xUMMQD9FjAMTO
	 ICzsHqvdBahTaAwd41eiXOqiwQmI7grHZGfZvMjqhg92KsklrF0mAgnDfX5Ircb0SW140
	 rzXHoRuXZRVZ9FRZzVHxMFuwS1BTWBWz2zlKC9Xey1A7yifQqLQn5bCW2PTsq42H0DlQe
	 m7gGnFMRxjj0IFNAQmt5fbrbrS07x2I1igQlkisv8i/ie1yMAzQ7nTOcxVJSedhWj1nAZ
	 11gQ8UkU/XiW2J65xVza2h+YnqcFx7/i8koGrJFBcx2+pBFOG03til6DX4uEPMqpBqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LblR3Mll;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F47260A380D
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 11:00:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F47260A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LblR3Mll
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71D571BC0;
	Tue, 10 Nov 2026 03:00:30 -0800 (PST)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 886443F85F;
	Tue, 10 Nov 2026 03:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794308433; bh=4ck62cy1mlRNr4GFH/FwZpJqZdKAc0N4+tB/W3NHdFY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LblR3MllBiBoWbbp/bPau9MCduLwG1ZSwBtHEe+oMYAEMj36I3Mv+8I48Y6V1S/A3
	 4DiT3rjIj15YNhjEKrgjKDo60yfQpeEqhmRGrJ3k4Cstjh62Bh3F8++Y84qbc+0NJx
	 APrqPZZAwLmaPhwOrBjKvSsYJiMT9fe2+K6HTZ0o=
Message-ID: <00a1bcb7-2884-4075-8d51-b8a465e37492@arm.com>
Date: Tue, 10 Nov 2026 11:00:30 +0000
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
Subject: Re: [PATCH v3 0/8] arm_mpam: resctrl: Separate MPAM domains
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com, ruanjinjie@huawei.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, tan.shaopeng@fujitsu.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1794283825.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <cover.1794283825.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 10/11/2026 04:19, Reinette Chatre wrote:
> Thank you very much to Ben, Jinjie, and Shaopeng for reviewing and testing RFC v2.
> 
> Changes since RFC v2:
>   - RFC v2: https://lore.kernel.org/lkml/cover.1792443633.git.reinette.chatre@intel.com/
>   - Patch 1 is new. It adds find_mbwu_mon_comp() to replace the duplicate
>     code found in resctrl_arch_cntr_read() and resctrl_arch_reset_cntr(),
>     as suggested by Jinjie.
>   - WARN when domain allocation fails. (Ben)
>   - Squash three patches into the patches they build on. (Ben)
>   - Move "Require a component for each monitoring event" ahead of the
>     structure split so the check it adds precedes its first user.
>   - Fix the mpam_resctrl_get_mon_domain_from_cpu() function comment that
>     still referred to the control component.
>   - Add tags from Jinjie and Ben.
>   - Please see the individual patches for their detailed changelogs.
> 
> Changes since RFC v1:
>   - RFC v1: https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/
>   - Give each type of domain its own structure instead of duplicating the
>     shared one, set up each domain independently instead of undoing one
>     domain when setting up the other fails, add additional verification
>     checks.
> 
> The MPAM driver represents a resctrl domain with a single structure,
> struct mpam_resctrl_dom, that holds both a control domain and a
> monitoring domain. On a system that supports both allocation and
> monitoring, one instance is created for each domain and its two
> domains are added to the resource's control and monitoring domain
> lists.

Thank you for this respin.

To avoid any confusion for others I mention here that the 'MPAM domains' mentioned here are the MPAM
driver representations of resctrl domains and *not* related to the MPAM feature
FEAT_MPAM_MSC_DOMAINS. There is currently no support for FEAT_MPAM_MSC_DOMAINS in the MPAM driver.

Thanks,

Ben

