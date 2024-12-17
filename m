Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5B81EC017
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 23:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734476616; cv=none; b=u+BSMaviEChts2klvFsTjmusFNsHQxSwjIhW/4Hcvaqvhn+sWznvGu8KMy+ZYRcifsDDPekD6Ddo3VVdOuCVFuNV/C7Q7EEl1TwQLLPDTpcZXvGFjUMeplpLTnF+ZNEXp86A1Eyd10x+IuPC8XftyPxYGngQ5TPzwvJU4pyOQGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734476616; c=relaxed/simple;
	bh=LsZ1ZAGFzhLCkUumArMICoun06GecZ1j6+dij9s2dZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W3iSpODqHLP0FQULphnpZ4amBXL4iyaIG9SRoDSSPpNLxlaCGW+hxR9P1+99Zxxi5YuaRWJCJNW2Q0ZWWKFM2NR52R+5RcK4Pb3QvbX0uWZAvlz3DWF5bnXFJG4GQHvasJK/fKtnED19Q+CwTw7oku8lWQhDCiQjOBG5I7Gd/Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMmB6YbG; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMmB6YbG"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844ef6275c5so144381539f.0
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 15:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734476613; x=1735081413; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P0mtT107iSHWzSANuPu2CjAzaWYVw9mVugeiQeIiH7w=;
        b=GMmB6YbG1Hs/BAZnLp8otuDDytaNCCRZ+XHDLt2eM+08RCPqisbUS/zjnbKjvTdj/9
         eCzrYUzO239Kg/rOwfXjRt+H7ggr+6y0oJQQAvbT2vGm4C7qoNGrjEA+gHZSuzNyY0B2
         jBxkwXmKJnuWIOtqT5X9jqE7UOogY857ji8GA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734476613; x=1735081413;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0mtT107iSHWzSANuPu2CjAzaWYVw9mVugeiQeIiH7w=;
        b=E8cZy5C0f/XhmLeGU72lDrOVsj6mE+vYf7JztpQDc8Y7qjxvGOR0NIcTbFOfVRkhPi
         w5UIuyubT4+8acfjCBzRRyC8E1HlGfYTWiHj65plSuuphZpwJZRjRK9XE9ma3luw7F1/
         nFQbDpyZPuAjfV2gDJ59/kCG+P0jTo1YzHrnXSfvplTc2f6cel+5Cb/OfPeSyDorcTUT
         lA0q+Ofsn/O+VB5lIlsJzoSD0NvIvmZbmAbsJc6ItG/+QfcOFOPRViO4f35UHy8c1PzD
         2esI1KtIyWPqJyhGPb2LjwEQIsqvkf23GC5Ntv/FqXeVD7nPIWoLHt1C1jAiz7oL/8Ni
         Xq7g==
X-Gm-Message-State: AOJu0Yycvgx3cVNFbhs9U6z2PCEET1vdEa0Qe6PGtWl3MP2lEbHMjrEl
	5Q1buqB99F23R+/y76nXeQ4rUkUTtMrJVJUuNh1rliwm/TJeOuX+iDC9rLJletg=
X-Gm-Gg: ASbGncuYQa2TB8bovwjzCSv/oqsmlPK7rRJSIxtCOSSSz4kz1/Qr5H+6Cc9ocg0vu5f
	peV4bwIvqoBACD9VCESIoDfSG6kcQrZL6mVuj5f3AonXVZUy3QjQSpWCmbDgI8rpGWrZCw+/xrr
	vIEnXkitIzbwNx1xGIPR9RPu0IcOcOamF0mb7quoPVEt1Pqp/9IlcTlm7dBvgh9zPPlRAXz/1fS
	S7/Hvx1nnlxsrb/cgWqccjcfAJR8fDR7GUsHIPpyxdRonlYwcBFlTGNoBcTUOZQtYqD
X-Google-Smtp-Source: AGHT+IFbiQG2jydmVYuqIJ9wUCpDmlOF6LOcO1cH5JFWnd6a/BVjSfS+sjBumA2syMJeOaIemZj88Q==
X-Received: by 2002:a05:6602:15cd:b0:844:bd90:d45c with SMTP id ca18e2360f4ac-847586073dbmr57522239f.13.1734476613537;
        Tue, 17 Dec 2024 15:03:33 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e378242asm1909129173.128.2024.12.17.15.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 15:03:33 -0800 (PST)
Message-ID: <607d68ea-7af8-4350-b3d4-d4ef1341dfe4@linuxfoundation.org>
Date: Tue, 17 Dec 2024 16:03:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 10:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
