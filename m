Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AA71C4A24
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 21:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752615292; cv=none; b=pJn/zF5bts8/MaoQXt7C3DEnr+1By/i/frdH3c6WKfaxZDwbcYFAO4hnew6UxwmyCqfCKCufeUS1ytf0i/iRGXog3eSzqr1zQr0P0PC8rVwbsQcyNCbrw+HFZqgMrqDKErvjhjF6OYrBfag1Cdwxt8ktVchVMeAMPPAcLPDean0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752615292; c=relaxed/simple;
	bh=IFNMR37pFCsxNKnP/HnH757U8wunjC7Ye9Euo8+I5SE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=qC8ymKyowPjrKcLEB2TeG8NNvFxhqs4XYZnOx+/QbGgWniBkxW5IJ1PMr2/IGbiiKB2ccxC8m78AJSTE9Y73xku+P0Mtht1O0bC3yBicWvCqP3eLvZWkDn4UwGnH6k6JoMAAPAAX+SOQbgkr0sPbBMfhdblp6m5vqo3k6/scHSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=ljMEHrsw; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="ljMEHrsw"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id AA0C87D32D;
	Tue, 15 Jul 2025 23:34:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1752615282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3q1nBxw+JcGoqroH8se/TEselkikRYqFQQ4XJJpobcs=;
	b=ljMEHrswOmkjxRg5Z0C65St1LhxdGSgheUlhIbx2Q22vz/zmafXyAvKyoOxqwVcTRt+F3q
	rfCEeuwwuejTzRBsp+1zM7f/FfWUR2Z3kpaVGI5R3nE4HqtAaNlX4juz9ZwReraqeYfNy2
	o90JUrCfv78P4dcKzzMax3PlQtp76DY=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 15 Jul 2025 23:34:37 +0200
Message-Id: <DBCY9JJVK09V.2BJZREMMACGKI@pwned.life>
Cc: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
 <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
 <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
 <lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
 <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
 <srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
 <hargar@microsoft.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
From: "Achill Gilgenast" <fossdd@pwned.life>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Greeting: Hi mom! Look, I'm in somebodys mail client!
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250715130814.854109770@linuxfoundation.org>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>

On Tue Jul 15, 2025 at 3:11 PM CEST, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.7-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks, build-tested on all Alpine Linux architectures and boot-tested
on x86_64. No issues noticed.

Tested-By: Achill Gilgenast <fossdd@pwned.life>
