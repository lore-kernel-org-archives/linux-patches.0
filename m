Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B993705A4;
	Tue, 26 Aug 2025 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756233162; cv=none; b=Bec0tvMrxfRdkzqwLcN7uKQvS4rb43or6FbgGD/ldSdilo+e2wuI4Mxn4VjQcVHp7OCTtJckDCVBorlPCmXLzJqVaskhtEHYsfc3D8HP+ImF1Nwbc/iX+CSp4yLzvcCh+2GW7uhP4zSxNpOmjfW97F4yvkG/exVL/yB5pILvR4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756233162; c=relaxed/simple;
	bh=3++ybm0O7L5S1uhdboyvThJ2yfqFpAOAfdp7iuM9SbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnO90EUOqE9Unx23+3xqyDqPX2TYIS+WXuhiLIFl1qCoyOFDbvYcBNT9xx/fDy6LSB7S5ss5H6pWudQTNuQbVcw17hi4Sd6V0CgVk7OuVL4GvqjN14s5BC/j0VtqxhvBwzA+s6seDH+8S8FGbcQtB5+j1GkmvgkcS2QwvhMYzHE=
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
Subject: Re: 5.4.297-rc1 review
Date: Tue, 26 Aug 2025 18:31:22 +0000
Message-ID: <20250826183121.3860-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It builds and boots. Can't run any of the usual Librecast network testing as the
kernel is too old to support the NICs on our main test system.

Linux auntie 5.4.297-rc1-00404-g8387e34ec6fe #53 SMP Tue Aug 26 17:32:06 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
