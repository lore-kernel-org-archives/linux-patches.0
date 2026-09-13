Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB212D46A2
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304446; cv=none; b=B2Aw0LwG1yRbBBhy4ZS68KgP+1MYMQkMZByd2BLllDTSlNO40cxfvMZgCwuZx0tjyWe7Ruk+X0KOrUSC8Kr7vbM8Cr3ypfuLM5hqj+KefylO2RTc3duUyxSyPRUniHyqinHzCYvjKAbM3TRCCXz7VilIkB2YYgevwgav2ZhdUVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304446; c=relaxed/simple;
	bh=gcr5ZODKioCQasuXg/vrCikCHtxD8G6HMt3lMqUoEx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YO7vb6kYBCCMzxQTNSQUeNWqqVoWYWbIW0pcgZGmXVbD96mWkeBTTU2uYOr6SoyZE9zw4hy95/RWIfm34IB7+YD50omRpj/hr/l2qH22v1o1slchLrIjzxGsP7iRM3RXirhPP2FCd4vpotJYDcKaeU06bPxIEx0qATeh8bRuHkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Npie6WTi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=q6SxjPuQ; arc=none smtp.client-ip=202.12.124.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Npie6WTi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="q6SxjPuQ"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8518C7A0059;
	Sun, 13 Sep 2026 09:00:43 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Sun, 13 Sep 2026 09:00:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789304443;
	 x=1789390843; bh=td/Xs2Ok6Y/4wF6mKsQ1UG6KD8v+Iy8wxiTS0v3U4rA=; b=
	Npie6WTiI1jJetwS20Qpan0ExxJ1DvNLACiaOdi4/jV4UgBrRB58QEFVPfRlALxc
	WAZecuQVVSLauAHcmQfJkWj72kuUGZNLLZhaZBsgc5lpicl8cP4W8dsedY5QLYgK
	o+ez6v/pF4g+tjFNU+14ifjqJOc2wpm7gitwJs5Ly/EzvWZX6p5wiEblYAY8esvs
	aVQbGQXQGQwvc12HTnbT6Lm11KXq25IYNSYMwESmn9VMOrAtpqP0QJsGyenCa0yE
	Pff7ninY4AFkPSJpXTmSD6mRObJJaoJpEPXP25EGBei4k/M6389dCkEqz0enkcxv
	/j3cGoBKGPNivHr5cmknDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789304443; x=
	1789390843; bh=td/Xs2Ok6Y/4wF6mKsQ1UG6KD8v+Iy8wxiTS0v3U4rA=; b=q
	6SxjPuQSLx4XFd7FR0btKHDD23QYH8KPgYdaG+dFOEKtvbsvQkM2Lmvd88Nq7YKs
	opF0vwJSnhp5V0jbuW2kiiTWxZePYcY/o5IsOoDiDkAWYv/ANO1zHcuzk+2FPnaU
	xCHoGu+iBB99+ZKkFFP5GAtWnIPczcgQFK7N+54zVbOYBnwzUNkdP0aD/OMb48Gy
	vkOlAF+XP5cjDcgzh9Pf+RlnWvyrnd9xCsgfxuxnT0njaJGc6Ftvr3qDBYdixbc6
	1Kmeg7S9/0n3o+/yr39tZnNap5WhlMdDlFI5C2HXcKIP8+6wWjMwe/9va8luFNSh
	vrDH27pCLEmnDSjqF0aZg==
X-ME-Sender: <xms:ep6mapLQ2JJyy__hi4t3SiPYXpZv3Fef4OKPdEDbY9f8gOUATNdN_Q>
    <xme:ep6mahBJTxCy4XfW-mOl9Q2yxOLFztlYrrGvRU3VeLmq3F864brfiWYzIxLThX_lF
    h-TbMEscLaU0b31E6XVxQxhVRtWLfw-zdjkEg0kAgAkKnBAobXrgBAw>
X-ME-Received: <xmr:ep6matNiOnFEsakcO_uHd-jlHxflnR59p8CRcUxP3zgvLKSVOUVcPwZw5VoAnMmEcR9LvolK0wf1d8zrdPXPCMKHT0p0U-HL>
X-ME-Proxy-Cause: dmFkZTEP1GNCSiTu3mT82GfDidd6MLcmps5PTlWJ/DkfmSADxpPg0YT0CvgBQGO2Fg/IOQ
    sVdvs+xNgwWZYwFbAo26EA7lM8UuHXRHjOFch0mS8LDX/STP8BXGeAcx+nv9fZGJkNuosO
    pjJTsaSVoRDefS4/4AIeC7YEbygZQ2Z3GBBCySqlRmsOyoP/46Hsw97ILnXBE6o1qyhmh+
    W9AEhjyoV4qqT+U4ZzAvkVa6alytMYnNYqRz7NTS6w/8OpwSojwdOLAiM8P1ph9uI2SOBu
    qyMfUZGwGFiIONxc+Ldie3SwpWg8IPK9F2LHZN3KmdpWPQSjXiik+wAa3oNJLqpnfl13FT
    YwhaQC9NUmm26o+zAdWit45u6mhL2KezR7A+tRoEqQCf4xhqLKIdCiAx+gGYy/3kScOy46
    FyZAWqH2xKw+G0DsHA15bhoMmiJhGPYpAP/pHEZWAile2SqUE9/NBrYnD5jDOB8p9Ur7Zu
    OD1NbYDqb1sdOFIt/kvKp8k3LTBWTKqqIbjgv4ZjHy21sjtLjeMlh97lBqBJwrQn0lalr1
    yyRFSnr3+c8EmGliaj9BtMkPRqsSGX6LXqlsQuHgq4hvd/bBiy6suSdmPdp3bvIjkyppAF
    Sd2wyUsH63MdNhX0R7h71r/qOYLumqi/0Oi9IaRj43GEP4mpqX3R+n6f0UVA
X-ME-Proxy: <xmx:ep6mauWPnBIgFR6FvQNer01tvoOfv9FsaBq4XSy56rrQzv8y0ttS6Q>
    <xmx:ep6maoS7eE4TIvou_EF516HWYMBP3viAWaPXV0tv4v26Slvs4M2RdQ>
    <xmx:ep6mas0F7PdQuoI4_8RO0lp6ST5gX3xeDxbnTsVr8Z-JUge7oQ-L_w>
    <xmx:ep6matjHesUrxtZwx4O_5Pawgvg8-Z0FZ-PCLSwCkXnYFE-6EzIRKw>
    <xmx:e56maoeaCvu3F7fVHKm-4ddwRCHeTWnNxkGXUpDjgd96IajSdXrRHcr2>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Sep 2026 09:00:40 -0400 (EDT)
Message-ID: <b8701818-6f28-49b5-bf32-cc7136f8d331@pobox.com>
Date: Sun, 13 Sep 2026 06:00:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065607.535295758@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:40 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1).

I'm seeing the same "needs updating" warnings in dmesg that Peter
Schneider reported on 6.12.110-rc1 and 6.18.52-rc1, but otherwise it's
working well and I have not observed any other regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
