Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF282153FB
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741346119; cv=none; b=HfjpGllyMmqEXTqYrZB2INqBPDb1BFAJyvUlrWsVjj0CFO+6rQjNhWvAdoXd0Do4b+hGJAZB4W87OgZ8Gy16YkAUvqXfQMTJeRHXwQYF2mhUKHavbgKYO2uo+BQx0OqHEORcZAL4LRJEIdB3vGDjGybzlvU8l7kXl1pqWRxgoK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741346119; c=relaxed/simple;
	bh=9Mm8dyEK+xTcn5mdQT1afcEoDnaBT339NszPBErn5pw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=mSfHWSsRGP6Pv1jjchdwO07xZIuV8CPntx90XVUU4nvhgScEYTCTmwJwAVU3qZ4Wm0/Bw3yNUTxflPaVoNZgbRgRXiZ5EcmjL0b2QWOd+qF87Qfgn6HGaN0GmmPC7g998jCJsPfqZljd+hY89AVlaznu7uxT3ZS3zqiN5ViPG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=dV/oYJOZ; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="dV/oYJOZ"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 03EB57D3B1;
	Fri,  7 Mar 2025 12:07:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1741345629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JCkD1Y76HXMoUWwsQ707VJYhpdhLmw2/c4GQ/XiDQg=;
	b=dV/oYJOZ0tQ8tmQRXHoBDhj5vP+EuymYEGvKMe5KkF4fjam6nNAQxK7OGNel3fR+luAUHt
	K8VUZWnwG+L9h8CYK6htwZcABUzmemAGSsR3x/28f863kyV1LkWaIJZwGvjJhFwGn31NqD
	N+BM0YBbRabt+rmwAccuvThWfIbPtf8=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 07 Mar 2025 12:07:03 +0100
Message-Id: <D89ZI7RAY6RL.309JYSU0OMWFQ@pwned.life>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250306151416.469067667@linuxfoundation.org>
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>

On Thu Mar 6, 2025 at 4:21 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-=
rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Builded and booted with Alpine Linux. Thanks!

Tested-By: Achill Gilgenast <fossdd@pwned.life>
