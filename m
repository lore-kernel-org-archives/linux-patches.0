Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74282AD2C
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 20:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764794604; cv=none; b=l/11Ml4Hw0L4LkoTfADIgYpmNLxFGf6TYk/eClKS7L94n4ABdBcdFNgCD68idrC/m9P0c8vzNWgrysxQ/wPt8UXIm8ZbC7/T7GZF0ouYrFFe4HE9QhRBHul8zWztqgbsgv1VHy+/zLkTKqGVaKWe+oxrLA8tuQffC5jUmZyVQ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764794604; c=relaxed/simple;
	bh=uChY98SMxaqGwShhbtHMgtlQwE+YpKuZEtJ8qwM1jhU=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mHBMTWgnoN+rVjJVvapSAq7h2u6Prshx6S7TNwuTjDh/Y9FNSyGk2Tfzgn9JPGMmiAvaR/rIaDYfU7/o/rHI4jjOjT3x9nBI7f9EA4Q9Kqme/Xlv6uIHq0W10jV/GJZ82HfGngmMHl1DNt5k2nRUgd04xNknFRkds+GfcDZPuhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=KzcBhc7T; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="KzcBhc7T"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 00DC49A2936
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1764794206; h=date:message-id:subject:from:to;
	bh=uChY98SMxaqGwShhbtHMgtlQwE+YpKuZEtJ8qwM1jhU=;
	b=KzcBhc7TlvuTIaKuwqvdDFZr3Lj08dMUZV/7J4m6hUpIlGPBRUYsprndzzEGNxfpm9v1rNa6pjq
	LCyAnHD9vNCSarn3AR58uoGEgQnCEaNr8GRDTdmdyuCjNP9gzIr13s/9Dg9DqeLwa1N+OSKDV/rT7
	6P+MBXMiqVLwUK77fR8X6afeguhf95p1xW7neAfM8AniT7e2Abo2uDRcnkht7vMMk0dMi9Mzg5NVl
	ITmkJEUYnkeuu2Ducb6DQepqKoj8YEm0qnMrK20P9rE7L0RnWE8KH+StcceRnjA9FPd1q5Gy6dDLe
	EI0riqPDA4QqgOG5f5tWEA2JYzw6khFGhCaQ==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Wed, 03 Dec 2025 21:36:45 +0100
Message-Id: <DEOVC1VVO6NU.1DAURHNHDPIPX@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
 <conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
 <achill@achill.org>, <sr@sladewatkins.com>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0
References: <20251203152346.456176474@linuxfoundation.org>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Wed Dec 3, 2025 at 4:26 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Builded on all Alpine architectures & boot-tested on x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
