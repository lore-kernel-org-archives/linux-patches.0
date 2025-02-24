Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCF220C49C
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 23:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740439798; cv=none; b=Qn4kZLZDkTmSIG9lLOlV/mi1RO4o1ussjWaJ0jK9zJvYURaXr0Ip2v4KQsmaK9QmkaON5+jlXirhbeMjl4DrcLFANWvztwefykDQshsOZPOpq/SVnAISbTZ0U1euBYwd9Vu2HUyLOd3Y8x6fC6EnPIODOJ4yHYwIJ/eDOHeBVUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740439798; c=relaxed/simple;
	bh=IXdCBDzCBUbkFfthm9/aQaa+v1dqrKyH+wUiO54d3RM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eSD4X6i/OqxAlY2+v5ry7LaNsHzs0CPkdEDxPzYgwajiV9AuL4GMNARb4jMV6XkBywdw+Grz9SYsnhk1PeI/Kgn7vC5Qn8iJdNAzOTsPjk48PaJLyrVcqSsV3geRG1dlvaiSoQoqjZfjpoP50qeVdfGHeaSv38XkTU2zNp/xf48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVLRaumL; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVLRaumL"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso44302155ab.0
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 15:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1740439795; x=1741044595; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xIkbRf4FMel4QDOvKceYfh/yaQ7I5vhGFgantHaE9ig=;
        b=VVLRaumLtnUPyFva6BCi76kLSVccY6jIuVhP3hyChvpyZiFUDnH4nfBMxOz7hv21sJ
         TVjWsM/YbCR7FILtaEboWzXM9vhwbwRB++c1jfGsKiDyGcxB1HKBzprV//tTBrjOxvBx
         7tNQDTxJSusDUkXjnx6Vbmc4MMhh4WgQfT18o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740439795; x=1741044595;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIkbRf4FMel4QDOvKceYfh/yaQ7I5vhGFgantHaE9ig=;
        b=X54hsuDvqTCnN3bvDpPjygsgCS6HdQ+0queyg/TqujQhNd+Od2jAaGaSDrFl5fV65M
         gqex/MZhh995eIaxCFWujquSxclTy/HM0kG3R4cflaq/IhUFzhuO7R94OUNPdjRypUZq
         rTdg8fbSjiBsKAHGkmdhtZqo4hkXZBGCp+yYmohRHl2tYXjSvpDfnlvgx1v6S66OxexH
         0eToPbom1AWLE5VSZkxJGsGNXhn3qzEDlxWVzfU95tDrJR18+9kV3Tmu0LlbgudF3ppP
         xgC1k30PQ4+KJfjTSpbceKrcqYdFNGiw3p+PJPV0mVncpAxsVWt99byjAbGQDVK91s9p
         XNqQ==
X-Gm-Message-State: AOJu0Yz7X0CC+ML4VETVL0IBppdLTIoEaXbaVsPcPBHXnuIRD2HGNN2N
	qVxzpzWMn65jATvuHutzLZ3emxZrDzr4i4o9xEr4tfNOoQ9s42PjHdG63oCOXTs=
X-Gm-Gg: ASbGncvgoha+MFjUBxaJnMO09GMhMEFFW00sd8bzvZTCNFp1aj13BVFoe9cDKclxESX
	Ooa0VGNDq+oCFPqalhtG4vkm9EEDLSb+gDw2fK9os8nX8A/MFCBe6IcBvRIYZ37veXJ1JNJHv5j
	GVJUr6ciyS/EjLXk4H9QeKnMRfZ2SDrj+W70duNZ9z4qndx3c9oMFr6k+6QAt7VZLbu3tm5/b9k
	XActtBJu0xoAG8rGlSHR3HA660CTKRopN4tcQaLUlIMZoMwbT3tLB6MdXWxY24PhP2Id7s+vT9H
	0bGETmRwrUNC9eZ2t79IdfBfP4kVtSOZxByP
X-Google-Smtp-Source: AGHT+IFHeukUOsy+wlnIGOaJm7Qp4XcZ0fW2Qyx12XDKe2CQzjzBgXCGHcleQ9ZvF+aWz4koZdKKyw==
X-Received: by 2002:a05:6e02:3d83:b0:3d2:b930:ab5b with SMTP id e9e14a558f8ab-3d2cb473053mr135338755ab.10.1740439794863;
        Mon, 24 Feb 2025 15:29:54 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f047530b0fsm126453173.128.2025.02.24.15.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 15:29:54 -0800 (PST)
Message-ID: <23ee8dd6-a4c9-4369-970d-07e5f142c96a@linuxfoundation.org>
Date: Mon, 24 Feb 2025 16:29:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/138] 6.13.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
