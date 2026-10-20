Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486071;
	b=QxVjbhvw+tf5cXQrBL7HAdTzCzWvWLNJQFdl+XdhhgN5D2f7Qh9CQPPzsJX6twu1IdkG
	 hLwHTtF+r7vQYWJ1FDaF/fnkFgNJayzmsOobOWIfUwgywaaSu4Axo2RKp+3t+NPUJXyc2
	 vY4zBazilp1NyfZfLrNgDTiLaAXuntrUbqFSJtMH5/YRVBJt94Ov1lqC9KDT4t/mepxHB
	 xPkiMbNCFAfjYozzyWA/39fxeS1EDCQCWrd91k4AZzOFIskom14W5FnMViPmqdXGMtn6x
	 aFhBRBGGQGsjxRnqjsOr8ZyByiie1U1PUbexuMwsx1f9K20GMg0UDccu363zZ8k+vNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486071;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=4CDV7Fb28f7p410QdXOYcdHtqn3aUTnJhPVD7hO35j0=;
	b=0SOwgeyKM3+mDtITbA3wsiU00kmMkHEVfzTI5GBfwj6vrmt2IhCWkPc7hgQZZ8W5G7Xc
	 jjU1Pgh+4BOOiXhR6Nt42r2LQu1CbvIqctaHGDsBOX+sZtpgi1mtKi5AtI5Z0nCnpktlp
	 5loOL4XrPyjrcSFc2pdlsU37almj/IKRyZGj9vQHI2SoZb3UAT3EDuk3mT0gEdEBQj3Fo
	 M1LvJvYqsXGo1bI+T/kraZwCD2yronLyy1swbN3HXsKizaGrnYamUUs06S/KRTbU56/Tv
	 +8wIDxFZwdjd6AmMMbV0Y4OKdRQn3sBc+npR4zqUsiuE4OKZ6WAaxaOVP3JWSZeshhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F17606A31B;
	Tue, 20 Oct 2026 08:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49F17606A31B
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
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
Date: Tue, 20 Oct 2026 08:47:34 +0000
Message-ID: <20261020084738.42318-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020075535.084584701@linuxfoundation.org>
References: <20261020075535.084584701@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.160-rc2-gc578c158a368 #1 SMP PREEMPT_DYNAMIC Tue Oct 20 08:16:25 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
