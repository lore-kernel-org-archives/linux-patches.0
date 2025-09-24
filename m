Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BF02557A
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 00:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758673664; cv=none; b=FwgX5FLShOyjDDSr4hnVhV8982pUtubZ4/rXTfi4utfy7Ys5GD2TE7y3Kt2CdO5DQNEhX+GmlRdQESycwYK2ghHRqDswggy3pEqAGTWQh32rWyU9o6X3MuZuH+mrpddbgqtlb3eNBzkZBjtIPLGCr/bXZ+AWiExDutsGeYOatTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758673664; c=relaxed/simple;
	bh=5Bo7zvA6zBJS0OJDG7OZpq3+FCrMly1wKoLYNe7TreQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAqQYcUhHTG46FiIVA6A+c7k4b6fSg7WpRCIFD7QL/SbawQF53E74y2sd686YHk1QX3b2qslX8RctpVmkTUOsJ92xDk0OC+XGlbOTpTmOIgwIlwGGqx9UALJmNVFqVT18kB9eOcR0MxspOPmh3wr8GqyJuATecjLzSdkGqCSpGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYA19nrQ; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYA19nrQ"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-4248b079780so17282595ab.3
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 17:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1758673660; x=1759278460; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Wz4Rjalrhb/QiOrQ6U7e+va/tUv77hOSowEW0Hrr4Y=;
        b=XYA19nrQJsIePAfmcQCdzdf6qLv+l5sO72JZ8K4SCeDV49llo1MVZAiXwPdi2WPMUG
         HvZkhTpXYuuhKOXNKiT133rtT927J+61I+eA643OX2eLzbylVoZ4rHrZa6XiEH4FHqHG
         1kku6u6uJ/dmvaaxW9TSRK7XCbJC0phNxtlNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758673660; x=1759278460;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Wz4Rjalrhb/QiOrQ6U7e+va/tUv77hOSowEW0Hrr4Y=;
        b=Yf26oNGY28q99AaRsN1EDnbvfeuzaMMgtCJILCEc0B2+Jjc/+ym9XbPG7691lSgoCH
         9Gxh8A38P8G/HfquIOMz9dT7sKjKFhM4cWQuygl06nCs5ZzL0ckGio48K7n8l0MIgHCp
         1hpc2Ifx9O/Qp0kyItmJu67W/kbHcYfY16M8YzFjzo9+xeLckCbmDA0rUOjE/AELmo3+
         120heZIB1ntLWLecFTGzAvAFoUywytVxgb6kiJd1UlPo5Vf2HvfsLRNv928rDcCllB6R
         HZI1bMknRqi6EZRVMy20Bd12yNuHnlVj7TcRzB7PXzvy6H1FFf/5IS4tESG3U8GIZGml
         fAEA==
X-Gm-Message-State: AOJu0YzWj/zPF24VpbFfKsgR1NndVcBC9qO9yUt7hZZZFZUue8WKNPjD
	tfyo7FA2jLt+v+1pHW+aGXoyThXl1WFofopNT7lt8ggbFbfRdYa2ngmBcymyOVpA4Ho=
X-Gm-Gg: ASbGncul1bYzVicSGgwH6o6opIsN4/+6WPJALqzPkCYBD9W5OzoAZwBkEu9bAEzJXwh
	e5v2bP56dJZesGOn7IrbrLq0u6AiQW0bag2YUDN2IhJRk5e8eMVmumy4fO5p3JvoItumhupaBuC
	1IdId2vMo7kZAQEzSjS1iHgZQtW3/iJCxSuJKtAaljPv8eykL1fKnzGS9uHXU6Esi8llz2GYxi2
	7V2easYttmdWiQezXUgvYmt2Nzk3kP2jEclYiuIUA3/i75+C/ktIfABs2JG+j1JZqGAeX1HhJ6Z
	1tuuTImeHUqmCLsKHBZG3KgWJXX70oiNTADhRoQbfIk63sMWeNsMoG0JWbouIILQejzXaOBLtq4
	qnLQVwXVfMSl7seg3nN3wagBJngHBbzJRVwA=
X-Google-Smtp-Source: AGHT+IEjOPwrjQXV1ckIcBONH2sqdMovm36FztTg4RY0FjQkuAcLbHH6PXEtgycQCgk//BbSsBfTaA==
X-Received: by 2002:a05:6e02:184f:b0:403:c8eb:877c with SMTP id e9e14a558f8ab-42581e98f31mr80677015ab.25.1758673660629;
        Tue, 23 Sep 2025 17:27:40 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4257d1c2a23sm24632625ab.15.2025.09.23.17.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 17:27:40 -0700 (PDT)
Message-ID: <5565b45a-27ba-4283-a671-fb43b01e6446@linuxfoundation.org>
Date: Tue, 23 Sep 2025 18:27:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 13:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.49-rc1.gz
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
