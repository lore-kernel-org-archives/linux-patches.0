Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEEE30C343;
	Sat, 14 Feb 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771084946; cv=none; b=s1XQ+snFpRFwIVBk2CVY0VboN0Lq4c+WJc6Jo/9WIRyNLkFraIEnF18Co2UXbykJwhjHV2IhpIAe5yES8E3MZ/1JYLqEPNIlLLPt4INQ/IpP1ZVEHC9o7YhlH2jiYE+EkRA4fH/03HdSLPPh7AK3SM2bzsBQSIuJPHUVGxJIrLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771084946; c=relaxed/simple;
	bh=+pf9ffarTZFJ7wtuz4BIbYqBG2lYpGTG+yVklzPcv4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp4AxFSk5ABFnHwXmnWRMlLqL83vAWLquNwsNY8uovLP4HBAgjR8elHMQHw5S9tS1Q3vzrL0i6AU5X6WnLthrSyX+eDcgyTj1kTuZCR/37eqI9hxOSJZ4aboaRJvY2QII0+B79lFoJ4HAkVGCOTQkVp7ji+7kOfsyAiD8WGwl3c=
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
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
Date: Sat, 14 Feb 2026 16:02:07 +0000
Message-ID: <20260214160211.4444-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.11-rc1-g1dd43fd284b6 #1 SMP PREEMPT_DYNAMIC Sat Feb 14 15:10:56 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
