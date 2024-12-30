Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB619ABA3
	for <patches@lists.linux.dev>; Mon, 30 Dec 2024 20:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735592289; cv=none; b=RyEHFWDaFbTyC3zBSuJrnqHH0SDX/q7dAAXqyTQkXmSzyIdS87AFQLZUPBFfIKQfnWnarBGgggqUg5mcuygS5LIt4HKWdkJU9LfIrwPYqQOVu4wV3hHtrnM08rU4Ef8wQVqKzPqmJosaV+KbIW08ShPNlyp6rQqbQvfjwap6+qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735592289; c=relaxed/simple;
	bh=H8N6a4tWwoPYuLV+gldL2S1ncL9sQ+rodDK1OUz1BiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JzxxHTQ2RN2MrRuhrxjlkdRUh7ZOqbf5233fWdrbyCTHFz4TGIhqAuppOX2M1cJjMpu196CZmmOuhPCLp0E7VZPdJiFeiiHqRxI4S7e2KVcDIL45f8LDxYStmA8N4KjKYUrGrmzH5pOZ9/F38eC7Dl4qjxRKbQoV/sd9uZAYRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qn1/jnzM; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qn1/jnzM"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so373553439f.0
        for <patches@lists.linux.dev>; Mon, 30 Dec 2024 12:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1735592286; x=1736197086; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IipZ0qQKC4K8cot7QR37D3+65FJ3YdRAftDW4yRG0W0=;
        b=Qn1/jnzMM+vQ9x1CzCm+kXeKMSuYvusE15h0JJeuzGnjAccZMJmSApx3e9yr3aDTqi
         VTzOy+sq8MYCtJ13AKkcSHoPHpH5c/Bk46pueuGfy+KpNPfBxr/cJmR3L+bcidaO/KNc
         5iEm04pxLVel2GA6BaM79q3IFl2/FyJXDV8G8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735592286; x=1736197086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IipZ0qQKC4K8cot7QR37D3+65FJ3YdRAftDW4yRG0W0=;
        b=FboQ8Q+17WqVMR3yMkJLLNXXROldFVtJGdkdg8S8Ln2blxJNxJyxNbVeJaRQvyNATv
         xeKjzSPgf/e+Im9RboXlGXl8rkWlj0lzbKbxUCCvc8Idc0HQayqKNEaXDIua7H4DZU1+
         5UtRiVegRN5/lz8yF8Mv3mLMfKtOxJqiA/I3Uf5aOWZRiRp0pShyjIcq6TmmJPDjFMx0
         1pz6jq3VILqjiB5R7zmHjBYgQNcBqWk1umz8nEe6qd/UC0cvlw21BrKiQF6CWm20K000
         6QR6ekrJzcLu/zUhwjYqigSo4C58vZaSF0F29tt4YjpS3uwlVwotUCYkSp0vOIyVSEQ0
         7iXA==
X-Gm-Message-State: AOJu0YwS3WgN/c1bPn6Zti9gNm1iW22PKB4Efof7hxUu1k9rx7wca/We
	m4eEvZcvmlTaOPH48g0jhulfNo5hW+Prp2USxBTaIrYyRKGwRv7QNvr2cYAiPtY=
X-Gm-Gg: ASbGncvFRlHagsWcHt+1XS/ajRyG76kLDuUSzqpHLKJvKIcipBXN976zdX9VRgsn+d1
	9BNAEF6dRHFdcqxipvOC6YQF9CKKfJIU/SBm2IuaR66/umdRxKqO7yrZaCxits7ug0xSAPzJIr2
	LZvTQ+jcDzXdGyVeXN2tZiUL918QyRCu36/j6u3CxUhx8/8hPqXju5Vz6bRHAQczQVt+sLo0QCx
	WJxJylYewsbh+ijGz1Thbx6DqaX2twT6Bw818w4MU75PKm/LVXuX7sKQAHT9JPMZqdY
X-Google-Smtp-Source: AGHT+IGgVs7BldTqI5pIHAqkhcywO8lpEIfYRehE73LDMbpEk46lG6oYiuSlRXYySbFmIZ9MNglGOQ==
X-Received: by 2002:a05:6602:1656:b0:844:e9c4:8bcd with SMTP id ca18e2360f4ac-84988d257b9mr3078453439f.8.1735592286638;
        Mon, 30 Dec 2024 12:58:06 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf4f360sm5819290173.27.2024.12.30.12.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 12:58:06 -0800 (PST)
Message-ID: <d4261c30-2286-4a69-8439-3e77138ac88a@linuxfoundation.org>
Date: Mon, 30 Dec 2024 13:58:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/24 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

