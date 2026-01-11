Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C10622B8B6;
	Sun, 11 Jan 2026 08:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768121784; cv=none; b=S9GPqlBxa77+Nb/JXboblInZUMv4VJirlkRtuwenJXyuxE9kiuPmAice9X9O5zqh4tbijiRbMlE1bAfCMChnbbM0K8dyZZGZxwfUqCkUw9RbQQn64Kv7tyyPv3rlYw16anZlm74j3UkL232gWLoGd51DufL7tTNyP781k6xa+54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768121784; c=relaxed/simple;
	bh=ASALGachsGIO8VwjQQj0brNQDONG0PpwAtYJ69ZCuh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAXcrEWYdTGdrFx87ao9jpc3stLc5+6JOARMd4jRxlKz1Zho3ahLpREehv8ghg2ycnwEtuRLoqcGqOE8mxizHCkRGagl36zTNDX2VXcy1+rKqc7OYkNEqArepAfLqAS0dJ1X+go+vErh6C9RAeliFYDSfqsgifXmqwEVnsglQZw=
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
	pavel@denx.de,
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
Subject: Re: [PATCH 6.1 000/633] 6.1.160-rc2 review
Date: Sun, 11 Jan 2026 08:55:45 +0000
Message-ID: <20260111085552.7906-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110135319.581406700@linuxfoundation.org>
References: <20260110135319.581406700@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.160-rc2-00634-g38b254e86276 #1 SMP PREEMPT_DYNAMIC Sun Jan 11 08:33:40 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
