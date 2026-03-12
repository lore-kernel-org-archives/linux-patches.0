Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8546837472E;
	Thu, 12 Mar 2026 20:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773348113; cv=none; b=Mr6JrKkXzHFfwraAWatVp9WKApKi0z0A4qv/8Dnmb/IutnCeex8JLpErzvgG87nLTFebpreXhQE8dvcOkTeAxpMZEx2XFj8wStm0U+iAo+Fk0n3HBHa4Q0pwiRlyNJR1ZwD0t1Q4BZLmdggugEDsUtdiIWaaKA1B0G39kaoYTcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773348113; c=relaxed/simple;
	bh=Hz9BY+a/BFbCswoSrSUgdbB3RXTMwzL/d2Hhv9YWGfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPIk2CIzu+WjrrDlseTAmoVROMiql3Mpbuc0hd6u8LWZvrqE7L9YoCZ7/VauKuH5JG3iq5464VtmeRNy6hIT6DsWVIyqpOqbg1oS+FQHloBVSK4gLbHkkBpfnlSkPBpMmJps4th+7wJkvD4mIpl60WQI+3b+bO6Pu4MhbSnVZ4Q=
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
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
Date: Thu, 12 Mar 2026 20:41:38 +0000
Message-ID: <20260312204143.2301-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.19.8-rc1-gc1996363ec4b #2 SMP PREEMPT_DYNAMIC Thu Mar 12 20:17:36 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
