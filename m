Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE441EF0BE
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 05:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225914; cv=none; b=bga+lkOzIx/VN6xeuNTFyZhdEiwmI4zCQKu1cp1ERYxMLa1zhu+g8S/p+kHqHJ4qLe4Nwm2GiLcx3/w+X5y0pv6KGJD4yLQF5veIiFz+aIuRI4/DszEJInj3LA1HNP2PBmPwGyszoGrn9eJfrbeKNtbHSrAtCht9XSNA+EC+yho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225914; c=relaxed/simple;
	bh=VblScn+VHpVJ5tYvYcoJfh8x8io4nmUmEEvEpkfw98w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=uv3zxGYpj5Dbhs6hyREDvJd5fSAesu5JhHXt/lH//vIEf+ni2wk7p8AFumwaM/Tkxunpm7d3XejLXqDLGe/p7ARaBeTJ5hkNjWoY08XgDu0cInap/xSyW665EUoKB06DmS9Ub+rhBxLGc5pWVxbb5pfTrCb6uPfNMHgpuYpUhh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=SbfxFKa3; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="SbfxFKa3"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 3FCBA7D326;
	Wed, 18 Jun 2025 07:51:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1750225903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtrHyj1OhX8LsdJLOiGICZLEnGht4gXw2jkwnEUt48g=;
	b=SbfxFKa3e+ahyfmz4k8BXmkNLpjVmEvhqkTh7/7Umki6SYiLOpiczRdoWphMnCO8cec6Xt
	CAslcSUc1Rp0zNkXB4wCca0Rybi9WtcFXD5oJbBbG5ZfuqtyRGOmK+c1ycOGXISj+C4pIN
	Gt+qU8BgC/2q6eLSTapaZLFiasoPSmQ=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Jun 2025 07:51:37 +0200
Message-Id: <DAPFATGF5VF3.3RCRSMSFLR5SM@pwned.life>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250617152451.485330293@linuxfoundation.org>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>

On Tue Jun 17, 2025 at 5:15 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.

Tested-By: Achill Gilgenast <fossdd@pwned.life>

Tested with Alpine Linux' configs. Thanks!
