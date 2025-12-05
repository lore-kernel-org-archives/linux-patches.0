Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D217328B72;
	Fri,  5 Dec 2025 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764931932; cv=none; b=a+1+CzGShK5BZIvpZdDWs/7E9HpA48zzxk2z9xJ91qdJq0u5ERWOO/MlQKBb+QYUKp4vvRLhuH5czG+tEoC326oR6cEP8erDosK6ZCEgckJ7r4iuA7gO1wTXz7p4TqD6gJADf2BhbUYao/mvm9bUhmuq/+PFKwMTxrZAhcF4dyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764931932; c=relaxed/simple;
	bh=LfvpbY2BIgeOEr543g2hdgx44wT7PQaMq8+nZPCNjPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCUkSb5yB4KnYCn7xPOtYBiFKs61cX038NciU5Qsq9ZTgzyyHps5fOCyzp1Es1lO7oksn1JwpUPVXJIWGX7shCRVo0/gV5/dpQhLnwHKXhRyFuu5JL+aSmuMKerhVtH3NyEb/jw2y+lkpT3PUtL3CjjdEdxfvppD8IbqvvNb9uU=
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
Date: Fri,  5 Dec 2025 10:51:29 +0000
Message-ID: <20251205105134.3918-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.17.11-rc1-gc434a9350a1d #3 SMP PREEMPT_DYNAMIC Fri Dec  5 10:49:28 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
