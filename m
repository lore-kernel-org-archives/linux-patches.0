Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C968211A14;
	Sat, 14 Feb 2026 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771084944; cv=none; b=DbV7jqHAc6qmxDO7vGt6+MLiCBa92OHgz59ZHbeijjlZLFenFJrDcxor1NepLLRDjv3bPYTmWWiEIk4LzseCMag5JxXV8i6Wf6ocwtWGcp/TP7lXdwkbm+WIPprjynSlClKLPqfTtAEQRFzSS7fnoXOb9NrORbr2vH1GUbq5XDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771084944; c=relaxed/simple;
	bh=a+SDpLsW5TVI3e+uBJiURrjmpI5w7z2eAWc8sC3FgIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo+gjPtDusZ55wuo/Kqxm4BauVkSuyZzcAhwMrzBDauyhGVT9jMecjEBR/Iwmr2M6O68qHSdInvWQq9NG/0nrxf6UkOA6tPVLdOmiX/N4k09SKZuWII2SAYRpEzrSDCd5BnRF8IT4rTqKG8DL1/w8UuAze6M5QWiVjgSRonfedU=
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
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Date: Sat, 14 Feb 2026 16:02:12 +0000
Message-ID: <20260214160216.4483-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.19.1-rc1-gfdd37e7f30ac #2 SMP PREEMPT_DYNAMIC Sat Feb 14 15:14:08 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
