Received: from mail-dy2-f38.google.com (mail-dy2-f38.google.com [74.125.229.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCF551EE0A
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 21:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804602; cv=none; b=Xnwwo6aZrojSoj1hyMa4EBs56J3sjKpNjb2KdCKa4ub4edljyqfv/5bwk5qCCSNFkcKNGdNa69DqVMU+dH46U8v9iG5569WwhhmQ9HtK1MyHT/fbbtrteqKpx9ji/iX8lNKZ/HEgwXdCPKk7idvVMqYKrz/x+PeyarqNph+7EhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804602; c=relaxed/simple;
	bh=bBR8nRQ8XAmNXA0T6elTngU/deKR9ybB3YQ04hMzTJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u8hCC0J83MeGm50NQz3YJcC7qomL02NrEr+nZHOQoBqcDrpKeXHTStFyj6JHb+6dNqHmA5fOrffov5+82VzrE7iQnKn6zdC162xu59zRgWhUySQaHi04b3yBAyRWyVcSlowsffp7xyP9uNlITYFT8vJ+ZIribj5sYosm/QfP1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I926pI3a; arc=none smtp.client-ip=74.125.229.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I926pI3a"
Received: by mail-dy2-f38.google.com with SMTP id 5a478bee46e88-34b14db40daso1195312eec.0
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 14:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790804600; x=1791409400; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8lkawhUgZ2z6Rbax51KT4StG2qQ9CPt6IcVwt464ZjQ=;
        b=I926pI3arNERi98AwpSYUMefgWuCOsaPc1MlF0nhbTO8GKvpvFq11pY+LVRCAu9B4U
         PI1Sb7F9R32oE3Bo1RbKAvxSP6C6YkfIBvirp/Ju4EgPbsDXVrRSixVHWVOjbNWRGS4t
         q+Qwfvq+iP+5A0YUMR/1odlAc+A/yU4cMbtWLhnrBKoJw98KMXrqeXzmWnUpj3hiSPXJ
         BklBvo4LCGzbTlS69sw2ddRiYyPAPQ0LeDfVbpcpeHjx3eXhmG9EEC/aVjuG+D7NCBQ8
         QlBa6JnpweAnlNZmDRcTmtVt+tOmLNwaUrVJxVFkfr6QNPVu1NYItoZXXN+AxDsOXvB5
         4PEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790804600; x=1791409400;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8lkawhUgZ2z6Rbax51KT4StG2qQ9CPt6IcVwt464ZjQ=;
        b=D8EgWMQYVRLXND4MnSliwv0KgTkFvMNxmWEZOdRtdcFY2jfTO5Uh+b2WDZyePOiGIP
         qdfAtyMi8FZuHePgLcDlOTAxlRILZU89BK1SyZKgzXdlM1eG7hGp0JeuPIdU8J21ms/P
         ZXW4pMkksojhN0pJRL5icTW30A5ubXd+7RdV2XiQsa4BJQox/HJ1srYpmZhYj2dG5qXL
         9+JKQvafX82s8C9qMDb1GlJ4brcILmDFQOGVNGN0xHwaql4oDEiokLwJNnKWbvmItn9r
         OtiwoutuZsVItJ0HFfvoqcZMVyWlYna6cx5Uyxo36p5nkFrx0nPnXUnwjcu7IolWfb5h
         BhWw==
X-Gm-Message-State: AFuF++k/fpB3f7Pw0gJNEFBwq59BpPxCG1hgZ16u1kr6aWfNlpfRuUnu
	5oFXZONs2NwOI3Psxu8T7DiJGaWwu62PX/cDqhqE6M7HO5iZNSMzZgRq
X-Gm-Gg: AYBFou1xMto2/B2y7gwDCcv78/qIw8cB2Ewj86hjnZ8hoc1I/caKEkEV+kDh4No1npD
	EcJfp6PfBIAAWNlEW4h+Q+W64xSCpE+jdutOS2Hzym+tO2pTtFJAcNpIARhF5S66wd+3oYGdAoA
	iYCPTgADPM/8A88uvNE+gig4jYTpBo1ra51KxVuBbGM9Jg7ZArC5gcVW+SK2KYTPzw7Zw3l2T3+
	7QsxPjzkcYWZ8C0Ubzuq2pMe250jsBM7RIEFld8bywDthlHLYKaV4eJkgupqZv84Np1MFeNft0X
	YvRkSWaILAuYtarkDX6jWUvbqoDRG/R/RBPzfTUoa5viFe1CijbUt4NAei5PhxTqG9KaU07tyzg
	vbIhWPisiZf8t38GD6dfolvEPD1UDQ6RLNqfBGiUCATxKCei1iKE6ThJ8QMUVFtmS+hCwRfDIIy
	qMqngYIIVlAl7uIYgxkmTl54H0U/hDElA3ARZ+sYcUrFwW4JfeWv4MjvdMdsA8Fugp7xVzv3/Jx
	Lw35bJ+0Qepjs+tyfyIxt+wX6N3PIDRg3uLbRA=
X-Received: by 2002:a05:701b:2914:b0:147:9ad0:cf15 with SMTP id a92af1059eb24-14dcf494d00mr686116c88.22.1790804600394;
        Wed, 30 Sep 2026 14:43:20 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14df48c45cdsm762620c88.16.2026.09.30.14.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 14:43:19 -0700 (PDT)
Message-ID: <d7429656-810d-4146-aaf4-4c6997c4f030@gmail.com>
Date: Wed, 30 Sep 2026 14:43:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1193] 6.6.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152434.301151190@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.158 release.
> There are 1193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

