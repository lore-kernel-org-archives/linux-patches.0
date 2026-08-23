Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DFA2931FF;
	Sun, 23 Aug 2026 10:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787480968; cv=none; b=P2JN1m8hFYRvJQZ1aoympwekrvPCCqLyS0GsOhn9KDS9yYZCHHaPnKXdw/3S7T3uVm8fwW2o1CzZpwpG/X6sU71Zy0TAwAEPdFb/UyfEynROfOkaHUpQKfAQWQkvyALt5fkbG1zeuxPyr+9N/a0QtM7Mt7BUATHRmD2NUDhYQxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787480968; c=relaxed/simple;
	bh=GsAL/BHbzsswboNxJoGsoGpL2SHfKdIGu+0QRVx0HNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGr8CgqBENJta8uuBqe1XmPljWwQioHXByfkSilIMLi2v3pQrpneFViUY/D3H8Ch5NM39ANfpZFQdbX18jOwJeFmwQ1vafHvNIKhV4ZSWvQWJLcKfnilDrA0H046AXHzlnnBiJtJuWFWoJaexnjBR2FTTfFCvF92fyfbB5uo544=
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
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
Date: Sun, 23 Aug 2026 10:29:00 +0000
Message-ID: <20260823102904.22569-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
References: <20260821142844.249995408@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.153-rc2-ge13153cedf62 #1 SMP PREEMPT_DYNAMIC Sun Aug 23 10:04:04 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
