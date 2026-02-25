Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7BC34029E
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772041741; cv=none; b=dgjRJFEDHkeOWeTI4fZARtt6y7r1msS/wPuRns+X6R1XUpdynZPsWl6JGCZTf0mL9QGL8okfSPBP89GUH2t4ks8kOPoB4LeswNchnWXt6/fi/vB3dynpRo6rgIl/m6qRJs5QY85Bqt43mIeyBjhBBXVxtxcSHE9KDgSQ42N6OPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772041741; c=relaxed/simple;
	bh=LZxpww8qtNfmNYjyTXg4wiB+YYp7xy2/ZaBoEhlwrIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JbR+d8eolxDu5H7qoCx7+TsB64E13zNd9P51H1F4WRM+YcA8aEGNXy5xB55RR1VKm7Jr9aLx1MU0GCiIlf9l3uSgY5TaiYNp8eGpSdjwDXf+9FA47CQCrWidlLfktV61tYYMEU7Tx6V6bvl+56uayAZ8FDJ1E3TMxXOiVsAUahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MlcgzTYV; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MlcgzTYV"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2bdcb30fe8aso995971eec.0
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 09:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772041739; x=1772646539; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=172Oa8jwqVe0zsnsyEKr+GT+lGU4uwg4tXRbJreHs3I=;
        b=MlcgzTYVsQ86r+KeG8Gobon+RmDtS98W7bPssBQTfTOLgzE5046cfm6MPDFFeQzk8l
         qeIsn/sZiDS8S+/o0Mpa3UKkF65usxwATKdK4Q/pVjI99WcwRFtOUPN98EjMk6vO7MK4
         ogNqxC7kmDxtKW9IK0goPlv246CrPSmCMizLcbbMfwenO7WdGAltMvM5VDKJosdkahix
         OOCT9OyLs5oUzOMcARL9bHF3/wHD8PoR5tbagRafdg0ItGza4uwkNYOosFNWQ7AONUc+
         FPNutfeZmLl/aVjgz6IY/SF9XGksQPxvLtvBI4bLA3fU293aj5LSKHC0aZO39Ue9rK95
         /qWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772041739; x=1772646539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=172Oa8jwqVe0zsnsyEKr+GT+lGU4uwg4tXRbJreHs3I=;
        b=jM/zirlQQeljCLM9TGKTuc87yxSE1xOVR4JWT3K4a9fnBjRzVkP/T3aq/kVyFuh58V
         j8Q+uotbDG05Jws1E+DSUlA6OmAA1Zti8iGuK0t7wVH7QAMil+JQRMZP23X/NK1kM2n1
         /1T35wpJK8aTBkfN92BXuUfJwqjnfLhOOA5Ic0XhsIof/qoOXKArhPwEk6Hz/LHQXYPk
         pmmT4dgoOIHyg0a1sHjIYC9Gn7EKgH3BMOa5Y/uNu1PUoprC5b/qatb6i0+oOMzrohFZ
         GdLaDwo1HjrpeNjdsoRSXNR06UIjqY5p/XmzknQoiMsYgyANBp1EaeomgckutI3sU8mf
         LT+g==
X-Gm-Message-State: AOJu0YyjLzhCSbpzVqxEnegAWvxrT+Ftso1S5SS39SQg8QyVk1s65CQO
	sqNnTZmy5AVkrAU5pqKhpZ14huMa8bmdiJ15tdsnUUWGLdMgi9FIwyC6
X-Gm-Gg: ATEYQzwALE4eeFP1/Ri0lU8dfhtaE6jI8BL4Dk9LapaQ1rJhajfpltcZJ8En6+FImCD
	jxLNoCLlDlOvn72iu0yjUHekKdEZSu9cYwgs99pTN4JJSwNBt45ZkiZEBGywMm8zFBXMd/6vc9m
	CyS5vXKRGNoaOppHcUgreZgYYlpaIdqFBbXiIQ7p6hjs2Hjskb+1S/ts98WXfizPqq5CaFoOOsH
	DIhLId8afJo943zwWZQH09UTS7sWDwHl5SKzbPY4QnkfzTes3Lks8WTOMF9axDFOYuDTEj9FDdb
	5ocf59YKLQPuSXrkJMiISW7fCxbbQDenWgXln51SQMCBUXYIWjiUbeV8HmxdVtQHsj0uBsGvbvh
	yAsmbTcT76UbVJSrQFoG58fDiU92q9J1uDB552iNtYvlgOUuohDgim71BbmqpprTKvmRG4Gr80I
	Fgxu7JgoYGD2l1GHIOosO8wZPPGpXnJguEYEnZGzCGx/MCBVqJQw==
X-Received: by 2002:a05:7300:80c7:b0:2ae:5bde:a5c5 with SMTP id 5a478bee46e88-2bd7bd3578emr8168287eec.30.1772041739091;
        Wed, 25 Feb 2026 09:48:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bd7da4775dsm9397487eec.2.2026.02.25.09.48.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 09:48:57 -0800 (PST)
Message-ID: <7a610f1c-8748-4361-b5dd-86de80c95aae@gmail.com>
Date: Wed, 25 Feb 2026 09:48:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260225151847.709818960@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 07:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
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
