Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670C762143
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707862758; cv=none; b=ecX6kxNU1BNJOiALVkrKQcKahEHkf0W5wlVNkhXQeGNjHsFyApBdXFjQERb/aONkaCRCKIsKyl1UZMbZGTXPckwCWWFHSL6GqcZvAGSswWgouENd8PUWVH3ouCSxtS5irX07/bCC1rA4kGlx67vZARTpmtV8d+bYNlp8Zlir4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707862758; c=relaxed/simple;
	bh=fTJeE/0vTi3j4ZDncZgiJFys8r51ebCtKQPYxoUm5CQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JCwSFRgN5O1OzUH3tAYOqxiMQT1kGd7Y53RX5zQ4c07NQLJ/EuomjxeNEeSpUSoX8I90FI3z7WjhVbp/Ak1luyz7O2Taif+fxEp0bqF2YjOTTh5dsrfULtEZuzf+mzm5D9XUPSUf8/E++4m4eU2ceIPSCezrET8U3bgErCK4d4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGh3GVAi; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGh3GVAi"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-785d5705681so20137685a.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 14:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707862756; x=1708467556; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HOwk/2w2eY60TLURHPvbKuNQvYKfknP+nGTPYSp2+GU=;
        b=SGh3GVAiSiq4kpZkOhpOMNY4+Xc1A8VDT8ZIbsE0XWHED0uZ0S8rBgZzFTxCeiHBb8
         K7S3LnnCZaskovTgKDMtmk4olxswXeQNBtqRlOWGNuQZUNrUu9SZzQoC6d6203ytICcI
         P0JeKZM6AglhYB1q17WtqAMSK/nuoahptMQz1bSE94o5L59jPClgBSoI2ExmyS+K7T3L
         oNzDidJu5eChL0fddrFW0Kj1n9wzdccZNHZ65iUv72ADysFgajRlk5XmyMCZMzrik/o/
         0AWmuLgtcGkz0AyqR78NdZUC+wIEElQJC4UX9E5+9WfLK4gO2/Sgtk9ippULK2OvFk9J
         tuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707862756; x=1708467556;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOwk/2w2eY60TLURHPvbKuNQvYKfknP+nGTPYSp2+GU=;
        b=o8WTbjqr/68fyyMS48V9QC/cf4L7R86lbsHtvf+QkGESng5uNWreuK4EwNST4zACil
         NjH3GhsR4ifPU42hrQueMLa3K5MBYYDxnROiLLEiuyUxRXvusjjbRpxxPOAng2LyvI7u
         SPSeLq0VJnaz4/SJYlD1SWm0Q4Uh8YrZZzP3d5R3xWGMfx8lbZ/iomFg6J/RFZ/5hyxS
         sDG9nCACAH+LqpmAbx31JnlcxjxZzzWV45k5XIGnXu7Q8m1BlMFyJI4iYbPOmOf7+639
         QYHx2pD9rcVvEY2uhdu6ZIFO35kXm5G7Mg8fi0wjGxPwvI3MyArvAqglC1VBFC2f67TU
         DLgA==
X-Gm-Message-State: AOJu0Yx4kGIiJoo4yczi+uvBBUpFM4ryAlnSOCxJvbWvl3dgG4ow5p4T
	WRq7npRRI4L9hgcrK47vOjaRx/PxrX+Yg9fxvnXIuwWTvxO14UPU
X-Google-Smtp-Source: AGHT+IHGHrykYSlNOyjcS/UZ6V4dNHsB1WQ6ZHMxk3R/TLseCIBbsBNj5CZuJv4DpukvlbxrMZDZEw==
X-Received: by 2002:a05:620a:9c6:b0:787:18b5:f56b with SMTP id y6-20020a05620a09c600b0078718b5f56bmr305955qky.34.1707862756217;
        Tue, 13 Feb 2024 14:19:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUQWEXelBgT9oVykeo4eUb5AO+sFg5/aRwKxasJIC9ql0n+08RV5wwSQteDqeZJKuXvu3Qg3T0TmXGKycuzb+o8bpeTeeojh9w7381pktWRSaj1hidZhDJErIils6+ExmR4BJtsD5Hzt4u+jQtqx20JjbsfcFlGZz3koKLI7snxS71tg7Ej+4jgR3FZQyjxxgaWY15Lcv9zbN4mH3T9YbKyDUdGYLLWL6XuBMdu3OXRv+AdgErqK4pPcmyFHF/DqEnofsRC9mzsC0lh2xCYJw5iW41d6ZNbYgEthTtPZgzbWcbMC09ZVYPP7IwKrytZ01exUluV5pvs4Oe0yFpoJAFV5JCgfiNi8zhqIN794NRF8pNWwnZPWfPbkj70f3XvlgrJRAanyAqQehNmZ3DjZh+t5wjXgq+ykRAjcaGk6Tc89LIUQhLMt69STQ8v22/7qJgSQW435DXaYzMEQ0ds59IRxQXeUPH5kwNyQBqS4SrAuh/2NQ0Rxm5SkqOJiZIzRJJilhlxiR+g
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9-20020a05620a166900b00783f1e600aasm3282430qko.38.2024.02.13.14.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 14:19:15 -0800 (PST)
Message-ID: <ff048126-fc13-46d5-a77d-d7ccd21578fc@gmail.com>
Date: Tue, 13 Feb 2024 14:19:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/124] 6.7.5-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240213171853.722912593@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

