Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCFC3A7F4C;
	Wed, 16 Sep 2026 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523573; cv=none; b=RDvde9jUzLh4JquE1qsvevJXU2WmlsJDp30n3ZOyi8X3mM4+AamJVHzPCSEiohFpYxJqDqZvo0mmkaHfQvtFUDok5Vr3vO5Ap+f34EQfGKdl/QHZhyqVRBqh7fn9Z7Xhd3FrTYdKZAReRTukhGj6mI9A9+fQrI6icusr9lsnmg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523573; c=relaxed/simple;
	bh=oJbTaiU8XKJIhqjt5t5yxkxQgvAZjJ5M/o/vdJHPG9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRIKcSCKJchyuvyyhQibcTBSlyXyXc8ZaWb1enY7jebvJYGGFPX+ivXp6kPNsNEwyoUT5bJy0/jEep143rRYKmCkU+Ade6n1sC6P9NZvaEJFznede8YmcswAGl9/yO+3/e5rAq46gT8ulR2rgT5QY+bNl1jBwIt+6HXrBHIIWM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJX8VXdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJX8VXdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BA51F000FF;
	Wed, 16 Sep 2026 01:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789523556;
	bh=L43MDoYi68BaORedkuKft148Vwi/yvyUFCDZEFVPuAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJX8VXdAIel30zcudXjh9HuH54K0age5Kmo2Bu88nsxV40j4Gacr532qOWtyLudEI
	 E/LzKu16jEDRBlZD4b3VQZ7cQWRkWsQJ8VLbCb+VJOoLsFqbfaLgtah059Z3Sd/jsB
	 5CeOC7FzH6iEaRwjcOEC7IlPhKmHnYULh/QQa+VQrwmR7TXlzeWkQJk2KTye3jI0KF
	 xbzqkNftlvcECyCi1dwA0xe3ighrIaevO/si2+73wKxyC0Hxn+mVpe3ETxmZwPvMu5
	 Wuu0S5KNCk23xDMqEJ7T9XcOvzB4hsYOZxfY97m64Ps0X3olJVErTzHvXfUlhTKoT1
	 gtlFEb3W+feAw==
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
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
Date: Tue, 15 Sep 2026 21:52:15 -0400
Message-ID: <daily-reply-20260915-0010-re-perf-hisi-ptt-build-break@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <64dd0faa-fdfa-45a4-812f-638574beca26@gmail.com>
References: <64dd0faa-fdfa-45a4-812f-638574beca26@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> perf fails to build on arm/arm64/bmips with:
> 
> util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c:14:10: fatal error: 
> linux/unaligned.h: No such file or directory
>     14 | #include <linux/unaligned.h>

Thanks for the report, and sorry for the late answer. 2b8a2e5d424f ("perf
hisi-ptt: Fix PTT trace TLP header parsing") was dropped from the 6.1,
6.6 and 6.12 queues before those releases went out, so 6.1.188, 6.6.157
and 6.12.110 do not carry it. That covers the identical reports you sent
on the 6.6 and 6.12 threads too.

-- 
Thanks,
Sasha
