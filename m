Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68827305688;
	Wed, 14 Oct 2026 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791941256; cv=none; b=FCwsGw2edFJH8XcI0Emjvlsy11XwFVmZ0eTlG3FGUY3HZSe9Fwqw1wqvEN2sx3lejIVT5QDbnAjGTiwm3Zql2MDgRgEWovuuDGQ+6jbLz45Fb/WfV+FXztBRYfvt2XUCKeyi/hEUsD3KhO2mP48CcT2o37WL8+KgFwmzQqlHaew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791941256; c=relaxed/simple;
	bh=BeF7t50VIAYyEFyHz6rbHRV2qdZeOldbYFI0fGqz7Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwjnDjjWXPGg1UVJ+aiga88X2vVW/ZJ28rO4pCUIVVaszB3xEz1PVbPLemFhbcFHRmPP5jcnYiBF+Q7fRMPh26fwjrxL//yVxlgLKbgEdbF0icWiNaBeM/BiHTS+ax9SPXMfVWXEDjAoiTB5RvBiWzfauDp/BBXKrHRnv9PgjDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTGfUKZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTGfUKZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E094C1F00893;
	Wed, 14 Oct 2026 01:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791941255;
	bh=qb8BkgwT4vlOEWEXbd4/b2JsR4d2BUdSEBvb02wZRPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTGfUKZHsRqwuV+jITTUREwKgk9SxzRgxW1cyuh/bpygwZo7THVrk3b9YR4N5M1KZ
	 4uMaYGlm0LIV8nm6h4slsJIKXO4CgGWEhHPMPx5X7BA4xOy2fDtGAKZiPd70I8yu7r
	 TBAZXyMDyf8Vboem8mh6eBp/flhFeDfAEqTqi7j4ILHPiaVxsNM2/hB0XC9ZFxVrAm
	 Z6U4D+kLehgaDd3ltKA+sssoGsD0cwycQRc83BXHmmx+NmIzE1d26WDurNl7WJjLY1
	 IlQNlZN9y8m2z5fDIT9uuGC0t6U5hYrVixGi2sm/89o7tCVHsnr/OR0y/vGZlE3Sx8
	 /IZJ5oiFEuuag==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
Date: Tue, 13 Oct 2026 21:27:04 -0400
Message-ID: <2026-10-13-1-daily-reply-0014-6-18-rc1-krb5-link-failure@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <as4kGIjqjrKzu0O0@auntie.librecast.net>
References: <as4kGIjqjrKzu0O0@auntie.librecast.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Build failing on amd64:
>
> /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_get_mic_v2':
> (.text+0xfc2762): undefined reference to `crypto_krb5_get_mic'

Thanks for the report. The krb5 patches in the queue need a select of
CRYPTO_KRB5 that was missing. Queued for 6.18.

-- 
Thanks,
Sasha
