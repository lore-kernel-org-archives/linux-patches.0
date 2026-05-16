Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759483D567B;
	Sat, 16 May 2026 11:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778931863; cv=none; b=VhDgY38R5PalMvA+AcVzxnhsL5yOzx6su/q4lpM+ZECRSdBtbDPGOvG6XDCZgOqk9cclifF1zJynGJGZcrjT1ZCzzu/43Ffd1xIrJ/UDfPg47bkvD36OayTdVBwACxHE9xRH+t2dtxuCNfZOk0BfaMnEiq9zJEmCKVnPwfaD6uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778931863; c=relaxed/simple;
	bh=mNS2klHwBgFHDP1XCTV4UDCrcANi1qVC1JjICqurCmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPZlysgpUHuhBKksZJb7SvU6CEIdTd+zIpETQyIkpn+WtdCYKVg60GREttrgmQLHFLhGqSs6PiA0J8YF/8BPgRRDXeqwUbVP9wPFinNruEgM8uJ149MEOSYAaBGHGBGpLckVwswaVOcAVCgqXfs+EzRZJAlwFygYzmx3tDLlJhU=
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
Subject: Re: [PATCH 6.18 000/187] 6.18.32-rc2 review
Date: Sat, 16 May 2026 11:44:11 +0000
Message-ID: <20260516114415.80480-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260516102236.209957148@linuxfoundation.org>
References: <20260516102236.209957148@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.32-rc2-g2ee21fdc348b #1 SMP PREEMPT_DYNAMIC Sat May 16 11:34:03 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
