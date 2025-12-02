Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BA28506B;
	Tue,  2 Dec 2025 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764672946; cv=none; b=iSAcP2dE5+5EU8XGR2i4ArZBTww7BJOla+pGjMnpk5SWytnirhtoVfW4Zl/FtSjUuY1S2S/TiSYyVewG86gpCpUb0XtZdydakptHVLKQRloP3efPE/y0aDVBmSgcDJ1TLECy2u5QcbPImBOVWUItczMFR8YveAsfRpSetE4FKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764672946; c=relaxed/simple;
	bh=mhVhYz71PwVFqWNoqIXO3MOMq6qTTcEWWrASeX6WDag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG8b+Ci+KE1xYS12EsN9TVODDbL/zcQn+1bsuB1yuBCP0UTXeUOGJWmWn/rRrb1lztBuhCA7bFayjkQQGX7HiAFiYK3K/LUCDPVrOQs4hQJ9GxY2ax6eS5qOpB/PoHq9YZ/4kdAYNK+mAaD2bmc/XqBvuYVdy7QYELIDqj9NXQ0=
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
Subject: Re: [PATCH 5.4 000/184] 5.4.302-rc2 review
Date: Tue,  2 Dec 2025 10:55:26 +0000
Message-ID: <20251202105530.3625-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251202095448.089783651@linuxfoundation.org>
References: <20251202095448.089783651@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.4.302-rc2-00185-ga03757dc1d0b #1 SMP Tue Dec 2 10:50:05 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
