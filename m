Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADB73B6BF5
	for <patches@lists.linux.dev>; Sat,  1 Aug 2026 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785562645; cv=none; b=O0ul/OFdSQnhqyfBfGeKWg9JOKQADzUr1ks/ArianwLfHNOx68XboAAh9gT15on6YrPYPFLEbrW+G4CxT3y6/BRCm+lkqg3twHYP+cp4TFFPyPXud30GJvSZGc4CIHbzgTlCWykp6WkiCXss2wwZjOjVUJemkvizVYyxyGShUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785562645; c=relaxed/simple;
	bh=XAa4TKe+I0zsmMl484oQTyfnWczrzimXXspnyUgEq/U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Uu3btWTWhuksBlMvx/Wuc4fJEF1FUJpATsV+aW5O1sLqZmInG2/nND2XJnf3IxP+Zln8dvQoD5q3PpTk6ZdxqREUJhewMjbmWZsqhX73o9mqwY4pAqGXOcvM0heCATMzOxklNSJjJXR9GetjfPlQfAxw9cihVbEx4UE0BP8ajNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=AMcG3tZ3; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BKKqCnhb; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="AMcG3tZ3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BKKqCnhb"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id E00511D000D2;
	Sat,  1 Aug 2026 01:37:22 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-10.internal (MEProxy); Sat, 01 Aug 2026 01:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1785562642;
	 x=1785649042; bh=KnvNmU4wA3iXdtMnFnEaM5zs5YSDjHYQVJJyAFQvCfc=; b=
	AMcG3tZ3MyUv8hJDE/cn0e/wPXH/UDF/vQ3JiwhfjSVgIroN3DW3Mnoni4hO5qot
	ZGe7JZ8sWKBcz04GFyItkZDOySYitWhZ+ESxaN5g8gZuJYtzQ/24wOhbrhrrxz4J
	jrxYqrnVG4VWzKlKirvNm0lu4sO8A0Nq6OjwMukM+zFeO+whmlVQgK7PvDQo1H/1
	Cx6/R5sJ5dGxv4PVeY0gw4XtpUCcQdkmuvxMyCvE6n2sFJ8u60Uwvn27jiG/2xHL
	6ksNCpJUfaMVmn2rhzurdGONLjE5MgZbSkHZsR5ekpOlgHO6a0oRkqestJWRUyP5
	7s8PbBOL5dB16lLNvuJaTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785562642; x=
	1785649042; bh=KnvNmU4wA3iXdtMnFnEaM5zs5YSDjHYQVJJyAFQvCfc=; b=B
	KKqCnhbIW2j7tDlgVrMctAWohVrW0GBn9vm9RbV2Ccb9ZoLGfY13pZ4Sd7azxUTa
	mT4S9KaSoEy5Uk1rCnldZjxH4seUoaVdoYLNklwLsgv9wWaBJM1PHOEZ2LbLgoZU
	+SCS0oZxZIKJv3/Bs6tOXNlkN1VNRHhggqd2uLFjZC2SzYWMtQVLpfpU9cz9flxp
	Rm+apTJ/jj4Ky8y1WgRMcJhaQMcLwOSTs0TXqFTkANGlwIa62U0rhc9rp/SeB64c
	tlBTebi7Egn3iunQmbszpWNAMYfG06CNtCSZxeHmFOigk1jlclgfPbW2WrYTXD1q
	y09+G/3qRWFukga7IpCww==
X-ME-Sender: <xms:EYZtaqU2g3PPcfrVH4HcapKgfQdi3CfH52aL4vud_1LTk62uyz67CA>
    <xme:EYZtaifRFWTnTxuVR8koHAyDPz894X9Ia8vJ7xrvW0yfdHqymOWxqShnM8sfo21BD
    iMfRwdMjRehdOVq8doCa2KAw4LcaY_SNZaYQusz6W63-ZxVpEbF3Q>
X-ME-Received: <xmr:EYZtap7-OuLUfGar4AhgaJfwHnv6_i1HekHggwTy5rBe6Uai9R_UYI9V3dpJvuyRkKqbGKjdmTfKuW9CKoeOSkMVY4WIZPda>
X-ME-Proxy-Cause: dmFkZTG1qd71ZL7uta8iL80oRdtvk0BrPRhqU5C+7PshtdX14Xf00s3RlWEQlZRx3gCYzN
    zDsp+kAsjJIPvy9/xnhmX8jZvEVX+clqFd3nsgGVGdBI+FkXo/eW9a+Y8KQnRNl6V/yKeA
    6//CTQvupHCXWcQ6z1pfmmqv5iRzdNI2rb3KWU3Qk+JHsK0PpLKKW0fdx1H0GzQe1v8JW1
    kvp0/zwORBniHouJ9FbxjXLNZmOCjpoa//IEpwKDNYeoLZIPOI2I5NYad9iM3A83O5Xn1j
    G+bxthadoeTrovJrvtIO41/lrNN2iwFQpFiVw8U1fKY4UtFkdvqLnBwuL+ws/HunEpafOt
    iOfppWh4wCuPbkYUcc2Sz4xcSZMQAkSfhS4Sr+l/YeSZt9ndK2cbnOQ59rIbFiIWER/KcM
    ksJEuRXmNgzwp+3mPsr0yMjCuGLMr5HZH9RT/HMcMHBjnnYwoPdgJvtUeghtjComQnRTXy
    Mv04KnZylngkRjHrjbec5UBwJw98QzI3EwNl+T+HlTNgsx6tRDUG2TGRnKgxcZBl6CCMuI
    Na8C1q4SJ3Qfjx5j8RrVbJ/zSN0Oso49VUf5q8uUPcTgLiz5kdxjgc8onWOuBQj8UxyHit
    5bB/KaA+I6dMjBx2BmXkNPV4oURne5TSfBbwUfcQrbJjkFrgZgrwCZ17tvIQ
X-ME-Proxy: <xmx:EYZtalRH-2TpF3-JPUKwQjjHHiI95XrSao6Crkn04hNfLtKcRbiEkA>
    <xmx:EYZtaseP7tVgJXJwjD2OCPnUwwncF4lQHh9OAS8JSl4KjJX5OKd9vA>
    <xmx:EYZtalSYj0l_GKFD0ikxcyJvvl4DMsAvKeAYekJcIH-Xg-8ELm3BHQ>
    <xmx:EYZtalN1OaSLSAI54lEhgOfFMY6Pramifjm52LhN8gURs5FkKijScQ>
    <xmx:EoZtauo95eME0kKiWtwR7r24W2jxs48WGSfYMfhve_-WVfnaOM7fs450>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 1 Aug 2026 01:37:19 -0400 (EDT)
Message-ID: <036def3e-d2b4-4f54-a654-f6b2d4774d66@pobox.com>
Date: Fri, 31 Jul 2026 22:37:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260730141444.267951807@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
