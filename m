Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4F38756B;
	Wed,  4 Feb 2026 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236341; cv=none; b=t9O0EZEBHliQIw2CO1Dj8SHxIlIlHgguBQ/77FRWjosGGJ9ZYGDqeMkGwheY2Ba55xiX4YG+n0DMBqvZQvM9H0ckm8HaWGnKG8wEunkI7RUH7sCfHQDgtT2tPvahPndX7C6LbkC0DqdCzYmrJTtEGkSo8luwX7xPpuIsZcWOKBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236341; c=relaxed/simple;
	bh=JsnsuivJ+2Pv4xj26JTh2FWJLNhL/pKJbREsdbRzkdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGnQ7bHUTdoyHVLUWffx7zsSAmpnCARL1x4U3z6HMMr4+7Pq+j/2IaM/pkrFe6CoboFBmuT7J2VgnLgR1h/erJgoF36IpOaZ7BzoDOTIxRO6Iyrk+vOKs00sl1TtsXS81XFCl52WRDViGqZe49lftxnzEUXyEYCiLE+wZSdEGRs=
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
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
Date: Wed,  4 Feb 2026 19:52:10 +0000
Message-ID: <20260204195214.1788-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.69-rc1-g07626bd7083f #1 SMP PREEMPT_DYNAMIC Wed Feb  4 19:40:33 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
