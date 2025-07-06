Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467C2AD22
	for <patches@lists.linux.dev>; Sun,  6 Jul 2025 06:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751785001; cv=none; b=WE6cxgEvE93oJs80XTmSz0JPFIKhKwvBtD8XlB/KGbWylxkDTszuXqMBkQ9PTE5Vrfglfek6poMXgCqIG/gCKknnpwwakX/b9ktAXBQc/zdPGPCIxKBX+9HvVfl/EVKDv4DlJAPNL23oCAF8ldUcdIRuvc75AS4rMDqcyoQFJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751785001; c=relaxed/simple;
	bh=uZFJ29pWr65nZG2eR/m1SERZQlCuNjsfXl7Glk1/KwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uUu96f6CHy8AJCGKv+xuQXE+/jTKyZ2J1RbNtUkDyavwjt6+SerW8doRm0gW/BF5UMquq3eMduS1/YaslyjWdWqaf3rDECGDSnqUaOWuisKJfUWW2IDe0whsjRNbdZODcbo8NrT87+ncEjSnzPULLmeHpnOG/JSxyFG7tC6wqq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=8GodubLA; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="8GodubLA"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1751784995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZFJ29pWr65nZG2eR/m1SERZQlCuNjsfXl7Glk1/KwQ=;
	b=8GodubLAggmg7ZnywHdHCb1H0QSN97Sw1/0yTf6Gbe7zVMpRPdG4vZoFLhyOKMCuU/KHGV
	9SDGBm6AbfulzRBw==
Message-ID: <3f9adf2a-e360-48b9-901d-ecd96c10a620@hardfalcon.net>
Date: Sun, 6 Jul 2025 08:56:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250703143955.956569535@linuxfoundation.org>
 <3ca03800-3d4e-41ca-897d-a0d05d6499ba@hardfalcon.net>
 <2025070618-outbreak-badge-bc22@gregkh>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <2025070618-outbreak-badge-bc22@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-07-06 08:51] Greg Kroah-Hartman:
> Yes, intentional, I only do new -rcs if people are reporting build/run
> errors on -rcs, but we drop patches that people ask us to drop or fix in
> the queue without doing new -rc releases as that's not really needed.

Ahh, makes sense, thanks for the explanation! :)


> A tested-by would be great if you want to provide it, thanks!

Tested-by: Pascal Ernster <git@hardfalcon.net>

Boot-tested on the following platforms:

- x86_64: Intel Haswell VM
- MIPS 4KEc V7.0: Netgear GS108T v3 (SoC: Realtek RTL8380M)
- MIPS 4KEc V7.0: Netgear GS310TP v1 (SoC: Realtek RTL8380M)
- MIPS 74Kc V5.0: TP-Link Archer C7 v4 (SoC: Qualcomm QCA956X)


Regards
Pascal
