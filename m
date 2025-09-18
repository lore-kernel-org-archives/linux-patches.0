Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E31E28314E;
	Thu, 18 Sep 2025 05:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758173348; cv=none; b=Uu/roM24jP8gm8PAtBYyFRjebsP0mvuMzIVhusi/rCG4Lj0SPd7hJeeP4tCVOYc0M/xR9daJ3J0AUogJ5KIXPneg0xeno1NOhbeAv4mznBnetfEKX/G7+o11RK57RqEi5sH0cWOllj1CtpwhpRBtDbsWW/4+2ZiivfdvG1OlZw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758173348; c=relaxed/simple;
	bh=jFF/S1ISw8YjO1jHasoYHdT/TNTahJxL1WSFRDn9HJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaqngdErint26fbCrivXmPQTGubywH3FkgXk+5nQOqj1gD0nJ4j0No1NMEYk9L/1aXpU6Sy9+nvH71Dfw+ygbSst4R6DB9pRH6cRSd6lClaaNF2gAvvy5yTT+q2Mz0gl+LzHdbkyENn5XVqVs9/s03VfL11vj4gHBq2Wsw+g73M=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.16.8-rc1 review
Date: Thu, 18 Sep 2025 05:16:50 +0000
Message-ID: <20250918051703.4009-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.16.8-rc1-gfb25a6be32b3 #80 SMP PREEMPT_DYNAMIC Wed Sep 17 13:17:09 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
