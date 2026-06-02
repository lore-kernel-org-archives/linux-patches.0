Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F03B8959
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 09:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780391721; cv=none; b=IZ6jHb0psLUyfEugmw9IxLgNnHfY8sJVo+ET1HJ/aA34TJNsemeFrZN0QhCxOEHKP0sk68cFp0kfDgWjjtRl5qpUKsnajtE1ffrGtn8yrKTx+qBQEWC8+JbwWst6XOcKGJjPFQkQvAWfGtA8UlvDyoumSsouKSiyISPHH24JTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780391721; c=relaxed/simple;
	bh=wDdUTjS1uiiROITR8pl2La8dWidC/29wrQyzY8OL21M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FdT3tktX8h+CUcMbPG79hzKdb6m173z+eHYQIQ7Bv1JBh9GYwn8E1jp40lCGiFrJOHZCP1iblF6V0BqT+55Qcej1lAX09kJSMUzQLpIPiuLCnPmDO8remD4cwjnlx5yReDDRzSUxAuCEjlgRhMVzryUFVKI//tZzJJF6UqsUvYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ATy/w2E5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ATy/w2E5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780391720; x=1811927720;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wDdUTjS1uiiROITR8pl2La8dWidC/29wrQyzY8OL21M=;
  b=ATy/w2E5/xj/Cv72xVcbGhOMcZBxq/hODQCSbPnIxsw3SEpnBx8qXuTo
   QKf4gmCKa4ejL2V/VVgjRDav0NQA92fWgqGkzDDKn3OyJoj7cN5ZFN6fq
   TN7UCbsALPBgIJOvNksR6T6ltyot0Y1tVC7jcJRNzKb84E+kfzqaViqLP
   LI2Cz3tQuYJy8cRG+HsbZDih74XHTyGwYWLB/HsdaCcHjxCBWx8NUrUTM
   FrS/nAb2Q9PG2jKqcQqD3Bs8f9yUGYaDfLwOUQqcyHiuzB6J9+8KBZgxs
   4o3n1CVeIlnlkf71wmuXJ2+l+urlIhQhKr9KWDitL9r0K+R4WQQK7b2MF
   Q==;
X-CSE-ConnectionGUID: iSkv9+nWSOmnzUE1G6TlvQ==
X-CSE-MsgGUID: rJsDhBqpQROX2AN5osAOCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="68716595"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="68716595"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 02:15:12 -0700
X-CSE-ConnectionGUID: YhaHEIsESnS3gtsYgnxwhw==
X-CSE-MsgGUID: miUEYDmQQWWe6mtnqpPrNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="237505158"
Received: from mszycik-desk.igk.intel.com (HELO [10.217.160.157]) ([10.217.160.157])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 02:15:11 -0700
Message-ID: <da793a64-3a52-4c8d-8daa-da2c5c877e27@linux.intel.com>
Date: Tue, 2 Jun 2026 11:15:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 178/272] ice: fix setting RSS VSI hash for E830
To: Jacob Keller <jacob.e.keller@intel.com>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194634.287856530@linuxfoundation.org>
 <89da255b-a781-4ccd-bcd2-b2f856a8d7a8@oracle.com>
 <34103d30-acf0-481c-a387-26a9fc4769c6@intel.com>
Content-Language: en-US
From: Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <34103d30-acf0-481c-a387-26a9fc4769c6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 02/06/2026 00:20, Jacob Keller wrote:
> On 6/1/2026 9:37 AM, Harshit Mogalapalli wrote:
>> Hi Greg/Sasha,
>>
>> On 29/05/26 01:19, Greg Kroah-Hartman wrote:
>>> 6.12-stable review patch.  If anyone has any objections, please let me
>>> know.
>>>
>>> ------------------
>>>
>>> From: Marcin Szycik <marcin.szycik@linux.intel.com>
>>>
>>> [ Upstream commit b3cda96feb60d91fe88d52b974ff110dcfa91239 ]
>>>
>>> ice_set_rss_hfunc() performs a VSI update, in which it sets hashing
>>> function, leaving other VSI options unchanged. However, ::q_opt_flags is
>>> mistakenly set to the value of another field, instead of its original
>>> value, probably due to a typo. What happens next is hardware-dependent:
>>>
>>> On E810, only the first bit is meaningful (see
>>> ICE_AQ_VSI_Q_OPT_PE_FLTR_EN) and can potentially end up in a different
>>> state than before VSI update.
>>>
>>> On E830, some of the remaining bits are not reserved. Setting them
>>> to some unrelated values can cause the firmware to reject the update
>>> because of invalid settings, or worse - succeed.
>>>
>>> Reproducer:
>>>    sudo ethtool -X $PF1 equal 8
>>>
>>> Output in dmesg:
>>>    Failed to configure RSS hash for VSI 6, error -5
>>>
>>> Fixes: 352e9bf23813 ("ice: enable symmetric-xor RSS for Toeplitz hash
>>> function")
>>> Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>>> Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>>> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-5-
>>> a5ea4dc837a9@intel.com
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>   drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/
>>> ethernet/intel/ice/ice_main.c
>>> index 2a629b9a9e03a..664bedfbd8054 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>> @@ -8108,7 +8108,7 @@ int ice_set_rss_hfunc(struct ice_vsi *vsi, u8
>>> hfunc)
>>>       ctx->info.q_opt_rss |=
>>>           FIELD_PREP(ICE_AQ_VSI_Q_OPT_RSS_HASH_M, hfunc);
>>>       ctx->info.q_opt_tc = vsi->info.q_opt_tc;
>>> -    ctx->info.q_opt_flags = vsi->info.q_opt_rss;
>>> +    ctx->info.q_opt_flags = vsi->info.q_opt_flags;
>>>   
>>
>>
>> I ran an AI-assisted backport review and checked this against the 6.12.y
>> ice driver. I think the E830 RSS fix is incomplete on this branch.
>>
>> The backport fixed the PF path in ice_main.c, so 6.12.y now has:
>>
>> ctx->info.q_opt_flags = vsi->info.q_opt_flags;
>>
>> But 6.12.y still has the older VF virtchnl RSS path in ice_virtchnl.c,
>> and that path still does:
>>
>> ctx->info.q_opt_flags = vsi->info.q_opt_rss;
>>
>> Upstream has newer VF helper in virt/rss.c preserves q_opt_flags as
>> well, but that helper/refactor is not present in this 6.12.y tree.
>>
>> See commit: 3a6d87e2eaac ("ice: implement GTP RSS context tracking and
>> configuration") which is not yet in 6.12.y
>>
>> I think 6.12.y needs the equivalent one-line fix in drivers/net/
>> ethernet/intel/ice/ice_virtchnl.c, changing q_opt_flags to preserve vsi-
>>> info.q_opt_flags there too. Thoughts?
>>
>> Maybe lets drop this and backport it again ?
>>
> 
> I think you're correct that this won't fully resolve the issue.

Hi,

I didn't submit a followup fix for 6.12 as per [1]:

>No “This could be a problem...” type of things like a “theoretical race
>condition”, unless an explanation of how the bug can be exploited is also
>provided.

because I didn't manage to break it. Should I submit it to stable anyway?
Also, as stated above, commit 3a6d87e2eaac accidentally fixed it in modern
versions.

Thanks,
Marcin

[1] https://docs.kernel.org/process/stable-kernel-rules.html
