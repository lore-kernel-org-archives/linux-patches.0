Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE0032038B;
	Mon, 18 Aug 2025 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755533370; cv=none; b=gIUQm0ydvVtOk63A4sb1pWOSsOIxuizhtDsBO8E0L9QypBTGbGgUlDnwFxl7MHy+q4C+U+L0XBcsBvu7KTynJgnu7YngoyMsTeg9UPEhAAoVxtIe614Sx2dsI8j8RBotpVq7yc/21lN4FbaVHb2fMfGLx3giLcmdpO0u7yUv4j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755533370; c=relaxed/simple;
	bh=fCax3K4FEx/eYbPWRwfmopiPlmpIcVYUXtKyVKOQxOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBDMlljZc/aj8X5aYKIbuxihvP6fDWwukcmQH/C659seZIYUC1/Cpr1j+w9CkzgoluXnuInOAfYUEDeqHdc8cKbCh+rjbJKhOmfH2MuuArj6QcBhRj481l5vZrl21R5mXnz/MrXzzXZHskNaySDV7LfuR0cpI9mQ9uACjWJ5I4k=
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
Subject: Re: 6.12.43-rc1 review
Date: Mon, 18 Aug 2025 16:07:00 +0000
Message-ID: <20250818160659.4494-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.43-rc1-gd65072433784 #42 SMP PREEMPT_DYNAMIC Mon Aug 18 15:58:39 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
