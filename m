Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4782D4B71
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 20:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750709476; cv=none; b=Jcw/HxDc+r9QXy+YOx7gFtMPAuzYpBp/qxRmfOJDk+gulMEqZvdh/Ap5nOtzzHsmYww4OioGiRy9Q/GOVeOzNua5X7gSZbGQeUR83+Fw3vTMUbI/WtQwMzqsNRFFPgMwYZL2IAE0jNu9BQk07bvI1mbK5sDhaNp4vOSQiivunnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750709476; c=relaxed/simple;
	bh=eVyXr4lpmQ8oRKMhvQNHeCRkV5KsVKpl6CmYHNtvN50=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=jzsaMRg9eeERCukcSOEGwPZwqkzv94EyWpjNl75VSpxjiw98RQ9EmqK6ilg/VtXJ4pcIkvtCN/odSYHhs4TpBgqCW92+s7h/UNo+lVLrZT1QSIJL5IN3NU82wqgy3BBj7fGEgA198acNL/KUP2PtaF9T9Jg4UU7foHRmYt+W5yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=GXQY97Iz; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="GXQY97Iz"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 673757D3B8;
	Mon, 23 Jun 2025 22:11:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1750709471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZsuLJWWc/pAl26yyCkp4TnRrVey7TofGIGtR/dAmfE=;
	b=GXQY97IzaSa5uJ6alO7CgPr+uK/1ynYqHTbaFoApqjgo/Dv7OyHY70iSrGHp49Ss5npKaH
	lI7IIc8A65pgHqV9l0TNtrYs9JZoxK5YfNoskN2fu4Kgser7igcMRQguBZCGZwHRPdfIkL
	vEwlgqz0GUj/olHjqHnGAZ1lmmylny0=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Jun 2025 22:11:07 +0200
Message-Id: <DAU6PMGMR1CV.1GLD5ETJKI4A5@pwned.life>
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
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
X-Mailer: aerc 0.20.1
References: <20250623130700.210182694@linuxfoundation.org>
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>

On Mon Jun 23, 2025 at 2:59 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 592 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.15.y
> and the diffstat can be found below.

No issues here (build tested on all our supported architectures & boot
tested on x86_64) with Alpine Linux configs. Thanks!

Tested-By: Achill Gilgenast <fossdd@pwned.life>
