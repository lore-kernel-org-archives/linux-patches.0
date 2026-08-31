Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1183630AF;
	Mon, 31 Aug 2026 19:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204219; cv=none; b=E69nShtBkgeQy/16zlmdth6KuBidalLQpxwEsYJWW+0U94CiQDggABIm+SUpnB9lRC9FHszEvlevYOhNUpuc7QC0QjyaWiEaZ1FqLQPvWW7GgPJKcngkjBY5MT9CdN633s4N/l9GmD21Tvdcfs5RVZq6xBcNkAyBKIS/2Qn0g/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204219; c=relaxed/simple;
	bh=6TMszgwnWzUNjoQhIvHw+LFVVbDskHK/jucdESsikDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeJPOhPL0wG0YMOI0fz1DL6Vcjokt7XZ/QQ0z7zroWeNeN5OXhx+0usUfTFW0VGvj6wiARrEHR6K35+cfaSdVpy93fkj+HfaE4kH4Yd3NuXaPVpQcv2hfeTjYfDrG+cxWImPux/ilw9u/pPbVd0RLyUIrskI1iDqH1gkL/kRylM=
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
Subject: Re: [PATCH 5.10 00/43] 5.10.269-rc1 review
Date: Mon, 31 Aug 2026 19:23:24 +0000
Message-ID: <20260831192329.31075-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.269-rc1-01407-ga5b83a2b4fcc #1 SMP Mon Aug 31 19:17:25 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
