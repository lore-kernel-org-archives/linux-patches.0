Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C6629D26B
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 21:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771017931; cv=none; b=YoOK+mY28ewocyxvZAWJHFEu7D8F5+TdNPKFtspwnD69fXcigH5aAJXAz+6lqeU5uq28O5g2bSkCrceyIute4J8JzqIY+IXzDBSLncboJ1pbuszRSP2pTDY/fSp8zwr3/LG3w3sSv7QfkjmK0C3qeqhJwOhhkc4tja1szF6UtFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771017931; c=relaxed/simple;
	bh=1WwrIcaWQymVreqECXIWYDtm1u8fIz9fAE30SD43/vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IhJzDjuKHqgMAtw3Lm0ZjQaYB4aQDK4u9cPyFdXwZgGg6ENpW0hfyAam4iJLceNML3o3H2jwGmE5OL+LJ2fqVWwxNRwhuHmt4xf9ur8ma9DXkE6/Ha6JK2nd3m3ZHMjNAawxH0xjT+DmDCLqPnceWkFe1oRfQk1NwfQrxalm5zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzqtA/Fy; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzqtA/Fy"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2ba9c484e5eso1410999eec.1
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 13:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771017928; x=1771622728; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yIxCdoHa233ZeVcDcsaE6m/fBIjWqKAR+0y9FsDJO5M=;
        b=IzqtA/Fy9B/yZQR/aQZdIm0kpliSh/wCCXolK8gAx3FBqgfwu17XEOnn4l3cjdmftR
         nIwK+fuSGOrRdVAvqWawW5eAtNWkgg328rPC0UgW9UvsLCkgAlRoRR386fQtEWoLGT8s
         7X8kOo5oLv3QAXeGVUzSkhqamHfhM8B5qhr00+qAIoCjeKcpneRQVTcgqW9z6aqQfz5W
         PpmSNoH+Qy0bUGQEoSOsoL7tQHPT/8E4bK7OM53mwc/1yxX/50K0lK4CIFHaFbSDIeTi
         3NG2oM/s6F5fTTJcEUn+323EvaWVdb/CZzqe9TJEao7/xRZ9VnzghDlF45jiyJTjGL9i
         0uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771017928; x=1771622728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yIxCdoHa233ZeVcDcsaE6m/fBIjWqKAR+0y9FsDJO5M=;
        b=VVhw/H5P/qll7ZmDC3arHz5Xz7qMN6ZLN9mXj8pI0GJuqckevCeBPdiqwGqXtt07A4
         MDpCNsyjm4y5idKLeQuA7z//GMxnO9oHT7M0F2ghUdIt8eTycW0idnYGuTxks9GwhMJa
         Gyvt+YBGCqqRcYhowBN1nDkcoxXG1qU1gBxKbVM9Ik+K7UMJkJ3PwJJvDCLJ6uYKJNGS
         O2w6VJfKGude/1HNEGTiW5sYNGXNREfDeayRlUrfQIVfXi2a6OaejiqkaA997DIO8sCw
         J+IUOSbE2WVtsTecx1yOjA6B9HjHaSJsrKOnhnDjx1RoB7tXJ3F/OOEsVnYLLMPY3KNY
         tN6w==
X-Gm-Message-State: AOJu0Yym2DAYxew+rBDx2CdF4u2BtY+avwITVaJxUtPRtFlGTjYb7e5J
	o8s4d4VE85wk7ICmKwN7XoSWAmufqqfT/d38ejLW4UeMXr7Ta8LG5fb3
X-Gm-Gg: AZuq6aJUMcJAbTJ28UgvTtSEaHNO4ZXC0KS7YkTNcKmgxUfHFWt79ezcd3gCa7FDcgZ
	6TWq40cFeozfNKmVInAMh7ZuNfimMYx4l7MpYfcNf3yoUEyYvSskjrda5ySuQsgaGDVFAgDF6qd
	gUl6nt32bf2fYEQeaVPaokLkvQ1HrXwREC9KyM/XMdmrncBDJC701yhR0mNVPNMKWFylGZDgifZ
	STXYHu66KT8uT69n9ZK142vyqMebiGG5p1nSHI30mxVP8DNn+MXSdVcpAS7140WNE9b/KfOINr0
	Yk99EpwLB627/ZpmjGeYlqIwI20X0tz30MbOHegAwcsD9y8HYRwxh4hQntB8sqvDniGX6EO3CE7
	s8pN8dg5xqO2hJogL9bKJhxLXFsE0bQYGfZIE7t4pNSy3QWNFs4y/alqBJX1X9LtEcBndKeRhae
	hHJqlDnb3zHHCvJ2UbEsH4fCx7esUBACS7GKXEEAknIsTlnfFVrA==
X-Received: by 2002:a05:7301:3e19:b0:2b7:3281:6c64 with SMTP id 5a478bee46e88-2bac9356778mr271085eec.14.1771017927525;
        Fri, 13 Feb 2026 13:25:27 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bacb577c1csm86147eec.13.2026.02.13.13.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 13:25:26 -0800 (PST)
Message-ID: <136f19e6-ba84-4f1d-bb49-465c2333bda3@gmail.com>
Date: Fri, 13 Feb 2026 13:25:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260213134708.713126210@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/26 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
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
