Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2537351C11
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 02:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788229855; cv=none; b=Dc/N5SFgopcanIigxqScADXk/oFdBa85yo9/nWnixIZdmWJwsZusAlEX1cQm/Be4oVOXH6cvBbusAlVaFZ1zNtw3ebnd+Kk7ZnGHTcLWyycdq/Q2Wt7RKJNFvzSV5rCXCOtKYr+WeSxrc9wjblD0gVBTDy39Cwnefq7Q3uIKNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788229855; c=relaxed/simple;
	bh=/BjsPLH+mUGnMYfx7J9wd0WyRTwAYMQMWUKvt3WLG3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UyxyPsUDIJj9Wu9MJrWF5DB/RZnSX8W+6SE6mpBOL9VgH9iDbIvc9CyRX8FFDk+J1YM1DAOyuQKceiVZzq8OZ3iYWfBhyPMPYYQo3QAptZgwy3y+eXqMdzEHMQmP7W+UMrZ3axxuoLQdg6nAavcqkvblksG67ct1aRzQ5P29/2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRHarmX9; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRHarmX9"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d715f4a587so4689615ad.2
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 19:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788229853; x=1788834653; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QamTYhkNj+WbJDRkMGOPRcQWDLFJdElCHgizZeiu82Q=;
        b=DRHarmX9ICvssv+nGvKQHnAyJvufaV5WZRFmBBxYmxe9/WZMXtUWNmU7eEU1TUvKwk
         AC9GTKtEKvdwGO6qjcA62o/g4sQYvpeQxzIS+9SopBbAxr8fFSn5SQoquWq7wLBEP0+W
         d0ge9al9JKBj5WO0qF1FZtzBpUd7m8P/FiCDRCVF8mxDHH4V2rDXkyU4GgxmFz/hOgzP
         A0Y8rjWaPAfqdkl4oy7s5jf8ymgxmB5fLE2J07GJnY37arwD7AX4rVvVbTkMu5+R/k48
         07JZ7AsKAHx8l8yLHH4PYPJZAxEm3gUQLN16+ZqEsq8dWTTBWeLoCec7n5Cgo/P4EfzS
         B/Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788229853; x=1788834653;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QamTYhkNj+WbJDRkMGOPRcQWDLFJdElCHgizZeiu82Q=;
        b=fQ1Ze+l56FWkjiIKFLuwDgA8axvqVUWs1HUoXfgDoFSqYoSsluOpN2ziA9B0WF361q
         sUKuscGnzldQVJad60WX5iMo9XU10sgJ563ZMnyMXelNzA1rLnb8BYUOFDOaWBlVdkou
         9wjLc71195KIIWFqF6dgFMZwVa2+u4DKKNKpq+5pQreqJI1O2rr3RChPTHd8762MJctN
         Uz5N3fBEItMYs7xgQDe1DFo6VgjGKmBlCR8NxosymQo1ENEgyJwsCL5XVnEWOzi+0w3Y
         9BuC3W1Iis2+vI3wIAgItzNSa2lLzPizz4fBYYsKxXc4GIy0jpujKHkvl9r+oFTy/d1K
         4/pg==
X-Gm-Message-State: AFuF++mhAHDsRbshjcRD4YhZ5hsFPQSlglO89vStf+Gu7GGWquqA2lZG
	h20e3K7GLk83nheKYFSw4dqeaB86EX+DvJHchy318VJrjPg9kRN8IpIw
X-Gm-Gg: AYBFou3vVhvTKRtiNGY6jHjHo0PCQ4oAOML5XNykK2UW7afyRnLsb1jmvH4HWjNVpGB
	yef0sMzXKvSZg474I4EjQ4lX2RCDIxz9yTaIJahNsycn8nQw+4Ps15UFQTD+l3/cJZk2HOnjHfL
	ETLHvZKlHB2DAvTJxFm4U7wDc4bnboLT2yJyqSxxzpgqFUzEQPqlxJkaeN8DPaioeOQ8xDaTiiE
	cUFdQO/JpKXM3P4AKuAVDOVsegmqSGSnYcXsLk1L/+fVPGGsirlxsQCnjq5BC9X/v7psGpE8rVF
	YkhJqJbJxHej9+gNS7kqXhUYIuMPuypS4+NKJnT4IcCF15poyiDihPrVOJragnmR3IsybbO1vLU
	Kh2g46I47yNxtVhLU+gqxBJqRLaMMXfmLTQyDsQe8FML/lEQgVaGOD1gzyBMvKYFKIQAIbtS1kZ
	ch3YSE6ih8Y8TAI+ZnTnw8cRgIQfpcgmO7/CNL2Cvn5KjLJHj9KXCpxjKY37fnhnLthkk/hty0/
	Pnm1hzNqJEna3n9BylY9uz6lvh9Yg==
X-Received: by 2002:a17:902:f54e:b0:2ca:61bc:317c with SMTP id d9443c01a7336-2d74def63d7mr477797405ad.13.1788229853041;
        Mon, 31 Aug 2026 19:30:53 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f9ecaa9sm35043673eec.26.2026.08.31.19.30.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 19:30:52 -0700 (PDT)
Message-ID: <68bcf2b1-ebd7-43d1-b2a8-979e6ddf4c5f@gmail.com>
Date: Mon, 31 Aug 2026 19:30:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260831133359.055927882@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/31/2026 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.3-rc1.gz
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

