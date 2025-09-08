Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993372EB5BF;
	Mon,  8 Sep 2025 09:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323641; cv=none; b=XdkH/MjGUt6n/RJBHAhIZVwW7S2kUZAAYFTOh0zjB+yvkwfYrJhG2ZLOAR2zxiCM9TfgmfLR52DMm0XPJNZjhM4iatfl1J8UF5nKq/yhabMahuhzdasXwHUW/zwJoRIBSboyctztHtrqf6O1Joxlpobwlvn3AGrXQIkqjg7NsiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323641; c=relaxed/simple;
	bh=cE2w0Y2k4uzTjH+sAdsJuM/FTkD5N3imvQMbQ9qi7wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPBewvoT9aZUqTfVZ6pG05RAK0SKoVo+7pv96zZciD2T/lSeFtqMgld5QC6SzIj5wevcpV36zeUuTtdD05o7f5edCwL11vae7bJnmB866kHH2knUAgfSxxxVK/w6pKPfHuYT9IWUmb5/0FX4f5YIuj9HyRwnO9p98C7WxefORV8=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
Date: Mon,  8 Sep 2025 09:27:06 +0000
Message-ID: <20250908092705.22794-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.192-rc1-00099-gccdfe77d4229 #77 SMP Mon Sep 8 08:57:49 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
