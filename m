Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16B3433B3
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 10:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760870180; cv=none; b=fM0o2Ic9ZUzNHi+svJ7lA8/nd29c1naN+50Ng1vYeptd3UtyyJ7NMEBuEXWjb6ueA5uJuNI9REIuUKQ9XdZvVBUpZEsCtfEixN2DCNwP1mwLlodLDgbU9eOZU8JgDpxGFSsGuFtFTLeERa2QOMhDn3ki3HGuP2EShXZSfkyG0Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760870180; c=relaxed/simple;
	bh=fzEoJJ4oSyDi9YjOxhY+M3q7SLNQDvwJrccCLfpfKcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmIzrPS6rl1YL4rKwK/HGA82qcqPSyNMAlzoNXGCJf1BPdGc62SWrYfaZ6JxS+gNr4f1unMjdhBLgeFfudKRYMmtsil2AqhuXlkvctCSXOXYtFd2EZc4UzWiCWNHS32N0QzBhXuY1UxirPea4EtCUDogAs5e5IO3g3nVwoY7n5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=lbrRGSbU; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="lbrRGSbU"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1760870164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FQe947/O9iqYlutvzargj2o8S0Aol/h0akSb+s1b1Vk=;
	b=lbrRGSbUia0Jb8WUNgKVUWcJLn7/dTuM7f4hLQxeitvpXCEqpCnBYkm9K9X4cNkBQF3K/F
	Dz7hn2jV4RJeitCQ==
Message-ID: <ecb16a51-8ea7-4abb-8ca7-c49e349eca22@hardfalcon.net>
Date: Sun, 19 Oct 2025 12:36:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145201.780251198@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-10-17 16:49] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
I've applied all patches from the current version of stable-queue/queue-6.17 (commit id 11094dba5f8d0df69938f47f5edc5472ba790eca) applied on top of kernel 6.17.3, and compiled the result for x86_64 using GCC 15.2.1+r22+gc4e96a094636 and binutils 2.45+r29+g2b2e51a31ec7. The resulting kernel boots and runs without any discernible issues on various physical machines of mine (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and in a Zen 2 VM and a bunch of Kaby Lake VMs.

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
