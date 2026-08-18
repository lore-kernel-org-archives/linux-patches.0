Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C952F27E07E;
	Tue, 18 Aug 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787063778; cv=none; b=hwe89AljvcwRvsKDz3yaVkDrqKTnwTNi/MG03IMJQx9pqXRH0hEaCJe4UwBFPB3dWbIHz3+gdxJON+aCOoNTWfAR6AQPGLbJy38ELeMy4ChrBlotVkYfy9x3uL7ZW9HL05jZ9cBhJeTPRkHHyabekZQ9KI7fUKpxuhV1hcfF4Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787063778; c=relaxed/simple;
	bh=CP3lDjDjNLlD5vkw+xlW7Rh3Me+MS5R7QC5ZBTO9rH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4FXHoGcA/2cU4oyxoS+pA6bdebm8orsLEI9Kxus4qy3IqfuCo685MaunLzXwv/JlfKQ6qpHq7LDAAO+Esq5hE80STeW1V9UEYdcL2XkgcOTr6L0AH6XzBrCsBlV3iaSurHKhuj5RLKJZcYvesNkIvOuWtxz/Ug1jpVuM7IE5EM=
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
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
Date: Tue, 18 Aug 2026 14:06:14 +0000
Message-ID: <20260818140619.30813-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.183-rc1-01649-gfc1a790d487e #1 SMP PREEMPT_DYNAMIC Tue Aug 18 13:49:09 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
