Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4982E62D1;
	Wed, 10 Dec 2025 10:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361777; cv=none; b=rwKMOr9a95N4vT0FfnzZFs7s5bxiALuUelewKQOxN/zhQhqSeZ52CI8qa5I2O2CCH6kCesfVrU7mjK8QyNh9gkWCZi+X2fyxvV7lQuPBbMB8EFEzAIs/66+YRe3JwUYSlDHW9Vb6nNCqiVuJ8nzDkns1mmxttmZl8fITb/feQm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361777; c=relaxed/simple;
	bh=X2SfEHH1j5zd+OXLvPgd9hoLwxS014te3hlaksuRcyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z39gEjxN3b6EzUmtq4Re8Olz15/jGAALMVBdESRUO+HgfQeiru52yDvtYx9/CyyIMuNyQmx01DmGcuJYKzmOSzRRbTt70JxaCEviyjim//pbeDmuXQINfKbmMMU+QxZLZC9qF7r8u7Xua8ueRmE0yBPllz0fhz4B6TDvWd/7zSw=
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
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
Date: Wed, 10 Dec 2025 10:15:39 +0000
Message-ID: <20251210101544.2342-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.62-rc1-g4112049d7836 #1 SMP PREEMPT_DYNAMIC Wed Dec 10 10:07:46 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
