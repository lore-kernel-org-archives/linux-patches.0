Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8184A6898
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057707; cv=none; b=bpwzX07UQfIHznZ3mNMcRu1eDZVR6AOsLdac4rXWwkQf5OC5aJTnKx4vNRGzHol3AIuwIxdWKYx7+eJztET9e8egK0MgNqeelSW8DuVLXx2KUhhQAM92dbQaoKT82Te45RwcTpP95MLb3FSeS5E8J2Ls213JIelDSOLXP2RZh5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057707; c=relaxed/simple;
	bh=0Rxw/cZpFE2t2adNIrSGwGJp/YF57F3N45av5Yu81XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f/OF+FUl2GPtJ/Pn+Non/EtD3fHahP7IMDp6QCvbYOlSRKWAeicCxIX3iCo9mvFByV1gHBTuqFpuF0qsWxRZgRNVVHOUkxohZyt0Rykf2UBVYqP7m70iM97h8rxccEaMd+EOTNXlNUgZAq20pDrL93SThZr07uwQK4tZl7p6bWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dBlF0p7g; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dBlF0p7g"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4834622C8;
	Thu, 10 Sep 2026 09:28:21 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C75F43F86C;
	Thu, 10 Sep 2026 09:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789057704; bh=0Rxw/cZpFE2t2adNIrSGwGJp/YF57F3N45av5Yu81XU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dBlF0p7gfD82GdlOpkOWBeu4vxuGyUtbRqOEO1NDaq3D+df9gdytWEIt5692StFpi
	 vc6OnlBQ5WtmnUWKVESE18UxbWk9ajg4PJgjOJ9inFaVfP43w+anYiePWe3NgoBcoT
	 xihofpJAKCzPwGBQgDyJ9iNNrAWabZyc+RjTj88A=
Message-ID: <86603611-b20d-4a0a-a247-8cebb11b3432@arm.com>
Date: Thu, 10 Sep 2026 17:28:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, babu.moger@amd.com, yu.c.chen@intel.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
 <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
 <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
 <26e294a0-76a6-4ec0-9df8-021a76bf8ed9@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <26e294a0-76a6-4ec0-9df8-021a76bf8ed9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 10/09/2026 16:37, Reinette Chatre wrote:
> Hi Ben,
> 
> On 9/10/26 4:11 AM, Ben Horgan wrote:
>> On 08/09/2026 22:12, Reinette Chatre wrote:
>>> On 9/7/26 10:01 AM, Ben Horgan wrote:
>>>> On 03/09/2026 16:29, Reinette Chatre wrote:
>>>>> On 9/2/26 9:10 AM, Ben Horgan wrote:
>>>>>> On 01/09/2026 00:54, Reinette Chatre wrote:
> 
> ...
> 
>>>>> It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
>>>>> like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
>>>>> consider the component at all. Would that not cause monitoring features to depend on which
>>>>> CPU of a domain comes online first?
>>>>>
>>>>> Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
>>>>> "ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?
>>>>
>>>> Doesn't the !any_mon_comp check provide this?
>>>
>>> This is the part that I do not understand since any_mon_comp seems to support the scenario
>>> where a mon_comp may be NULL which is a scenario that I do not think resctrl can support.
>>
>> Ah, I see what you are getting at. As the monitor components are only considered when there topology
>> matches the l3 cache (same cpu affinity for each instance) then the find_component() call will never
>> fail and so mon_comp can't be NULL at this point.
>>
>>>
>>> At a high level there seems to be three affinity masks used by the monitoring code:
>>> the CPU affinity of the component belonging to the control resource class, the CPU affinity
>>> of each component supporting each monitoring event, while these are three separate masks with
>>> code sometimes treating them as though they can be different they are actually required to be the same?
>>
>> Monitor component CPU affinity is enforced by topology_matches_l3() to be the same as the L3.
>> Additionally, traffic_matches_l3() adds extra conditions that mean that there can be considered an
>> uninterrupted link between l3 and memory and so an MSC at either end is effectively the same. Namely
>> the same restrictions I've mentioned before, only a single l3 cache, a single NUMA node and no
>> intermediate caches.
>>
>> You list two rather than three here? Possibly you are also thinking the MSC cpu affinity which can
> 
> I did mention three masks. Thank you for clarifying how the one mask (the "ctrl_comp" one) is associated with
> either that of the control class or the same as the class associated with the first event. 

Ah yes, I misunderstood.

> 
> Regarding the other two masks: it seems to me as though the CPU masks associated with the two supported events
> are managed separately. This means that theoretically the class associated with QOS_L3_OCCUP_EVENT_ID could have
> components with different affinity from the components of the class associated with QOS_L3_MBM_TOTAL_EVENT_ID. A CPU
> being onlined could thus be associated with QOS_L3_OCCUP_EVENT_ID (resulting in mon_comp being
> initialized for this CPU) but not with QOS_L3_MBM_TOTAL_EVENT_ID (mon_comp is NULL for the same CPU). In
> this scenario, "any_mon_comp" will be true and the domain created and onlined while it does not
> actually support both events?

Hmm, it depends what you mean by "theoretically". In mpam_resctrl_pick_counters() the class to back
each event is chosen. For QOS_L3_OCCUP_EVENT_ID it will always be the class at the L3. For
QOS_L3_MBM_TOTAL_EVENT_ID the topology_matches_l3() call will check the cpu mask matches the L3.
Does that answer query or am I missing something else?

Thanks,

Ben

> 
> ...
>>> I think that it will support the multiple control work if this is done upstream first.
>>> I will incorporate your changes in the next version ... I believe that would make you
>>> a co-author?
>>
>> I don't think co-author is necessary as I've just offered review and you mentioned you'd already
>> tried out the new structures. Up to you though.
> Let's see how the next version goes as I become more familiar with MPAM.
> 
> Thank you very much for all the insights.
> 
> Reinette
> 

