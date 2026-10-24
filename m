Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792839539;
	b=zMXA8M5pKGsYkFptgPkKcL8rFgZYJURIncdlTbosa2NAmEUq1xSSinHxBQy6ONZifZgS
	 u7pjxpVev8UWP8HUyvlLhxzDNmxzcka65QomFrj8Mbu2+jsYU75+mAvZ+ndZ8bbkl0wuH
	 Za5/LBqTmbwwqhShItdSiIKN0PTtxGurxaCyWo8Bj96Gnn1AWa4JWza7Qe0Fk1xrycH+a
	 Cgaku2EDQ9g13Idol+w+00ubhiPFB4yLaf935kNieu6peb7vFRpN6u65LoQj2z1QIj5hk
	 u2UaohZxzLYako2ArjvvKiTbiMkTTWqQqJMJI3AbA9aIkP5icnoZDxkbsKumm7ltfKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792839539;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=CyefV5kFTreuvPN1UxzVU20IThLQaklREz4SOAcgohk=;
	b=tHBRlt9aLo46xS4Eq2xMHA5L+lDQB6MsLLf7nW58N6gKCSo/DeK+fAnX45trOh7yY4iR
	 1frEBrpGexUMXEqoZj2KgiXGII4bJmCGGSV5ouSq9h4uyzpOGUpxgW7IdYAwiOWTDdsWE
	 F5l4gqQLVajreskp8cbDJTuemW29n8rC38cqdF+hf4o31t6zrbNDf0nC1iQJeEnkN0Mvu
	 QuiZUnQBf9Kjihb8aOpO0a0VH2kSt51+GrpcX+UjfJAYPK0bsFHCdVS6hz+LX7WI5OHRF
	 3AUAvXx3k0CbGVVQQc5CNo9ZeB7pkcZXgdVb8fyplyoXZympNZwORTIabNeg4/7XKdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5130E606A31B;
	Sat, 24 Oct 2026 10:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5130E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org,
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Date: Sat, 24 Oct 2026 10:58:39 +0000
Message-ID: <20261024105841.56861-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.59-rc1-gbd77a04827b6 #1 SMP PREEMPT_DYNAMIC Sat Oct 24 09:18:13 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
