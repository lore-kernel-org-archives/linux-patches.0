Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C813C9A3
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738966521; cv=none; b=llxnCdA86ZFKtQIwiHkQIcUnmUaVOZh19zMkjw4FUnamysvd6LGgAWk34OAI8w/YSl2c8R1bj3NSvN5j3tCtC5cjDdRYuo71z7GoqBwsoAJCKWsPxWeMnOVD+pz9S5l4KuFnFPoq93R/v2uRoXD+pXv03kiU9xXnDrU1eEujdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738966521; c=relaxed/simple;
	bh=Ga7CbJd40sfYvrQ9Iauv10Cwuj5BSAHcXQTxrVVFGZg=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=ubrmhdNbWcfDb/3EjnakLNN2NOPrmxtfu2fqAMYGOHevc3F570HV9lVUf2TZG6EeJoA49bXxcF/r2xGC6Ka5M3TwI8q1l1XTMfNfQEnzJaiaZGsTJh/3Wy8zdL5Zmb5tdg8I1aJyJAYdPOC0UdfFuml/9ECGEBkZSThWoZm5aZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=dHtKmsm0; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="dHtKmsm0"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id A8B1A7D3AE;
	Fri,  7 Feb 2025 23:06:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1738966010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RAJGnsk9g5KDk+Q6J8DtXwovGOwC+pY2zb5XcFKtlEs=;
	b=dHtKmsm0GezbtgkY50+nD9qgSx4yCBe93thtI8O3lUGCJ6PRgM86xk0mtn1gQfQeBAhsny
	i96gF7bQgCMhjEUCU5ML4LSy9Pi+yDyk4eYRrjhe51TeFqDqRIGR3Uan0XxUYcTIkr/haM
	8CvzHYJOyDxi+OZ/ieRTObhKI6LlEsg=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 07 Feb 2025 23:06:47 +0100
Message-Id: <D7MK034JDRNO.3LKC9MDH3QRNX@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
From: "Achill Gilgenast" <fossdd@pwned.life>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250206160718.019272260@linuxfoundation.org>
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>

On Thu Feb 6, 2025 at 5:11 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Feb 2025 16:05:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-=
rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Tested-By: Achill Gilgenast <fossdd@pwned.life>

Builded and booted using Alpine Linux's packaging and configs. Thanks!
