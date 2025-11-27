Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD0C2E0923;
	Thu, 27 Nov 2025 17:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764264575; cv=none; b=sPZwpcGiB+SPMG2qYlIqU71N2LwkD/DkiD9bBMzkhfJs+yNuG3BIHhdZ0GjQln6nIdURxqIUSgEP93ke24exDLExFmZZwE/YZtyHglZrqID7rXPOlmTB8BpOeSHAtK1QamseYw/hzf5sjFm8v56f6dD9l5BSq0PlL+uC+TX341w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764264575; c=relaxed/simple;
	bh=843L21xN/Zc9Y3dheLG3w8onjM/GAIjO1ooLWVXWbbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3xj2erJF0qJgxSD53JBLv8GO8TpXK6/+ecKuVsUb0GFBfW7oGke6rwUCR9u7Dp8lVJvYeKA1EGgKRmR5T/zH+M90tQdCBOAkK9Onmd4H/0iJGyJdEs3nT+BlJpxrAdjk1W260KGp4iSoS/J1TV8TK2+jhOBbWsPJUZ23iFCrcQ=
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
Date: Thu, 27 Nov 2025 17:28:52 +0000
Message-ID: <20251127172858.9784-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
References: <20251127150348.216197881@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.17.10-rc2-g6c8c6a34f518 #133 SMP PREEMPT_DYNAMIC Thu Nov 27 16:37:21 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
