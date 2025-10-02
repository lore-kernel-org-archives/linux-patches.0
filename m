Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D167D1DE4CD
	for <patches@lists.linux.dev>; Thu,  2 Oct 2025 07:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759389275; cv=none; b=D9zC/RJuHx0C2xJTGC3p3ESX+6CqGGrK/fw+5ld0ULE7XqRU6fFBvdUj6gLKYsGuqUZHr/jV3wCwbjZF4EUoPcuk4s/lrNn48wry8aq5TgSir3HIPG6QGbpi0X4zVul5lC7hSo5wUfTKFddyTLopdJf09GxOMrMiLMQni7YXBGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759389275; c=relaxed/simple;
	bh=0WAJODxkaYC78/NXZIaEHtRUIomp/HSODLWOq7855uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NJZEFDXSTTmjsNW13WTtu9iwyJvPRiF84IU3TFFyQxzyo2YoDs6wkALx8yM8y9r9EaXt6xBATplcWyew/iAUbJtVUYY8BZrNR5EYheszNeZW2AwRpuPC7QHeNnvmrpiIjlRdEJAJmQhIVeUZGJT1Y47sZ5VRN6wqI3pSycwtrqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=Q02HJgOb; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="Q02HJgOb"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1759388799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFSIsK6zuip8p2LTNK/t+i/Ri0Px578CxGOu8ko/byY=;
	b=Q02HJgObtFq4zjausj5FHmyhqaMaGbzHEexGa4ngJEgaEDsD78AWiCWKGGC3Z2mE5HdOMV
	4v8XRVe77keAQSBw==
Message-ID: <304181ca-daa5-4866-bf80-28653a064958@hardfalcon.net>
Date: Thu, 2 Oct 2025 09:06:37 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.852512002@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-09-30 16:47] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.


Hi Greg,


I've applied all patches from the current version of stable-queue/queue-6.12 (commit id b249cb4d7eedc179382f657819c5ff4c55230b44) applied on top of kernel 6.12.49, compiled the result with GCC 15.2.0 and binutils 2.44 as part of OpenWRT images for various platforms, and booted and tested those images on the following platforms without noticing any issues:

- x86_64: Intel Haswell VM
- MIPS 4KEc V7.0: Netgear GS108T v3 (SoC: Realtek RTL8380M)
- MIPS 74Kc V5.0: TP-Link Archer C7 v4 (SoC: Qualcomm QCA956X)

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
