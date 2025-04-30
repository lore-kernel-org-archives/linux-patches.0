Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908C6189BAC
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 07:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999320; cv=none; b=YgD/EeHgDm8EjHWfACtKddXHXhxKqNCi43CfzvhNhfWhhwEzoGk/bcv9ErM+Xueyx/xEMikkDl5EFllZ6QmX42hF1wq0Fim4WMzdy5pKflr7xVMPRs50Q1aw9jiDNTid7uBhYYAPtEJbaWAKfukYUp0d/AmpHzT6vb+CxaLHaUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999320; c=relaxed/simple;
	bh=C7ZFKCsoLPWLbqw0rXNqdYUoJ/z9gq/6Npv3NfLINRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dal1mZr4MyWovUHWRdQdw4CtnRDCVZY0D45goWCYD3iqTaW77w1VJ9Sn0bjWRftdhbEQY8Udon1IMenV+KQblvVQhPsSYhjq6qHkud+lsnvtdqSBmtKznueXZlEx+c1PULPMGw3DgO/QQVnEvhpSro4rSEqQyIej5OfBbcaXtIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rCTqcBZC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rCTqcBZC"
Received: from [100.65.32.103] (unknown [20.236.11.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id A0E8A204E7D7;
	Wed, 30 Apr 2025 00:48:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A0E8A204E7D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1745999318;
	bh=9CvSgBiVpPr6KzMXfUTXg9eT9FAu4uEWIBGNAYDNRQo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rCTqcBZCNPQt3ZWtjbpA2ItG3DYxUpQqxaXhjvOZxtrz3jKCzmriLb/iMHMIrk64y
	 IadXxHnvWx5MqqALi67oKVlQSK6uNffNyFCWJ4KwTpFX/rW49NRSJcP8vjQ5cqI6al
	 yjx5yGER4PiVRmwHTykkQ5hd5rLfLCZD/8FzLgSc=
Message-ID: <f2ac192c-a64c-4558-aaea-fc79313dd892@linux.microsoft.com>
Date: Wed, 30 Apr 2025 00:48:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/373] 5.15.181-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161123.119104857@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v5.15.181-rc1 on x86 
and arm64 Azure VM.



Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,

Hardik
