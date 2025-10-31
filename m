Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1683A2DEA74
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761951069; cv=none; b=LSgItnl3KVgXA2viZrGq52/db2gdwaVaeEs3u1dmkMsq2WugsgVOsVJPYO9telUV6mu1jcL24pJsVaFuvFwsVUGeiMcFCVEE29V1s/Tj6hrSrycVQpVZ7Q7LJHc7a4mdzAEKRhEZKpCnC3ZPjXpYi655sOKjWGxdO5WaimjlHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761951069; c=relaxed/simple;
	bh=gv13ZOBLu/+iAJtGNfzjmapjLzIBmNZI4LhI51G4IMY=;
	h=Mime-Version:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=r+FgWl3dG/py0UEvh0dfIc+IMwqlx2WKQUec3ohafJh3aFWGTHhddU3P8pvLoTB+pyghIXUcwiwHZX9e/XeWwyd8sBVLOB4qjtSK/+X2e0smTyq/ubtKutav+yXGbmy19bJ0TkVMqa//ZPIYf1TnYWBr15j+02I7SLySTXr1QWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=UZIW70wG; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="UZIW70wG"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id B85619A293E
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1761950754; h=date:message-id:subject:from:to;
	bh=gv13ZOBLu/+iAJtGNfzjmapjLzIBmNZI4LhI51G4IMY=;
	b=UZIW70wGA6wQkkzJ9ZSpBEKMhJWAfRuIvIEvDWQWjTtqs2ojY4yF/Foo7i21ip997hdHNquPZD3
	oW2oRb9bK2d5DRJy4L9NNuCGSBGPKiZ8DNtWuEewU+Q9sZ+P5w9GgewevFd7bJsrlyLPdlCsyzTem
	ZVZLX0xvvEYn8qY170PnhsP0MpTOPA+DVOvdLiaV3IwOCBRMHl9ooXtiss2QHRKi+4Kwps35LP8vo
	p39p8pYVATEnBZE0tdCauhuTfd/0Z/tydR93DIZStL0L/e4M8oavBirtgPpyf03Loy6aLCAlnK1LD
	jKd4TqWw54bhSPaHoF/irtC8V/wrG7IOKzKA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Oct 2025 23:45:53 +0100
Message-Id: <DDWVEXY1OTAZ.29HESPZ5XG9UH@achill.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
 <conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
 <achill@achill.org>, <sr@sladewatkins.com>
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
From: "Achill Gilgenast" <achill@achill.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0
References: <20251031140043.564670400@linuxfoundation.org>
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Fri Oct 31, 2025 at 3:01 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Build tested on all Alpine architectures and boot-tested on
x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
