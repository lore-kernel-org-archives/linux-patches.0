Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143621DF246;
	Mon,  8 Sep 2025 09:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323568; cv=none; b=qyFbR3wBGCbSxFRPVWfze+A1n8usg/itDJ6E9Cmt5fdUEptBQzJEWOT6uzpBICQyrhWjt5TAk6C/Ddd06rXhnN3XFfbnAw36F+eOGFmfHCWonbEESsdTddqMHfHgk+Y6tCc8mdosGM65E+km4vo0B2eQ3mDs54jfxT0aCMvNPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323568; c=relaxed/simple;
	bh=z8C4Xu467+7IbG9tT5vav7Z62486OR4EuaQLAppgWqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdTjIVu4UMwNR6lllogdB3PIZ3qsBS/RqQszE/ZPrP7bcXF8bhhs0zkkWCyaUICbi79yzukNWp4555+Ag9MjJKFmbIdBcAYOG2mwydlMYWwxykFyIvzerEetpCdr7bX8bm43yLRMZWNLNKb/D4ywV3nJfg4W3VdeLFCcoGpjUVY=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
Date: Mon,  8 Sep 2025 09:25:34 +0000
Message-ID: <20250908092533.22608-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.16.6-rc1-g665877a17a1b #62 SMP PREEMPT_DYNAMIC Mon Sep  8 06:39:13 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
