Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2551A9F91;
	Wed, 18 Mar 2026 12:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773837704; cv=none; b=Pnd2o0d6hM5/yGOdbGudetUNe8pxF6SwgZwqzFm5yH44wsd2GdPoOn+KTRH/FKTy973riqYsZi725MU6EPlDP6W81NcuGn968ZUsiQL2fZCDfPpHNWx+IYEu9CW7IDrvf/Ijgfakfw2HCVtzbbCMtlLUaunKAgsd+JfnoytNLoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773837704; c=relaxed/simple;
	bh=IhDLh7bPCQb7JZT5zUDlRf+Fk9MWTgOM3JfgR26gHaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib2oE6QRCxoTk0HX1b/aP68X7cRnObZvL7xoDcHWj2xthU0THPSzRHLOXHvU6THVcuUDBqiauR/k0a0nIePcHly4v5eWLQTmxzOPNCBiohUKOeyATbmyjAkPK/8I8Zd9FUq8URcfigK93sCJ33gDEQAyzkkp1zfigchKQ2AeaNs=
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
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
Date: Wed, 18 Mar 2026 12:41:22 +0000
Message-ID: <20260318124131.49374-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
References: <20260318122621.714862892@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.19-rc2-g1cc312cd0408 #1 SMP PREEMPT_DYNAMIC Wed Mar 18 12:33:50 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
