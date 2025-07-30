Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0792DEA8A
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753894080; cv=none; b=FJ5SHQUSGcF++JwS1bY51UvY1AaAA9+GuTlAJKnCaf746UzH73Jb36i30zT80t5k9KeTCLsKVsUF1+VZk55SFVncu9gedkcRnP6GE4Qviii89Nhsc+Tgx50O3Du9POmKCt6jjJdq1nTszV6mgpZvFqugjY+CllEmlBFjIGTukkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753894080; c=relaxed/simple;
	bh=27cNGqR2HBCGoB0i0kCeT87pItI5N86fPkvQOIBnvb0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kKWd+kYRIEwOk1Y1XYtWon/SQr673qsZQz/sH1ZPwDyD33WdoXCy8Z69LOvSVCMRXLDJ+sevcqTxqrGG36buZKpUpIZIhBvgvHaJ4RQ1/kv9xjcUtXnWkL5wUcSYc7WPZF31LvJuB9mdFId29RhjLl6cxUWFcWZ6V8HjFWoo6Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=nrhQbFst; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="nrhQbFst"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id BDE617D32D;
	Wed, 30 Jul 2025 18:47:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1753894071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkPyu4Og5SaPSLjRik/W2SWQQu0//xaih98MCg9FLPA=;
	b=nrhQbFstZTjveQuaniMkMaWAjGVyPf7yUTjSekuldt5BFYmnEJ9pUrMx2ooT+aYgG63HXP
	SLYIh225XjYbSkNyBiadhNhAZJ/anzx6YyQXkUMTVUyLLTK011HdX+JloXZeBbmU/q/fur
	KTUVXntQ1lX942PL5gwo3Fx5BsgMun8=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 30 Jul 2025 18:47:47 +0200
Message-Id: <DBPJK39WD6QM.2PN6V5C26FSUY@pwned.life>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>, "Achill Gilgenast"
 <fossdd@pwned.life>
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1
References: <20250730093230.629234025@linuxfoundation.org>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>

On Wed Jul 30, 2025 at 11:35 AM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-=
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

Thank you! Builds on all Alpine architectures and boots on x86_64. No
regressions noticed.
