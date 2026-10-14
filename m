Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8335172D4;
	Wed, 14 Oct 2026 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984061; cv=none; b=X4gNr6EN8gSKNHX+K+J+gpdS0uZthoXgVQtbUHfiIHaEjOX3hXex22avrW2Szwks8NqxQN/kmS9Pspm5+co09JJ3YPP96J00e7RLFace395vR97qyrLdlUJES5aRrgLK3kWANauqpbbdZzuYDzBAkUGRygfIbJ4isJ2MYu0jUiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984061; c=relaxed/simple;
	bh=nRLZnv//dwSZ3z+xSDKmbCSB3JBY3nE9um3ko3XnW/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEGqmsNKBWVnfSp/atTaKxj3aK8n+mOSU8s70CSsErIKPcnDT0XAz5w+oeEfOFdV+zuFYGy5TP1a5UVm7HequflP8L4AYyclTPIYF06JYzrDBkT6qojhhtUFOxF5UQ53fV5dx3UzLU6TGipvNoaQjW2tkkF9hGACb4r4iue2vwg=
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
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
Date: Wed, 14 Oct 2026 13:20:47 +0000
Message-ID: <20261014132051.25842-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014123820.008483134@linuxfoundation.org>
References: <20261014123820.008483134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.57-rc2-gfea86ab6861e #1 SMP PREEMPT_DYNAMIC Wed Oct 14 13:14:11 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
