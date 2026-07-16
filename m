Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045342B33A;
	Thu, 16 Jul 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213714; cv=none; b=Hbnh7twUaFTGi6+a+RxFssu40jqkg8k+mbKmmeZO6WGXV3kAgl+s0fXseRWDEHQD+PC4MRZKQ9Tbd5aYrxwXN8LP+/OkEQfy2sQKl8u5BmnqwAsFS+j+LLuZQsqs9HiNCd5S1ZWENQZGyE6OyAFsFprRXrZWNw4fI5P5lS6Rzqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213714; c=relaxed/simple;
	bh=MWd2tXb/i2ofl0XsUSK0zpIqbsO7OJCDmXUAvb941dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVERlO2fWX9uXdX3/M/xVKYfv32ANK4+IzrYrfnS64pRkacBZxOGDCPOHHbEo/hsq1h0EHzE3poBZy7B2agnnk6XDqdUdZ2vmzbQmzdITrhiSyo3QOOKzo1OoXyEPxcebbusTESNCJNKQevwhDrurot5oreJrWxaUKsEsW4eSWI=
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
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
Date: Thu, 16 Jul 2026 14:54:28 +0000
Message-ID: <20260716145452.45916-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.96-rc1-g5a3bcd4be3fe #1 SMP PREEMPT_DYNAMIC Thu Jul 16 14:44:06 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
