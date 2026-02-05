Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AB42FD695;
	Thu,  5 Feb 2026 17:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770312094; cv=none; b=IIOUOWJt6V5YRz6UOB2yX6EUqK9K1vu246rlGluyzCPZ6UDgla5ooWPmUedl0HFLac/bZ0mrXfXda1hKsKsDAIIbsikuZfYiKSlvLs0Fuj19k5KqsyudGwLV00tZHc68S7npWdwNrBFpTMXv37jnB3sQpvqFzbAXDSh16li4WHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770312094; c=relaxed/simple;
	bh=uTsec6yyiGGMFNvFYNW0gTc6U50ogspJ8Sofd+VmZ+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELThE+1H+V/d1X8bdfA9ZQEzZOX3p19yzPcD3Hasb0mkMvki6wx/HzQkCbLNmQ7fRSKQNwPlpadP6grDC+AGGTjqq9O1MqKWVR3DxTxLBC5CYB36YEflQ5QKg7iIoEXHNJbx+V3UhXanSYVIFAonHsSEKdLhlPjJfRigldIKxso=
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
Subject: Re: [PATCH 6.1 000/276] 6.1.162-rc2 review
Date: Thu,  5 Feb 2026 17:21:25 +0000
Message-ID: <20260205172127.15781-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205143450.492803005@linuxfoundation.org>
References: <20260205143450.492803005@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.162-rc2-00277-gdad6f0d7f8e3 #1 SMP PREEMPT_DYNAMIC Thu Feb  5 17:19:33 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
