Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2143BD657;
	Mon, 23 Mar 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279227; cv=none; b=ibYDytZhVZEfF08beJaNmUgXNBJIcr8vghTLUadFQNioDhCyVujWHulTEnUSNCp5LgI8roJO/RSwQKDUDtIzz4qTu5FHx6AsMu/UWtyi53ztvf6soYRIOfindczERU9hU0WrIm29M4AiFYENT9BCkJ2mUTyPCxDbI26pdJyqySY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279227; c=relaxed/simple;
	bh=M2jaoEMXzh1sibgYUeKxHjiBpyFYTFvPaCNUoIPr9ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWNxw4jtXoL8KwGadOinguqhYJrmQ96jv+PU406BBcZK7HmwakqAct8axudN8wvLgv7SL7MwwFck3K1O0c/WwAQpBm0ZAs6fVRVwVXGlvlVqq57NQHJcdHpWgIgXj5CVmmNSwiY8VRLq/XW0h2Xo93d5IDzIblXB0AMgY+mgpXg=
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
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Date: Mon, 23 Mar 2026 15:20:09 +0000
Message-ID: <20260323152012.30331-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.78-rc1-g461750713daa #1 SMP PREEMPT_DYNAMIC Mon Mar 23 15:00:49 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
