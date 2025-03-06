Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9780520F089
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276474; cv=none; b=FNCHkTVhSCc1PvjEw66RBAc+rfsa5pAjMP1rv4UBYPS8ZYzK/vb+eMuPG1pulWzzO4fkutcBG3EFCAkiAiSBntZEyZXdz9uq6EJm0R8D6FZiO1MtRP+eZVJHOecVSrT+Rov6DSDmfbN2/oOl4fO24NTzR1RhomUgJ4PE1Ij0crM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276474; c=relaxed/simple;
	bh=Y8K5cESscjaF6rF5kbITcV9M+zFFDeiGbZwejQ8hVoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bO69LRrwFy+yX3kzYGmB/7a3yt+JFfm3VLT2nRXbYBVIsH9JwbCuhovlL3K3uLevUVyz3IPEuZoSh+PxlNTE1Q6jmYJlEo3owt/k/NgJJ/6WYgAexSg8TF9Z1kCn/H1j8H0gmwwXASCgs1cK5E3Bsixd39VwALAxjlWKbgFqjO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KP4+DjS8; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KP4+DjS8"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85ae65ba2f1so21717139f.3
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 07:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741276471; x=1741881271; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvOdZWrfaIf7exFCH9L/y4MUUS5qf5A06Ts9Vfm5eLw=;
        b=KP4+DjS8bg1ARO9BhG7sHnhtiLkWAqNI4X/F2aooHpSyX/phYqc5wMjACjPDMhVy/B
         goV7FDZyeNLW69CI7OIcrtwitfKwV36MHzVe5D9sqnHfSdzA947fYyfdHZWRZQusn7fg
         0i45TRYp267Q1MJAUEW4kFBf178L/Rh/ibATM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741276471; x=1741881271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvOdZWrfaIf7exFCH9L/y4MUUS5qf5A06Ts9Vfm5eLw=;
        b=jaU4Vzt5A2+LiiO8//gO5U1mIreYdmn30B6kFbUh3pX+t4lm42+VmFEhZMXtqFcIQi
         yvFhFuvF3CZy9iLB1WF8sevK31KsqbJcabSg9TaUbtuLUPF3OUsbdAfwqJiyRgr/mrUq
         PC6wBQORq7riYVFr2MN9TLRa1LpsDiek7lZ5fpxcPL4u989U9bofNTxXE7Sk9pBKiYMd
         muKXYlvx0BHT6huEDN24kSlI9ItvZh0aOo88Y4cg5XEqZUXd3S4/NGWpcXWF8PN69amA
         Bjs1IFeBN+axhA/+xDJJu1M/WSZi66vk3mj3Bm3R5sMtyBD99YPRtY5IOxpwFCJAT+Rl
         6rew==
X-Gm-Message-State: AOJu0YyyGNQ44PkWsip1Igh7S5dhwhtU0/z1GPYa70pU9vA+EZfgRNbl
	akaEBk87c4Id0FmxW8KeuZidmx7le91H3svVzXHUaD0TCorLus3HEY/gwJxai4k=
X-Gm-Gg: ASbGncuH25wV2KTaLjW5GRZR93/d/bRu05FuJ+UCT9CZvnsCm+iWh0bG+BZ8+PmFaCC
	mAp6bIyVjdB1dAYe6TX8TwddcH6dummKsi0A+Dx906glQwnBZ0r9OgiLF6iWrnhU/wfBTgqz2iq
	lEaEqBxNdzpk+fWArrP3anuipTM1PRXlhlE+wwdE0ZCB+6f7n+wK042QKyUhaAR+qiXez3oFMF7
	MRHl4w/+tL1rqVFbaAAY8Pp2d5QuWHMjxOzXRj5Pfr+9fM0em8iwiEaRw5pHrY+HeHuykCx9Kvh
	Py5lcsoSTmePlYSzXYK498nhaliWkQ7fhl+wj6UEG3d2nTFU4lvmaBs=
X-Google-Smtp-Source: AGHT+IHLDBt53t7ndm1iVGlgIfmFiG3NsTwS5qxb6ssEp7txk9g51NwIcfyHhH9X4AvTQef18vir2w==
X-Received: by 2002:a05:6e02:144a:b0:3d1:79a1:5b85 with SMTP id e9e14a558f8ab-3d42b9a3c18mr86895115ab.21.1741276470750;
        Thu, 06 Mar 2025 07:54:30 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209e15550sm398211173.39.2025.03.06.07.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 07:54:30 -0800 (PST)
Message-ID: <11011f63-e614-4a23-8d9e-7aa1387ec65b@linuxfoundation.org>
Date: Thu, 6 Mar 2025 08:54:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 10:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
