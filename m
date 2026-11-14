Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794623266;
	b=SSrLYvGQJnM0+2Vbcvwew+y4ULUjx8LGutlkhcnKG8hXk3dngOEJFWQztFG/nsiMl9Z0
	 hm89BDDk2KiUmcxEYZY1L/aui8bc3jVRl5ZWGA+kFD5z9QbRwi1y8ZjlY3jypl68RjLCx
	 KONRYufUdvEvGUqYjoqDg6n/wcMmeH1jP6tTfpCUDvAFJiuwFA+0FjLzdm938/A9fqRjg
	 dKanoN26MzmoqiJ0ZeswPboep4C66ek3tixEl4IeZEZUCvbtOD2x+NhkabxLGNY4v4g7H
	 va+m5K5p1QwNZ9YMrFQcpXItRlwUP7vM47+xfgdL5o/9qE8vpm+XsIRKg2t5omfir/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794623266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yaLTihFeNHJYB8qT3CWD6+O9GuqHwl+Xob3ryUVJY0U=;
	b=QhqdxNLuw7WjP6qoMFm8VKCe/EdRjU0flsrIlMpTlaOJjKgudgphpg9Nhtvtf1bTj5e1
	 Cygl/+Ws2woIRXjOmLxXCREc5gWizgNr3izXRtohLmMEpOOz61LxYdrC/oI+kBiVLWyN+
	 Yx7NAe0PyfUTv4CjQogjP/Wwz7y6j0Kj9vQdhQ0K5LABGzGQ/UaNq57iG6XDfjTbxzUtH
	 padEKZ6qFWCdMBgoGOGe1ys3mnzAjA4QTeP5Rc5JB5YQYTcSJmQfhO2+t15fQ97eJiE7k
	 CrIimXAl5f9eDn4ld9ScY/dmMKIEFfCwtumgYgoUnMuK0V6iLnEFnLH7HndVSgN9HgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DN9b1Y4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E95606A32D;
	Sat, 14 Nov 2026 02:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DN9b1Y4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461921F000C4;
	Sat, 14 Nov 2026 02:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794623266;
	bh=yaLTihFeNHJYB8qT3CWD6+O9GuqHwl+Xob3ryUVJY0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DN9b1Y4Ug0xc3eeRrzzhBwa5PPGi5NphXTyxz7dMj9s952NFVKVoF/bLwMZj9d06j
	 7arKH+gzOxzMMlgBlyBDQoiRlvNyoCG62SOYWAmDCkuItvawV80heMOQgzMOoYLhZY
	 RcSkGY3Eul7Qcnc/agT2DoSXKGQXK9VLiiGvPl8fRvbTm415BUa4habNaUAdNu9Lwc
	 4yEoygsFC+oOr4Z/oa0b7n2oT3rIA0lEY8rxDoOfTyAWF+CWHBZKA+h/TdIKy/ywOg
	 5lbE4WjeSvmHrykP8/rykLuGSFOzPsxEh/KT3OuMNUK7r68G00aZEwxNai3GFjayuA
	 S4YfoCzZPpmtg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
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
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
Date: Fri, 13 Nov 2026 18:27:32 -0800
Message-ID: <20261114022733.110657-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Nov 2026 10:42:13 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
