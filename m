Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB23B6BF2;
	Thu, 30 Jul 2026 20:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444125; cv=none; b=R1FMKZp+gTlHkwNlhmTsutqd/OI8PUq+LLm3ZcZnyDUPqE2e2X0JCh4MSpQIfmPbPSJs/Oe6YbbldRD39mHAADeCSW80d5wWROgHEgUX8O/0qcfcpY/l+qYsIlIhqKc+KJqFsAXkpMdm+dNvyhufjPQ9kj47H2khV5rmQCcvmVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444125; c=relaxed/simple;
	bh=vCf/lHZWf5v9vcOmK8ffa18NaMyhMn+fpi5C/KYIkOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz5Ss+CjHVIbNTO3WLUCrmZ7V0WLj6tAkoh/OzLu2uEoSjWlP1OVTnTftacn75bFzvyccQR8a4L2fm1s6ex1PJlRAWgDfw86Xctskwy+HM4AWsx0I789bVzB7SG/ycjzZoI1yChos2ECAqI/eWJSHY11ednltkT0H2pzsSSVGlo=
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
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Date: Thu, 30 Jul 2026 20:06:48 +0000
Message-ID: <20260730200651.20087-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.6-rc1-gecc0c68d2044 #1 SMP PREEMPT_DYNAMIC Thu Jul 30 20:03:55 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
