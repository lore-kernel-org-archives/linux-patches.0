Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3884C2222B1
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 10:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739528793; cv=none; b=ht3sYvjjxqyA10oNgSi5bQx0f858purBHrSiKucwdPggAenDL4wZQjTEeW/sCIsHoKesjGxwCkqa3czSLeSndcu4OAhVr56vAM1RnFhyfoZ4QoEpI1t50AlSYgteI9JGtrDQTJViQ+WOqYvjexPyVsEwTKW/+ozgoXrPS5L3NMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739528793; c=relaxed/simple;
	bh=GjCwZep69xupRoRACCLLb5DVGAvTPaPxnLIdlN9pf58=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=Ym2mgv5Wj10+JGIeEqcfQJyxYPa3SJG2n5mbXRqf1GkaTs3HZN7uvT59wGZZV87HMuAMklyjYDpWqMV7kNLcacQVkUEFeBhLTx+cijF/KZcwwgtNKA4TBLCf37yoSADDju6wTppW29eVMez4RP9E2LhgJ3LZnT201z/G6xXIvDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=c3D3B+ea; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="c3D3B+ea"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id D408D7D3A8;
	Fri, 14 Feb 2025 11:26:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1739528782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F6RQVsIU4bbHGkbGX+1jAhfrBhEN30MwRCLRDWkB20=;
	b=c3D3B+eaO4Vk/VGBCZgQgYgmnlzhMd81HKrLAJEETI4gxAX5VFbN6zrhcp+Q9FsoLXi4Kq
	aK18yFDaCKbZbtEdtoFxHM0iRMrKj+HxP4rScgQwJXLl+wXLqGcaKwa5NOaUOn9J3SePEy
	XWGxLkefJWhUTDbarZ+pEfEWiUzyP5Y=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Feb 2025 11:26:15 +0100
Message-Id: <D7S3HJ5TS25F.PLI2MONK2TSL@pwned.life>
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250213142407.354217048@linuxfoundation.org>
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>

On Thu Feb 13, 2025 at 3:26 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.78-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thank you! LGTM with Alpine Linux configs and packaging.

Tested-By: Achill Gilgenast <fossdd@pwned.life>
