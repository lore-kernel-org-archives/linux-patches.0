Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B4735BDDC
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 19:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767988163; cv=none; b=hxgdVXZwfMjX2lqiS5Ex9mf2mny+yX79wC5/wJypU+ktBCLv/JxiuPnYLwWbx0RqkszpwKR8OPWkYPduop+N4bjiPYw3Uuw3xFbHCxYpPiq+Gh0BewYrGUssRz+jODRJ0hHYB9R2KfZAdufDHo9A7J5TQjDtjGXCDkZVXjsKH+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767988163; c=relaxed/simple;
	bh=fNgpKzV1HTUMU30nFRHOgjqfz1ALy5IdtMnv3OyZ5AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7/UaxW+MxOfPjEqAhceI0r/zB1rmUcngptI7rkfKSs2Wk9fZDjV78kn8lnT09Eom8WLlYEp8OJ7yhlBhfZ4XsiL9jWIHeiHGJWSTzy+NddQLrPDl4dpVMyXZwtKmHEhIo0Jeu9pO08Z3mceaoAA0DuMsQMMtBOXHd0v27NkceI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeY8yrPb; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeY8yrPb"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2ad70765db9so6946348eec.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 11:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767988159; x=1768592959; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aR93X7jFP3F2xN51srcz5K/pRwSYrhR5yVbLC1NYbmY=;
        b=aeY8yrPbgpKkcQfGZYoLZz5VTKRiVj9e0pf5K25eNBzUk+K1NA+R53goJZjBixmpcg
         ryg4dAQuaPqj++nDUCCxVoHziCgmpe+jbT8RzhcXxXgO6F7X/u5tjDZwvfxp2xX5XOOl
         uL/ZbuzBaXsT+qoesPwtjHVDE3JzZsCgI34W9vzeHijgtXLppyTD80L1aLZD2xPqD2s+
         TWgEJyuhKL4Ed8zpLlZwjdFsUxDBY44C4HdgTZBozP5DIwhRj7BwpRg/BE906thOWD7j
         P14d6u+D6OtmAdiw/6IYyQvk793ZFe1PlkWJdThFG0YE0X+QALKBGEgxplAkwnQ8Cq+F
         yLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767988159; x=1768592959;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aR93X7jFP3F2xN51srcz5K/pRwSYrhR5yVbLC1NYbmY=;
        b=mUOD9cw1+h4ZKwsNdMxZa0cFrBB/F9YA7Ri+4n7RJiigSFUX/rkM3DVQzkjrI0UV4V
         xB79bdM0kQiJ/1rps7G2E+QCSfyRiN2asXGSLRnIj2HdUbU3PqGMiBLD0+CexmSRYxZO
         zpbqVbDK7PhMYmRI6pOSwjAGTRRtiiRGQP+7imUaPiSOUPmr30jhsE+LTThB/RhKA7hQ
         Yi8avxN8ViqXoC+WcZhBUUap42/eglW2u/V+4LVtX4+gizK7qBUGyNT2O6bv2pcCBB0o
         ufesAq44+A6vPHJNbIIE6EG1zw1k+0OHhtv6tSAg3TW9gs49k3nwsZv2dGugPW3Mv5vF
         7BEw==
X-Gm-Message-State: AOJu0YzLNgVJfR0/0GtDXYgbzjnoC4oSKgrJPKF7mkVDlRdqk2EER64u
	z8vq6UeC0wOTyX5mN1MdYZedQrHeO1pi8+d3wqRjN6W8KI7xPZ6zCV13
X-Gm-Gg: AY/fxX7RU9fAdIyVMuBiX6WR6uTNhLJJLTxOQEVWSIj60K4bQO61EqAD4GQYQ8cixz4
	sWHY1KLq5qajPi8yPWK3HGVauWyAI1GUdjPPbM9GQ/qc0lxuMRQHqSoEGUQDoCFc+dcbpcd8tnm
	EBMMpptzdvohLd+Dz19dZ4O7EepNxsYGOsFQeERyEpKOUyL+bt5w6zBnYY6Ri97k1rg5o7GeAy2
	qc8zJfKXNaiBUuPC8+35SIDGi8ksO0UWNDtB4zdyhaSP0bCGZdXt86P40PijIRdjvOtHAg8pgHU
	cvHO47WpjIDqpCWSZJyA1aGV1SGEYqfz3RTPQcXFPZQ45NEiLxgHWSLDt5kBMAqStm7gVO+h8qc
	iU8ORe/0bXy/NaZfgiaPOux9o2sYZFcOvl5KYP7a5t8NuXoeQE1cxUe8OubVu9wjoiwyc/oYA9D
	rCbY7KYPXBJ+HB9Ur3hgWFM1vCkff0NuAeYyCEdg==
X-Google-Smtp-Source: AGHT+IFvZ1SqB0E6m6lTuwHY2ZsR9JOTkGm7acWRR4cfQOZSjjIKuG+tOmwjteXbZhhRzDDHLC95mw==
X-Received: by 2002:a05:7301:108:b0:2b0:5a23:9c7b with SMTP id 5a478bee46e88-2b17d341a09mr7102693eec.41.1767988159283;
        Fri, 09 Jan 2026 11:49:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b170675076sm11972955eec.2.2026.01.09.11.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 11:49:18 -0800 (PST)
Message-ID: <fbe5d6b5-6fe1-47f3-8e1a-ae38eb896f31@gmail.com>
Date: Fri, 9 Jan 2026 11:49:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260109111951.415522519@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 03:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
