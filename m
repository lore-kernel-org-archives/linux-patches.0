Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792486071;
	b=CPAidzvX7N7ZKddvxDN9MvgyxRrTtcB6UHxRZnKHwSS3biPgCH8TX2RBXSfMdDfnziN0
	 sQgKJ3xfVhk93ShcgREqt83hQcn6M3X2F9u6/5uynHFUwA6eXnS2G0p322HEOXSMXRqZI
	 QBgcXYQ9U8/e7zxWLnXxFfS0bgT4OoANGuQDnG3zSbGf3cBtSE/vdAem/f+p7lYOfREnl
	 9mj0YUae3oRZd8uUuSJbye9gA7Fgll1lK1qZ6VutqHr5TdcjIC6H5mFZasd2c+vmAFTwY
	 XhcDs5xq66QXr44vuR+M73KuMI2GYKNVo6b4Yt9xB4YewASCEVWnO9upgpAgYJpehVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792486071;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=MqZf/TMKTmgV664P9rGulqa0tOLFZnCQsQiI5BOUexE=;
	b=Q+3+ksWS2agnKtsm/Vt5nM1VyrfYggoUniG0DUu3hNKiiaxRXLc6boQ2FlbG7esMO4D9
	 di6H6Q6EsEvcQFBmPmaIbYymeCBNbjyd1MQcREUk9x/73/Vs5Cfapr+C8141j+gh3BXm4
	 FkepeCZWXGhcomgGswg0sAcLjIMqI1uTIMy4tBhcYuyMCzA+c2gR03fzn/6NoNuNlVfqo
	 fEsLGE84LozFnTvckOpw5Ju26TvkpL9NPQ6rPhXUs9kvmcVQLsITG5bk8ft/S6rwaXfEu
	 DuBGQ44PE8nADgLSvd0nllNJxKce5DdyfWPd5+L5/S/9fUaj6PkHDYCt3yRg6Vi0b4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99381606A319;
	Tue, 20 Oct 2026 08:47:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99381606A319
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
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
Date: Tue, 20 Oct 2026 08:47:25 +0000
Message-ID: <20261020084733.42278-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>
References: <20261020075246.861837975@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.114-rc2-g9fb48106e91d #1 SMP PREEMPT_DYNAMIC Tue Oct 20 08:13:31 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
