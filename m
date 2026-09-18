Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDCB3612FE;
	Fri, 18 Sep 2026 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760763; cv=none; b=QYxRZ3GG5itmz9enLQ8uDjTRJz3b1KFhEM0bdINPm8+3ynJoMy5Hz+NRLL0JMohPBmh0Yx30x88HCcqgesvrXdxBQgf6YaYBlG/oRDo4k4GxqHcEVaj4Ivo0B4X+7CGKR49Kl0whcaOLBD8JnKYOBOSA4nLUX1xxs8Ish4IHF7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760763; c=relaxed/simple;
	bh=x/7ZT245zHU5glgO8C0jT8smrlbx/dTbMPELgwiXPNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMUpGnf1aNkHuRxnEFrwkHBdkZC7UdXCJA9FACQ12MG5IUC2tVSdcVYKKW2kZEppufGJcgOtR+nOlOsJSKRjV0bUolpMfd8gZLI+6eNfj0AtgiyQfdlwCl+LrAIWvickWLIhimM3OiL/Shk+xw+bsEYEXY7pyhUF02sYrRBt/KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcwxNKZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcwxNKZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AB01F0089A;
	Fri, 18 Sep 2026 19:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789760762;
	bh=IDFVBITtwOiifF/+fZ+e/oYGJuAitFKGTMoKjMxQTLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcwxNKZkmyr1i2w43ibiMtlzREE+ikb+uuw0artDOczqbKGRmYCNYIsYvOh7VZORO
	 CZ0eg/wDcrVvatDFeyy0ivN3cha/wsCIJ53mY+ARol6cD3N4ZIWa1iiFrT4O5BzQwI
	 O5nvsVafPrmwt+XxdWvy8rCBkJytU6/HVw1doB5ATXm9dHldTSYheKEW3VytOpRbff
	 R2gVYfl+tIA1eHy0xVbBv66ttn7yHK3ZqjMDWRjGN6jxB+z0Oxh+OVzkV8J8tBbFfP
	 SqEDZxQYwlq0xJBDoZX0dxZXzqfj7MJ+JsGojWgKsBQsE/anYDGtsn73xN7cJpL1b5
	 AfEHybTkxhn0w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
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
	Guenter Roeck <linux@roeck-us.net>,
	Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH 5.15 000/935] 5.15.221-rc1 review
Date: Fri, 18 Sep 2026 15:45:41 -0400
Message-ID: <2026-09-18-daily-reply-0014-re-alpha-fp-exception-bits@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d08261fc-605f-4ed6-b7f0-b9575c2de55c@roeck-us.net>
References: <d08261fc-605f-4ed6-b7f0-b9575c2de55c@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> All alpha images:
> 
> Error log:
> arch/alpha/kernel/traps.c: In function 'do_entIF':
> arch/alpha/kernel/traps.c:373:35: error: too few arguments to function 'alpha_fp_emul'
>    373 |                         si_code = alpha_fp_emul(regs->pc - 4);
> 
> This affects v5.15.221,  v6.1.188, and v6.6.157.

Reverted on 6.6, 6.1 and 5.15, along with 49672d026cc4 ("alpha: fix
ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally"), since both changelogs
say the two must not be separated. 7.2, 6.18 and 6.12 are unaffected: the
second call site lives in do_entIF(), which only exists on trees predating
a4184174be36 ("alpha: drop pre-EV56 support").

Matt, could you send a version of bcfe3187412e ("alpha: don't leak
hardware-fabricated FP exception bits to user space") for 5.15, 6.1 and 6.6
that updates the do_entIF() call site as well? Otherwise the fix stays out of
those three trees.

-- 
Thanks,
Sasha
