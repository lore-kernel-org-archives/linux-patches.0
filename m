Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142DF2A1BB;
	Sat, 23 Aug 2025 12:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755953298; cv=none; b=lTjUMfSPngbGPmr6ZfF04RqnbZawEr+eERioltC8Y+Qglbmtpto0eV7qN4qLUgmF8Oh1YkaHjkE1L0wcGnmDX+w8XPn/8Uw4KJYPrKaNliJzAJ3lVX9nvCTxGMlxeJyDUFCDiMOOMtPGdg6sukcYFGRulyJvja1jvwjsN7PYKGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755953298; c=relaxed/simple;
	bh=QV0nhvrDWGxTi/LW2J/7cfZnNKa9UItn5eKfdcvgyCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY2SjW3HkK5SvHy1cRiLEIk3yoZyuUEnXTQMqxG7y6PaZedgnis7gkXQAvThZbZ8woRWeWmlDdBkzXAJULVyIoCWFQzRhoaOB9X8L0v2yLTc0IljPosF8kNn721Oa6h/5lwQvgdEWduIGTjN/YU2GEecgiWtDspnT++59tzbVaA=
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
Subject: Re: 6.16.3-rc1 review
Date: Sat, 23 Aug 2025 12:42:05 +0000
Message-ID: <20250823124204.32507-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
References: <20250822123516.780248736@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

UDP broadcast is broken in this kernel - the destination ethernet address field is mangled. See:

 https://lore.kernel.org/regressions/20250823121336.18492-4-bacs@librecast.net/

As this is bug-for-bug compatible with mainline, I believe stable policy is to
wait until this is fixed there before backporting a fix.

All other Librecast network tests passing.

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.16.3-rc1-g3fb8628191b4 #47 SMP PREEMPT_DYNAMIC Sat Aug 23 12:39:17 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
