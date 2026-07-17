Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DC23CF694;
	Fri, 17 Jul 2026 10:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784285753; cv=none; b=YLHAX5QQQw9Km3G5AzVG6AaaE9CcXUc6t5fwEPSetSWwQCKn07Zdybvrq9VLNW4tO5B+S9VmoUFJGHpwrppzB5Cpu3wDRiMnR+rszfDLc439fsJJP3CqexFB6UrO0al4x48iz1DzIAYw3xlAvL60TPGgESXDm+NKT3/RRl+OwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784285753; c=relaxed/simple;
	bh=EnkQDb+yx5MZkWJGHOwfzJpCeH0UYCe/JRjfR8dkSN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKHFZdN9PxEoHm8C4bgN635M2CWqXJMVvpCo4ZICJwD7TK6wWyvYu3DztQnLn19EA0qLgQnnhlNmbKFJneQn20J88mX0ETbx8KGMhZMqfimlNkL/pusavJI8Ti/IOANUt/STrCkVDF3QF4c9SSaRXVQ/jyv13N22kZT2ZBIkoYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
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
Subject: Re: [PATCH 6.18 000/495] 6.18.39-rc2 review
Date: Fri, 17 Jul 2026 10:55:30 +0000
Message-ID: <20260717105535.35957-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717101904.922623678@linuxfoundation.org>
References: <20260717101904.922623678@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.39-rc2-g67e26b110082 #1 SMP PREEMPT_DYNAMIC Fri Jul 17 10:50:08 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
