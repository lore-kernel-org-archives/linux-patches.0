Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE802E370A
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751723446; cv=none; b=XJ5r26klOTkK2q4qAwrtjKuvqzMiuGyroZBPk2oLG7LZtAN0ejtB5kmZqiAT33hcoVj6FKpAOmTlyGp6B67b+sTkEzEALsyM89uyeQpTtejTCFvc5YQTLMcxeWvetqctUzwjROEWhqhDR+9AYxkWBpBJJZRsnNAmKfINserdMSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751723446; c=relaxed/simple;
	bh=KTD4FLxcO6O3F0Uz06MomQx86VnuH+P6EQI0R4x2o38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tB/BEUB4Zx+OrnRsIPlVV5wjcHEH1mmAng+bKWgFEN9dfJ8n7VteqwoRzeg+eXMWnHcMKLKAj8h3agJ48/IFL5w+jTPWSKcLPBwVONpbAhfparbC2kzcCT9elRC0zpP7TVSrEPDZb/NTBKizQCqzZSEJK/lqt2KdlrFFGQzQzgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=Cq2sO6mj; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="Cq2sO6mj"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1751723434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9LH4y+MMMjaudgXUUhlq8KLlA1S4bGHYgtofYcKGx1Y=;
	b=Cq2sO6mjQJLVOIgUh58Iy9krdhDPfz92QS2Mp53xGH1B8n+pytHwpuwmz1eX7k5MKMSnN0
	5kzxIkn3vXqDt9CA==
Message-ID: <3ca03800-3d4e-41ca-897d-a0d05d6499ba@hardfalcon.net>
Date: Sat, 5 Jul 2025 15:50:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143955.956569535@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-07-03 16:39] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y


Hi Greg,


there seems to be a divergence between 6.12.36-rc1 and the current state of queue/6.12 or stable-queue/queue-6.12 (five patches dropped and two modified), but there doesn't seem to be an rc2 - is this intentional?

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/diff/?id2=08de5e8741606608ca5489679ec1604bb7f3d777&id=4c3f7f0935ba0c1ca54be4e82cc8f27595ab8e61

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/diff/queue-6.12?id=c0bc2de2a5416da11ffadb0d10da975d1bdb1ada&id2=e1bd69ff09807d5bf80f17f3279240cb223145a6


In any case, I've applied all patches from the current version of stable-queue/queue-6.12 (commit id c0bc2de2a5416da11ffadb0d10da975d1bdb1ada) applied on top of a 6.12.35 kernel, compiled the result with GCC 15.1.0 as part of OpenWRT images for various platforms, and I've booted and tested those images on the following platforms without noticing any issues:

- x86_64: Intel Haswell VM
- MIPS 4KEc V7.0: Netgear GS108T v3 (SoC: Realtek RTL8380M)
- MIPS 4KEc V7.0: Netgear GS310TP v1 (SoC: Realtek RTL8380M)
- MIPS 74Kc V5.0: TP-Link Archer C7 v4 (SoC: Qualcomm QCA956X)

Not sure it that qualifies for a "Tested-by" though because of the divergence to 6.12.36-rc1.


Regards
Pascal
