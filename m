Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1790DF72;
	Sat,  4 Oct 2025 11:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759577773; cv=none; b=GhRrndWKwcbG7awqzE/lCpXW40X3q47BblGRr8YaIPNeMWM5u9JYXpY7keTqC6uuLqJpreIjxlBKi0UcjcwGucv659Y49oONv0pPgjMLiK7KIWxD4kGZZxAZ/rifi87oKv9pd9LL1bH9aJNKyp7M0nv6z3xz1OaOGJWuLsWycWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759577773; c=relaxed/simple;
	bh=1gE+MX/HpomFHqTYo8SQhgjzvc2XmdPuvmo4GGnfD7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2nRuw7FFpJgjVdj1rpgnIryM1xgqL63cKGn2+fawPtIhWyp1pmwGpMz2KO7xYXmLU1ISFY1p5hWP0mXLL97vsNmGit/v0RapCkOixV9BPBkqh7t63rE76jKjvWKrGCSqkh46GJwcKEfrmGTYTHZnHQjLPsA12BF2TwNWvuFO/I=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.16.11-rc1 review
Date: Sat,  4 Oct 2025 11:35:54 +0000
Message-ID: <20251004113603.20436-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.16.11-rc1-g13cc90c947b1 #99 SMP PREEMPT_DYNAMIC Sat Oct  4 11:25:13 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
