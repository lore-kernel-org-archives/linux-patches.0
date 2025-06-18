Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8359D2EAB6C
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750255875; cv=none; b=lE2oVQlSCLBtd8KNbngtvFF5YLfjsIdG/a3F+diJa0LJVVH6D77JBeglm2/LpTuweiVYQ3OrnysVFTZjPFNdkCnwKuK7rHkEMnOVzYyc9VkrSP8pjw8epdw81J9GkzR0vVxrqM26waIDRCCvUY9f1rcz3NXysjmIlEi8zfLjYSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750255875; c=relaxed/simple;
	bh=cUKuuxowFo1SZ9wawpwIJTY3SBMVpGZMBpEpAWMaqts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EyHqMzbQoY9MMVIOYzVmlP1/NecmYbZ5kBQ9pi/lz2HMPb9Rep8o7m2FordVuNb9V6KXgddPL+UNfEzlu6JCSvGP4i8+uSyfjIUqRzEOyMlSCUQ6WrhW9Rz2mk/BGKHSIEGKtXNITdIveSB2BE98CE5aAs15WE96rL/1/UCujgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=crQbKVX2; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="crQbKVX2"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1750253526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+Xs3mSWwiOpW/TKAW/a32e3EA51rUtpxiGBCMeOCZo=;
	b=crQbKVX2y4JSe09683eSQOfdkasLhpKvU6LGOlUbcT34eN0lu+nkTHw8RU3xyoa4w0OIh9
	bS1c++lL8p3qxRDQ==
Message-ID: <c8e4e868-aafb-4df1-8d07-62126bfe2982@hardfalcon.net>
Date: Wed, 18 Jun 2025 15:32:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ronald Warsow <rwarsow@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, conor@kernel.org, hargar@microsoft.com,
 broonie@kernel.org
References: <20250617152451.485330293@linuxfoundation.org>
 <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
 <2025061848-clinic-revered-e216@gregkh>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <2025061848-clinic-revered-e216@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2025-06-18 07:42] Greg Kroah-Hartman:
> On Tue, Jun 17, 2025 at 08:27:03PM +0200, Ronald Warsow wrote:
>> Hi Greg
>>
>> Kernel panic here on x86_64 (RKL, Intel 11th Gen. CPU)
>>
>> all others kernels were okay. nothing was changed in my compile config.
>>
>> Tested-by: Ronald Warsow <rwarsow@gmx.de>
> 
> Any chance you can use 'git bisect' to find the offending commit?
> 
> thanks,
> 
> greg k-h


Hi, I've just come across the exact same bug on my x86_64 machines, but 
unfortunately I won't have the time to start bisecting this before 
tonight or tomorrow morning.

In any case, the culprit must be one of these patches:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-6.15?id=9cc80b684b4f77d6c54fc0f1d34ecfe559838702&id2=f724d2960e671efa0e5bcb51327690f791923e4b

I had built a 6.15.2 kernel with the patch queue from tree id 
f724d2960e671efa0e5bcb51327690f791923e4b a few days ago and that kernel 
works flawlessly.

Today, I built a kernel with the patch queue from tree id 
9cc80b684b4f77d6c54fc0f1d34ecfe559838702 and that kernel crashes when 
trying to boot on x86_64 with the same error messages that Ronald 
reported yesterday.


Regards
Pascal
