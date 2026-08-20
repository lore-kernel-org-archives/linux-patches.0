Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4EF3CB551;
	Thu, 20 Aug 2026 20:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787257503; cv=none; b=MjwUofHX3eRov0DURdalc8E8o3uoprNwrUjhVSAO0G+a4DNJvG6Xo6d1uByCVKjyXPE5SgE6cpC4kr+5YU2LItyHmP0c8+gpnU4JDFkegUb/S34Yo1gEyWEEe96JIteDc6Ei1nfnwo6WHyA/5Zj1z7w8OHigVCHlLCkFyeUx/v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787257503; c=relaxed/simple;
	bh=6Yz0UWjGOJXEuPWYJ5AePolNFlBE7LxZn2DrQUmXWd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faTPsGE4QzlmGJtOP6oaMFqND1At/p5ubkC0+3I2+MzYsTyIFHIgg1kP/kg73CAtk6GQ+UFKjzGMsVCdyYiRimLOc8lzzYIIjYBD0nd7XO7Rgu6oVF4HrYLr1AyiQMfay3uWbCjjPImGOqF6AmCHRn9DScB0fdOuWLEbATDSUx4=
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
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
Date: Thu, 20 Aug 2026 20:24:47 +0000
Message-ID: <20260820202451.52446-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.184-rc1-01952-g1869cbab73f5 #1 SMP PREEMPT_DYNAMIC Thu Aug 20 19:51:21 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
