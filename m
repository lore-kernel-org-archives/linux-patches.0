Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624B63988EB
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 22:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789251007; cv=none; b=KQqTU+hLb3iVlZ0Qc0rsEmnDG4UjkaQo6Vm7062USfpOijxrItYlfe/rvc4JBwrKrirL6MdgK2ulMrde54CBLC2oA0GymVvdGGuj9Li0Q7gr6IlhPw0EQi5Dq+FonKz5avOa/iCKdUQUYveKLbMe9nJSlpXXO3D9P8L652LXDIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789251007; c=relaxed/simple;
	bh=Vov+j5lDlp1u7/WYFDRXdYXsByK1/9uAFGJpfSM7sxQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H/LcVtPS+Ov1bCvSACF9OWMenddzrGYmOCDjlSA0inOs58rxzQYJ/SSSzBS3k1DgmNJDY1aYZZwbjHa2x+48HWYpcv+jqK7mLSQKMwjEI7LuoNATgiAtq6zrXi2NYRbMdIscJEY7Lok9swYBlqrL1JRFZTVzyUCeEZsup4K0vkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=fzyMLKJA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OSHxRMlT; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="fzyMLKJA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OSHxRMlT"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 10D657A0067;
	Sat, 12 Sep 2026 18:10:04 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Sat, 12 Sep 2026 18:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789251003;
	 x=1789337403; bh=Q/4eVZLXIfFPSy8zK95spoqi1UGawTiBDjAwPmkQG+U=; b=
	fzyMLKJABRKrBxQVddgR4MxWXT83PP8nVRhlb6YOTNObBOM1TkaEbww/jkt7fPgo
	eC+eVd8wPQKYkYcdKSNR2MWUvLBxm1PDWbqkXExpE4qh4qLkn8JkqUG36IqlPljT
	QyjnzmEL3PWCde0LxQmICxG+5nj8hrRt7DDLB/0WsvbLxDdj2yZxlamslbRcSN3G
	nWCCkTz4vLGXsNBIf/Je3qyghPGCD4dlBrqueSHCHR6u85rchYbpzTAKwVJ/zKaZ
	PJ9CEHbFhiY+oisyjZMy3aVlSUK6s1C53PB0ZBv2KwpPuo2sxXiK7GZzY0d0Z5e3
	uIpKchB1t239qMaxFZaPyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789251003; x=
	1789337403; bh=Q/4eVZLXIfFPSy8zK95spoqi1UGawTiBDjAwPmkQG+U=; b=O
	SHxRMlTwYirUyVTN3E8r8qu7ozXRXNtZakr7ggfCgEvH7hd8aGPlLl/z65QskKBQ
	R4YcMeCrmVwWHkqLOum6q6cmE73SJYyjtG8UeERBS4Y3YKuXaxdf+0EGPqmu66TW
	nNH6iOSYdaU2b3Y/+6M2R61qgVGRB1SprF0UzfdaQdSxVLxmte70/FV7WPDGRB8D
	oUhaxEnu6GX8nQQ/v4HMq92f+DvjQv6FKG2K3tCA+asgQJIoEhHiW05q6Xe2QdM4
	Lhv21OqpI7TAJrfFwSPT5aPIKH7jgp8SVcoHTy4aqkDWlL8MWy3Tlk8x9DBx1PNt
	nMkP2K4qvJEAzVPsQjPbQ==
X-ME-Sender: <xms:us2larMliekMjWFiwQ3Gh-H609vI-No396LNDFDG0Je3N6cN8dIOiQ>
    <xme:us2lah0uS36FwdjODV2izhVLkpOscLEBmZ0pEY_zTob-5fga0jv1Z6qbYdXGyYnlc
    9iP6WWtIJaQbcPgGZmxo64EjOlgjfJq4YpEWGj4NhHC9yR5mRHZAY8>
X-ME-Received: <xmr:us2lalyXQAPIUJfCs-KzZEMcujPQQ50H4kSBJR4J-Fjn3uRm5DuMEiLkQAgPV92jFQQ8JEaOw8DIwWi7ZIm2GGuF_kDqKPBB>
X-ME-Proxy-Cause: dmFkZTEOd4URmgIQpVJmQCf+djr9zQftB7RfzWwwY4Q2Q/htCvy0vFlU+SMqBFByQvVW7g
    5o3r5JILiFMigy5B6SLxMMj6kBcuv3T+zpyMglOh0sgq6+4EzvHMQSk8Sqettco54cSeJ3
    Blu3ySgnrQfZPtVMq+dkZCJ72/aEebSIvHNc5TIP/qm8hwU5BCzGw8pwIA4lVxoo6pNKZa
    22dr+MxgXBfYMxpOqb3vGfodBNUvYifpoi9LLLKbIFHWTcH+OGZIudaAcMS5KmY6F7P2X0
    32JuHQa2Vbnz23oDNezsqbY8kUZKIcEmsIJ/lfuiatCmBDHxVqFH09TGXdy0Wtu9pMjJnS
    P+pD0rWyZpqer15WkVfmWBdrQdrniPFPLZRRXG1gdfcaPeMSQWu5Q7OVOJGFnqhjGTuo01
    0HNMwoUcXq7GlcOCHDrpPxI5g+DrG/LbmxQP1mzDtK9kNYschCONHgE/iZbYAKZZ8bGTRN
    l/l0mF7T4jz5msqPux8s3zVBOjS+v0hu973r2SHCmZAYo760bAQl/MvtNfDxdE+psYAKf8
    JqW6Z5en78/Q/1Ll0xZtAeRPmPl9eRNk2MnF+L0A3HAvCpEqLLAusPBA/WbBvtteoZz6bY
    uSvedHWy2gsh/LKaI3f8NblHrS6N0opBKbnc1qeAksCwtpBgO5BY1WZnwt7A
X-ME-Proxy: <xmx:us2lajoEwA6k3nF-s1yTO6t-roiqTFHSq-PveCU895-2MDZzG9y9Zw>
    <xmx:u82larWhcXjOYWbqJGG-_JvIIbenvkaXM8GzCrPVnTjW7dW7iE07gw>
    <xmx:u82laqoO4iiNIslZJejrPUzj4QiMglJs9RSvPT_10iJhScp-wuzyhw>
    <xmx:u82lavEb73tOTjRuyMxvFO-HPTaa9qVdKfbo-wPIjC8_5Odg7gTv-A>
    <xmx:u82lati4iHMNyUihPOvA-t0UjqQMc4bXc0iW9ZH-BHBclB-cxHcOzpmN>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Sep 2026 18:10:00 -0400 (EDT)
Message-ID: <96b9da03-cf5c-467e-891c-387704647f62@pobox.com>
Date: Sat, 12 Sep 2026 15:09:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065607.279695368@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.157 release.
> There are 1424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
