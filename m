Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90772E57D
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 19:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737486657; cv=none; b=XOaH+cSM4LWUv4TKse3De1WnIZ1y3mhvQ2fPs/M8Ee4/WgiMR5bcsMAmNaxYqRIHUk9TXWpl/+Wtcij5bhaLm1fGUkf0g4hwZm2OfUD6Y4D/dasstLuDjeU+HPt2fxWA+gmDOtO/TNvsoIFeAATJGZmRRHUw5Ta6tfTxvR8/P+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737486657; c=relaxed/simple;
	bh=KzjJOKqD6Z+N/+NcTSTo3EQgTIbfpaHF7KpnKlddH68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LdCpYRSvdOVHC/Vs+zwM29Zv2e4CQdsRZ3tVDiBx8OnMw8s33VsCxjUZxCAm3qFdm5U1IoSTjGviJQtc5d8MbDZu7lj/fnj/euTfSTs64MGwNpIFr+3O1dWyPBl7wXmdL7AUzqVTUTjxdgZijqwNgC4FsG5k2wJgyk3IPATgC54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+SFH1Fm; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+SFH1Fm"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21675fd60feso127514785ad.2
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 11:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737486656; x=1738091456; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=W1pNuIjqzZ840SRosQJ4eln3MiNEBVKPiikiM0W+82E=;
        b=f+SFH1FmOIHpu4XWhixp0oq2XXRNah264iEgbURqn4X9X9IypeGDeNK73ew0YKmdx7
         H20v+sIxxxBAlQRD/D4U/bXCuXem91nWyrr1n4ylkba2RcecH/XROty7JseLylB17QlT
         qyKWOv+s4Ep+pw7S23gJp7uNqkAsCXeQ68lOfG9f5+jWjeiVhst4wfL+AjbUwYq3gAx5
         gOCGEQHDF0JF3CYsLTzrZ03ThW6uOeOFLx8GJlWtFJbG5EsstfL8BohDG2qzpB5DmOKe
         mqVg2KLTpZQEtpPJZdax/8uon6r6n/UrjfxIxcxr2ft6O2KsVOoHJYd91drb6LEMvKKv
         2dfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737486656; x=1738091456;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1pNuIjqzZ840SRosQJ4eln3MiNEBVKPiikiM0W+82E=;
        b=d0l4AvLYtS8pWZo2EPsoRhkKKeQUFdw+IlyUoIcsari7HRYPOlVvwqTZwL820lp98y
         7bIGxyFAyx4Jt4I4FQFD3IoxUtsuQ0SNcRoakyLjLYw6unolxohwe0o7/yVb1L7Tdzj8
         4yaN/sKPVAEk16sJPO/50A+Oy08ozHZWWExeezXbgNaHlaMKrNscv+T5p7cx723wxcCn
         07wO1gr333xlX5wq/3JI1I+qWKgjx2VSTojRZ44dlwqrj6+44qoNCRnCsm915JKFLoZ2
         OKHdFQTWXOPVPQnC2JSqIFFFikmda2w8aHjTVTQZTCz9aLx5uRc63MXBYIm0hYKdWCtp
         pnsQ==
X-Gm-Message-State: AOJu0Yz3pqnU+3t1ephs+YfuPHJCIT6GFe8yC/Z8r/H3isjR9l6DsypR
	JcKaJ1+37QvhUm3QqrWAfE545a6sT66+MuRvKI3YHRzfKT13kZqx
X-Gm-Gg: ASbGncuqbf9kqNpZUJVFr6LBuytMtioAJHOXHlI3lS5fkGJr+wkxP2a9mxXb1ksSG5z
	Ip2LgwJduL5A36KgRicFto9pCF99BJ9bQJlT3Y+6w4/NNS4oSm+l9bUU2k8uiaMvwyDQwGmVB0x
	0G37VtFBp2zEyLdG5fwxuyflc86Zd1jj8MZVh9tJ7ttTKVq4gvtICP96TB7jgbPJDfPM3SL06SD
	W3Id/vmphy2dzTEWMpOzMvFtvJaqiiELWsdW0rK5/CvUuyeVDbYo4MyfmMvOMJeUZ/a7i9Jx6st
	uhVI8lJ8OXTVD2leXHcqnQ==
X-Google-Smtp-Source: AGHT+IGl2mLddNxf4fSK7pUAMOrNxLri2edA7Xg7UvDmuU1p1Xi0yyK3QEn8Y3UxUnuW9nnfzgByNQ==
X-Received: by 2002:a05:6a20:6a0a:b0:1e0:c5d2:f215 with SMTP id adf61e73a8af0-1eb2147ea3amr25676718637.12.1737486655734;
        Tue, 21 Jan 2025 11:10:55 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bcaa3a964sm7897244a12.3.2025.01.21.11.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 11:10:55 -0800 (PST)
Message-ID: <a0bac38f-e7b6-4532-b2f0-9435e82b3253@gmail.com>
Date: Tue, 21 Jan 2025 11:10:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/122] 6.12.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174532.991109301@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/25 09:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
