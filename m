Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52972798E8
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 23:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771370162; cv=none; b=niQVl9HZAWRncjUYKhu74LqnVlHurFXSGtIaHby1n15csuWr9L2Wo/8tM17Ccj2qrQ8+xwDar/8Llt/qbgmyXt6UejUYFwEcqKwoOPPEfdJci1EHem7U3hxc1URo4wz5mCfnha73HCFF3ZpwL8U7dRru368a5sc2kWmJNjaI3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771370162; c=relaxed/simple;
	bh=1PD739t4ZS0LVSBx19VywvEm0CBVJ9CSO2WxAAT3dNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2SiLP7D8cIfWsBDpMfO36UMFXBvXkUdumUCluc4HjTHLyxJRHfvHz+wIC5gSSArYgWKAThJx6N35XMMwX22l9kka9+DmmgWU5+ns9qMDli27UrQtytd4P0jcddv0ZJ7SMgq38yEunj1vkqjcaMSHU83p0Z0UPcIoiHE22T7aig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9HtvCE8; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9HtvCE8"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2ba88e53b46so198658eec.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 15:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771370161; x=1771974961; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pcMrv+r41UeNiqyFo02w1fzNFCK6uftWPvZvbC+3wM=;
        b=a9HtvCE8be12/4gnRJY13oIy+DXKIzMcdCRNJJ4P/wt1npni0pE2x/Ge9et3bTGOVj
         HR8ILZWFpTkhyQTlnL9jvV7cDiz0mHMwNYAeA+ntuvZs4nyG90yP2gcnMfW9lekIM4RY
         qyEeSdTmzz0PWjeGtwmK1XaZVMpPIVipbvC0jkyK5UkdibQosX2u86eLYU1fcFpde5PS
         peVCsuXpmqGELfyGsINPHn/6W1YDzlS9fuKHSFlHQZRZoens3GKqFKf5dCBzMAfsHCbk
         qOAfXsbaSoRLyLmgvYRte6OeMJCCNWxmwCLIDY9/yJL3X59qfa0GNO4/IV6vJWQd/DF3
         ky4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771370161; x=1771974961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0pcMrv+r41UeNiqyFo02w1fzNFCK6uftWPvZvbC+3wM=;
        b=h7qMV6AOB8GHYckXbh+WU9WJ3mfdqgxcMFYrAG90AxHYeRaNde69kOY+ZIWVcQPgCv
         HFJUQUYNieSXDKEcH3K/O/EV0lqz/wV9TplJ3N+vKQQEMuOtWIqn0+K7IP3MfujKW6Wa
         lmmJMIWi/GntE7obPPD/UY8CE6yVPXLk09MwYseV7Th6HhQVs0FSUamfzBb+nQ5fyM3a
         6q+ejMdOkSNt/+9cQ2SlTs0CLRj2njExod1r0KfRd05ECkTVqYzYzT03sgfRkd2ruVy/
         CmQaRC8EjY/4XmeZUJ+VwPuAlgonxBuDf1qRFvDUeKKOZp8wErRzzC1yVEHUySalhuUf
         KPiQ==
X-Gm-Message-State: AOJu0YwjSCoMNs9f50Y+nTGC+fwU8tIJfL+T0e/L/sEQqrcQKCC42PTj
	YI6t33bt6a8hjU8yJiz9eyPzCHmF724sKbB3kWBrKTPlKtp4g5v+UH8d
X-Gm-Gg: AZuq6aJZonDRT5dJbC7AGZRTtQSJMOsEGf2ToeRJtAubOpMmcQua6Z5E634dT+vsorO
	RuABQut9nHvANSCMVapIuu61AB0T8slPYW8n4CleqoO3X6Ssh6c4mez4fi9jZmeDa54QekWn46z
	CjF3xMpGvyBCiyMMZUj+dCZhBlSf0OEouqUKhNKdq0UWBfv029X1XZI1iNfIE7dpKM07jTHBz4A
	uTwx31UXxVgrz/WRyFuiQeKduHulvLzNk7ThNyv0AH5Y0dmvm5EA2p6BF8Ef2DLhxcAQXOf0MjV
	sb+BBRgwwv6RLH39IMrI9omxsqiabltiSTTyB/Pdl/MkzJgl4T690unW4zSTws1FRpo44VhXclX
	baSsiJ0XJW+39CPuaXInKIygY/DV3vBdH+C+5BXh/HJyyScarEflpg+PhiXj+s8lhudapLSMPbR
	q/VXzRRDfgZAN6JtKWilbCcbgyrhM0GxRfCHRJlRdEmLR8cjBo9jWgyHchd38p
X-Received: by 2002:a05:7301:4192:b0:2ba:974c:4954 with SMTP id 5a478bee46e88-2bd50a048e1mr23850eec.11.1771370160555;
        Tue, 17 Feb 2026 15:16:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb577bcasm15836517eec.12.2026.02.17.15.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 15:16:00 -0800 (PST)
Message-ID: <f57a47a0-3c87-43e5-bbd2-3f9567d11e1a@gmail.com>
Date: Tue, 17 Feb 2026 15:15:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200002.683975158@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
