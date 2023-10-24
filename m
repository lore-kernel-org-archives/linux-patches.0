Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6533FE1
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 07:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="bDrlwZr2";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="UBZ/gVPD"
Received: by nautica.notk.org (Postfix, from userid 108)
	id D7023C023; Tue, 24 Oct 2023 09:51:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1698133861; bh=h6e4ASUwqGKjNohmy7ZK23hAnr+NlDUoomsSYM9NmDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bDrlwZr2aBKcnsg4N+6aLHYhOP6ycWdvneNsdMrNcv0EDwYzRizR0wq0yUfRCTAd4
	 ty8O0hwiwu42Pc8DltREOdEF4LTld7F/qNmUFeVTj7AugzsAVL5cHxaVbKMEC/RJME
	 CqrK+tipXeTDLNQkEQORlvKvcgtfjkBF/+QxQW1m+aJO4s1yQFeHtEALz1STpsDD6I
	 IDMGxyElAy6L5pXLZXqoKgCDph9U94w13mErrTkGYiCMl8CuZImxsTtzVDALpJ2cjB
	 WTCx3wiThOYf8vGq9E69UyTi1gDhA2YDQCZ2zIxeDzwY073ncN4zotIyuSuY1HhT1n
	 9je95e63FTSVg==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id C99B5C01A;
	Tue, 24 Oct 2023 09:50:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1698133859; bh=h6e4ASUwqGKjNohmy7ZK23hAnr+NlDUoomsSYM9NmDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UBZ/gVPDGQTVf84yBhQvlQsIUrUF6fYaVV3MIrszKRmsijHOmviEm1BoBSXh48mUp
	 cIlJIdy1kfh00OWE5vJoXMGdCPc0k01x2Z9rH56/oddrgbjzlbAFSJtwO/gzqXs7ew
	 LYdxfNykrO4UILMEkI9avMnNShAix7pSfvqihPPBFvWDTBgRb6C8327bWIgZh0QlJ3
	 tVJRu+we9ZZDtBbTD1gHuFNQSEBskg/ukV7QlBY6PkGOaXoOpGOxyinM513mRwNvP1
	 JmLQRS+uE7Mow7c3GvuBcXBtylLzoBIiY0CFuaq7l0Lzw8IOgiHLf7775+b5cZTghu
	 Zs2EG5Ykn+Asg==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id 31c69e22;
	Tue, 24 Oct 2023 07:50:52 +0000 (UTC)
Date: Tue, 24 Oct 2023 16:50:37 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 000/202] 5.10.199-rc1 review
Message-ID: <ZTd3TZ7oZH7nxKfY@codewreck.org>
References: <20231023104826.569169691@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Oct 23, 2023 at 12:55:07PM +0200:
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Not much point in adding to the IRQCHIP_IMMUTABLE errors reports; I went
ahead and reverted these two commits:
da4ad7dba3a1 ("gpio: vf610: mask the gpio irq in system suspend and support wakeup")
90225415cad6 ("gpio: vf610: make irq_chip immutable")

With these two commits out of the way, I could test this 5.10.199-rc1 on
our armv7 and aarch64 boards (respectively Armadillo 640 and Armadillo
G4, which do not use the above gpio driver).
There was no other obvious regression:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet | Asmadeus
