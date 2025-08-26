Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E847D255E40
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756221181; cv=none; b=FMdWhhVYc0qnJygSngDCTWcLw27B7kYPJm/sdKV906RbsBJhUnuItijavZx61s1s7podLU5UbiUax6QfFvrffP4QeuqBjgkeJliE4NeNI2ToJOx2vEHslHUIJ1OBE9DgTWtqeh0ybNW3F+mwsRGGp2ZkPehRyO21GCwO578VCZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756221181; c=relaxed/simple;
	bh=HjxE+jvSemmztjLoeQ7Kor5bNdMkSH2bsJaT0LMpHpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eI0SpvOVtbe+L25QJ2uQycz/DE1xG9ub8Q8SK6rFkwgQfA/u/xyShpL2tkw9JarUX04lZ3y3U/rpEw+EehCDxk9sWdSLw5XlGWaD/+aeoXQNAKBISFZngZvMFVgjjBlogPKg5msQ0AxuCSWMSTRyYLa6sG42wHSY5KaDvU2K6as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=TrHWMSmq; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="TrHWMSmq"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1756221175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aicesAZaaVpnFhA0L0ibeFFVdIHLDSvHjGF2Ll7ru7E=;
	b=TrHWMSmqiV+s1hVsCIk5I5A5oFjT93mPLhDfiZ1ulNttqFIOWU9wB3Dnc2cNDs0GehgPVj
	Z2SzHEF7KbfG1TBg==
Message-ID: <fcbab36e-5812-4bbc-8080-4e48e35930e7@hardfalcon.net>
Date: Tue, 26 Aug 2025 17:12:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250826110937.289866482@linuxfoundation.org>
 <ba879776-f2eb-4e5a-adea-07aad8929d6b@hardfalcon.net>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <ba879776-f2eb-4e5a-adea-07aad8929d6b@hardfalcon.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-08-26 17:10] Pascal Ernster:
> [2025-08-26 13:04] Greg Kroah-Hartman:
>> This is the start of the stable review cycle for the 6.16.4 release.
>> There are 457 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.4-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
>> and the diffstat can be found below.
> 
> 
> Hi Greg, 6.16.4-rc1 (6.16.3 + all patches from the stable queue from 24h ago) compiles fine for x86_64 using GCC 15.2.1+r22+gc4e96a094636 and binutils 2.45+r29+g2b2e51a31ec7, and the resulting kernel has been running without any discernible issues since roughly 00:00 UTC today on various physical machines of mine (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and in a Zen 2 VM and a bunch of Kaby Lake VMs.
> 
> 
> Regards
> Pascal

Tested-by: Pascal Ernster <git@hardfalcon.net>
