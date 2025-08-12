Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F071E274B29
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755033223; cv=none; b=CvXwv7uJywqu8SloiGnHX8f2ZQ23Dn9B15pH6CA4IEYIQ0KaIFXApHdIwOLcGO0IwCMF/npOLul/iXIhvT1uDZGnOlaj73igufLE/hWNZQ8lwsIotV/GbQLq1O+qgwEP/XdjRwOTnpi07wtsFbBws6RHUsETJKYCjKbMpKmHOQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755033223; c=relaxed/simple;
	bh=89HORkpnLHhTglgmgflGAu9nmJZk/C8g3RYgN5/yEMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=chrrGyyDtfLA5KEYPFJ0IlwW/KFPKWcIfinojsyA/CJNKFqAOShsxfUCkAYIlyGuDq+fJpioRc8nqSwE3zxcEWz5Q2lYNZcm0X7EMPJ/A1g5DcPFdYYPS8ygjyWyLLyLkeWFzUh1l0n9BCKvXits7DrHThSr7Z+KpzGqUbdjTXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpWbJAoV; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpWbJAoV"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-61998205433so2498412eaf.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 14:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755033221; x=1755638021; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kw/KFo/LHx26cL0RFRltD6D4t8qDEavgai3uT6U0q6k=;
        b=fpWbJAoVGKxP+DeKiOmKT4TDcIKYaq7mJuxRXztHoeimMwxL6eY6DCpaWchPn+KIcG
         xWa5pVavFBqu/qnTG/zp7iV8qnIAYBoxh04pOGIzwcrqV+dwLxhzWiTVkCdM5YJnQM51
         rwt9cLft5oVpqkFfqTAZaou8BqqgypzbKWGMPA0BTwSrSlM3ESVa0Ju2+2x7VE3oy7fE
         e18nB2YYBDPZT2pDwtYfgqvsjLFhnQ0+CPh2tzstWcbZqaDNlWRA5lt14CdQAuak2LOI
         D5Xztd/9iZK4B5NVA/QgOC7ecNoDSL742wWDisjP/jk/Pm+rDyxyLLlsYh5T80zrPxF4
         iRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755033221; x=1755638021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kw/KFo/LHx26cL0RFRltD6D4t8qDEavgai3uT6U0q6k=;
        b=riGFfbDpYYNeJSQbe9QfRPpDwayVDY2/Oel1TZMxIBVWDvaNTBwxucnMXj+/00Nct2
         NUvNGX9p1pMLSWueB1fzpHFDgcPdgFTM0bOVjnBxtgSLgSApzKZhbHXLsnyDxdBk6/M+
         16Ojkm67Zx+QwPjknaDOAT/k99bWMF58DlJOJWuqAr27V7U3scG8+qRYTunSsSI+qGiP
         Lkmg5qHfOrLI1y6lIa7BMenNm4hfQKFsGFJhbGN8QqStMZly92z7tFazW1wnxV89h0+Y
         GWiWwSS7aduwcbwIweFLIbxmlS+bnSbRKQCgDmb8JX+LPmYvg8JSfj1ejiyMMP1Tw8R9
         lb9g==
X-Gm-Message-State: AOJu0YwmqVDzwWeFN0rIt85OmlWLG7I+gHg5SyysdZ4dLxfoctBMzvjv
	+tOOx8sBuAKh1fnq0exv4IWz2bR6bs86SHGe4KwBJ2gzXfLWbPhLzTO5
X-Gm-Gg: ASbGncsv5FpOoUXbKn/Z6B4MOOw3PCt2FSaWKYZlM4EUORY5i6xbqV/GmzM1PW4nPWV
	yVxCITJAQYh661qtMwOwuTDySfk0oB07Wika1ji/P50RO1bicd4lMVkknGYGAJ59acAPrygHbnY
	zL55IVkO0WSnX5e31SENBXLPt1QY/G9WPO/tPtQWnWf/CvTCjwUGeB+jvt9PtqkCRBklxxCP5OT
	HdI4oxozUf7DduXgZBsT3u/fBiXW0vArddWDcdGPDQZbaSylSA2AJ9r1O745HHswyJ7q7Kjchqm
	fJFf6212QkjgXe34vDszzw0+lo1iW+l1bSMCxDpccIpCutPsu0sn8wlSW1C2qWANEdAiVxpbp8y
	3f5xUff7ThLBUz4X3XaQ+O9X2rXWX9x4ALVFP/QZ8MORL
X-Google-Smtp-Source: AGHT+IEzkJqt8YXtZQ5APn2SJ9WpGNWkWGrefioWYVPwmQVZTE3E0t10Zwz+RfT3lsAU4t+v0ZuSVA==
X-Received: by 2002:a05:6808:5192:b0:434:39d7:cb11 with SMTP id 5614622812f47-435d4165486mr499491b6e.6.1755033220795;
        Tue, 12 Aug 2025 14:13:40 -0700 (PDT)
Received: from [10.236.102.133] ([108.147.189.97])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-435ce700cbfsm357925b6e.6.2025.08.12.14.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 14:13:39 -0700 (PDT)
Message-ID: <5f5bcc37-ff5c-4cc8-876a-b99e89e3e894@gmail.com>
Date: Tue, 12 Aug 2025 14:13:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250812172948.675299901@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/12/2025 10:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

