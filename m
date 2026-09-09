Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB9D39CD12
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 18:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788979459; cv=none; b=d6xvTF//ZrrV2hKmV2DUpmVA1ZEdBHSqqKY0BwQICyFUeKjPYZCOB3Db8K6JA6OMWj44aZkm/azudmXunAk3ZEaJ20X3WjoGSBvJ2GlESQqMm2tzSqkSo0UzPoQchAfeluAFNKtoSrZqMvokIhp+JpEe6k15Z/yi4vg2v9QrygU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788979459; c=relaxed/simple;
	bh=GBJlCUhbFJ2h8LJzp7/8I5Sp8G1WbZOYa7N7EatzZPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WCY0JR3n7M9d1cUIIPR9kw2d6teUmffNRzq+Mqskzdum4i5DaD6+Owckiq3zXiIhnff4erODQ6NtqIU0qjQebtVpQ+zPArYlifTEKD1zu6XI2nMTKwpWL/50jFKJLzBD9zdtvhBQhJOGJ99fATxISrWMR/u9phNbzJmN7+XBnpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQYXNzAJ; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQYXNzAJ"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fb334e72so14161575ad.1
        for <patches@lists.linux.dev>; Wed, 09 Sep 2026 11:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788979457; x=1789584257; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xE4MhgXXi1uL0qo0jklt/DxI0WtmnC1JMz4tFPrlno4=;
        b=PQYXNzAJ46kdjQCZZFh7jrF/xEmQvL4uiS2z460+/RLCu65UUQaaoE74RailBU666g
         fbrsXoOVwXGmph6Q3QxCaJfGT1zqiTa1EuQJTKDRlD54ymjqIptDNnk9RtefXdVE8kiJ
         gGfSL7RPA16jql5ttnO+kjULrO1TZnEtTnBMmhHnKsDESE3qTpXKebEOCVKY/kOzQGDo
         7LIhg3HKmZwklH/YgUqsJwYOeQNEl8Ffb5tk/fZ01gyyaDu1MSihomBclhe/d0ZPaY51
         5QXOTdK8ovkHAUjOBY/4J2fbUBwVSt8pFIK/fkN//Ucilgr0nVwh9NvcQwTgYKYGRu6k
         eWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788979457; x=1789584257;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xE4MhgXXi1uL0qo0jklt/DxI0WtmnC1JMz4tFPrlno4=;
        b=LmKBYJTDZDFxmWh9OUh6uQzincqjvyYRFnOUVmnlnTptFIesGfyeE6+BWi825kaAd1
         iY80GNrmSkJSK6gFqkeOXYoKemlYPdIIGBjnXWN+NMRfaWytwe9tZg+eHnk6jc+nRQEO
         jWNJlC7ACFWWJlBJhKrtggdnkMHksiqD2uiPCItoBcNQSYksI5Ew/2moSmtu9u+/v/WU
         EKJbChLg1invw1EWocHFoFbOxnQmUEW9JQ/KShGUEm40vr+ypStRmUOpTF/DhW0LFbdF
         K/aS0FL7uShZ2lFHrLWiCwmatcEKPa++nyLJS3aXdGdvr08DI7QB2L6d1BhO6q5TJdS4
         2YCQ==
X-Gm-Message-State: AFuF++mUXke0zbKwplQ5MSZXqsOUwL5vtAjj27K5Sdt34I6NVZ1I6rGB
	DKNqUlsUSjcfPcrVjvcpT6gNkOnldm5HRYvWTohffGgc2G2SPL8P+fu6
X-Gm-Gg: AYBFou2o6AL1tmWjlZYViF8iVVzpbxKbWGIon6x4/xuLjYS8ywnQ0p3/JtXHAT5wia6
	fqNiyZGH1TXDIfTZJjBXyPhUmJd3Fw/oZRSZiBmF990syqhzKTRR9yZq/1TsVUnXve3qsUuOtFP
	lkz0vu8kHm5l6O366JJ4enMBwBNu/omveY6oZEksy1e7F9I7XuYvSGjPB6o5CEU+FDs2D+HBDZT
	K1tMaaIvE1KOgvxGNUW/6vJd8XxWKMkHmw1ct4wcWRPqRepuaqHYZK6HDcLJ2nJ1/iwT55Z6RVq
	3tLKGxXJUa/JsLanK9wy9yhGMSh0m1yMO6WpEnRUBa/vazBjbistZZVEjV9mIyxYT9Z8OSYvHo6
	tnar+PmNCR62eH4ZsL4EKaJ7mLC08MnxicNEmMLOwbaqQJLt3BMpF2vIZimhZ8BHmC1UXlw1N2v
	CD7CeKMiYil+7Qq+6jNB0uYWJQ8Znl/zx62p3A+4ZdkUGNJW3ZtJQu+RkFdtQ69KZbmcwRKo/I9
	sOE2raGAzCWcRAtJBDmTEb2nQ==
X-Received: by 2002:a17:90b:270b:b0:398:c9be:cca8 with SMTP id 98e67ed59e1d1-39bac13b38dmr11758975a91.2.1788979457285;
        Wed, 09 Sep 2026 11:44:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3397d6d1c16sm7741767eec.13.2026.09.09.11.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 11:44:13 -0700 (PDT)
Message-ID: <99110247-7f33-444e-b37e-eae8e641c45d@gmail.com>
Date: Wed, 9 Sep 2026 11:44:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260909134230.441546314@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
