Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29F3CBE60;
	Mon, 23 Mar 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279226; cv=none; b=D9ETTTgW65fkH453t8F75haJAC/WslUrDzigNe9UDm2igarK4M0XyqZmZIXmMnxldJGHjULi0U5aEw8mgEnRmeIBu16u6T9iqZVtuES6cVHuO9kUjHmC8lOSpacRb7udpTnyIBRW7j+Qj7bZVNgrb61+HHZWb5suTlyuMpFdlVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279226; c=relaxed/simple;
	bh=eqFI/S4cMArLWs0s4N17TAI8Fgt+ZD0KXlrq1+hQ/0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGLf3/2S3RM6uoi3ZjKYbvvdev5BbF25AsxsNpe0/o8khVG9wB8uLyktgb11jVjLDdbTCgOFfAsTrbLWO8AcZ4sZTShC9V5YfeC88bh7f9HtYfNk744M1VHxCl5NnX0QEx6cCSXbDTIEO6teurBkVvEm4BK7SlE0bVrpThmh24A=
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
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Date: Mon, 23 Mar 2026 15:20:01 +0000
Message-ID: <20260323152008.30291-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.167-rc1-00482-g67c872a868ac #1 SMP PREEMPT_DYNAMIC Mon Mar 23 14:57:39 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
