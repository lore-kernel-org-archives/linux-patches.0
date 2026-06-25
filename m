Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909EF367B62;
	Thu, 25 Jun 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401267; cv=none; b=r8OhFVC4Ajfpx+XoZzesrYZ0uIUm3FGOEVba1sDrb63TBaZqmL7Cm5rtamSJgDM5BoifO4pthDOGKJmiRXsB0rCs8K94gdE3dThOVkMaW3DjV3XyqZhfZ7SraLuvdw6Oy/JHZSBnlprE7yS8T9y3lnG/uwZ4iSdcw6hWBq+cTa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401267; c=relaxed/simple;
	bh=KH7kSG4TIMCFUMtIC0Lo7bfgl+W4CKNz8hZO5xdyt9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxI3wEIeKK1i/LPi9284Dwjv3w4yYFIJPbQjdDMXx+URgMHyRUninL51QhtLUvcmOfW24wJAuSVaItICAxoRYJ5O+udkrULGPNEQHHKxQpMbAs4JPUkf6GchWd6Gq7+rQ/qAceNi9inxlte3Br0Ec1fG4i0gop0Jb85VaSD+ou8=
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
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
Date: Thu, 25 Jun 2026 15:27:17 +0000
Message-ID: <20260625152723.8493-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.37-rc1-g66e1cbcc83d0 #1 SMP PREEMPT_DYNAMIC Thu Jun 25 15:04:20 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
