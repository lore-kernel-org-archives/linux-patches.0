Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEAE3A542B;
	Sat, 17 Oct 2026 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792263845; cv=none; b=qI7AF+GoUEPcOqjqSICxONJeIXYB8A4ARlI6D9qzhtmEj53dDM6P2MHBQnwfU0sNvtOgi4yPGa2Du1hOuTiIg32SeWjLyHKisMq8SIOFXpzkax80U2ENY4okR/wDEyqMI+m1ofzimWSsS4A1XIWYqibsqIE72QH8Rv+c0WbAsZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792263845; c=relaxed/simple;
	bh=F1aCEreOF2xQK5nvouE2kqgc+MIefeBO2ryk5arQV9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y52lAWp1rCVq95uSEWFDR6RHxghaNc07edrw3lUs0vWPiD2FmrFwClPiqfnBCI1KCy9VMHQQNM0fJ/fAApicTMfU0lwCP234o/0BpNbU5iXJ091O1BpCIu5gkBoa7UOddUCo7Xm1lhOqoNt45q6BLU+LdUlMwd1/c71iwNmvwdk=
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
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
Date: Sat, 17 Oct 2026 19:03:50 +0000
Message-ID: <20261017190353.32572-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.6.160-rc1-g47804a4b5884 #1 SMP PREEMPT_DYNAMIC Sat Oct 17 18:42:37 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
