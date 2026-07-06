Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DE738422E
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 10:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333777; cv=none; b=g0MfpWZUPweDHFzb83fmu8COA6ZG4MdKjzLVWwVoldize3WlBUDE1Q+vweIA27E0QdIuhGA2I+/tQXFUABmypc0vEa1EnzuP1YiElPG27kjOX6aUBXm3qOpTM4jPHv9QpBm6KsdX6nAo3dw3S7RFFcmH9uNNlkCUjNno/Ytgpwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333777; c=relaxed/simple;
	bh=hQGFqx4IJ46LMfGQptkfnFSJjPUglR76Hzn2hDUlyrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pgWRmwbOp0xbKY/43c7q2u1gYglQiK23yvIGUYubF2jsHW0ENxnSLiJ7eTW7ei6U+xmo4d+16fA8E7Fl8/GDztGZj3fTDxdGdJdD7sWfPiT74H1duIFhxgWOh2l+bROgvnKsmvXE9SZpW5MtY3hccNynO8H9B7IcWFtkNeTSx7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OLpwM/im; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OLpwM/im"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-474303f3c72so1659157f8f.0
        for <patches@lists.linux.dev>; Mon, 06 Jul 2026 03:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783333775; x=1783938575; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DgZGkATc9v6IJyoP0jVfXRsi6k/bycnl80rgTX/hwpQ=;
        b=OLpwM/imJXsXjyVU/JtWWOKh6qGhZzgE5QQ4QDbEDtOZC133UYHp/OfRZKyP4Wlcck
         0ahV0ki5NzbQWnQi1cuFeGBL45MfhO6aSXrks0t7dbpGBrdqvS1fPnoHVVRF8LMO7odl
         4Qmj6vBT5oI1f6/kbjfp1O090/6cjjYBoeHmGuw8joYMFMWIom+z6EA0ZhdyPln724hB
         gxXscmJ2VBTZn1KxJSdw+OGxJOhuzQ8V7xUQ4kmwOSW+KxoV00DQ3Hxf8LI3OiquWqlq
         dRfnQeAFOpbFjPXQRbg8sIgtRSCMyyT73Tobon91vKs1Kiao8qtKZI6NWo69/zbMJQh3
         bVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783333775; x=1783938575;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DgZGkATc9v6IJyoP0jVfXRsi6k/bycnl80rgTX/hwpQ=;
        b=poNBz0ws/Y7hk05eqs//rlpOmHaS2L7tSQ+jIBic1w//knstEl8HB03pdMR7mxzwKw
         Y/NsnlL6WUZ444QJRax3TS8xbzr+udomD39ACGrUCbfl05X8XpbIv9pADe/KdFrhjtcy
         KZcH1q0FpIh1xOhFhZSIekFq0TmxFCAMc517ZKwanK2TDko4YN76OHsDzO4LsJnOaILh
         qi04XkPc15yJUJSaIbumSslOErs+iZzOKmxtfL0tuAbtG64TplSYRRiOX7RrJ5VYFZj3
         qqel+O6U95b/UX8NSXNkNB3mjI58X/cG6nmUqD5w4i1Ox9q2s/9l4tQQKAy/SMT3IVPj
         T5ng==
X-Gm-Message-State: AOJu0Yzaf/aOLCnp757v9uTl3/uEVyKkma8//HKLMA+t7d9MWzdl3DNz
	nibzZ8lD2gL+1oLXn7NeR5DeaCXbU7vDYmerDlIKbWVPfvumPkUMYmqB
X-Gm-Gg: AfdE7cmo3mS6sZC9rYtwiUTIW/2awYDNawb5BR0QOTASqUBz2aXpbcdozaoI5/4hn70
	YpD4n2CspUkvYmDKbLtVXeWqH77JHfgKaiAI7jjsUTu0qNDyvYWhKsjEB+sIZXMTVtc2LsE0eYR
	tAtClY21vjIhQgRofdjYf5kPrjbBgUUtZqK71wtdSxDr84P0EcajuO4JGbFsdvALiZwBEK+67+S
	IDbiWhSdTHv1lAQ07f2FQYPQGO2CazXA4ntRqMuKNwDPVwkkI2cE5GFSE0aDWeYOHg85ycMavTU
	F2lnr9sj11tu0TCM3DZVfjj0v3cHEpyfbYsB2FUSrj7o3ZJMOdJqMx7z5/OMPZJTLFCaN88iACo
	PoIkWonZpHQxgWc0l00ZOUc2qKeEyNodF70kkIVn8tG7eLQzRN4TGWW1dRbIXX7kO43gu8L6Cgv
	q0z+K2NGijGMmOH8U++Pi6N0PlwLz7Gg==
X-Received: by 2002:adf:f288:0:b0:475:f100:360d with SMTP id ffacd0b85a97d-47aac5e3774mr9178054f8f.60.1783333774411;
        Mon, 06 Jul 2026 03:29:34 -0700 (PDT)
Received: from [192.168.1.23] ([92.183.46.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9b4d850dsm24605054f8f.0.2026.07.06.03.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 03:29:33 -0700 (PDT)
Message-ID: <2728e1ae-dac5-4b6d-9e6b-8948b558a341@gmail.com>
Date: Mon, 6 Jul 2026 12:29:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/96] 5.10.260-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260702155108.949633242@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/2026 6:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.260 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.260-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

