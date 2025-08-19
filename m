Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8B52D8384
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 20:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755634484; cv=none; b=ujSacdzs9sriYvfDSTOnq/+CbS3Uuc2GW+zqyEcNpcfXVAFtfoSG58S1C42Wt6PVnwDZwhWPbEmNOCBNtgxEFQnUftYSjvBb4jZOoWG+vOJss0iB2VvK1rqWd81qoDrNPsYR7iOUHFMo4yQUwF67+n5Al9cnOC/zKXqfPspCm1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755634484; c=relaxed/simple;
	bh=OolmA1E6f4UZQDmmRkd6bRhmOlCMy5rIQVXKiXzx1QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+HCw3uh09N+cnhe7HV2xwx2bj5tOeYbsVhRY2+VURs5+mPbc6Az8nWMJsGdna5kQ/2UtJ9+F6FTqkzgcqxHaMrcJ2+pdYyXJjQ5B03stPq4nD2mdALg1Qdq0bW3EVlysZYfIOibtealvZwwyySiJI9z7uY6TGbpp0qil0VENkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dn6do2s4; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dn6do2s4"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32326e2f0b3so4321502a91.2
        for <patches@lists.linux.dev>; Tue, 19 Aug 2025 13:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755634481; x=1756239281; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W73sVd+N7uqF/LudfqJGmM3/FeGy4NK1TMhJYYrn5N0=;
        b=dn6do2s4T457s5bRCn5swKtI9PajqOWDqUWYXk0QU6zZraFM+CEEuKuFywNlkN5Oh3
         +BSTuT9fIY2SVdYJUkFNrjaQgBelPnzA2DWrMPsIVkfe4wOXYPaeSjNr98Ppi2f98CsR
         Zx5qVEHzb8HKNC/dd/w39tWfXF4vwgTeDVQeF1IMwIPWCQWQ42JcPv31J6vPphwfY0VM
         J6Z2IkJhGPk5AgNA1CgwHA6TSbW5qEri1RvoGq4IZ/yv3ojZZddARG9M2hvFsGetfJ1S
         L5DADLD7iH5V7V/Ycnnq8e4sUK1fZ1vMpmVk4ZCDxjz9IFXeEtEvKMEo4Ms3hqDrCTB+
         nD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755634481; x=1756239281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W73sVd+N7uqF/LudfqJGmM3/FeGy4NK1TMhJYYrn5N0=;
        b=J4sc8w7+MfA4dcDihsBI7kiA4dpGh5n4yyGCok7i8T0ZxhI12Cr3Y/1Rg7Ef8nCyP8
         fWboIHjxRuoIXabNN3Ign1nIfRh7DwQ4gMvi71PyveLj7tnsUKSqyE15e0Fl7cabmrEB
         aywfkRcsmqLfz2QsE/z0/qLX5QfrRHkKv/NTDW7XfhbnlzRPyKikM3LBmD4mCizN1BRJ
         0pTWLmIdqiDafrCBIHEot57NS3Ln+xwj5tg7yjNYpkis82Z8EAXdDu7NOLJl/fv7/ySW
         AhFwkvcUUqGgiW+WBpwe9uRkokBo35EKIlSisP+Ua3G3pUiNqV5SsvK8mgtbgrSWBgzQ
         Mt8A==
X-Gm-Message-State: AOJu0YyBQOutni8yX6oYbaEz5UORN3KS1fPnh0EnlzuMaKx1G0j3tgQj
	bTZ7DpcejbOyz3WBIWA9ZrWK85x9PWV9tlT5uWWolDdsAfUxDwHOYRJe
X-Gm-Gg: ASbGncsDzYtKY5pNmYRQOPQVnrlbIKc6LNdwuqmo4gse74FOhtZ3PealOmWp5AYVzMs
	8LxKePHDHlNpEjFlUwRB+PxAvIUDbItCGLIfVgY3fQnZbKYgGOV6OvxaU/ydVrH/sgbhKb+JRpf
	/k1273660JZZJiEJiT4NiwTXh5K6YHGain/iGaepi8WZhL8xZEprkwZZCH+7z8TfV1dvvXX8/o/
	mlqEgYKAhAhg0KvVkH/6v3ePt5HMwZZzDFRUeQoM+X1ivxxWQG4VYUfQ72inIGpPatitm3/m7tk
	upUMoiL66Y8Irb+v5QHTvDYmQwRbH3xZpYm6bxHYOAgwxBnxwNM9lzs2O7X4TaqOJGZA1v90mcB
	jMSL/irroIUzAgtUOekiQ0Skie1y/6eNshlvjUmmfa/XE
X-Google-Smtp-Source: AGHT+IFARVu7RhkMrgt1lXl6S/Use2BcQ+zHOPhn+JhotfEN9jUN6dNrFSWcbiPHIsc8h/OOnxrBmg==
X-Received: by 2002:a17:90b:4e8b:b0:31f:210e:e34a with SMTP id 98e67ed59e1d1-324e128f8c6mr544831a91.8.1755634481199;
        Tue, 19 Aug 2025 13:14:41 -0700 (PDT)
Received: from [10.236.102.133] ([207.212.61.113])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e26259b6sm17569a91.17.2025.08.19.13.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 13:14:40 -0700 (PDT)
Message-ID: <2b2f13c2-fe4b-465f-9c83-f76be8f2f45b@gmail.com>
Date: Tue, 19 Aug 2025 13:14:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250819122820.553053307@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/19/2025 5:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.43-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <floria.fainelli@broadcom.com>
-- 
Florian

