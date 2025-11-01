Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094202376FC;
	Sat,  1 Nov 2025 19:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762025537; cv=none; b=OfzAw2zXE3NMhICCWCxNjbefDu8vL91QnX+tvEykPfZwNz4Z4GgEp1GSXwchQ8WEGLBpUwZRIwFZcYRGV9FRZkdTo8JQZlsOZgHfbzuGvbr/lSajqJQEJjNeZmL/oTTqXEs2/G4KUQFulx/n57DlPucd9XHefYXdgAzwHgGfHZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762025537; c=relaxed/simple;
	bh=q/uc13hTaEtsl7U5YYJsv4iMAXLgv5JYMcHT+Zhuzok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIdxf/OrI6BprAX6NuMGirm6xvfpEFEQiVPuObfjAOcGeRjzp9+/+FMPg6Xo8eoXqGKhgBAY+ag63R63ueO5ursI26pLn0spiNfj7uGrFeT/vyf9WWkn+7RhAvVzAt/WVLAtEPyAduyvge9pKtm9QYZcM/SgsrvIwDp338ivyq4=
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
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
Date: Sat,  1 Nov 2025 19:32:04 +0000
Message-ID: <20251101193207.2366-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.116-rc1-g2c2875b5e101 #127 SMP PREEMPT_DYNAMIC Sat Nov  1 19:28:10 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
