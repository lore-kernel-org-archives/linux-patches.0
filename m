Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1966A47DD79;
	Mon,  2 Mar 2026 19:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480161; cv=none; b=TDeb1frESJCiQKlea2GjmfepwQFzDheYKUOl6AMgPk1LF7Lcm3UCtJeAhUBccNPKgl6A4h13WkHMlmSqdrecMi56iEtonUU4UQBPJpzCbOJ7FFLbR8dKJ+1aUv3djFDUE5PR73wIm8DBRw5xmuy0qAW3ePoUmspzz4gDfyPm6oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480161; c=relaxed/simple;
	bh=8jVKyf64VFqD8mfaXRetKiEdIR1jDU54xXlo9mSjYdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lusfrjZMyDM/vyLgCXb7LXfXoswgC25cHSmj0Gf80c0PQfm0NMpqjEMFFQsYG8XoQGkVMDnl9ym10Z/0JPtOGUZ/ebkFxRrcqfOdd1Y42vBA0Xwi3Gb5k99qva6m6h0abjtrq8SlfCRsWi9PrmUvle6dcnevG9zUqM7JkAkGKJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: sashal@kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
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
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Date: Mon,  2 Mar 2026 19:35:51 +0000
Message-ID: <20260302193554.3392-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
References: <20260302160834.2518716-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 6.19.6-rc2-g7751ba022511 #2 SMP PREEMPT_DYNAMIC Mon Mar  2 17:25:48 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
