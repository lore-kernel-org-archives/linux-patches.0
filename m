Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1433E35C
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 00:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788223513; cv=none; b=ntrM5XNBa0y7Kyoc3612roQlSqEsMI767JvLbNPkq+61V6D387+rbIlr2u/rn2LH4dHMAYN5QhUsFj0HARa0YVQ8PDB9hQ+Y/ZuUPrq7Waf3uKWhe0q0ZZzvhZwj/So4xnS2RLDO3prQrFS/nLvHDBbHmQaobrfrrLL+JRSewFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788223513; c=relaxed/simple;
	bh=b/cr/GpR99/g2ZRVZTnX+M72uIFpbYKpxinXPlmHQt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qSvq/AAsWfjBj8ujCGamj/tutcJdUc5qBxTvh5teEbgkJI0gIGJwB/LvpeHFX1BkNMBHrSLyvG03CK7DCQ8esz6nvPvSTcRN/YCyoCg5aVUnftwewBaPuwVM3o5DfQD3k8d3mj33Wz/hyUPDhNmWHxnFXAfnl1Qkxu/DxayffMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAa/PxaU; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAa/PxaU"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cace91f112so34040005ad.0
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 17:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788223511; x=1788828311; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ayLUeYsEczkt1CuWOz3uZQfDpFUlPJaeekAPDfzeJMk=;
        b=JAa/PxaU9wpWUuql0yMh87HY2rrBBkZmjBf3I0VDcOAQ5vOazlvVvNxfsFLHnF/Pk8
         qsT3OZ3Le29wVzV/Hv1G1WwBlTZorixmlyGyoC5AWIM7kUc+tG3kvDFwiYO5Mud+ksx0
         RMWDbX63X9O+gBofh0NS8kMpl/sq9oM6dqWKce090tVbudwDdB73rHA5/xDhYMRt22f6
         4giUOoMee7B2e40AOq8EoAfpoCeo5qJgr7vlx0p39QFkmmqKgQkDkaUhAE0xByxC8OCk
         yQexeK6ivBSyrSJsDQ+gPDeG0uaW+h24XtEEdFP923Q5iV+/yqhLwsHGefW0zxkUWoO2
         PAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788223511; x=1788828311;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ayLUeYsEczkt1CuWOz3uZQfDpFUlPJaeekAPDfzeJMk=;
        b=Y8hgse6vjDATz+Ng7HH8XzjYHAodRA0E326TFhMvAhGZJcTnSn9k6TLATY2YwKhaZa
         mNdXnLb332fetf4C0JzNPsDLaTPiUeHtTb29cKvaZhhppbduuk2cqIgvVclfjMQLPVvF
         /hY8oGcu2uNgk0bW4QNsHcqexHdIItL2nhpVC4+FtX+u9th4Cskaiw0CjGPGyXhdbOXl
         scHVsiM5xFCWzrFHaQrG1xdHB3CgOqe0dpbYtKHEcEdSnqoJ6hJ40B2pe1ykfKs+SwPh
         HShts8bhD6OwlGltE5O6wqGwmkNnoD2rSymCDZCgIcyHHx2f7p4rWyJUaH0vSD5hJiV7
         u7Mw==
X-Gm-Message-State: AFuF++klFikBTNjKLylWFoEJQi4W2rmj5uUm5FA53YcirfL57Ay6Es5X
	4A3ZP0pNJ7Dn6gSek3MBiwO/PNOAAXAmhOdMbp3gRwjWr6D+WRBqcJlM
X-Gm-Gg: AYBFou1y/Vw/dgEzfUEZnhXXn4cEE7FL0Et32XY9Ej1RZ3JpEZYN3mwYFczJzqL2OnM
	ON1B5VE/3chfNSiBTxdIzyvG6DiOlR05m3yVNCJ3kM+Bg9KIq+fZ/TCejZgUUK7AAC55r2OQWiE
	D1u1DNiMVYbQY/pID2MakMN18jQ+kUmkmg3bbuBUPpIAkCmwEiqDhh0IK1dtYdNcfgqPOUcFyFL
	rkkaVfnA8NzsIs9WUB5Fk3W/OiQqTi5RhNbs8ZHdu3ymZgZtzbu8POJ/3+owudzKj3pAkWOAEnT
	hB6AvIyAZs49zgp/HrC2TDpRqcVeCt/8mEfA3RbGaF279ObWqOaHIW2aQ6sJJJhXi5U/GoXpFtP
	c0L2bSZCFC7JeheMreWGei8cul7WLn4Jh9n+d3pB7ABkHoaWLVxdbFVILXO8gpL/KyryQHozAwE
	Kik/Lrj1wM9JNEtERLUWZRQYks05K8VxSFxdSTKO5Rmq+XhGXnnkottUsIpUgvXOYhNNXY6Gf9q
	udotHLPfRVtPF1JxTz1v7O5tfBxfss=
X-Received: by 2002:a17:903:4b08:b0:2ca:e62c:9e96 with SMTP id d9443c01a7336-2d74dc51c7cmr475653825ad.5.1788223510826;
        Mon, 31 Aug 2026 17:45:10 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f9e3cf8sm36111824eec.24.2026.08.31.17.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 17:45:10 -0700 (PDT)
Message-ID: <89a183a6-945a-4f85-aa2d-821bf25903ba@gmail.com>
Date: Mon, 31 Aug 2026 17:45:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.185608553@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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

