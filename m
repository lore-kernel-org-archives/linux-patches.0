Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D852F549F
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783604423; cv=none; b=gmndzM9pUSvG3gPTsDw79cF8qc9Q5dRu7uGQGcVs4Ivi9l7H1rzYSeNn03emePBnGFWL2whVP+y+lcYSWrf1DHqa4ncFcdxUBddeTws5zUzE1Q5aNticQOCrn0cQaL1vMkIi7mIMVkY6sfL+PHvh23PU+DSr+4Iakwc9qclSXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783604423; c=relaxed/simple;
	bh=QXagd0Uz7fZfcdhazpgZGPt/2+NclByuQtbv82lvBt8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ff8j9so4DxnlFq+8lbR2xdsT31ltdivbVfd9WKB+c3S0LZjstRmQJChQLP3fbECIcnlswpyTlRYaLr/Bqu32pUnUNwxtWgRLrWkUZPPLTOpwABhASebqwQXY28flMJBEanQyuDI7lOedKMWFz71+UZiooDmYC5ptLmHW2sfsCK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y/ZNjZZx; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/ZNjZZx"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c5220cb7so15005675e9.3
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783604416; x=1784209216; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hO6rFDb2GEle/din1RNG5/7y3MiX9cRgUxR9gEATaPw=;
        b=Y/ZNjZZx/gWbtEQ7uh+KjtPh/NR5w18eLUYgifzHToPIn4l9jHYw0LZL3NIyIvH8jE
         HRL/5zNwOPCyDNp6/POAzUDD0/GKY1G6aTUGluu/wLceSrgbcrD6fUm/yRe6z26VSlNR
         8jBXw7M6onSyfeRPLUlpKcDPX5SDoxvqwwBMvu4Dful1o86DrChxk83EiuyM6FoaYKqe
         i5xOI8b+VROQjva6qvYEhVpW8E9ltiDdppu0MmqDf7dNWouBpUAaNvi6QA72osjo/Cse
         2CehhAMUNMi0Q5TR9fb0VFgJXA0cD+IAldnSHOKz9RXbTn9/U8A1Yc02eAhiOSRX5nnc
         5zwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783604416; x=1784209216;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hO6rFDb2GEle/din1RNG5/7y3MiX9cRgUxR9gEATaPw=;
        b=hbhTkxgP/d1Ld5qBV0Wx9WcvA+yBCLwDaA1+P2QwXK0201yCGvOt5lGaxoSzDXoUMw
         UD49xgx4hUnh7s8r+wpLsAiwBPMnxSAsTTHG43oJUdNxPHscW45CdhRpCNhwl2qA6aeW
         g0+6hMGkZyxrgnjVuHaXpYIIdvaqxPWB8wHDV4caapSBAJ1EFfZvLgqJ9fHjaxNeAA+j
         ptAUk4M/dzv2KbjaDMAp9yvDRSZvGe3ZHjy3RIk8AEj1DIJJ03hjxcz7rZhuad7WAV+y
         kkXkkoVQabaWowjTiN9aKCOnhK+2CAEnh8TY1lQLxuepI4AJUFUhKTmHhDelzOVcVufl
         I3Bw==
X-Gm-Message-State: AOJu0YzZJFrFN9zx3z/5olYj+5+cDtXISGzDwD4eF8Z1ORtF1BB7OTzq
	iCHJCvu7QppTGSC3kadgCvUOl/Ul6Sgn+0YFzLt7Ge32ItpxAFZ1gQj6jpusAz+b
X-Gm-Gg: AfdE7clfzVBDQs754ogKKMIDtJ+Puusy1SvBQCUXzmUrn51Q53otQPiY+OcLKUWSO/m
	smkCNWegEwWvPcyJTPqo9Av3C/o17WtmFwSB3FRif5WgUABBdJcC6vOon1HWHIewaIcYC45P15S
	epNtT+fwTlXO0uZvFVhPniSqk11tkD5xEDE5o57D0A2TD2KvTVUnkMUYYODnAbuPTmCsp/syxPX
	BIemVXPMu0Gop98Nx0LfT4wRWH9Up2KYvOXzqmCsJtVU7A0vxRj1Deu3JHxNG0stpsHgW0RJtTP
	3ayTgFLoWuuyY6w1/bbBL7i1QTh/8CR0fn5WqeGWaqJ3WWu+RXrJZeoCMIEkH31xTnz4LfD/hEY
	1dVyH7FWz4nIqZ3yP0wUWmAlkC25lRxhZ1zrMbyk2UdoMDpkcqp/CtJUQgaxbVQ2RxUPjH2/t7Z
	k45ha9FeMQiIYiZYs08/evFSxRjS5fiURgFeMCv7c1VjGMxxbM9E7GJo441FiHCA==
X-Received: by 2002:a05:600c:8b17:b0:493:e6f7:ad75 with SMTP id 5b1f17b1804b1-493e6f7afb1mr67726295e9.11.1783604416401;
        Thu, 09 Jul 2026 06:40:16 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb70a372sm62769235e9.7.2026.07.09.06.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 06:40:15 -0700 (PDT)
Message-ID: <b2a52387-32b1-4a4a-9cc9-c3ec83a313b5@gmail.com>
Date: Thu, 9 Jul 2026 15:40:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260703072825.068705122@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/3/2026 9:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.95-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, please backport 
7ee7f48413c42b90230de4a8e40898b757bc8e82 ("perf trace beauty fcntl: Fix 
build with older kernel headers") for the MIPS build of "perf" to pass.

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

