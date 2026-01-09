Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C933238C29;
	Fri,  9 Jan 2026 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767986344; cv=none; b=J8+Efyz+DPJ7Stg9Un8HuGDEEOgZiG7hjqQvHpEfqSPCIZSkucjkN9U5n2IBiJYT+mNHTy3mqvQvzz71NbcfAC8Gz7BRLbMW7lDQAzkU4gBMm/2Ou+ikxXHxtcx8EyGs8hc4JMnjmfqX/eaDx5gWAhyyWFNV1/eXtt53jYVUYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767986344; c=relaxed/simple;
	bh=gqIeSkxuNb1x3XSnLRMXu9v2if8gTNctz/ZenwYdv1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8IQ2wS2s1D8+ooTAXYexiXxQ1XpNa96ivjUMtmjoSyDCvHOXb6KtI3bpBUxH2GN5h3VjoPFTWvM8jf9x4CMaSf09C0r07//l2BXXJ6A9e3C0gTgYmhUOyskbIXRdXl8TOwepeXlrGXLWCngsdXRIIIh/9mFakzLRfr3c2g2df4=
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
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
Date: Fri,  9 Jan 2026 19:01:57 +0000
Message-ID: <20260109190200.8424-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.5-rc1-gc4b74ed06255 #1 SMP PREEMPT_DYNAMIC Fri Jan  9 18:57:39 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
