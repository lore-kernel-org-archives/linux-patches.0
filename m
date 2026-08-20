Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B4E380FE3;
	Thu, 20 Aug 2026 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239240; cv=none; b=MPIgituenF1wWJ6Xb6NVpdpgPwvk11JAFPJ+1z9lRHs5TbXp1RpXrQFLsggLRqq+G9ad1XQQeA0tZvVgcf9EfMFGqNoLuwm2peDB3EcR4vkA9mm7gh5g/c8F40WMZEI0z4iiXPZxVI9/D8hf9nyx1LbeXz1CdGPov90I82j4wA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239240; c=relaxed/simple;
	bh=QXL+IcVZA5Wdgvt+tEwcblalYmjTuvK9IA2R2Jm5AwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvsE1uFpZTMC1GyrbFAXOoLcGFPm18RhxpFKsdccAfR1fv/AoqJ3q73YKlbMaBxxRuS4ePdnbslrq85P4+gNrBJDI2GZHTuI4kXNXfEsQp4W4OIvi8yv2XVO1vXCvr+TdewUCEYJPkCzv3j2CBU3Xg4ORqOSK9EyuFLHbgRSLnY=
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
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
Date: Thu, 20 Aug 2026 15:20:14 +0000
Message-ID: <20260820152018.39159-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.10-rc1-g02db8575a623 #1 SMP PREEMPT_DYNAMIC Thu Aug 20 15:17:07 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
