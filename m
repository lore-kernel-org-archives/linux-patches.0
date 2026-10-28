Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216403;
	b=Vy6KtYoCJA/h30w45gc1Py9+Rm2fyqBf6nRJSM2E8j7Pf1n0pQcgCc3MJGm+Tzmf/6LN
	 DfHXkr3OYzzH6T6XRIwcT5E03rsxgBQmGd3hGKtsM0cQiEaQ7si8GMCFWxkdbnZurv37R
	 vR+Ou3uTkKWk9O5TPtikFMnn+FTPwZ1baDQC5ZHSJSVBf6H5KlJ1Kbjqs4nvr1H9fBkZ5
	 IEwGXPqqkMSmUjBjzt6tlH2c1QPzlRWHsiV+RtKf0vYbEE5+mP0RxaYUMHld4w2WHK890
	 gtABvalqkiUUqPFWOkVApEBASp9VnW81U+ejoIc8qoSqey9EtIDlD2X3ylApuJsjAsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216403;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=DbZrs6QE5TY/aRLEnexnq/XF0yw7kphb7f5Ao6KxKBs=;
	b=PL07KnzanHHiEG9SgisRxyrqmWMn9Jw3bGl131ZqQvFA2Q9kAiS7tguawR0FkMmbBkTh
	 Wx1vXpGXBWbIpZpvkVjL5vPUaNbNn2la55QujWCmXolA6NALUQV9UjPbeOZCTd/xlev3C
	 30mmj7sLpNysf65+m1/CGBC22lx9qov9VYB9kT+lJKAVIz/PTAkaWPu2S8bh0hzM8ay3f
	 C7BwK9xRo6c4Zp/6AUwbJNiTpgTkiE8EgprlYgvxZ+tiiy7uYeYYRWgu1KP6RaUX1YF9I
	 gqWBBFTtyr/sLLnVwuBTtBiL4rnrcLzi6Xfb0pcV0RkpW0LvEHMKCd/F7GO1UBmpQQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29E4606A31E;
	Wed, 28 Oct 2026 19:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B29E4606A31E
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
Subject: Re: [PATCH 5.10 000/516] 5.10.273-rc1 review
Date: Wed, 28 Oct 2026 19:39:42 +0000
Message-ID: <20261028193945.85857-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.273-rc1-00517-g827e3840d937 #1 SMP Wed Oct 28 17:48:41 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
