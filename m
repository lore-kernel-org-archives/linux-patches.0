Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04A9379990;
	Sat,  8 Aug 2026 11:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786187160; cv=none; b=cFj9pDKiUqxpFGJRLLX4e6eaQ8ZOzoOCh/fhQdHiAooCqddZcoh8/CMaFY4p+20UYKcWlGEBWWa/DKE1aW1gP3d3S1+I76bzDOT72w5ZgjuLJXtm6EsJC/Ig5i2jHZUNi4JjwvivjPFJpCdZA3IAB0KmeD6fwCx/3m263lt4DM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786187160; c=relaxed/simple;
	bh=+Ss9sHVRsMDgvLbiE2rJCAijlvLY+NLOqUuCRlMv9BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5wKtLhStm3nkbQ8EXuTW0g4Al9afyiPMOi0rS1UQ05eZwZyzCmlZiLCrqxHzDwI13P2pMzGxfUKyHJh4rfpnwgKv0YlVEpOIuWcaBwpFfw45t3MytNtcNg2FaLf2+TqvGIgCnn4n1A98PsEfbuqrXYhOJFYP9GfXl1r2neDZi0=
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
Subject: Re: [PATCH 6.18 000/396] 6.18.44-rc1 review
Date: Sat,  8 Aug 2026 10:22:38 +0000
Message-ID: <20260808102241.28728-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.18.44-rc1-gd06c9b57c3bd #1 SMP PREEMPT_DYNAMIC Sat Aug  8 10:13:20 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
