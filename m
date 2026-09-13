Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1AA39DBF5;
	Sun, 13 Sep 2026 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789298795; cv=none; b=ulkoQrHH/VzP2iD1oM86U0rR6PrUkcx3J0VC52AKITsT7/WWTeQBD12pMfybkzcLa2N3ZpJeZmpd332iYzsGD2xaKF6iz1P2Wo+C5x5HDCCmxyC1Z05ndNsBci30KThQpDBOBWR9CShuN5dz4ALEJ9Q6Tq29N/X309zVXjDLE94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789298795; c=relaxed/simple;
	bh=llP5GpqHUgIlFDG7wrlefEFtaZ24NfDk5sz7agjAXl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJv+TXAfvHXGLmsJfVuc6V+MXAHuAMWdD8i+QPaAcdj4hjIQwEBtKVNqZj/Utf4ExwTQWploeB9+mN1yA6xqebDjRm2VPitCpKphbRnciRvgPHwZ2cTi53HDDh/Hv6JdSwOEZMzHApRnS2cfOUABZ55GXBw2Tmk6/saB8a7+AHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkay1oxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkay1oxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A911F00893;
	Sun, 13 Sep 2026 11:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789298790;
	bh=aZEqXNAYaVqRmNDZqsWHyhP1aPd4iri4oSCMJeVeYfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkay1oxG91B+/M+fZblxROg4rcxr3QEYUeAu0MrD9d8Mo5wj+yPIcTbaRw0JZrFh4
	 yAvEzCx5B9lXBQyZHJPccxnnEeoieTO/rKqkQP6LsLyZWOsH61dN79zx4I8B61p+Pp
	 hGDZ2X9aYp8/CZuoOuYOvd2HGmpVkX7R9FMlqNcPUk9qaH4s0S/Ouaexk/p4l7qDrF
	 dlh3OEp2AXT19Tktax0WcXALG0dtO7wg9m24ZuDliyR78ycyjRYWeFnuu+iv0CDjrt
	 ivAtYF5PWY8WIGYA+0Xu13fhQNJf/vrJe+sTA+xLuO7tBAQPI6TbQmqCTY2C5c7m8H
	 c3WpyAh1ULM8Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
Date: Sun, 13 Sep 2026 07:26:18 -0400
Message-ID: <rc-reply-report-009-fsl-audmix-6.1-20260913@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1a29a80d-1615-4110-8aa2-eaf931b579b6@w6rz.net>
References: <20260912065548.086904252@linuxfoundation.org> <1a29a80d-1615-4110-8aa2-eaf931b579b6@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> ERROR: modpost: "fsl_audmix_runtime_suspend" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
> ERROR: modpost: "fsl_audmix_runtime_resume" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!

Dropped from the 6.1 queue. Same CONFIG_PM=n build break also hit the
5.15 and 6.6 queues, both dropped as well.

Thanks for the report.

-- 
Thanks,
Sasha
