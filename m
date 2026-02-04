Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF823148C1
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770234191; cv=none; b=l/NDlJ+sf7JwKB8G7L/pGNAmrezY8dv31TsBpLrzy1FjajtwzFcLpzBWDFX1VUTghWSVnvT5pnqqMtN4h/yIFJQ3nlxobowS46btAccoYHxaHnxgdnZjgOGvhBx1TWCTe8kesfWjxaOrHfNla7c233XczA1fgRklv3DtUwI8OIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770234191; c=relaxed/simple;
	bh=Wc5QFMh9Fxml3vOwG6DK6GyG/751AcaAfY2GfpJknkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9SK75WBQ/wNfjfEE24u1otRdQdq760wxT8ZvE02OCM7xo8TgwhNFsfP4IoMX3tbcPrqmCdF0RAvpsCmdTrEHH81DuywjOy3hGzfco2RrG50BqTC2K0vf8es+4m7QGi39j6emH49plYScBXEMEiufYNU42H15wYiBZ9Np70BWaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmwotUFt; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmwotUFt"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b740872a01so196838eec.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 11:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770234191; x=1770838991; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xwCXZ4zC7YICxnWnD4euiuGc+15/UPTLhn9e6UNnqZo=;
        b=MmwotUFt1XW+JvXzuSxlrHjdCOuiJR8ba8r4kLnJgqNRXNwN0BAPHz0wSfmjusWxLB
         6OxmNC2EK//MsT08YdsmlZUWVGHGd8iePNSlAKxCSj5uOfcYPlX+mRl4S32yBXItNfTp
         A5c+HGGzOGEDGcW+CvYqJmwOHcyuLKDoxOGMgpQB4C0G2f463NrvEXpOaKkx2/w/ft0Y
         dEXax5FVjvduDYTy36jHeordF4Di3ZryFPDmhPHj9+NCtPTH7LXo5IkcbZNW8mr/Gtaw
         RYqv3ztCePtEd7u5z9lyehL7YuRvzQrVWqi3OwWpVXGAyHxpuzXBFao3EcXmJQ/cg+fc
         +kdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770234191; x=1770838991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xwCXZ4zC7YICxnWnD4euiuGc+15/UPTLhn9e6UNnqZo=;
        b=Dt3uDfhGr0BuALaVYSDLZvy6e8SFfuBjgPTOq3RTpTOshwQYbiryQBVbKO67LblNu6
         IeX4tVa+64c36oMU//G3/R+AderEiZhLTFz/4TzsjB0xAB5++BKskctAbaTp6e3Igggp
         GQsnKMiY1C6c1DfHsZAHQYfI+7rbXcD8ME3MFswF5g3E+AnUhhRRcjIZoqIhv+Io6qc3
         qCuxtNjb74UZVlxqNiH/dqHTkxI5zilGMeR/iZ0mrF1QqmOFVw6FQh56YSU+TDuiFO6r
         Tza2IVndJb6r5h5jhuhBW1uJsoODNxl9zeTptd7POSTuqOA0B34BPYJNk6DlW7Jo4p4V
         khHg==
X-Gm-Message-State: AOJu0YxxmPyNhj0A8j4dvFO38/DYSL/MTI1b4LkcKRB6kHrIqX2eOx3A
	mcPJJl0IXzYCz3DpeNQKamUrHQv1BjJIkN73KbkKyF7qCoS1QTrf3FQa
X-Gm-Gg: AZuq6aJaa+pyQ2tBJqNnCxkUcAHVrM50NbWCuWQEpvXi8eoCMb4yXoiYHhKKi9/rr4L
	cY8Te+VmPepgfvz88jaBCw+nN3zh50SfY8iWM0AWUXn3QskqeIXBPMAADSERZ2dW6w2RWHDp0IW
	XbwidMM4cXJq8GTy9MT52GHzGSJx8wtN2UPcdIY7o4OFfb/ot+Y/p8gAjDd9k4zcEyRXtzddwH2
	5a9Pg0vrw7boOSJm8hdSBJCf6h2UkbSaRThjaTIi2iNkLBhvKJ/AW2tKlJfNdAW4SutJi8uoVrG
	LRw5+XS55ydQal1WPwvFOJbPaEZLsz6wpyn9bi1r3vWbX8vOITalDgSFM7clmhfIcpfkpp6DHZk
	S7qR2ushVj+35PicX3SiYK316I7SaYp37CuMMyS8tbpjZYwSSFNBFSC6Yi2Gt8FsyOOeCMhayMC
	VBtvp58J3B8zodB9VdepHzBsa5heIYrP3XJ8tyyA==
X-Received: by 2002:a05:7300:dc08:b0:2b7:fdb6:ccdf with SMTP id 5a478bee46e88-2b83287dcabmr1936382eec.4.1770234190736;
        Wed, 04 Feb 2026 11:43:10 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832fc1d50sm1945723eec.27.2026.02.04.11.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 11:43:10 -0800 (PST)
Message-ID: <3a0bc80c-4144-4c01-a94a-88c36bd9547b@gmail.com>
Date: Wed, 4 Feb 2026 11:43:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/206] 5.15.199-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260204143858.193781818@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.199 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
