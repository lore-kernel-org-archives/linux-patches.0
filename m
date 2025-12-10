Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363F2D94AC
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765375288; cv=none; b=kfvaMjm0+dWdjgUiBFC5EV2WZ8nBo/k9ZGzArK657YohWEFy72C+WOwWj2RxTtyT4cRENZf//zKngR7v7sWLTpzzb2/ICoRV3RMJF06YqyReoKtlWfhEHWnOkrlxKaEhwvbHpvDgGCCXaR/gJIkVHAhR7Jc4mRXPXW3YSKs9ZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765375288; c=relaxed/simple;
	bh=u42IODHUWqTOVJ/z9HXUeA7qPM3De+e11W0WYds3r/4=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=D43o8Ibo3QcY8eL1wdenayPYYJmqShvR/aDjYQY1KcRsPJymU+WN1At8ZybdK21AsP7gBiZCIxiznbWxKYrDdElgfSA0q6/09UoYFePH/05OpYhVMHq6v/xbnXcFJPjcPT+L7jY4pVcSIsJqpU1SEj4mpYXLkhEgZVV6p4SXMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=o4rxD9o/; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="o4rxD9o/"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id A74AE9A2936
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1765375282; h=date:message-id:subject:from:to;
	bh=u42IODHUWqTOVJ/z9HXUeA7qPM3De+e11W0WYds3r/4=;
	b=o4rxD9o/xCzvf3cG1hMdxHlIJ/gc9nomAbRzLZZmILUdFiCY5M9hDpRwF0kjPUZDiSTi9e8v8YY
	sBpJeLjTj8u085HUwUZvnPKHHO2mDazRN35yOUU6rxYR/PgjXvtSNJR84bgkjL7rJpslDKgX/29JB
	oiBHd/xLGPy2kk4xWas334ljhuDl62T48dk8uRcmkRMY+YTxTZfmZqZtL0ASSMa4pn2pHn98nGkk+
	xjKDVZxbUstWGn4T9/xBSmqFUn66wf2D7wGk/xq1vHeETFbgUWfmZlIJ7a0Osmp96EZIK+J6cffnb
	O+kJYJlu5ljnybHrad7l7Vh7ZqzzxaCvoibg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Wed, 10 Dec 2025 15:01:19 +0100
Message-Id: <DEULB39PC2JO.1BLSTXKOE0HRY@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
 <conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
 <achill@achill.org>, <sr@sladewatkins.com>
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251210072944.363788552@linuxfoundation.org>
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Wed Dec 10, 2025 at 8:30 AM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.1-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Build tested on all Alpine architectures & boot tested on
x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
