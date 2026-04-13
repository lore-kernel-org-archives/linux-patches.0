Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E722371D0A;
	Mon, 13 Apr 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102197; cv=none; b=sJMhuxefZhOh/N6OgNMVyvQdEy3thdKpRrvX+o0oqxoyu54Qlxyz62FDzVcOuZYIIcEb2rCWSAz2GQX5PaOGsb45VSuyY4iczT0CDeJC+hrfSqX1LfKrnooki42woUAvNuPMbHolYI1w+aezqVHV9tsOE5898aSAwShy4MF7kDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102197; c=relaxed/simple;
	bh=XcxdHTkgZXNTnpWEyRjCHXpKeF04GzeImnVMgCCneuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H38YidlZPrAb1Teu8GCi8gVPj55zrcKHpIqifewxEFy0Q8lSgEaqFhlNcAJGCNF9vzW+/yhhJu6BzfVpK5pBKoSF3dzsMmDTXnKqDvXsHlAO5V8aQjZRbVIt4pdGWAGuV4Ah2cyc9VML6iHvuU9SJmcMnLV55rO6xwhu9uyh2gk=
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
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
Date: Mon, 13 Apr 2026 17:43:04 +0000
Message-ID: <20260413174306.20485-1-bacs@librecast.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.19.13-rc1-g425b22d9f3ed #1 SMP PREEMPT_DYNAMIC Mon Apr 13 17:28:52 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
