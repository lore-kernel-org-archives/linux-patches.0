Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C242C4503B;
	Thu, 17 Jul 2025 09:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743998; cv=none; b=dmsDNPLAX8z9dxdUHoDUXbkpGg25CVA1nSCLmpRPdJuiR1faUUt6b1wP2i9YSkcMWPAcNoj9AeeePPZ1xVfUsXVBTxCCNx07XasiF2rgVe47hj351/cNzOKPJu1YLN9nJ6EB60wHbo90/SaX5X9NkSPeJ2hVV36FyylpFgU2WG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743998; c=relaxed/simple;
	bh=nnFeml5JYAzYB7eXqsJLnkgBRlObvVYQCOLbcvgJ/dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYx8U4MbN+KnSX7qR37oN6fbNZaHjQAYTu22ZIjGFFz7h4hd+mqCf9/Eu3bsV2+wvoTj9/HNPw87XwO+IUiDJbQlH+JaMImENiACsXfwpDerx3ZNaUVPbv11kTmy9eGGG8KoiTJNEMB4JAGjS7p/xcpuRK9Vc/QaPiW+jKB7Yj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Received: from [2a0c:e303:0:7000:443b:adff:fe61:e05d] (port=39252 helo=auntie.gladserv.com)
	by bregans-1.gladserv.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(envelope-from <bacs@librecast.net>)
	id 1ucKmI-007pPH-2d;
	Thu, 17 Jul 2025 09:19:46 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.15 00/78] 5.15.189-rc2 review
Date: Thu, 17 Jul 2025 09:19:13 +0000
Message-ID: <20250717091912.7718-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250715163547.992191430@linuxfoundation.org>
References: <20250715163547.992191430@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.189-rc2-00081-gd21affcc10e6 #19 SMP Thu Jul 17 09:13:45 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
