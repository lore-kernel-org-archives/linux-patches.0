Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA2A381B0A;
	Sat, 16 May 2026 11:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778931866; cv=none; b=Wouv3fmb5N3XY8uv+rLRoliGmhnLe+t9qgK7ZeXFk5pui9cuekB7pISusE88EZoJZdo7sMiD90oHR+VFxFqHeXUJ+ih5g/JU5Ixq5imgmOOn2wzxKHmwdJMiqhfJ17ZdpiPKBq/o23PZ5Ds2EEXzbVhcFyYarGZjiisTEgB/0Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778931866; c=relaxed/simple;
	bh=BNwJWaT5Ga7fRRwZmo1HzSDsjTn37m+eZSQ3cHBXmEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USlRodeZp7YafTqyRU1GwgJNAogY97VaRVySNUpxbhplab7+w7BUfT8oxke78pYr4kyyi5zmcIlg75ImOTbEmAgMhR9RX/PE8+6YNNZSiOUSwab4yWnCNReN5dCis6QhJ4HjunszBcBP+3kXo30pAXJxZqgYn5/J+9RbbDK8gAs=
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
Subject: Re: [PATCH 6.12 000/143] 6.12.90-rc2 review
Date: Sat, 16 May 2026 11:43:02 +0000
Message-ID: <20260516114409.80436-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260516102210.570453769@linuxfoundation.org>
References: <20260516102210.570453769@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.90-rc2-gb82aebd59f80 #1 SMP PREEMPT_DYNAMIC Sat May 16 11:30:54 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
