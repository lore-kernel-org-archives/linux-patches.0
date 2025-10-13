Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEAA29BD96;
	Mon, 13 Oct 2025 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760375176; cv=none; b=qMK88SCGVNW44IhQdFloAh7McEky33g6JKjKfGxH/KLrdl3h6PMkd+5MN5UMc7oqLAABOILPrecbhItB5ONtsp9EmX7BrmA6tRsXlkOCWMI27SNwQpziCI1ITIvIQpQ6gWNXBPTJnmVLXRSVIfa22tCMVkbOW6EQQDgDPd+A9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760375176; c=relaxed/simple;
	bh=WU5pH+GBBwTJrj464Y8FlFe+lG2TueA1ID+S8b035cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUyQvnjpC22HtTG30PXwp3dME5s+lizL4La1icWdgIt/EYYmf1EUtWV063RocjcuzJ6TZ7eDtYjvt+UChiG/6KeZxxnkXEQD5ed7oYbzJ1/y8Jn6RP80P8NlYXHFkI7vgr1bY/O0mM9AaOg8D2RjE9EWmD8FdWarm8grhb6tCNs=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
Date: Mon, 13 Oct 2025 17:05:38 +0000
Message-ID: <20251013170545.27052-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.17.3-rc1-g99cf54e7bd2f #106 SMP PREEMPT_DYNAMIC Mon Oct 13 16:44:03 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
