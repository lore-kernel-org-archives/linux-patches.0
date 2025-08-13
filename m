Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA532EACF6
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755092748; cv=none; b=r0iXaydaJd44gzk8Dp+XRPxpdwoKWwOGyiYt2JPeksIZMDMyrnLC87qDtWrhMZeJ/QwHLuduMwsUWvajT3OxeK3BB92VQtWgyz7gGplUt5FdGlcWZF00Pzcl24IYeFPYSBbq9jouHMy6usCzxQ+A1jpFRfPHt3nbaDazQDc57JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755092748; c=relaxed/simple;
	bh=jpPfaS2mL63R6WRS67iwH9PKBwGzxuPSBvRVcdrghQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MoibGPJxzA7pUKsLFpb28c1pEskxOiA9lByqxp+0QACeZaA2+gDUoiV8qo/5vIAg7aSigm04BQBiydfxPnN0bpmWb67H5TLvn/PzGNzZw4L/e+GyPcKBT7LncoqfO5lNwXtyBvweR+yPOMAcbw3G6OfVeVh6Zmh9neT3cf/qPdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BF5C12FC;
	Wed, 13 Aug 2025 06:45:37 -0700 (PDT)
Received: from [192.168.68.107] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45E363F738;
	Wed, 13 Aug 2025 06:45:44 -0700 (PDT)
Message-ID: <f970dcac-cc89-4008-8704-d9ab7c8869fb@arm.com>
Date: Wed, 13 Aug 2025 14:45:42 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 096/369] sched/psi: Optimize psi_group_change()
 cpu_clock() usage
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250812173014.736537091@linuxfoundation.org>
 <20250812173018.391927854@linuxfoundation.org>
 <83b69ebb-a052-482e-aa6d-34194ef18dc3@arm.com>
 <20250813130807.GB114408@cmpxchg.org>
Content-Language: en-GB
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
In-Reply-To: <20250813130807.GB114408@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13.08.25 14:08, Johannes Weiner wrote:
> On Wed, Aug 13, 2025 at 01:20:41PM +0100, Dietmar Eggemann wrote:
>> IIRC, there was a small bug with this which Peter already fixed
>>
>> https://lkml.kernel.org/r/20250716104050.GR1613200@noisy.programming.kicks-ass.net
>>
>> but I'm not sure whether this fix 'sched/psi: Fix psi_seq
>> initialization' is already available for pulling?
> 
> It's included later in the series:
> 
> https://lore.kernel.org/stable/55070b66-0994-4064-9afa-de1e53d06631@sirena.org.uk/T/#m0ddd243fe107dea7488d119cb60e8a9e18e2c9a1
> 
> Linus just didn't keep the CC list when he picked up the fix.

Ah, I see. Thanks!
