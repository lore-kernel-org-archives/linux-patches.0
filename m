Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56537CD2F;
	Sat,  5 Sep 2026 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788611294; cv=none; b=kujOPvCAB29u0lz3UBMNvu6G8J4vzjEU8beqfT6G1mYL2RILWbp5G2P1dnbngQLcbaMUqFgU2ALgMcuSD+5Xlf4Gyh8tKMYgXPmwAF+YmsoZIXOAGDC0QSJYOBUgYBXuy5ESusm7CqaSrH0JgZ8Lqrs5J13UK3EzJdnpIJcyMeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788611294; c=relaxed/simple;
	bh=BJYo+V7Awb9p0ztxNijtEgrzJB5hIfnTSb1h/R4YLOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBH0rKKhSby5SvbzYIAwN8CziU9G5QTlrTwAH2OTe1F5lEVvSS17ui986kRlzSmdRAS9aSrK/jwYx/fTAPRpaFzDRUXXQpQrAgcuZj/Sfws1xmun3kpTyV5zIsOkoNBoOoQUH5dp0IQxYWKa77XoZLr9yHiv8J181Ni5L/yXdOs=
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
Subject: Re: [PATCH 6.18 000/551] 6.18.50-rc2 review
Date: Sat,  5 Sep 2026 12:27:50 +0000
Message-ID: <20260905122756.105083-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905115635.269562615@linuxfoundation.org>
References: <20260905115635.269562615@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.50-rc2-gf06ee4caaca3 #1 SMP PREEMPT_DYNAMIC Sat Sep  5 12:12:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
