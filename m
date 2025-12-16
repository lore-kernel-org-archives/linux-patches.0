Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3E7241691
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 19:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912689; cv=none; b=D/WkeJVAPjABZ+4jYiH6uRkxK1di8rEbptLZeYgyqNP1T36ihZr4SxeAIcetw+3B6H/sg4SPxYTPeuL6a78TAo9lfPm2MyHBRX1iBm9Vlh0w/vPNhrpMNbM901IJX0cJiZZTApPbzpUsqrLKnYVZzTabraDsuekAE+3Sis9SneE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912689; c=relaxed/simple;
	bh=GikYVmqqxhjxJgm6gnrt4GXoCf0a/2j8+0kyUxo1+pE=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=KUIs4jjV5gttHcdvpe53n5TyWpVW7gDFG6fEKCSUtNPeaQU53HGGIp0ILiWm0krAvm9wyRavbnZpwf2VD/EjXCuMFx2xrGotQl0sr73unvbdbDJB/vIF5kMzbd69oHpqhm3v/7XCbfyVwWxHkIaub9gSu3chfRs7P+iKNO6ghsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=SojeGptb; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="SojeGptb"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 83B5B9A2937
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 19:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1765912676; h=date:message-id:subject:from:to;
	bh=GikYVmqqxhjxJgm6gnrt4GXoCf0a/2j8+0kyUxo1+pE=;
	b=SojeGptbML87R5IYDq7PV1qkKiyCnazxLnbbd5Bs5RoS9+kjyLiWBsKJ60dd2ZIN6kqG+GzEN/I
	5bmYGfGN4lOS4c/Gncxn6bF5dEdp7FeNHhPz+YUBcZLaMm443yaYXKfJTFofeu8peZ5Y986qn6vA6
	DQvkziM/fET0zjlLrhXPObbJw6CwrB8RvNp47azJoYJr+tymijIwG+qYbmAe8lznPBx8Ta6VUDpej
	gRJJLd3RVpDkEhVeK32MU7UBnbefFanz3ueRTsidvZikD+3n9MdFXISWH21YjIVY0oAMtFpGV4Mv8
	3zxwIDrx/PoVUibSiK7/UcynCeFflFzl1lhQ==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Dec 2025 20:17:54 +0100
Message-Id: <DEZVSR85OD3F.SUN1BKV73WI8@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
 <conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
 <achill@achill.org>, <sr@sladewatkins.com>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251216111401.280873349@linuxfoundation.org>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Tue Dec 16, 2025 at 12:06 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.2-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Tested on all Alpine architectures & boot tested on x86_64.

Tested-by: Achill Gilgenast <achill@achill.org>=
