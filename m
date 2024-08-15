Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659BEBA53
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723749695; cv=none; b=u7zRHZmO0i0TlyNYGLfgjjjuIy1PdUx5HJB5jCiJlUxmih0XsbiEexo4nURc9B0NEERn/x5mc/CzH/uDhZOlDrsHmSkkoa/LNFS3ZTibGgoxUu1fXzWSRdz91uKU2cYlHIDhl1E0JlFipqo6LEIh0RdgASIeUQJuVwOAeFTgHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723749695; c=relaxed/simple;
	bh=L8EPgfErufotgtcVogDTGa11kdtq+O4nYORBDNA/Lgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgfjtflPYdqLCsLV12V+0TTF4n9zPG6LeCWQ6YzPy0PaiofGvanlFbYkdNp59A6PYH4szpd88lNHMr5V7qrG/mnlXvrzBR3nYL4/Jro3UPQ7bSXi7Tjcv5f2ULJPhMYGyeIHRHFr9X6edHgDhm9aadgAQ8CuYAfsp7kKqcGx9aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dx3+2kWc; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dx3+2kWc"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-201f2b7fe0dso7750245ad.1
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 12:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723749694; x=1724354494; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Umz9hDXFSz3YBUb9yk0tQ3KFZaZp7tJt+ZRbi1r2fU0=;
        b=Dx3+2kWcxod4dP/b7CU/bjQHJ6GWwNix+2DysfGP9OFuhgbs93SWjR2F/c8ZNxYXlZ
         TQ2SPSIGYVnsBGWewgImByX9fVqx/CnyhKKzPdVksJ5D8zj9rP/F9BJEPYCTsX+Uzryd
         Y5EFz6KVP+o2MG1Y55UiFZk0BtxUFgGiFLwXAW/6OcD29VSFckBPfk0574jc3PlvjSo/
         1uukQnYmmIU+MNR7VcecSdfZqvnjzBpz4PfRkE48xW6fc0l5iyfTyhDJYRzv5UzNpAJb
         /FHGslOp3K3UBT1+VC262+7kSGBIc+El7Qv1u6iABbs2YgL8ACXXDZF74TFdfnd2JxT5
         mc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723749694; x=1724354494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Umz9hDXFSz3YBUb9yk0tQ3KFZaZp7tJt+ZRbi1r2fU0=;
        b=s655OThA0Cbcrcu+5FKiQSjlNUPHSTL2q5Qaz6oTfjmL1+mkxv+h110tVQ4pO8wRAK
         de6AQYT5Mf14CIP+mZcyzHflPbRpiUAu/m69KhvuFzf9EG+OhDBq3DAFGfQMUpN15d7y
         9TbIZmDczf3tsoy5zIDlndt7yRmSAoFQgKWb65oV/GSeP3XjHEiOHOCL9gqXwm6Jvwvy
         MGrZNLqmbDZbEFL+YUUpSZUzkZ7jAlz9FVElWNRDSskOib/vmQuqv464WEnADVsSOZSq
         aMI3w3xOMikCaZ4wsJ7CQB2AjhGM7b+SAA5Q+LGyQfla8ch7l9LaOYZcQIVpG4pzt7gR
         nQGQ==
X-Gm-Message-State: AOJu0YwBGwrlM/3hF0e3AWKqlFPMjaoMO/61dwk+SBQDef+XtqP2EM4x
	jkUIWH2hyK0a7PNrhNp3LqtT1pJD7xsU0TrhbMQuGA/6u9YZ8gY6
X-Google-Smtp-Source: AGHT+IF7fvFs+8/4+eEtd/uO/sToK/u6WOiwUJ3JPwO8p43BjJXgCpRgn8uVmQNMyQanV4QZgamreg==
X-Received: by 2002:a17:902:f68c:b0:201:febc:436a with SMTP id d9443c01a7336-20203e868dbmr7931075ad.15.1723749693535;
        Thu, 15 Aug 2024 12:21:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201f03a1468sm13274725ad.271.2024.08.15.12.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 12:21:33 -0700 (PDT)
Message-ID: <d203bdb1-1ee3-4de5-9d20-1e2b08e710e7@gmail.com>
Date: Thu, 15 Aug 2024 12:21:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/259] 5.4.282-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131902.779125794@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.282 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

