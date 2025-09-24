Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EDF3064B1
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 14:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723795; cv=none; b=cw8P7thkfe8gu5Z1LGmREGMXTepOLEKSxKN6rWMhgHWjXHY/PjWJWNqRh9cNpDTzmqo3KrjEJxqnT9Uk9efXLG6Y/ApGuNtkU/gmaWIlDFs2NkOEacGXSSbgKdTukMQjbWRuWP8f+3oZhIaXfLLg7PfPHkeQ62rdMgpglII4A4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723795; c=relaxed/simple;
	bh=19kB9OlVKaPtRowoHT3FawWYCxV9ZGG5sXbMcR8rUiw=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=KaK6srNnkxyyXPAEDg/ckZFG6JM/lgl0fe4NzwXiktOvGGB8Jwa7EfxbpIaAmphif6YWXHczB9Ooa533TSBORUZsorLU4X2Tq50w3loGsn4f1mQTFd0mSaq1n90khE95JFsXGVmJWhKka6gGrPnCHJBDkzmYOIJukASMOWJFpjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=RPonkm32; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="RPonkm32"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 9E1D79A2932
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1758723782; h=date:message-id:subject:from:to;
	bh=19kB9OlVKaPtRowoHT3FawWYCxV9ZGG5sXbMcR8rUiw=;
	b=RPonkm324wKf2Nm1QREuTdPdzmqfSWIKNWRMmGB1uh8kpo2ZsAM6ylUkBgsJC9Y3xYcjtLR2dGr
	CcRRQTNSu861a+IvSFXzt+IRKzNJ1z3NONa9X27UNLR43FadGAtM4/AhidxX+8KPmKU5DX36jkcii
	tdvEhnXTaUNQ74TPeMY6QS4JOJ1e2VUgU/5LQRCm+Od/o1KKdXTrV5p/+ICHMKrGYlwza/8amQqPO
	VpV8S4P6qnBuPaoGM+VqLGtInHvB6wKpxZYBoUZgqyEpZGtiOz2QkIMnX0+kzcDk0Md2P6ZqOXgPY
	7qD6szt5dwChQDT1KuHlKiFxwtktL0dOA/Tg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Sep 2025 16:23:00 +0200
Message-Id: <DD13JR1E3XXI.1VYKY4H9OA99O@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250922192412.885919229@linuxfoundation.org>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Mon Sep 22, 2025 at 9:28 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Build-tested on all Alpine architectures & boot-tested on
x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
