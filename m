Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F0933439F;
	Wed, 18 Feb 2026 09:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771405779; cv=none; b=gLmKoFsxurUG98CqSzZzUe+dY+V1AGWBrzaOtAefzUWbYiJgVmx33D8eK8eesfP8PJJH2Ie5f3w6PP1/ECg5xCyesabRVRRyas5/ZxbQYJhUtarYu3OjVeVE9og8WOkgGxrwzw7dIdiIDnH30zhepxKMZ/uQtD4m3rQQb1PAJNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771405779; c=relaxed/simple;
	bh=eWi6TQ9pu3U2zX9/b9tx8LMVQBtgg50i2/+OeMM8Fg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xrq2guj/Ep0uvtQgg86DqFhmMT56bsew6nu7ir3U7i5F3ezgLpDMNgteXREaH4lcEvK4Dwe1leA76CYqE+iNLmpX6kpXRu39GrSCBuAPXWO87h92T/tW64oapqUeI4nnAed1MU/+7lgYSuEIbHrnIiCCG0e7JLBzCWW4EjiJ5jE=
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
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
Date: Wed, 18 Feb 2026 09:09:27 +0000
Message-ID: <20260218090930.9798-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.127-rc1-g27a952792232 #1 SMP PREEMPT_DYNAMIC Wed Feb 18 09:02:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
