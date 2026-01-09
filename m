Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE6C286417
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976419; cv=none; b=U4rPXY96RCSlJaivZqSTg93/lBoYM30/vHoTLrCxKzZDJ3xKtC2H8j+M2Ghyxjro6xLBKL4XtplaxZ0FAaSuydTcm2aGoC/oUS7I57/28K4U+ccngCsBWEtm/j+1GvBAzzRdURvFlnfuLe74S0zXiZYjTpfAdUwic57pYt4CuXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976419; c=relaxed/simple;
	bh=J556trm/0nvnUnXTnYYJdZLUYJ8kDq6PBKeOWmSkCQU=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=dYz9dILXxbAf1CMweigXxUpQ8sN5bnA6QQ/9KENda3H3CQCS3bxOQ2tRTpO636l0HlKBM3kKkxG4GqgH4b+KBwpQw4+WgzPbtYdNEyE8s1J6kCHauYFBgNDjO+HLPyBqtJLFZoNLOG+DrCk8DE5pXOyY++ZpGRMsJc099sanOYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=J3S9Z/kK; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="J3S9Z/kK"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 63A719A29FC
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1767976008; h=date:message-id:subject:from:to;
	bh=J556trm/0nvnUnXTnYYJdZLUYJ8kDq6PBKeOWmSkCQU=;
	b=J3S9Z/kKIIzUGOBikKAil0E6gXTL/tsMZahFCMdoSTSvwaF2S7k2dvgQRVj2CqPXsaMYZq+2Zr8
	rgl+xnY5dwOKiEZEnxOeC70iZ/hOTmm396ovS5ac+ljkYiEoSojDvwLPKdNojny8+K5nD2E90buoe
	kcRukT3FlwbSdB0RxoSJZHxtL4gYwEWzqoKyvBpx3KxKOFb6JKPJ+B/vHq9inSzmWEbfYpdydzJcg
	7aAQOHhB9Oc2idTmsBnztQaPjMqTlKf/kxWUXcbfcQ3ZcNsu+ar3PDv7NIx2mOLZmxvjqD5fWbSDt
	FPljtwLOWUzNLz4KKd7P4Cbf5yRD6K8tcueg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Jan 2026 17:26:36 +0100
Message-Id: <DFK76OBVZWDO.14E27I3UHXSWO@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
 <conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
 <achill@achill.org>, <sr@sladewatkins.com>
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0
References: <20260109111950.344681501@linuxfoundation.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Fri Jan 9, 2026 at 12:44 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.5-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanked. Build tested on all Alpine architectures.

Tested-by: Achill Gilgenast <achill@achill.org>=
