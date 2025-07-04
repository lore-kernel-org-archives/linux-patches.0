Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400E528137E
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751614982; cv=none; b=ghuk0DrI86xUzi0YInv0GiJZjC3Oa2FwB6uLqQRx/VYlr2PrHuw8CK7+U1u6UymiB0nZuaMezHHOCeeYO6ItB4v5sX/sPixiiZ5GIFJTjGq6zgBmOqu/CUxZyJ6sN0SLl4rmvBfmIJBLX7CXZeoVqcdimWRVPD3oq1qbjAlrU1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751614982; c=relaxed/simple;
	bh=GMM0SntmXu3sILiKGRNti9amYKDqTIBA0A0DDthe6Gk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=H4+oDXbk60Oj+SEHTEl0+gsbl1sghEbxXMmDBYLqe69UnJw7IcdZZBbmY60aHoZDsDI1Db7yjU2iXbodzwr+o5pLBGS/NIoFzmPhs30fVNU914rgQ84Ay7ycrs/ze+bg4k4gH7AiUviSAdLLlaZBMqBhR+bM8iornD63izm+ynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=fcGu3NR1; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="fcGu3NR1"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 95FC57D3B8;
	Fri,  4 Jul 2025 09:42:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1751614973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYSd2l3Rao0PJOcYzgtrpjT/qoSvDKsq6vkzebulN98=;
	b=fcGu3NR1+7J5WBh2zxJp6sMzeZzFVJp/aSbbzDKYEMs446XiMLRsRE9Y3bmzNcs/Yfcp0K
	akUpOYDX63YEgeJC5tjYV9Mu4ZwAfeB35RSu2fvb4DwrkUZwF9cDxdUf2BaccnxjMl6YWO
	/zflOWDnlXKweuRENHPB4NPgywAX3bY=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Jul 2025 09:42:47 +0200
Message-Id: <DB33ON4ANDZN.AX2EUQQAI3JX@pwned.life>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250703144004.276210867@linuxfoundation.org>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>

On Thu Jul 3, 2025 at 4:38 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Tested-By: Achill Gilgenast <fossdd@pwned.life>

Build-tested on all Alpine architectures and boot-tested on x86_64.
Thanks!
