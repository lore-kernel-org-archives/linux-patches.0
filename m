Received: from mx.nixnet.email (mx.nixnet.email [5.161.67.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8BB2571C6
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 12:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.161.67.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741696000; cv=none; b=Y2TS/GSr5jZ71tYlQw+3is204vm0yffjoQzqTNHthq5Z4LcYVSLNjoa1ahkbo7+JUehFuGwXUa3cWHgXlZqvWZC16l1RMmrh5ZdZLoqp7g1spWwbJrSEVbsxIfMyvpAPD5UIa77wqOXJiJ2gm0/u5WSk4gF7FLXilQQ8VEPJUog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741696000; c=relaxed/simple;
	bh=ZDA41D56M+Vb+JPh5GHUAjorEx/znjRD+rUHpDYb9K0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=a6IqDdBNTDGf/YCjIELmpdniR2WDFCMkvsJp/b3L+bFAjd6dGBwK06PCL84cxrlzqkB1M16Vw7Z6mzF2XyGv1kYsecjQ6bbFeE4cbm/Ha2SB6eRPh7YHz4f9tXzN1dlphLSajv5FQIekAjK4hFuB+R6nrgLTB4kX9t/2vG55ZlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life; spf=pass smtp.mailfrom=pwned.life; dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b=QOCuvqvc; arc=none smtp.client-ip=5.161.67.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pwned.life
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pwned.life
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pwned.life header.i=@pwned.life header.b="QOCuvqvc"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mx.nixnet.email (Postfix) with ESMTPSA id 6DEEB7D32D;
	Tue, 11 Mar 2025 13:26:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pwned.life; s=202002021149;
	t=1741695988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTv3pvCKkLqk/zFp5+ZFY3D3ixFEYyO9KwHWCI9sGiE=;
	b=QOCuvqvcG3T4/eMP7cfADz9CFayB0MNL3WOz7VoRNh0WnVc65QyRW3NaJiTSQbEq2+V9zr
	33Ozms4idIdSV7brd+UEDQG71ru7MpNub97rbtG7zkXo/6GDnZgAaQuGpaXFFCsi3mRXeO
	0RU9ZLnG/rxiQ4v6pBaV/XcXurBWHDE=
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Mar 2025 13:26:24 +0100
Message-Id: <D8DFP5JO7TF8.3354I1EBRW655@pwned.life>
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
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
References: <20250310170447.729440535@linuxfoundation.org>
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>

On Mon Mar 10, 2025 at 6:03 PM CET, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Thanks! Tested with Alpine Linux configs and packaging.

Tested-By: Achill Gilgenast <fossdd@pwned.life>
