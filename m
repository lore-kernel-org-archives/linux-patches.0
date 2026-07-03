Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD913B47CA;
	Fri,  3 Jul 2026 09:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072380; cv=none; b=kvXEAYRzPA+zkjQ8LKk+7oVIP9XoFfmjpErjss85228uSHi/dvqjkt5IMzK8rZu8kf0twtSWmLr2dWDP0hJAsRJHE2GRdHa7qX+qIGcPU2HECPQVR3b4uOcWKAjw0fqAOZJ5UXZRiw3dzgaz8ZB20GjvRFQOuO6EQohPz3WlM6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072380; c=relaxed/simple;
	bh=p5gqAOvyxSxYnQksNzO4WDj8qRIhtL7bkLrH7rucsjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZDAZhpNlCwSU01GVvSwua6dFpCyzvVtfZXDJVS6sbVWr187hQwJlGCwC2Pi4Jx8UONVbiFB+IwK+PB+5IOO4fo+aQ4Bsj3iq8nFBip6kmzjo92d28GADL/USvw5AMtn3u4CZ670pe1h9dAZPbhcHhQKxm4YfSXkxa88Tt6wpZA=
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
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
Date: Fri,  3 Jul 2026 09:52:49 +0000
Message-ID: <20260703095251.51023-1-bacs@librecast.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
References: <20260703072822.817328079@linuxfoundation.org>
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

CPU/kernel: Linux auntie 7.1.3-rc2-g19dde9778fd8 #1 SMP PREEMPT_DYNAMIC Fri Jul  3 09:16:28 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
