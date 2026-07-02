Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBB3381E9E;
	Thu,  2 Jul 2026 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021608; cv=none; b=M8gFbd2agLpA/6dfWrrrjZJt4t+jc9Lg7BJz+8JXtNfhBBG+6cDyaI1UKXA9fP3+JCjq+qLqgO2ydG3DCsxXqMYTFlhsNx8VRq9zkofpOWz3RYel3ElPfWgcmdSn7rd9nNEAw+FJHOwZyiJA0XNzet0fkUGBst/pmuZKiPxCEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021608; c=relaxed/simple;
	bh=Z/XZmMZYj48laOeskw7JJ95n80+pTwoPLk3snKW0moo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiKF5noBUqRLlBXpI+7StIne0Q7V7VfKM0qd01ubztBPeBGU2uB439eVwjKGU8R1zo2uYy7qy8ItMkJQrPEBEUEZ0NKYEssOM81s/crg0YrfyIhwzjeFCatKe8nACJd/wo/8OaMkF/H/OOoZe+zCiEbuyvzIUWO/bL97JEcyuSw=
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc1 review
Date: Thu,  2 Jul 2026 19:46:38 +0000
Message-ID: <20260702194642.34818-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.95-rc1-gc3978f97745e #1 SMP PREEMPT_DYNAMIC Thu Jul  2 19:29:30 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
