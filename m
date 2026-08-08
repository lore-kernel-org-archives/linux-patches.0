Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635AA37E30C;
	Sat,  8 Aug 2026 11:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786187164; cv=none; b=UbpNg5mAT/wCrYdsYo7dHxPeSecs2jLsfyuDPQOdgUKfbTgwD9JcKEZnaeAXbN0UjGlGGKJTf6KA2qSXQXAYStJsNeyH+U6mnBKxC6K7tJjOKOIfGz+JpLreyS45mGg6rmNR7+Ch/guC4FHkNmUz+rKNWo7x+E/I3a1z8uUU8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786187164; c=relaxed/simple;
	bh=4k29aXqFod/CRtVON2oDay7syLcnYdFFXDuUaMiecV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boCCyk9lQV5EcW69yF7nHtB5Bwh6bP9C9YmXckOKUXUvN5AnbvKz9yWLOyZa6YjcYspOkOFPY7iqK7/TLFZ5gc8OQqjOS5jVEjs3zSSa8Yrs3KpHUgQBHxf73wnBIN7ZIt2njH/rPXQcwUuZA5MNzjfuv0O3/nS2++3JvSlz0ZY=
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
	i.maximets@ovn.org,
	pablo@netfilter.org,
	sashal@kernel.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 000/337] 6.12.103-rc1 review
Date: Sat,  8 Aug 2026 10:22:29 +0000
Message-ID: <20260808102237.28689-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.103-rc1-g72d4b4c8c906 #1 SMP PREEMPT_DYNAMIC Sat Aug  8 10:10:11 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
