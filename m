Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C723B993A;
	Wed, 26 Aug 2026 10:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740359; cv=none; b=HXROz0Ql6eH9hEiJ1Mw0yV8Zl6QnxoN7YEoEvq0+xDpVzPJ/wY6uhuKOVibV8LMQt1l3cTYnjwBlrTvj7wKwj53YbHVy/33iOPzJ11v8wQLDjPoPGniB8swTNw+ZW1dlqJiE+9b9pOzyn9PtyI4qaJB90m3J2CiMH7YGCL2Ow6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740359; c=relaxed/simple;
	bh=5PjKblV3Rrmui9WQy09rTIH8B5C0Oz76XIBJVTLw+L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKPJWQIIt19cU02U6XPzI88+BGPJSyRGC9xDnbJN0NDjKaXpBlfiFj5AED7Mp7sO3EyD6njdLwhpvopZFhjRnnhUGKsQjVr4MczI7X4FPXz4UL5Cis9vZBeTOOYTXTPuBHFyWghJz6K5zAze7VrMexMPsYc9UzL20455h75hteo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
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
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
Date: Wed, 26 Aug 2026 10:32:28 +0000
Message-ID: <20260826103231.61396-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.47-rc1-g20dd49b80cb4 #1 SMP PREEMPT_DYNAMIC Wed Aug 26 10:10:28 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
