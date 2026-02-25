Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182152DF6EA;
	Wed, 25 Feb 2026 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772043539; cv=none; b=dXFR4FgerpwfjP7BZlO/xWaqDAq09D2uZy6GsTFWL5F2KrHJWaQT66fV/KUhAoykLOgl4kn3G5Ih4w+elAaxbd/uPGcnijGoiMHNJ6hDeqrAou9NGALABM8vDSf/GhBVJobZ3bRtKjWaOSnSqXDINHW0DuYGWMEjuEUV//re/A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772043539; c=relaxed/simple;
	bh=FxAdVlCeVfg8I66ydUeeKJcCUqJsLYOJ1CVQrE6OrDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGW4TacV4zFiaXns6hkdEli5iwMh7TgCRQsmW+plczOmwMa3UCs3BSxCbQagZBRSo2zpC1761M9p4FOqM4TlqDctBoGFAVv8rPu4L6mKy9STLdg+nWTEuFSy0ZpjrVFwkZwgEYS497nWCXLcoUjP3z1b5h3JImBuM/mZzVSgOxw=
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
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
Date: Wed, 25 Feb 2026 17:35:07 +0000
Message-ID: <20260225173512.28653-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
References: <20260225155341.094945851@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.19.4-rc2-gcb2d80377c4e #2 SMP PREEMPT_DYNAMIC Wed Feb 25 17:30:22 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
