Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE313CB551;
	Thu, 20 Aug 2026 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787257515; cv=none; b=MCHYbKzanvGZJ0ledqClK5FY0IqcjE5H9VltI8CSO61Jw5rO+OhG2LtzD9zqdYNCwMpn5aaqmxxWoOQoFvn8uz+1UZ2RTQ60aQlKaCVjJ8jD385jvKH8JIsPl3rHSUbP1H0c5nHVbhbMkuNiaGS5akIuBztETm9tOW9RzT/7Ws0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787257515; c=relaxed/simple;
	bh=gxs3sdHG2VHbnfNU8yN0pB2kPH+fz4p2HuFvpLsEA8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCXucae50IeOgKxb9ItyJ+YKiwOq2aNKc1T2VFvLbi5h683d85kEuEXIINjTRM6OdDDOSlpVuuSb3Vxo5XKCH7nT0C+bsTH4GbiNuYZdkhipglFwvIa4XhUuV8cw3xI4BoD3cxMxlXPYb1lOYIx5apUWdSAi9scQJF+n4DYCz1M=
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
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
Date: Thu, 20 Aug 2026 20:25:00 +0000
Message-ID: <20260820202502.52561-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.153-rc1-g0ce9d61969cf #1 SMP PREEMPT_DYNAMIC Thu Aug 20 20:00:23 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
