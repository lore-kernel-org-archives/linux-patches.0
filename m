Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E9B30C61E;
	Thu,  5 Feb 2026 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770312091; cv=none; b=Pv0xZV3ISboLl4gxo3qmEqFfIsc0xsjnr0xsVCEsVU26JdHV/9QvkW7c8Rip33kozFfNgmzJ3PsqgA7Y5jlR7kwN0BXdASa0LF/WwrV7yPidggL2QHq1dSSGuELNQArdmqghv7yQ2UGODERId+aZGiYwpiq2pAYoyAEtDL+GFfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770312091; c=relaxed/simple;
	bh=Nht545KXKtLzu8yQVo6SUaOLP5FZXhhoLi7XtmWuvbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cs5nNt9YO0H4eTObeFNysFoed2aU0cDKXfy3TsT6R7zoaIMKw+4ONtHwpXSz48aBIHLHP6QQowUbrF45JFKOGQD9oyrbEjo5HwVa0R9lYFEwtOef4KKwgYfSMgoGw6LecinuHO1R7rMg4RCJiBGCZsBtT6u6RXEs+7fAVRKFvu8=
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
Subject: Re: [PATCH 5.15 000/203] 5.15.199-rc2 review
Date: Thu,  5 Feb 2026 17:21:20 +0000
Message-ID: <20260205172123.15742-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205143441.536029503@linuxfoundation.org>
References: <20260205143441.536029503@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.199-rc2-00204-gf8f685541ea3 #1 SMP Thu Feb 5 16:57:58 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
