Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BD3330D39
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 19:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758136481; cv=none; b=cRrXxlBMmWIylb7g1amIvGUc4l9tMz+xoMnuxJ2dT9pUAHXM0x/gjIyPiKRcBr619hTCJ22eWmo0A+c7fChk0lpPL0wlslCddQnyiFBsh9ekAUE6oaq9LOFfLIxPR8FkbdzDvc0pFmvPOxeaUCReZUFXrtdkAC7zO6N/5PcI0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758136481; c=relaxed/simple;
	bh=e4+uMr+jK9MjVCUf13Vcm10orDiY6sPPMMsrDnuNaz4=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=shdzmbwKX29ZokmWW0X7gwytL77bEl8SQCx2aU0qMl478uE5GkmOuo1r8zMm4f9cisPRJbHAz4RivgRDTQZMehXvXsh0fV+foItsv+jcv9acBd/eBnyZbfT7r/1zpIVOvkY1LTAue5dglMy7LlQ8EmWzxXgFkG5wOdOyobByEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=benAjWNm; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="benAjWNm"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 962469A2931
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1758136093; h=date:message-id:subject:from:to;
	bh=e4+uMr+jK9MjVCUf13Vcm10orDiY6sPPMMsrDnuNaz4=;
	b=benAjWNm+xrzfUO4QFHi+EseWDJm/N87fcCPy/+elvGKRsPsMRjwtpuZDaFyIjQ2sHaQvwZJ/Cx
	RTS+racLuez55ElZMMXEkKT06AvRfgU78R9vCQfwKt4RrEb62jnKA1sntaPk1u4iz1v4rIkdTv6+5
	u1tcYC5s54Uj8QZNP9SXPzSoBZ1dprhPGzb9HYLappJXUpfP3OKHIsBJjS9JP36dNj7pV005dCaFr
	co3qlAGSbiwiCC6mejxfyHO7SUw5xdb+LIDCDnK/Xzg70vwMGSaAKtmTNMR67Qv+I43OrEVeCOa6h
	HJ2Yx2MOA+OWwV8Okkyop6N5ylA3o0AMl3RQ==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Sep 2025 21:08:12 +0200
Message-Id: <DCVB8AY7VTYK.1B8UFEG97596N@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, <achill@achill.org>
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0
References: <20250917123351.839989757@linuxfoundation.org>
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Wed Sep 17, 2025 at 2:31 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.8-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Builded on all Alpine architectures & booted on x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
