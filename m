Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2A137BE7E;
	Fri,  3 Jul 2026 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072378; cv=none; b=bQyoJUIXBsbg9BFOOgLl8YTKP9hW/2BUk/34R31eulZrzuCOYIqv42+wfZqlE1uE9LaL+g8muXgYLt89OWt2YgEk7aoX5CLYqWmDf/ojLI+Bni67Y43QvaFKPP1fezV/MVS29i35rxLb5pl/DEM201flaaABelLO1Vrck+bCF5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072378; c=relaxed/simple;
	bh=ugu6B4HUs+/QlWeHZwOA8BqzVsX8zmwOo9639Kypl90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ep1B8CFHnZiRmUWC5FxzxCHlAF22K0d0olqdXsvAAXwOusPUS+XKv4vY18YMSVXPbvGnvTvE1tJLOzBucLQqMajvmNrQ1Y6+PWkASqI6OmmiRZYaZ56MRvdVwMLtiOpZcpPIyCR2nLshdL8yrt32XJPqIzY3Ovw8VFmyILFXn3I=
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
Date: Fri,  3 Jul 2026 09:52:38 +0000
Message-ID: <20260703095243.50943-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
References: <20260703072825.068705122@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.95-rc2-g12a857d79c6d #1 SMP PREEMPT_DYNAMIC Fri Jul  3 09:10:02 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
