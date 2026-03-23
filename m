Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AE73CD8CB;
	Mon, 23 Mar 2026 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279229; cv=none; b=WlX3M08PRGMt6HAkyjkyCKJ8+VUVrulbQ0wk87mUAiCOp2wiWYRqGYWWKNcrOe5ZiBwyr5/Yw76xpo2H4Q+lbYHix2q/q+4tmBzDBWjz25c8r4l7AjnPc8rL9nZXIHuvtU7DT6TUWHmtoLRJN+2n6BZsbOOgQJO3LN61kqq8zFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279229; c=relaxed/simple;
	bh=vsXRmxQvIsW7L5BrRsLv4wxRVcZNCGzjJ4iSBTtU3oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r02uYD1Y18oRln0cSamX8G19w6iiJPQ9ART+WZht2KQRDUug6RYcvZfllEEp+DjYNRcinZPiIvamPLHBdkckTuwYxxrY3mdavgQ+6XB9Ky3IdDG2PNt+6whHnIDrwh2aF9oygC4GTiLsa8tW9nilr+pmR1e+Bg5GgAYRe5fgeBI=
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
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
Date: Mon, 23 Mar 2026 15:20:13 +0000
Message-ID: <20260323152016.30370-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.20-rc1-g81b464548274 #1 SMP PREEMPT_DYNAMIC Mon Mar 23 15:03:57 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
