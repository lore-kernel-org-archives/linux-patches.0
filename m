Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216405;
	b=qQVUs19xlyYiLRm1IDUBnC6FfEKoiYmJIJFfl4IecLZplglctLchx+gKtUdMot3dnBd4
	 o/uTDjgsDIR/9xamIp5r2oSeTtj6XQ48SdjJQe7rSUFBsHiu6+oJVgcc+UjcIaXisEQjr
	 KXRWr4mYAWSKufptq53pv1GPRDfT5Dmw8SQeqXcbdQDNxCC3XYhwVM+iYB0WRwV/bMU/G
	 4F0BUmeXw16+K/dyU/SwhCvJqsxlSK31Oan1A2MuY7oqtR37wOEJ/Px+pJMfP1xr0T948
	 yMmTdBM5Asyt+Xtn+LUT4Vji0UENsZ94C4lI0pcr68la775qd7EYYE3HnihQojWM7bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216405;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=/5q4hgET0hWjKQYjxzD+yzDJt7bHNRraKOLBAg9jdao=;
	b=xUIic9m3+6kyXrIu75Z4WxG3W5fSqlxwvPCUkBhNVLIT+AwE5q1xIX436wtgwj9zB+bi
	 MZpSGbaz67VL3DOWAnx6tvanktgGtYfhB1RTo6qqCsqp2In27y4X0dhuheCiVblKeRq+o
	 1JZPITJAOVCOjVS5XzM1UgPi2VpuORmfANcwkz2AL0NRbPZC/kLQJAL960u4gU3GYZ/Y9
	 N1bcnWzI+hGVCyV75MM1YGAJsKvtZ6dFruxTLpUi918SbRSGkOdD7dUHAYynwmWyUXKbJ
	 ftWRvF+J18NjBr+nD4sUnhOnkBr9iMEYgI0zS7gq9u5B/IfZhxl3/+cIcy2nBzb04LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3572E606A326;
	Wed, 28 Oct 2026 19:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3572E606A326
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
Subject: Re: [PATCH 6.18 000/109] 6.18.60-rc1 review
Date: Wed, 28 Oct 2026 19:39:50 +0000
Message-ID: <20261028193953.85959-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.18.60-rc1-g61d622c89a02 #1 SMP PREEMPT_DYNAMIC Wed Oct 28 18:29:26 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
