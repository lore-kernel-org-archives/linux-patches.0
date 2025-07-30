Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524142E0406;
	Wed, 30 Jul 2025 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753896547; cv=none; b=p73oxez3rBYjDzAuB4YzQ4CbqkqbLhh10ILUS+ylhSpgo2id1Ahb69qZZFo3nTfCDPDmtdkx91XpfaiWrQ6iDM0qFAKBEufp8MWDf5M/Gz5XKgI1+0Ld+L4XKx09To5mG4Y6NSlIMnEJeEVQxDjeOzQfJjH/sPAGOWoeDyNnGGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753896547; c=relaxed/simple;
	bh=wdOxPCidP8lEoUDdij9ppCOPsaIa0slcpRMVoASTGEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJV1FWymcktCGA6jGVJCU1xGn6S7ixjFb9H3nduwo87nd5z/ucXvAmeCZ/gQJJhpwNoHVRRI8cPhOlz8g2CIkrojHBIZ6qmrnWYGmBDc40jbJjWuWjIuJnD0QeEEcsULw/j4Xcymo9hnKl2aAFUqPc6w8ogAQCw+RUO6VIQNo6U=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
Date: Wed, 30 Jul 2025 17:18:28 +0000
Message-ID: <20250730171827.29770-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.41-rc1-g487cdbecb4dc #32 SMP PREEMPT_DYNAMIC Wed Jul 30 10:13:12 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
