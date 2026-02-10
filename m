Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A9B32AAB4
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 17:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770744100; cv=none; b=LN10PFpODC1vYmUqYgXpp8n4o/4WG477KrVYANjBQoqzjRAXDQF3Iprnz4ZsyHVCZAsj9L4M6zuAr2CEnNMo/Ld7D/vBak4UFWWgzo7mE8Lez7oitBqvI4qUvvm8hA24wxX41b215rTruJ8lzSyf/ItFwAG7BA40dBFmMTSFQcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770744100; c=relaxed/simple;
	bh=Fchyxwe1YCStwrCTGj0/89DFgWyZkWddoy+Il0hGT90=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=bjMouHFAvsFqMQNfDTSbFwrXxlevbsTgUhNjnOgvhwwV9J+3rqJT1F5J76TBLBc/orf5/NNpdaA51gydE7zhh4RphRMRVVrOP86R8PDV6KSPIhn7jkkn/Z5AZ7DYkrFdZPV+y6PugH/spcrjjfnrU6hqugf49mLH2ARjKf1Kmh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRZ3yzuJ; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRZ3yzuJ"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b785801c93so10676324eec.0
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 09:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770744099; x=1771348899; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tnmAkUpXUH0Ee5kDeEWiVscqxpkfBtmb3REZzA8njk8=;
        b=lRZ3yzuJ56Xk7T3GFK7hmW2sIlq2rKbJJ9gF3HpEKBhE3gefoJmE8iYbyb3ObdOwj0
         DAid1E846krorMmTxPV8U2axs0BkQXZfKFH0S0IEpglcwZ4IkMt/NqGhvmRdFEBCjKyn
         QLYCAela7sOTe7LTiCBfd+dxd0k0VRwwpCniRIXsoYsK6eEzFGXc6cz7kEV4C9HcOoik
         XkYCi9GcMHd1rhWQTJtxgF110x+/PpaUWgv74dOCm5/2pVCDVmQptWnRqJKNfyxpghKJ
         Qe7LffK1cO2uQmwqM5HsgzUUzrn1GicdP33jFDlV1bbIg8F4cSTpkZAVKIavPdqu1O4M
         rjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770744099; x=1771348899;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnmAkUpXUH0Ee5kDeEWiVscqxpkfBtmb3REZzA8njk8=;
        b=gsNhiUJHM/TLr+G30AGAwylA6uo1gOq3Ie8COd5HP7ISZt8TasjHz9TY7Can3YtfW4
         aXBUJurwq8a+7yju2268zzFFTtkKy/Ke9peLCR/6FB2gFAToFUZCFYMoVAuR30g0L/Ug
         +76ivnvrOyyx12awm08z4d530H0NNT/TPHzfA3MtYartAZUueAZ2dj1/EvkLr83YG/Y5
         IsYXhtGxaiPc+eG5i84YS+EAlSyiqSyLPC/4YtREjylkIpLDuR6kwKgu6DK6jrna3yjC
         VZAt7FaUOsIBOIg1ZsxW4wAFje7abdOTqWNEV7GqkW0bRIXSs0NMmZ3wuf0J54/sSLdn
         v5JQ==
X-Gm-Message-State: AOJu0YwNIf83lKEijo+z1gekpebej0NVWslSt1hqDIKWR+eWtMJvWfOv
	6bOj8uJuu53eVAumg0eePkBatOEZlPyix1SgQjsoY084xYYwLNPupsRf
X-Gm-Gg: AZuq6aJcSsYLHUxdQwga9LErd3IUxEELUH78oHObkLrW8b7jtL/e1PwzUT34bNoT8Qe
	mrH7Ku/OgXWC/gYr+PBnUP3tACCHlK0eDfFoN9cKXvmLc+84TXczJUpM32Ti95VHZogUyVLbTpz
	7BxAmKBi+v0nyZLRm6SKh+oUEHRZnkk54mT6Tcs7kg4Q82t5HGbAoBZlSE/qRf8rs4UFul63Een
	adOtMABXuo1mOMMkVaxdTzHlAKQxsNjxFwAgpNDoUu8NQ0t6f5/OYjCAKewslyDz94XhexRfOyk
	mb6OT38IA/pFnd6kiYSB1Thqwji9bZZOznNaMd1ll0uSBS4foC2r0kh9WHMM+jq5DFvAovQ7atC
	T3v9XdQw+ji39OWvAuqEXa8cphiOKXnrAh2vHujydJxPV+QwYv/LuTAgPIP5kZqAYNAKYCo38OM
	dT4TvEH2/wIjPZyUxdUDYzHb2k6VbSLLK55LZxOO/D35ufd7tYC+POkUnY61ji
X-Received: by 2002:a05:693c:2d8c:b0:2b7:1c58:dca6 with SMTP id 5a478bee46e88-2b85646d9c4mr8668019eec.6.1770744097312;
        Tue, 10 Feb 2026 09:21:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12717d89610sm6302360c88.16.2026.02.10.09.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 09:21:36 -0800 (PST)
Message-ID: <b461f583-bd3e-4ad5-bc4b-dbc5f014ff8b@gmail.com>
Date: Tue, 10 Feb 2026 09:21:34 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142320.474120190@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/9/2026 6:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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

