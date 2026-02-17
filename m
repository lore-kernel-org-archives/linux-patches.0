Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BBF28D8FD
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 23:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771369467; cv=none; b=OPOA/rVOw14YzzSTmdygB9v1GlZfFtVqB4I4F7rGlqGA8uULMEG2pTYfGKIGGJixbnJZyMKjNPRE9WEs53UMW09+7FYohuUbUgnGHUW81dk7S8ndpEQPOf0jZs77HwtdGqT1HvCWp4UZk2VHv6G04YClcgOGqgqGAyAGTd00y8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771369467; c=relaxed/simple;
	bh=a2X0Mwt7EactACqp9o7cLtVT5VaeguI6k4gKiX1yZ64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kT3k+7oU0qquWmcFWWQYS5tW9WSm7hitsC0v83y+iFYotSJ5bZLika5Iz500Tu5TzJc35/Usi2EyU6y0vZSjLosKQMFxs5vVapjtUBd66R6nT9us59SJRE8HJsQCB9XgfmLm5Ok4omToJii4oPPzH1wAbylb9y/iEdfJdRBJpjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHtVHVSu; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHtVHVSu"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb4081e82aso606810285a.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 15:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771369465; x=1771974265; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kwwSX812i60Q6VmHMvgcgevCWAvi1urqgBHszEXADxg=;
        b=KHtVHVSus7jo1F5Hmtffgk3ihnkdp8QPIWWt6HDKbmkEREoPlgQstYJMMIGe03h4mf
         kHZtCj7KKyRhkAXxwKPxeOO9wh52SVWfA2vTDjGyk6IrMfShuutPomQiT6yTxnsF9Mmq
         xtzumEC2+QSchntFo32+y9NSLXXEunU57nygT7qTGA+SC60UVXjRB1yDJpB8uvZdxjrS
         mYvKYNN6+QUeFnEPYC3j383moxEvXnRzWpzaI0bc1noigK8TEDUQ0R7GJJAs+pB4fXnX
         +vHiBXQdPTHLDDZ8JcxX0lup3/uQqd0PHTMnWzxYPp2WByzx0h0BT7qUyNeas79j3Lcd
         Iowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771369465; x=1771974265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kwwSX812i60Q6VmHMvgcgevCWAvi1urqgBHszEXADxg=;
        b=E7dVgf1mii5ukGTpgsSAlfRzVvsBUMwdwnrV4sW7d8VtnrF8qpRFodWdBwKLH0OYSJ
         tPB+sYO2MgoWgVGJij4bCNx4p4Xi331GmEoSMwkt3x5mwAsIgn68D+nAYm78x+P8mAX7
         eEpW9MzYSqMKMUEumhfFRMMTJESUbhSjh3IqBpdLus6g8PUDSOC8jMlpON1ypo1mIhbR
         sCH/IKI1akjnc/psoPUmCxv3jNPtDT/Dc7Xvbdzwq35TXeIJkHD8i9jbCCvyu4PSI00v
         1MXkHLVhFBhAYcyon/98RZSOgui6+vInIiRuxQs1PHWQIFfPEcOF65GXZIc074pZOuKm
         XXrw==
X-Gm-Message-State: AOJu0Yzhamxzod38z+cqCRRA3pE3c6mGOl5wGuyXmJ2Y9FRFAjPJtr9v
	tTVe/E6bXHBMZmnU+d/DnQYYs9dpjvOaBSTMVxuf60lN7cTtoqsfcVIL
X-Gm-Gg: AZuq6aJ8k6iHfstfdPEcFiP7H/8KXfcb4/wBaGgMxrLa8OcrHKFoKkG+ayEddJzCkiK
	vq8omohVlAcpfwGvDJz3pcLLtWzIZEctYmQpi44Q6aPWRPjsZMRPJTxcBKNcXixrCMhrzeYvpJu
	SsVcteSbCbHghbQhzOPUUz26WhypyfHew9m9CVOQHuCJVVoVwGvv7zrzjjirz8gkLl521BownfR
	I4LcQtnK5uJSV2KtQ275Dq/3LzgkkkXXNGySrOTp7PI2EiOCoUKdyRsSnYBEwvbU6T9YcPgyj0p
	IGS6ktOPhi6K4FqfZ/jZ3+ceHYhyJEB7/vfLkkX1jMvGkSrh2VC9h/whSJjRJMh5KaFVOINT51g
	N77jpTunubrLCbNcIk4/k0Z9/ugit2rfVtecy3dIOqiI5wdIx9EVQck6KWXiRe2i3LEh/tEHpPw
	0iBfCLo11RKdjbwdFrZuFdcu7YWBSjyD5YZFZ03qn4WWKzKXxMzA==
X-Received: by 2002:a05:620a:46a7:b0:8b8:dd7f:f032 with SMTP id af79cd13be357-8cb4c017d66mr1539387185a.78.1771369465302;
        Tue, 17 Feb 2026 15:04:25 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb4ad01f0fsm1036356385a.39.2026.02.17.15.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 15:04:24 -0800 (PST)
Message-ID: <da1fcb21-7ccf-433e-8674-88a35b50f617@gmail.com>
Date: Tue, 17 Feb 2026 15:04:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200006.470920131@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.13-rc1.gz
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
