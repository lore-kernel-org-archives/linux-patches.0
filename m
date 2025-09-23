Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD502314A9F;
	Tue, 23 Sep 2025 07:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758612439; cv=none; b=JEwtX2JJ5DjiWhybIfAjS9HbXFMVbvTsY3/49kCDvrt9aCF+1sinG0J7nYZZwQjGL3FdSEbZby3nEXBVd4aqWIJCZupbz7S1wKCeqmHK9dWEEbGcETpKBa4Bva6sBQUgdBnfyEHVsFu8uyIZIPVuxNe6aSy1VwqHCtrICRYLPio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758612439; c=relaxed/simple;
	bh=fradzahgc6MByJuZGyJ3QUk31Cgx78XZgzqzRaF5ZnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEDz9bqx8PUdnsNolF85NJaFA0QqqpwKJ9J0L3rsIrv/nFVZqmJa4a6udMQVunLM+/6q8NSuKT2Bkcf/pyjOFc1g+HgKkwfSD6VTXkGq7yozZxxDwmReee598pq+TcTBcxfeUgTj0ZaKtHoBAtYTCII8UW9cNtnhY3CqARmKZ0A=
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
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.6.108-rc1 review
Date: Tue, 23 Sep 2025 07:26:53 +0000
Message-ID: <20250923072656.25379-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.108-rc1-g6bd7f2a12b28 #89 SMP PREEMPT_DYNAMIC Tue Sep 23 07:20:23 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
