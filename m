Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576BE3E00A3
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 22:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790809198; cv=none; b=JyG3sbxqCZhN5bHSKlzD3gDFvhH+cyjgsYqlGEvH+UeJxXHNLsGNnBdH2ua9zp4PtIPuJxN6ewBC0aMwaK3lHeVM+BOUqXNrQA9bDhm7K8+IKmfoKCTwdhguWGtJ9utcgETCsvMQWYkjbEXqSkPpP45f43k4t7ushfZajKGHu34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790809198; c=relaxed/simple;
	bh=V/ugLR6nvLH60ejVCgRMpkVVC/3rQZq4w3LOwnT6N8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbHVip2NsEuF9I1ezNWEg4rp4lLkgKNlW5BOQPd5DcAUBXh9z+GkvlR9TA0dkjRnR7J90FGpKjSU9DDon15eBgaLdMt1J+yXguQcVa62X5BRIxXFTmzw21N+73Aj12h1XcknQsE9nBedJ7PWYaWeO3vx0J5hsj5geEzRKUtAnYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zdm6HxWa; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zdm6HxWa"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3410209aa6aso154389eec.1
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 15:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790809193; x=1791413993; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Or8VFCzWUmGeHAUNLqGvmA8mAzXjKCrijFaz9WdWst4=;
        b=Zdm6HxWa886IXZZNhlataXPCkcw6NFyM7UVSHdfGME6Kv47DbnCE5VOYyVwvQaw2Kd
         0CoKYPgEc6gATGpdKL741tQZ8jWsH+hf+G419ArWdQ3Ne9t9epyKdyI1oPBuzEs6QCvo
         8298d6cskdkMliFNeEI2r8px9vPlHZl1ugxH5HjY0t4tDRV2XtH0d4LJl86X6zc7BOT3
         ukJkhPFyaGoFDyXzWhVn62ks2WFsDE/gfbWlyCWxDQvFPMHqHSAq82LxmMZnaBWyrAUb
         0HV1RE5ZBSHKF9lB++t2/pheXO3ySf58mgcvfDn1sBMgYixsvD4OMxSazjHKG8zkh1sE
         vURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790809193; x=1791413993;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Or8VFCzWUmGeHAUNLqGvmA8mAzXjKCrijFaz9WdWst4=;
        b=TOTcy5myciUZtzPoDeBIhUHVXsbP7+Wb5W6tyHfBCnbqrisInfzRv9Rllj7AFl2B0w
         MMXvA1yHOJMFinMNZOIqIn0YIiFUdrvL9oktOQYpgdkIU4BINoUtubvjX3FvMLCwr9Gv
         TKFLpz5D7SyUQpTF6SRGsq1PzZ0KI01gXkFS58BQ4aYxq2sL7GagrOB/ndMh4mv5i+g3
         3p7FlrPRJ1CI1rFbvBfMmmS3IA6k4LKKgBTfKkJUOvy1xXSS9HhesGc4dLxgdtroy2Lq
         loxutODnoNfyfuyeNg9iiXlEilnaWbHV5nsPPzap9iUGd9K0Z3wfS8reb+VzxjC+n0ao
         hKkA==
X-Gm-Message-State: AFuF++lQ7KEYVGYA4yH1koB824YNgeVxfMySMTk9mIWDv4nqquWCwCJb
	EMr/8HIjSigC0XwB597RTywSPr/mcQ+SDXOkRIF5dQHbY2ugGfmvpvTj
X-Gm-Gg: AYBFou3girbp9yEhTjvA9Gby1cIP3Y4J7WrcYV0rptVBX/aHLjl+FqqC1Vf/RbxvSsN
	AkQkPS5+7M91GhirYS24DnewHbwYPZe1kucBLv6a+BXzqL1QAen15f+/6GyVJGN9kf65IiVfdWO
	ol9Tg7n2u52bRREG+1B5OEAjyiGZzbSWLHwtUezjA8VpJ8njoiifcUuKt9IldJv0aYBymrXHAsV
	o6ekZoDXch7t03k+uZd7FhdVwBJ35KLsV3GIujZXI2CfL/m7TO5xy+FJLWJ8FywBHhRJOmGmx62
	WQ6dYJCdCdK7pINfTZtiHfPr4GxNUfeDLmu1Y+4ttqpWzvAGXhPsNH6NOFHRJlqDCyBEGYR5wJj
	4tIkHHO/ElOB4cXWQzvVGxUZ7+bJ01R9Xy8SmguWMdic20s6GtNKDZP5tPy5aW0nBMZZx6FEj37
	g3oFBCJrFKBHlU+tR85/BleBxVwmvJ1tt3XNLXaPrTbr5ueSviymPHX21XY2NHqK+466jga/LYF
	40W0nA5on2pkN5TIDziRf+vqp8xMT7PryzlMP6t1QI8HBy7UA==
X-Received: by 2002:a05:7022:ea8d:b0:14b:355e:2888 with SMTP id a92af1059eb24-14dd21269bemr841140c88.27.1790809193194;
        Wed, 30 Sep 2026 15:59:53 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14df359ee25sm1527465c88.5.2026.09.30.15.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 15:59:52 -0700 (PDT)
Message-ID: <00c2577b-e163-4f0a-a6b4-d067fe7c1f39@gmail.com>
Date: Wed, 30 Sep 2026 15:59:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/752] 5.15.222-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152358.131179731@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.222 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.222-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

