Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9B43C5536;
	Wed, 26 Aug 2026 10:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740364; cv=none; b=u2+n6S71V1zAzcZDH+AmMj7RFvtstrnhuZm2ZyletA/r7fM3kq5PRhMonPS8rOtLrx/kWH1AuQgioqEJTmABSd1dIzsXdNAHvE4N4M0TjyODkgJTUc0wTBHLlpDFihhv+dNM86bskR92voXnhNUypEDs39vcvAUwSTADed797/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740364; c=relaxed/simple;
	bh=MlILYQz/YF5gssdskIb+g0cpp5ZfiRqxjblEzuctqFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExhWjtlZSDCkrVFNplN9SDYfufbYQW5zKA2bHSqko0Ajz7etUZRnky0oaoX+KyGCvVe8kEqf0+jgtlU86t+6BNuMyN8W3oaET1ffp0pv9UJiGeW/aW4v0ba6n06lEjB4SSWJ4psdGvm9Oq2gcKsLXl9gwRHKxrGGqW+6nLmfUW0=
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
Subject: Re: [PATCH 6.6 00/87] 6.6.154-rc1 review
Date: Wed, 26 Aug 2026 10:32:32 +0000
Message-ID: <20260826103235.61434-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.154-rc1-g8147a3c12dd2 #1 SMP PREEMPT_DYNAMIC Wed Aug 26 10:13:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
