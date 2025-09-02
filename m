Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14E333A012;
	Tue,  2 Sep 2025 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756830615; cv=none; b=HtwRSb23ctyo6AwW7xPZTEjzpznlBTswNGejVlWGazwa6D3zptteoW/dRNrq1jyfAMGzZkOFQA+qFkREiw3bZlUPp7/vaMcp916IPQ+MrtZeaAK1lSupF0KnR0Pbxwyv7+WfbYOagTRBQBW4ynuBfyO52cARl7ZpiSZTVT6Yj84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756830615; c=relaxed/simple;
	bh=KUsBOCsqj6H2YzdBag7jxXQtiBFO/a5z/+8opYgVEto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYUF+tzx0t2Urltgx5D8tn5mDGPi4Tq7QLiZuOAquppgbKw+Uc+5qyHu9bFRPpmEuYK0ZUf8WrmCESWtzn/nogCD8i64zqv0AG6UzKMFjv0HjKrGUGIgi5IHXEo3IRjA92y8lTI6YmllisxKZ5inHgQui9OoH+4TTSFmcBuYf6s=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.12.45-rc1 review
Date: Tue,  2 Sep 2025 16:29:41 +0000
Message-ID: <20250902162940.4389-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Broadcast regression confirmed fixed:
  https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.12.45-rc1-g4459b7afd68d #56 SMP PREEMPT_DYNAMIC Tue Sep  2 15:56:48 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
