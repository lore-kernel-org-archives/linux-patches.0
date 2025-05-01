Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A5D257450
	for <patches@lists.linux.dev>; Thu,  1 May 2025 21:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746134977; cv=none; b=Wmx3NAUpfLjwEWx+ZRjq0S9Jru/NMYfoIx5xcIYgPWFQ9t9BGUALsxTwHfO+bqsQLjKXmlFeCRbwX3TXfNRkl2I5nG1sVU+tWpR/06GuITwBQT6128bzcJtPFOCC/+ekfY0XRm3jMP2c9cVODMxiAvN+iDDoXYjGsPmABt+j3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746134977; c=relaxed/simple;
	bh=TtQHlSs9mCuOvq/Od5atiUs3rhQI1FOYWBUI1lzVHu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=td80HKrLRJRpoK5jhCNfgmQtmE2lQgjstpX3nbcMvYM0MHREDIn0EfqVEzBSU4OX13HNzofPQ75slrFB7bB3A3Y6LUH5LvwMX1PMLjFyt1dhHAm6cDRgCpuhJ7lZP+4+H+wb0zRpX+XeK4lZu344tuTsI+zUEGaTQi5v75UJ0IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=IKi/d7M5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="IKi/d7M5"
Received: from [100.65.233.247] (unknown [20.236.11.102])
	by linux.microsoft.com (Postfix) with ESMTPSA id BC9402115DA7;
	Thu,  1 May 2025 14:29:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC9402115DA7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1746134975;
	bh=TtQHlSs9mCuOvq/Od5atiUs3rhQI1FOYWBUI1lzVHu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IKi/d7M55gekyAZwpAb7sFwysgYxmHR8ULVzeMxgJYNjnG6DTGzhLKzkhmTp8f5+/
	 sV16/KC75XFe3ISEoWkWu4OHNiVgOVHr78s+XuJvwvwUaytRNDy8VPYQj3OhWoGjTJ
	 ptqnJ74GAAcKMzHwTLk9KmQysDS55D3MEhFfv3uc=
Message-ID: <0455be5b-f93b-44c2-82ec-68717aae2038@linux.microsoft.com>
Date: Thu, 1 May 2025 14:29:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501080849.930068482@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250501080849.930068482@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v6.1.136-rc2 on x86
and arm64 Azure VM.



Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,

Hardik
