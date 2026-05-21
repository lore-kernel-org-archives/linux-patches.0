Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D7E3CA49C;
	Thu, 21 May 2026 12:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368162; cv=none; b=h8jCadx0o0BOs1qEClzAOfMsnh2a6lB84aQ6/ENB15o5cPSgk74E37e4EEkG0FFTs99MFrK6k8ja0x0FgxqdTzRDTO4HUv04/8SPnMwgjsvk38RE0+7iBOpp3ea7DhTBzD1MtUJ/d2kM0ZWP/0ivBRCWbhSeiurfzd0ZCa297Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368162; c=relaxed/simple;
	bh=lw+V4Ot6+KvHg/YRtyeeKRx4DrGnHZ1MWGirACvIpeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYgSSWvSyCppydj+lMb0890C4kTliUP+jQ6WtuWrslhYfn0givgY2GYv4/535uFos47H2trmgQ53tNYvmPoDzCQlZIztdGmOHh0gua4IyCbemCiZn5tykGo+x9ScXyzh1XGNt7S0BWUYcYVvh+zO86sh5D1pN41UIPU0SlAEBvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lC4vJlPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lC4vJlPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6E81F00A3B;
	Thu, 21 May 2026 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368161;
	bh=2iq20kpc9b/f5SuQ506PWKjHhd6oWacWvqpcMVCXXgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC4vJlPOFQFfQ8HwlRwKKyOtv8Rbd7oNcwMuwJ0Z1YnDYgDIxiawWZIfrmvWmG9aK
	 lK1zkzyLKcJOqIqE1/mJNU6GRdRH3Y/u5Zvw3I8KtQuDIFI6yP5Thm2dcWcXaLbbL5
	 xywy3m1Ngivnx3tg2kLZS/arGp8rG2NPcx5vuuu/8lrZzteitX0jiI89/IeaFi1lX6
	 qstg6OceF6EMOaqzoN7Cj3Da12EFA0KUNiilRNABIyqdndI7oQMrCXRruMSk/7HQKz
	 nGVVZHzqWNmoTchlH0CLPSGp3p1cOpKyvbLr1O1KBOaWqlD0FJu7wKQ7OT4erzMpMy
	 /ORsqLxph4KKg==
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
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 000/666] 6.12.91-rc1 review
Date: Thu, 21 May 2026 08:55:48 -0400
Message-ID: <20260521-6.12.91-libbpf-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <54f12da1-32e2-48dc-bf84-3bdaf8ef0f6a@gmail.com>
References: <20260520162111.222830634@linuxfoundation.org> <54f12da1-32e2-48dc-bf84-3bdaf8ef0f6a@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 20, 2026 at 02:46:48PM -0700, Florian Fainelli wrote:
> perf fails to build on ARM/ARM64/MIPS with:
> [...]
> libbpf.c:1538:76: error: implicit declaration of function 'errstr';
> [...]
> we would need to backport the below commit, but it does not apply
> cleanly to 6.12.y:
>
> commit c68b6fdc3600466e3c265bad34d099eb8c5280f1
>      libbpf: move libbpf_errstr() into libbpf_utils.c

Dropped 271abf041cb3 ("libbpf: Stringify errno in log messages in
libbpf.c") from the 6.12 queue, along with its two dep-of companions
(libbpf: Prevent double close and leak of btf objects; libbpf: Change
log level of btf loading error message), since c68b6fdc3600 doesn't
apply without a larger libbpf refactor coming along.

Thanks for the report.

--
Thanks,
Sasha
