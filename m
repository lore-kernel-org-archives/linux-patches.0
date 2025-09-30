Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EDD14D283;
	Tue, 30 Sep 2025 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759258234; cv=none; b=CzqBAp/GYdYHaOix0isFfwymfiHoEx/rtlGkiThg7zfc9qHwW627eHj1HySY+kTJ+0Mk1/IlmmjKWeBieyul1/z8zDgzyNpBmor4TWWHc4ZWr0tPlQROu41CmwwvcYzXZfOqiIliketCyCG0Ocq9FLDvMMwnZduyFeMP7tOSKoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759258234; c=relaxed/simple;
	bh=ZHeL/lZQYQn5N+jdEVWOlTvsNHA+5/iBusvsjps9Qto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCL9ElKeXhPeECEcJwuYLjEpCnao2n6OowBToM2EG6A6yjuhvciXL8LtCay13oG8H5X9RNFOBgEJ7vjFIt1YM72CrEfzQj5CJpott6t15DeOtlnH/u2cEJbMXQseJAyHYZhUNpSL8K70zeA44+ldga5Fy69ddIiuQk11QZH3tsA=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.1.155-rc1 review
Date: Tue, 30 Sep 2025 18:50:14 +0000
Message-ID: <20250930185022.3852-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.155-rc1-00074-g8a8cf3637b17 #94 SMP PREEMPT_DYNAMIC Tue Sep 30 15:50:11 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
