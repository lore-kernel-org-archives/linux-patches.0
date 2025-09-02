Received: from mailout02.platinum-mail.de (mx02.platinum-mail.de [89.58.18.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2701B2DC354
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 19:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.18.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756840157; cv=none; b=SU5HSdp3IpZ0r7IE5ckk93K7tjOhf4mDTvUf/q6R9oHVPD6N0yYV3fybq+raFtcKssLn+4nbA/xvYR8qp5IZ7u/3Z+gTe7wWLL/Y9dmTYpPYCMjS7QQvMbwaqxwBkILE4dsldd2Ep5qPrXJ+jK9GpDRtLtRRE4Ax8S1vFdpFKrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756840157; c=relaxed/simple;
	bh=K1l5oCejOEuDh3FhRGVEX9+GHaNomT2a84vfKEwh1jc=;
	h=Mime-Version:Date:Message-Id:From:To:Cc:Subject:References:
	 In-Reply-To:Content-Type; b=IYSVzMEpuP5ZT37ShErEf/bNLpbm/xhlxthaSMI5V4qPqAS5W4rV+ypH0Gp8ogWBRRmDdEnc/VaZYKozGXvVIPa9J8AJs2IlRsd02iwsH6rDt9gUE1indd7r6LyJMXnEv3tPrUFoeOY8+RKqsaedYshtjMJusfxcuMkZDbu8VAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org; spf=pass smtp.mailfrom=achill.org; dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b=PNC+nvnu; arc=none smtp.client-ip=89.58.18.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=achill.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=achill.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=achill.org header.i=@achill.org header.b="PNC+nvnu"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mailout02.platinum-mail.de (Mail Service) with ESMTPS id 7D56F9A292F
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 19:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; d=achill.org; s=mail; c=relaxed/simple;
	t=1756840144; h=date:message-id:subject:from:to;
	bh=K1l5oCejOEuDh3FhRGVEX9+GHaNomT2a84vfKEwh1jc=;
	b=PNC+nvnu8nezUL9CnaV5zFrgX05BsTiIKEbC+aU860PJZNm6QGrEQVhO5zgprS6AOPIrMVU/+96
	bw/IzbCDtSXDUCuIWOT7AL+8oRs3+QbQCns12hzZb4rwINqFZyMPC2JLeZ9cIGILMQMyl75ANj0sp
	ldR9jCXnuRG9jXvx1qqPYRIlLiWPa0BGDBRhQanSLEvnJCZzm4AL8hhceTwwmKBXpLy8Rbom/tzLD
	5kSUMANx9WBqR31HrXei4HuCzJIkA0hzxIV5K2rUCCjBN8DIEPOyRAsvnjB4lt3GOSeXuSt2TbMlw
	L8PH+eLsP5JyhIAkSEYXX4JYHyvj7CcBlpUg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Date: Tue, 02 Sep 2025 21:09:03 +0200
Message-Id: <DCIJUS5KX4CH.HI8OMXECSDB4@achill.org>
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
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250902131948.154194162@linuxfoundation.org>
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8

On Tue Sep 2, 2025 at 3:18 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.5-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Builds on all Alpine architectures & boots on x86_64.

Tested-By: Achill Gilgenast <achill@achill.org>=
