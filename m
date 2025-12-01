Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B5523909C;
	Mon,  1 Dec 2025 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764615591; cv=none; b=MVlh1TqDOjgv+zU0+hOWMr6ICloHuSB6/ZSy+pflxJ7p0pC3blYHlIqLC2RQkKdgkhju5gENGefGiGPaBg17iEedepVgTBBQIBcJcB2b1ZyRoS5NXz/ZCoV2iZ++yOXWa3S/r5UX2wLzPJcNstMVQ7vOynj3zs4kf10WoqHA83U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764615591; c=relaxed/simple;
	bh=j73ZLvJcZkjmpRtyb6H+kLtZlWmLblw05hPnBBZwHWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSZz8A501bYxOyYwGUT35XF9SFuBLEBvpYS54bhc43YcVtY47ArOmqYv1/4x1/WY4AQCmpugIsG3if27NK1eSYoYlWD4AnnArQvNwhFCHrvsQ8lZvdWyAUZU1nBElwkk3seEDNzDNzagsOMR+2Aijv/Ebk9VwSzds/7riNI/HJY=
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.4 000/187] 5.4.302-rc1 review
Date: Mon,  1 Dec 2025 18:59:13 +0000
Message-ID: <20251201185921.3671-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

Build and boots without error. No network tests run.

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 5.4.302-rc1-00188-g9ffc25b9d59d #2 SMP Mon Dec 1 18:49:20 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
