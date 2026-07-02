Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C4390204;
	Thu,  2 Jul 2026 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783021603; cv=none; b=hBaOq5Qs01GdLobAk1d0rYU9O8c2tIT2f7Shg0YMQ3/HilPJihCP7T6c29XiQnL0a6d8RE0u6kEZ1YTPHQCo4ogpCzbDh4HDabrTW3D/sZa5jYIbYCiG7hKI0LSjCcEmfk3sN1yhl7xcAyxHkdYpMksbuoHyKq0mEj3JdCmMJ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783021603; c=relaxed/simple;
	bh=qJfPM3RQrPIuTkJ8lZqvAfiOnsEkCEO7hExILALUTJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRRrhh4nExCPOqTVQNWHHksuKc4Ow1GR8CQ4s5P7TEP1kcUrgOkMW0UvZZE0LMU6WG028w76F3ixZOIp0RRsJ6RSXRgMTrG8BjeKBUvLTt8MkT4bG3m0kpqKXvVLLJLQzOHwjx+0Dellan9YlWMTpep/DGQi2kjBi3Io7tocIhc=
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
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
Date: Thu,  2 Jul 2026 19:46:34 +0000
Message-ID: <20260702194637.34778-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.177-rc1-00130-g7ab3c992455f #1 SMP PREEMPT_DYNAMIC Thu Jul  2 19:26:24 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
