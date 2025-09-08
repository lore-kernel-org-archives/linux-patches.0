Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E0F223DC0
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757317137; cv=none; b=GVgqwLbZd3nmo7K/dOB9yQmj3EB+H2LpiRkQvj8lUc+lh7gC7ghdp5lHYkRXvBq0MA0FWSa40CAdKrhVdnqH2YqF1hjjSK55afbEo9DsWQRhpnl68iqaPpGahJ8+BNyxSBpZ5oteKrwzSBGw33VIzySqvkSw7h8vkH7ppjps7tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757317137; c=relaxed/simple;
	bh=XYXznLu/zaBSaLvSIy/jzKBai21AXuNxIa28T8/Ha7I=;
	h=Mime-Version:Date:Message-Id:From:To:Cc:Subject:References:
	 In-Reply-To:Content-Type; b=McrABDIvHozl0oL82vWTgb/Pxxn5dwMYduVhSJJqmMxrTta1Xg0E5AXqUw8MiblESSIGUnmum0xmQT0LkMQt4sGo9pwPa61pPRSocE+Rd31M7BLMnacgkZC0eIgXUvCG/KQk45R6GxcmrFWc3K215Tzn+e92k6YpzUDCtigS2kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=L6FMUVYD; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="L6FMUVYD"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 0D3F19A2933
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 07:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1757317124; h=date:message-id:subject:from:to;
	bh=XYXznLu/zaBSaLvSIy/jzKBai21AXuNxIa28T8/Ha7I=;
	b=L6FMUVYDmRby72U4AUbIZEuzEm3NoevEE71kAF4PgyTgHnHqu+ZY6UWpyfmDf5EFAhUv9Esj9vo
	usfGbvsJ1akYK98CHI3+FGWFjkoTKUu3ozlG5AOiTLMGDn5Fd5Kq1Gohm8nYcKHVcG9Vr/3vYaJKo
	D4OYhBQVCoaltqpHUee3Pkdt4ftl91ym9LFTp+3jkJ7mel7qyzf5zWtrZxdRJZNqhMvbhSdU9mMh5
	/qxTgp8JArBAahDgrbu0FObN+hjAvN/0IF0WssMPsO8aUyAhX9pIrp2wfSRw3n6eGo8t3wEi6tkbH
	/5o6As9oePvYQTw3YFYwKxr9uFkTiEqqBcNA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Mon, 08 Sep 2025 09:38:38 +0200
Message-Id: <DCN8XF4C6915.OQV51LHSTDKL@achill.org>
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250907195615.802693401@linuxfoundation.org>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Sun Sep 7, 2025 at 9:57 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.6-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Build-tested on all Alpine architectures and boot tested on
x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
