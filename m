Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD833B841C;
	Thu, 30 Jul 2026 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444121; cv=none; b=sRme+z3Ain4/Vaq+b2a/2Ds8DbzcBUMbiAa806dbAE7aVus90wUK3mBU3bt2vSuhGobOHWWLcp5A1MT5cmWkbWxqpvNgM0VzX0Z0Zm7XhVoEt3wKxdNdV/o/U44u6VqZdOpTEGXrwx322CjGY2DirQXEzGATXHTfWfECPcbOiUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444121; c=relaxed/simple;
	bh=DONo+OlcJ6ANxskxYGZaSqVMLajgu5L94d9TLewylyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIFq8osOHqnBcr0U6Slr0gu29UdGnNqR39s/lxu8QgMTijwKGTAq+sR9H+nq0vXKdL5G02BVxqLlaR5IW06hYyF4vrozzty2L0Plq6DcKEweApJ2mifLtJDpOwlEBOeUWlPJubBnQjIUKkvHT+/qq5cYiW+bIEL15z3fijqzez4=
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
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Date: Thu, 30 Jul 2026 20:06:45 +0000
Message-ID: <20260730200647.20049-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.148-rc1-g7f195ac3d444 #1 SMP PREEMPT_DYNAMIC Thu Jul 30 20:00:35 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
