Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0819E2E92DD
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.68.50.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755072613; cv=none; b=G0UOt1cGMcIzjVRlWtpvjAGRF/o7oaZGAxWI/IxZ/U9A8NMYUbjeDzMVcqmRR1UhG3thAg9BtStNM8UAM0srZrjeSB9B1DyHrklqbJTEKREH8I1gSNm1oHJPCgjbxE0/0IxhvRQuCHFh+684RMpljPG9NXMSPwBTyg0qDDHBeiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755072613; c=relaxed/simple;
	bh=AB4CRxgZ/K+asTbTo0Y5VIvvzarVo9pWZDEvrp60J6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NDzidT7/YcpUbhQSv6nxnljwLYc7XfBNW2MvZEpv5MWiGe7h2zcEEVKW6kxXJZCC0po/FPXMYtRqj9mAHtp47aj13RJkN5x4kXpkUYhUB6bCfWk39ehYgfwmVQ8dSFaa+Wb2hYBft5QZuocDjQEoVoF84aVlzOq1GCz/WAcu+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=prolan.hu; spf=pass smtp.mailfrom=prolan.hu; dkim=pass (4096-bit key) header.d=prolan.hu header.i=@prolan.hu header.b=I8J3efPm; arc=none smtp.client-ip=193.68.50.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=prolan.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=prolan.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=prolan.hu header.i=@prolan.hu header.b="I8J3efPm"
Received: from proxmox-mailgw.intranet.prolan.hu (localhost.localdomain [127.0.0.1])
	by proxmox-mailgw.intranet.prolan.hu (Proxmox) with ESMTP id A4DF9A0168;
	Wed, 13 Aug 2025 10:10:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prolan.hu; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=mail; bh=rl1WbGMPWQ/RY5hRRY42
	uFaJEq5feAo9XpXUhJH2YDQ=; b=I8J3efPmqDQjvdTQfQamoLzL7oqALShoW1O/
	e/CvfzKfKwLQ8Y8I+Q7tzFpW3wk3WQtmLpdYA0sRjJ/xiPXYP1eMqmV2Y6tyCu/V
	jw5r85GQiL5j968a3HWIZqbXbgEM1SOILAZRiZcdV2vSeBVb8v85cyuRQa251RPR
	6UMUGS6eUFyv4FMaMlOsO1yNvKgLfQ3s4kXFUOUljQVFNrdMDhs38iHZ0Lkqx8ok
	b9wQmsyui4MnrjyC8/LnKG8i2P24+dNdTX+ltrO4uxJB+XW8o1QqnZANe6nJwYds
	yHAQStF4QLcq70dsFHuRVnxD2wXDd8xjziGCIZjvystcNtBTIQe0xf2Cqy3my7Oe
	th3xbfA0eLbOhrEk65aQWy99QcUkr1Rz49oWPPERljXFUEV72gVdN6WhHy8vj6/K
	iD8Wv1pkZIzDmHqdRGAurIS4ePn902h+fQoKHDtIz6BGh/zv1zkeL+EjHRZZ50+C
	zUBDF3FqSAEtFIyZjdVNoXsNefpMkV9N6Y8reWdWvKEsi/vLyMC0DgHW/TqQsJ7m
	YdjLf39GKsuCqH6VW1y69hk7jIZn6TFADkspW8VJG8B0rDjGl3QtldVzfMx/0Ild
	7SJ8ASY8YOKH/1UpCnjEWb8OAuyI2LgPmaXfhJbvcG26MObthA574roh6jKhhPJB
	TyNrbu8=
Message-ID: <44d15997-2c16-436e-b1f5-fc2de7afe29b@prolan.hu>
Date: Wed, 13 Aug 2025 10:10:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 519/627] net: mdio_bus: Use devm for getting reset
 GPIO
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Csaba Buday
	<buday.csaba@prolan.hu>, Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski
	<kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173450.953470487@linuxfoundation.org>
 <73f6a64b-89b5-412a-94d7-07cdfa07cfb5@prolan.hu>
 <2025081305-surround-manliness-8871@gregkh>
 <2025081337-reprise-angling-7cb8@gregkh>
Content-Language: en-US
From: =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <2025081337-reprise-angling-7cb8@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ATLAS.intranet.prolan.hu (10.254.0.229) To
 ATLAS.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A296767155E617761

Hi,

On 2025. 08. 13. 9:56, Greg Kroah-Hartman wrote:
>>> This was reverted and replaced by:
>>> https://git.kernel.org/netdev/net/c/8ea25274ebaf
>>
>> That's not in Linus's tree yet, so I can't take it :(
>>
>> So I'll just drop this commit for now, thanks.
> 
> Oops, nope, we took the revert also, so all is good, I'll leave this one
> in.

Sure, although I'm not sure what the rationale is behind taking a commit 
and its revert also, in the same release. Anyways, for the rest of the 
backport versions, drop this commit and pick 8ea25274ebaf instead (it 
should land in Linus' tree in the coming week or so). And when you do, 
don't forget to read its notes at:

https://lore.kernel.org/all/20250807135449.254254-2-csokas.bence@prolan.hu/

Bence

