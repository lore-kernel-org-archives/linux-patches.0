Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12A448D86E
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 17:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789407838; cv=none; b=EDBIrdHJAQY3UM8LpaWXrcyQT0120lvhwz4wP4pylTz1r9yf53Iz5f7GWzn2MHq1XcHhDOgJBZye1xNeZsdSP6WAwoEV2oz4+0nHwIRfs/3RwHUGSYFyRc8Xlu3OhTLAOwYYVACQ+myeWtK0IaNkbTN3KEsZXv/e6lUEUA8aO28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789407838; c=relaxed/simple;
	bh=8gcIc5zX6si5qsb6q2DxuxxIhhXy9/rwBO1dH9VLJV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dlc/q5FivYfwZI+xvBpuaHRUGwCXWSrie+Y8TQzohqjSqcCyEKBrVehUcLLfTXur2P/AEuMbZ/PQ5m5QeoUb3U4l+cUMZn8NFV4xEQQar2WrcYbO23FJlQclIA8m1uKbS6X6uX3JdaWx5CyQEyqYfBKVqFeKW+QSK6aO0cL4AoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFh9TWjb; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFh9TWjb"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2dd76b1361dso562495ad.1
        for <patches@lists.linux.dev>; Mon, 14 Sep 2026 10:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789407829; x=1790012629; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBKrvUeumU+i5r59LsbnvjiB+I7jzK030rNSwtlDdoI=;
        b=jFh9TWjb3ty3OyVjG0mRrX8SeDKj738ow5O6NThf9eLBOEAFDu3QF/Oju0JeKPeFp3
         00aFQDOM071mef1qQMwe/RBNpK++FlNTgP9dnT5Sgn+6aIK7p5j/XXp0/Mcmsg5/HYWU
         Cnty3OqJTrj2q7Tb09rkvtxVUuZDVINZxbLsXY+jlbn+O3S+YC3hgtU/ykiPj2vXc1kV
         QxzLVojHEc1JX6rvR47yL/POAYlO/lnvue8ndURPMz/5B7GWbqWn2BLxepbZKznUnQLr
         zZghkZxuz/5u20Be5pLL+LtjcflyqV8b9emmEJ2PAE1+Ct8/np/kFipZly7yBoiwo3dk
         ET2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789407829; x=1790012629;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBKrvUeumU+i5r59LsbnvjiB+I7jzK030rNSwtlDdoI=;
        b=Q62lufFpgpq+T3kZzoLuoi8U5Q8CnmFONwzZicqZ0yEpyC+tHycUkwSBdhhRHUNETO
         uT3hjGaHmcHiOOw1n7GiRbVwqOUQtxlUxmztEF/6S40sPg6OiVbEvBj2ZE9EgdNEKtoW
         C9lz6oAwFRts4Yvw9T3buI88v8cyKhI9EAzSCEjL59YxRGGPhxSJtIbZr+H9G1KP6xfm
         Z7aiwjPzflg7L4kZmEzKxXnBBcGsLGsiaJNReDpxAV9HPTd05IKmNZMnCPg04LEStOzh
         F54CO8EL5DR1MjiKJJ51Zv3aoh2yDoRujfvClFdeQ2GfbD+Dt+bK3iygpNg2RlU6fMqv
         6a0Q==
X-Gm-Message-State: AFuF++kDsdV4soCUkca9q0JFAZRq3zNFgjbiy2tlf1ct4XntKLlJHjSw
	9FszXDWWvkaS+Oe5e8W2FBLvhGhzDBkv1S+2gGx8IZv/bJMgx7t7qFtz
X-Gm-Gg: AYBFou0PXY8bIzzkq1N9pbBg8wFc9XfdzdTMoil0D3duOKsuGuFzlxK5bC53tbbcVKH
	Ae0jLeBup6uhdqvfFOojaSWUZsQM51Pk+rL8kjnuePxfDWJ4we/FytkFnfnUG6H0bdyBqGOqPkf
	2OnUgZUas9RYgqm2fDOrtRW9A/8whUPIQJ3tP2slHEzZhhfBnnCZ4dXuA3u6X0b05QOc1UXflDf
	hqgSDY7EMihZ2Bt5ttvxXOJXRkoGs8WFx+sFLhhKfO/iRbcybaU44DwYrydWWk8RgMCPdPjzYEM
	cwxGnZKKjlkhndtVgQH8G7YnOrYjhGSgm+uJoGcXoaV9G0rsE+1YyIqESUpWVJRwZR2qVnlClHe
	B8S08quTmpVgREd9IIXgx/fhFF2VNSayDlsH5m5d3ZC4JhQI+VHqFvD/14xaS5FJjW+iYoiVh5m
	y/rrLzm5u5cBwM4m5fRBiPsfHxM2fFB5IU3n6HrkYW2IPbVkUnninqIL9LP4u46/TZj0qFdhm5J
	jGcMkpZzmLxBbuW6mKsQ/bPr1/wxO0CS2v5
X-Received: by 2002:a17:902:e801:b0:2db:331b:e187 with SMTP id d9443c01a7336-2dd6c5f3c7fmr68629005ad.8.1789407829308;
        Mon, 14 Sep 2026 10:43:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd3e2dab98sm46940725ad.28.2026.09.14.10.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 10:43:48 -0700 (PDT)
Message-ID: <80a9813f-13fd-4048-a479-5615105335e0@gmail.com>
Date: Mon, 14 Sep 2026 10:43:46 -0700
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
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065607.279695368@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 23:40, Greg Kroah-Hartman wrote:
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

Same perf build issue on arm/arm64/mips with:

util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c:14:10: fatal error: 
linux/unaligned.h: No such file or directory
  #include <linux/unaligned.h>
           ^~~~~~~~~~~~~~~~~~~
compilation terminated.
make[7]: *** 
[/local/users/fainelli/buildroot/output/stbgcc-8.3-2.0/bmips/build/linux-custom/tools/build/Makefile.build:98: 
/local/users/fainelli/buildroot/output/stbgcc-8.3-2.0/bmips/build/linux-custom/tools/perf/util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.o] 
Error 1
make[6]: *** 
[/local/users/fainelli/buildroot/output/stbgcc-8.3-2.0/bmips/build/linux-custom/tools/build/Makefile.build:154: 
hisi-ptt-decoder] Error 2
make[6]: *** Waiting for unfinished jobs....

-- 
Florian
