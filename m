Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2171A01CC
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740507892; cv=none; b=gPZUyJ2U7B89werN5O94lUcQhPEPFK5Y6J5V0FbUuhkKZ8DtZ7BKpxXyM0Kme5aCDLH/02I6dsFKBtiq6Lupjbj9Ks99iDAMS8ftiLt67JAPwptTeyjt3tm/mnY+gpwspzr9j0F9uVsGp+JZTzDfJ7/GJhJQlhd9ZNSJXXH1BIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740507892; c=relaxed/simple;
	bh=iaATjlHw3bgNn21HkdEj8ENv2eXuMLNnP7ErX/r4HX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYWUH7lp5BlAjtk4y589H3AZMMQ7psEcgOxhaBU+1hNjiNbwdb+Tk6Hrm4L1l+E0VJ7bglgrG9QfX+PiUCUanngAh8AEcNqoIv4Cmu9sCiNxNMP8oAd+DJ6d3O4ZtiQs05iUnn2HnEaIQaqvtEejd2gPyJmFGA6gTsLWCYiGWOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=QR//+EyH; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=QKuPdwqu; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="QR//+EyH";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="QKuPdwqu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=zvdOm4mAruYAiRh7E0H4Wg6vrM/6S5lC+mbY/6dX+X4=;
 b=QR//+EyHJ7GX3lk4e/xxvIwd69YF8khMAXS/JI3TYUveIPt2lWGwshDMEgvahttoXalpxAFGT0IduR/MuG5kJT30P4OG9OmLQleOxheRLiriZ9Vl4e5d5rjxuqNJa5ghiSkX1RqURqWh8grI99mJFxcNIRE9XZfD6MIOcAR7nWfRM3IPCms1zsx9YNu+Nf+hMrxZ2R2n7ieQus/QAIFmPeI0BBraPqU7Mm7LIjWX5Gte9F/4C0IPV+K8ml9e4zViFk2TV6tw/ZzDPmvPgjECvyYqAxrkrcZZadmdlj7ZfkCWUN75zz1yH/CZrodlbBf0l2Lx2tweckJQH9yU2BsMUg==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 07986A80165
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 18:24:47 +0000 (UTC)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e6a94b6bdfso113392006d6.1
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 10:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1740507887; x=1741112687; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zvdOm4mAruYAiRh7E0H4Wg6vrM/6S5lC+mbY/6dX+X4=;
        b=QKuPdwqusvGPDmyojklMqon2ocSTXDzWs2bbNCGJ22hECgEXsh1xmXzB34c5IABUQ1
         n4tYgJrto7W6eJ4vWZyp/uSVFYhYXBdU1JWkCw3af41CPJR6o3lAxyINOHudYJtqWLbV
         yhmoUKKslS5oqpPKulj9UmDUocUE1Flb2I2IzPmHLGU9tF4QWSwOgJ6XhjwCqay0memo
         pVwwi7IP6xJEsFJ3yZHF+FGsNPwRIap3ZLr9MDDxiv6k7TpmzkuYtnWSaw0CNyeEHRU6
         D4UTDSQYSaOaJxLy6AWNsyFmBWV3n5dtXvTvrvlfCdMMTpxGwNIxdNlY9yTqlMACmIqP
         j2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740507887; x=1741112687;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zvdOm4mAruYAiRh7E0H4Wg6vrM/6S5lC+mbY/6dX+X4=;
        b=pEFIzpRcvKTa0DrMZAFlBPAhYhdQ1LQbM2EA6X15NquyiI1/oXy2yOVWkIj0BoNTFt
         kvZMiNYEhRF5alOYwPJBD5gFWOaWL2B55F51ZEHeX/QiJZNe8Sg0zQr3gck4ABToVE4m
         gBsGn+W9e9jct726mkFElSa+kv3filejQs5zh27y/Vb+H0Ccg5Gj98Vnj2rkgysyaZRK
         K4l7x2zJDX36YWuQxKqltApnwVEaWNA+jDRDkWaP4zJ8OsxyoBqT3wqFJah7fAD0qJQI
         GXm+yDgHto9RPOwHsCGqSR3PoueGbNkxmuqN21Z7afYe3pZlNansFzzV2uhVH56iH/rN
         7ASA==
X-Gm-Message-State: AOJu0Yz9tn2Lmwmm1BxWf01kJNa0XMj18pFAVwbTT0hnGUpmw2Dtruly
	ge02SAMifQv8bf+9Cuy2VGiOZdJBx4Mjr0VAo/qslyD9taquZwxWZDWjRphzlYPkwIlSpPx7XGC
	ihXrFnJ5+tuPv7xWr3N/tqJ8qCvCSGfN1cCkj3z6css9Fh27jyf2GWu+cedl7q2rpd1iNzm/3P1
	aq
X-Gm-Gg: ASbGncsigAJMCgJfjsm+NvpXbWVp/kEWVbiZyE0NHkbF3265w0JK3/imGIsA02RV6Lg
	Z1asXDx3rJd01Wwj8QVBGU13AOLbQyPNthIjjf57H2bG+AMxBTkwEFbHfh3PiLbml09zBexzQli
	Oe03uqQ4W9pjnOIhDpBc+L7n0In09X+MeoXMz5YwWjTE60O5Ggo0+JfIVi2rJ335T82WgUaeQ6a
	bsJJxR/Qk4EA0nn+G+tFloDViQEW//yui4esGyBGyiKJ85KGwdeNjcH+Yhld/JEp1EpPf6UouaH
	gOWVI3UuEqLsTjJYAx0CNxenWtp4bIzSLfVHEbnePbt4X9db5n8d8zB6o1XbaJSc6/vq2vYTVoE
	JdmS/NBedvg2csA/f8e5ZfCKn0WVXXGxZmIwO
X-Received: by 2002:a05:6214:19c4:b0:6e4:2dd7:5c88 with SMTP id 6a1803df08f44-6e6b01d7816mr281052536d6.38.1740507886683;
        Tue, 25 Feb 2025 10:24:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0ZNnvyi/eJtx6eJsBbumH8T1fTQzPvXG7ciwKqR2L/Gj19h/DZglqhJSSfN/X1QoEIlljUQ==
X-Received: by 2002:a05:6214:19c4:b0:6e4:2dd7:5c88 with SMTP id 6a1803df08f44-6e6b01d7816mr281052126d6.38.1740507886368;
        Tue, 25 Feb 2025 10:24:46 -0800 (PST)
Received: from ghostleviathan.computer.sladewatkins.net (syn-076-037-141-128.res.spectrum.com. [76.37.141.128])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e87b17103bsm12158536d6.94.2025.02.25.10.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 10:24:46 -0800 (PST)
Message-ID: <25f0b81c-21e3-4021-ae53-cb54b6c06324@sladewatkins.net>
Date: Tue, 25 Feb 2025 13:24:44 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250225064750.953124108@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1740507888-SbHefzd6a-Rw
X-MDID-O:
 us5;ut7;1740507888;SbHefzd6a-Rw;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;


On 2/25/2025 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.

Hey Greg,
No regressions or any sort of issues to speak of. Builds fine on my 
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
-slade
