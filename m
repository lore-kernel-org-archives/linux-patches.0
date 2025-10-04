Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A058C1E98E6;
	Sat,  4 Oct 2025 11:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759577793; cv=none; b=FFQriLmIBbJc1SveAZ2j6OPRFxsyk8N/+W7bR0DgO7RaWdfvC4GrVTqCZ5Uxso9PHz/I6ZiHiKg63nX8bKQ2nY0WZpkNIObtc4VNeak0dix4pm2R2dj6hwvSEzmYk2zZ97GnwWntqesxltPBNm6iSNpA9buY7sykr/v67K7RwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759577793; c=relaxed/simple;
	bh=U3V9OvDo/Nej11sO9iV05g2z4F0V/uNyt2BRQmQBbsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGJBrf5FXSaMv5QTnXcu0LUPNoW8JtQZGoms5c3sXIODKS8+GAp9P26SLt6AzvhTFscYXIKK7NZoGWXt378y3ZBLh/C4LcFwG0Cc1Dz7UoQ6+q71wN/MnS3QHiEWmoOCE0uEmD/ppolKSEg8IsB6q50KDhg4GrY3dsHgYpVb4z4=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: 6.12.51-rc1 review
Date: Sat,  4 Oct 2025 11:36:18 +0000
Message-ID: <20251004113625.20484-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.51-rc1-g791ab27b9c00 #100 SMP PREEMPT_DYNAMIC Sat Oct  4 11:29:24 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
