Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD7921C18D
	for <patches@lists.linux.dev>; Thu,  1 May 2025 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746134800; cv=none; b=eirsnoHdfzkox5zH3rZIRmVJrKCQVG5fo1mS1qzxvlKwZhphaq1TuKPAq7Ife8FAGwhCdzRxjj4GjEDxV6+rZzQhpsYwYL08AtuxmU9VySCK2WSU58InAg7TOFKBlJobNwsDeM1SZjcYTNECTk2fcVD2QNeosljhdWqyYPMuN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746134800; c=relaxed/simple;
	bh=irmpkIt6FpBZEesK9Gigy15TM5FLTLFvvAPmvm4ztXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDSsJUMMfMf/HQWnPeMw9Dl8ywVx37/UBAMKlxjATwRd2SfHNeicMRFmwtpyxKVK83axkwlh0C3migsUSW9bz3jPbFcw7zGEf+CHD7eRr/jxGXnJBiaEJEH6jxe1f1wP4f3rrZDUdY07y+ikVtN+EPc+8V3UiZdBA9xdLv51oL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=h2AuF2Xw; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="h2AuF2Xw"
Received: from [100.65.233.247] (unknown [20.236.10.120])
	by linux.microsoft.com (Postfix) with ESMTPSA id E670A2115DA0;
	Thu,  1 May 2025 14:26:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E670A2115DA0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1746134793;
	bh=irmpkIt6FpBZEesK9Gigy15TM5FLTLFvvAPmvm4ztXc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h2AuF2XwRqotbxNqsjugkESxfs0YGZOOdKglIPEDSZiXFGksBOrz7CqAEZaLOt1nW
	 bMIOiHkzvKXh9q43H/NpjtcP3lElRqHDnD84vJ0GGSiwZKhwJHcZFUWNf6ifvJsqYS
	 H/TP/sYK3kkoXktyBA97fLeE2MQT8mtW2TYY5oaw=
Message-ID: <ffc1e871-02a2-4977-9a4e-e3ee6b1a302d@linux.microsoft.com>
Date: Thu, 1 May 2025 14:26:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501081459.064070563@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250501081459.064070563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v5.15.181-rc2 on x86
and arm64 Azure VM.



Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,

Hardik
