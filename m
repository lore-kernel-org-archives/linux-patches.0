Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56E277C8E;
	Thu, 17 Jul 2025 09:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752744381; cv=none; b=GKScTr9prhrGVZ+fHrLhnQ/foXDMRLSV0EZ/jEog1k6yMuO7J5iA4gWagDgnbiUrWQsTz6+9kJPRF2mK0BnP3vWyczL6Tr1Kota0X98tcqzKGjC/KxbrMj8b5mSNnyQOfuyXmmwWb9EXjQVLzLFENqHgT8Be6RXU162Th1HLjlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752744381; c=relaxed/simple;
	bh=aNiQp2Wd7yghYBQJcA0Zie/NUHtuO6IsWALt1Ns9420=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogCKG0xR5HcehtIwt/0YYBVQuMInjLnahWvl4Y/oUJT2P8+DaNy4r0YfqSv2ZpCR0DRtYW/mTfsDPGhNooFRsDZyNUoGeZoA3Oq2rYjj0nWj2m79XlzOj6a8TIpYxraUD0CP5X9IU8xUPdw8AUj1IGPsoXuwWgGjJyXh5xZgXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Received: from [2a0c:e303:0:7000:443b:adff:fe61:e05d] (port=45486 helo=auntie.gladserv.com)
	by bregans-0.gladserv.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(envelope-from <bacs@librecast.net>)
	id 1ucKsT-0098Od-2G;
	Thu, 17 Jul 2025 09:26:09 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.10 000/209] 5.10.240-rc3 review
Date: Thu, 17 Jul 2025 09:25:54 +0000
Message-ID: <20250717092553.14132-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250715163613.640534312@linuxfoundation.org>
References: <20250715163613.640534312@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.240-rc3-00210-g2067ea3274d0 #20 SMP Thu Jul 17 09:22:57 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
