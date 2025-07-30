Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CBA2DE6F1;
	Wed, 30 Jul 2025 17:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753896027; cv=none; b=uEz8ZBuhrqi/JMcRIaZFzGipqQt+Qtd/yrERKehW/W5XMaAY3rCni8VYNVkNioNISZMM3vSa2ikndIeQnpweDPYdM3tzH7ZrSR99psXkGPrKqK0m3zjX7HiVMG0ov4v7OxBBbX8ptrOzrks/iQ35sshJrvXgjMWhoeT8zr+rBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753896027; c=relaxed/simple;
	bh=m/rDzWAlOo6y3gOCHwAlb/5G7CUl/K81mlWb1hMbAt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiqDWFC+rtcKi1oRa6SgR+lhUGA6R50BIwFrL7b91O7hWj1uht0CdfRXwnP22U1wf5O5IIT1lOX0x2/n/dhxZTb0zXXxELdBSSyZht6NAwvf+1G2gGe4mu/O3wr9aB2nlG3iYgEOAEqkjklv3ON12liVCIgRW7QPWThxNcvwg0k=
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
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
Date: Wed, 30 Jul 2025 17:19:55 +0000
Message-ID: <20250730171954.29840-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.101-rc1-g1a25720a319a #34 SMP PREEMPT_DYNAMIC Wed Jul 30 10:56:44 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
