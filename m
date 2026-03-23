Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6915B3B19D4;
	Mon, 23 Mar 2026 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275204; cv=none; b=a0IkZ4U4Zh8V7V1yrSxRvsUTOcbjJ3TmHixHf0yd+gLazL6AwZ/237RNkMPNmPe8sJA6OkIzlamiCSwtY2xWo7feRCZld79ehU+WaO/HNUMj0zgrxdd+xAwuVlWFwNT4Z+aA3ebTlrQ2tXC8kZWKBTHCotV1Zq2W+mtb0GgAnwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275204; c=relaxed/simple;
	bh=sGoqZYtTY1W1VmSLDgzscN9OahB1SaWtPZdq/fQhw2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGG9v5rMVAbsZh6bE0NILbEXFKKdB5epq1ADH1KfOVRFvO0pEUunaeCxHyvChvDUlo2zAenzyBX3AbmZ42fAZri/YDUxAXhmKZOLHOBt2BuxKsE/RJJ5YvYIiDdhPWFX4FiYcmYavKyW/rohweDh7HmIOSQj5OOfkuFhuXBChL0=
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
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Date: Mon, 23 Mar 2026 14:12:47 +0000
Message-ID: <20260323141257.48446-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.19.10-rc1-g5cf3b8242cca #1 SMP PREEMPT_DYNAMIC Mon Mar 23 14:10:11 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
