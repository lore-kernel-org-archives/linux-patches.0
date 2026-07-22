Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55C37A4AB;
	Wed, 22 Jul 2026 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784732495; cv=none; b=PXiwpmB+4PqcMnNterBycsCdPsz6kbjKvdG4O95kcpuZWf/WE5UXBS/yCBOodeJboRQfw9ewGCRkxqEv1GT9g/F0ivUrPn3DV6XZfEmF9XmbQY+CVgdrIHuAUnWMlqmf7ZZTNQRuFrUy9H5dZwyFeJZLuMvrToGYyPhRJNEWTXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784732495; c=relaxed/simple;
	bh=O857hDDbIa9eEHHe0OHWe14UrFTrdTnGij8yEQ+xsCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f00MbRv/CrfcES8PLbOf0qPtVlOTOGAgSxIga++TSNhe+ofzPv/hly37OI8ifL9/B0MLMJWLBd7p5aBt+Jk9hGKkjP9/FRTET+epq0v92MQ/KMSjDKmZr0OayL6zjCoA4PLGL+DFRF5a6JyVzL7HNC5lwBuKGQFIofiZiaphoe4=
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
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
Date: Wed, 22 Jul 2026 15:01:19 +0000
Message-ID: <20260722150122.33569-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
References: <20260722142947.085426486@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.5-rc2-gad98fbfe8a23 #1 SMP PREEMPT_DYNAMIC Wed Jul 22 14:58:53 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
