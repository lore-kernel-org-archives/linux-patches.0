Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0637D2080D9
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 16:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741711492; cv=none; b=MPeNqyKFlQ0PwBxADf37pqTLarjnptAOV78to/olTmq9jgctjHZ+Ro8yTpmi7uyt6rNGhHqcvbq0hHN8AAtQZ5VnDoS/5EbBwJa695IiJnlzvOZxHyZHv4R9/3i+GUHqQGLOQIh6szI2s2SXMx3pjd/UWjWHkT45cSNaU/XZpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741711492; c=relaxed/simple;
	bh=CFlZUAocSaDCXWGn3dMPc0Nzh3K2elHq0BNPfszI2Jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=quG0V1pES9ICmcZLqbMwFEAQP9yQbUIOoKB5vOwNnUVeBu7rgYyU/VximOyxLhbUrW39V31JejwAkWLwwXjPkOenF9WkzAlyrshVxXYYFlvSuW7PBPG93e0HZ3uLkUAt5ie7UXnkT/7jVBZK41sGFfnfjsFz6lp059r2mdDX1FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV0wdWJZ; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV0wdWJZ"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85b515e4521so74715039f.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741711489; x=1742316289; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xrH+kNIJIiWCh3H6rvZdYxZUqPJqXFDTzqMH9zIOUuE=;
        b=RV0wdWJZ0B2Kh3T1hTKhRYq56BZlHZx+lrWjwDN2rSbfLbVHDXFP+b1iYYoBaUIdMJ
         ahsjN8V81XNoWT2ubbMw5jeTpJpBFlJ2BhM+Iao4ft8cZD2gDcBymWFhPf1Gh2nqGcbp
         UXsX4pV/94VzFyBT09yagIDwAJ82HA6nRUqxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741711489; x=1742316289;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xrH+kNIJIiWCh3H6rvZdYxZUqPJqXFDTzqMH9zIOUuE=;
        b=Irat9TLyMMvstQKQcYVHq5PpjhqMJ8RxBUeHDWvj2Yt0HhJ3hHSjwQzLjXQhRt3gPa
         ULLTJUgJGr+Jm6h2ClkPKmZRuwiLvBZd4gono4CY4YmQRao7wzoUJklxmvyoAE5xC0Bm
         ZSiio8m8Ho/0v4ek15NB51YvYaBCTzP97WQBDeiEYsNtszGKFaFisF6MHMtRtBrgJaSR
         pxuRxkkNi2SK7esGrLUTMWv2xae1LHcYrmW8l27by8Lq98iRqfAoiHdVp/V+0cAAJQ9s
         uJy8BNBfqH9yiJwbASatRqg97QPUFUU1j8kM4aa8xpt/X0iYEykey+JOMdcnvzAjYmuQ
         cPZQ==
X-Gm-Message-State: AOJu0Yw1J2SmQdh34y9qBXDJRoqszOfO7IongZDmhf2KV3PnV+GNiCnA
	vUlz7ctr2H1f2YNY8irBpt8WJczfcccW0lLsh+84rT6xOezY2iFWixuacj25V+Q=
X-Gm-Gg: ASbGnctS5ntpR3lsRghvM8QEi4CgBlOeiuApt5up12ZkdSH6ZhiRHvMoVSnsJnLzhCi
	MqS7ffa5t1CWmvjS6ncF8tT7zJ5ccfr+/eyb6bzHck7BVP9iELIP9kWE0+R3ksvXJE2/knoDC8i
	aNtsrnxDFkjIYmwLkU3N8Lw4w1FiDPHsnA7FsJTG/956xtQRpzyrgLCiI60zJNULihWkGE/LvaW
	vkimrrtOERGMYxKRqCHZPVhRoFZv0kVP0yEa4n9kRBaqhX5nNM2uMypX95dWRVtupSFnQ3sJjbr
	Dg9OZre7AekvHDxYacWBS3w4oBTyMbhxgdDoHyDQ6T2dWG1fF+mpX90=
X-Google-Smtp-Source: AGHT+IHrb2zFlSXoeeuX8IlI/WoFm/acPhdpIFoy6HtCqLdyW+KyMDolqqVQT4wQsO6WnDlvn4+BoQ==
X-Received: by 2002:a05:6602:3e81:b0:85b:5d92:35b4 with SMTP id ca18e2360f4ac-85b5d923763mr831411739f.3.1741711489174;
        Tue, 11 Mar 2025 09:44:49 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f225d0af78sm1882165173.17.2025.03.11.09.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 09:44:48 -0700 (PDT)
Message-ID: <df71bef3-822d-40b2-870f-ba7ada74580a@linuxfoundation.org>
Date: Tue, 11 Mar 2025 10:44:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 11:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc1.gz
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
