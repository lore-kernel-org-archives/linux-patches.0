Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0919C1C5489
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 07:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998861; cv=none; b=m/T4T0WCfXL606Or4CTZirDrbsAW6YmHnLFJl4FPFWufS8n2JfSw4qTssW9vnNC4Z3bwii9GGqvUHLoLVc7ld/bi914OBKHiXGHnuTwb3es7LVez8dzEcRy8UOYZYFYKbcTtuNVryn0Ls9g6/3FD4FGODJ0qrlPn/bKzVQKGuEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998861; c=relaxed/simple;
	bh=tNgZS32HOtjU4tkboZXZ1AsNVqoObRKavYhH/Yeguaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pTsGc3qz0rlcMUwWg32FZNIN1sX5uCew51SVm/uhdyNWQWrzPnZAHbPZ44qjgmz/PIni3ukjupByv8VAarytWpl2HGL2eKXe6kkv5KYqZdeT2c8dmX8HU5PaV/BMBU5mC+GHJmclb2Sxm+tl5QOJhErshm2U8qj7/L0dbZhYhGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rZp0Vhf/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rZp0Vhf/"
Received: from [100.65.32.103] (unknown [20.236.10.120])
	by linux.microsoft.com (Postfix) with ESMTPSA id E646D202094D;
	Wed, 30 Apr 2025 00:40:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E646D202094D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1745998858;
	bh=dlYewUqnH2DGc+E8kgdnH3TqGO48vn3V0foRps7+MOg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rZp0Vhf/GyNzPfXUYTbkPnli32CExA1SKDzM6j+hjEF71m/RcG+3/I4di/3uRN6kf
	 fI/Q0Fch50s4NKgKJMlVupDwDFuKQF5KOMAaMLklxxh6oW5OpLv2dbBkcbiiK9tdel
	 jkJ6j/XPZWMilGS1nvcvcsaQFUyq835sLTpTH/14=
Message-ID: <d17ab831-07c3-4073-880b-fe4b8bbe7f01@linux.microsoft.com>
Date: Wed, 30 Apr 2025 00:40:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161115.008747050@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The kernel, bpf tool and perf tool builds fine for v6.12.26-rc1 on x86 
and arm64 Azure VM.


Kernel binary size for arm64 build:

text             data             bss         dec             hex     
     filename

27885928  17802215  760400  46448543  2c4bf9f  vmlinux


Kernel binary size for x86 build:

text             data            bss            dec hex           filename
26656038  10702874  1503236  38862148  250fd44  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,

Hardik
