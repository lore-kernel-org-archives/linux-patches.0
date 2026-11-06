Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964026;
	b=ygfDybN25gg+WOKk51ZDkmnjVFxPVSiZaortaLXaJBwwoA47+7hEMvXFkUE4WgRcasKc
	 wcVoogtK5ZdC/uL63wBvB/P2cdEVKP0H3dX8a8VKLgHWVdMlKbpSpaWlhQBSEhGUZBmrK
	 Z4l7OiWTFC62l3OgwltBrO+AuGM1pW8Yjizwq2D5Cbkf4wltIt1OarJvOqRQFTdxwsnIT
	 rF5jfhXOdh+Uhq4oWSu604c2G4Y63NnMIynJ7ozpH1xsyMjVL0J6I1P0oZXy3Xf69IxuM
	 K5YO0W+LJH81DVJHwBurSIoRGeRp4aPlYiRJRK+2XIDju0UmwI+rn1Wi4giMAYMnyQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964026;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=jRMte+ocGxfAdSPglXppsWHCcRQIM7g3aw87DoBkH44=;
	b=Ol8kONtNTVf0KsRfINIngNkQRZGxKvX9RtaVnqbgWcfOtpqTyJSuq1bOUN89IObgP97y
	 lpIVw8Q6OuZF4x53zDT2XLX6qpYtYOG7MO+ivkVeAm8fPSt0sDf+yv8QbaJr+71qX9JGQ
	 LXdUpoVdp+mrLuYjuhOtpBIoGbsLdoBDI6S4M7c0M9cqMWygLfPdeLMBGtGrZCPHfJBS8
	 XVlBk1LDjWN6MbR0BxKt+I1nFlU+wS1Rmk5AQoig7we+L1oX94k1MxljBbObB+EDXqdf4
	 /hw/p9FYuCw1Y7avVh8tSapD21G3Os/uyCejUpZTjxcmwKZkyPuTm4I/bA/sok3LZ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Yd4+/syN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE5A606A335;
	Fri,  6 Nov 2026 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yd4+/syN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB59B1F008BE;
	Fri,  6 Nov 2026 11:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793964025;
	bh=jRMte+ocGxfAdSPglXppsWHCcRQIM7g3aw87DoBkH44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yd4+/syNsPWEnmDHqKmPI5i2YlWwyeRA6UGyp3nQ4ziEgRZRmqoanEP6UYkdWTWal
	 5HaXeGfte+hLOGkZsHdBhMbG1ahYI5BGaw8DyCYUA19MtldN2IeXnG60nyfcmss4Dv
	 TpRPZH2Y3kI56xoK3i7Uj51Mx45OfFA0tTuaCDKJDdjLA2+NfPV2x1Htw6/0E4mtJ2
	 IBCxe8CoOBoyKkR0l4nqdd+D6yGrIZIOu3xpJjXeruB1Zff/Nzz6URWhNwI6OYb9QH
	 P9+vYoyHpNTGycOakQ+Uc//spRARKBykHHSy41TNtWB6vhA35xw+xAfsv6ozkMlhiv
	 d5AfC1UmORilw==
Message-ID: <4f6be43f-0554-4245-b9e0-4f089836521f@kernel.org>
Date: Fri, 6 Nov 2026 12:20:20 +0100
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
 <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
 <2026-11-05-1-daily-reply-0007-7.3.2-rc1-wx@kernel.org>
 <3d2ae531-b076-4dd2-8afe-2f30c7c1d928@gmx.de>
 <fb15f855-e306-4b08-87df-f31a6bbb2a51@kernel.org>
 <ebebc4d2-c2e5-4f48-ae05-d048bb350755@gmx.de>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <ebebc4d2-c2e5-4f48-ae05-d048bb350755@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06. 11. 26, 11:11, Ronald Warsow wrote:
> On 06.11.26 07:26, Jiri Slaby wrote:
>> On 05. 11. 26, 20:58, Ronald Warsow wrote:
>>> On 05.11.26 19:39, Sasha Levin wrote:
>>>>> I need to revert:
>>>>>
>>>>> "x86/mm/pat: Fix effective RW computation in 
>>>>> lookup_address_in_pgd_attr()"
>>>>>
>>>>> otherwise I get:
>>>>>
>>>>> [    0.108037] ------------[ cut here ]------------
>>>>> [    0.108037] CPA detected W^X
>>>>
>>
>> There is ea6fd393cb9e6811a748c7551de0dd3090f9dcde to avoid this false 
>> pos. Care to try that?
>>
>> thanks,
> 
> I'm a little overwhelmed and don't really know what to do.
> 
> I don't have much experience with Git.

You might try applying this patch made of the commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=ea6fd393cb9e6811a748c7551de0dd3090f9dcde

thanks,
-- 
js
suse labs
