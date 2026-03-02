Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C884A47DD51;
	Mon,  2 Mar 2026 19:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480158; cv=none; b=LFek19uF/YQBBmPdaZ0xfzwtjo+H5iB0grD15pEMUliQBRcKKav4rx92xwKFyKCL0mBsCRSbGJuDdwVVqOwqIoyQwp43/J+94TSOjqgjXEFIk9VKqcoYGk6YYmkPY84AMQSXXEhlK1ADOOGPf4z//yenUdXxzt9uHW673Qwqhuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480158; c=relaxed/simple;
	bh=/bHYbDWUh+YwI2lEhA2S5NqPQOqGiSaKcDNTNNvpxkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzR6htXKLU9vWLz6hwFClz3dXxXnc7Cyo/xzHoNTAQHF5vk+onAdx8rpcD9WEnLP69FlhLoh/3MldP8iqjLkTmLuFPH2qqNmwjLttiyrLKecLwRWtgBNmAH0aDZzkbBioUJDygVTfa0ZmFdD1/quywtRbz6B/HmS8I+w+S2xhUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: sashal@kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
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
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
Date: Mon,  2 Mar 2026 19:35:47 +0000
Message-ID: <20260302193550.3351-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
References: <20260302160853.2519610-1-sashal@kernel.org>
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

CPU/kernel: Linux auntie 6.18.16-rc2-gdf4b95bea8b7 #1 SMP PREEMPT_DYNAMIC Mon Mar  2 17:20:27 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
