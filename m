Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD04B1EB2F
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 20:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737577062; cv=none; b=eD44H2iO1RpJXPsr7slz9I3phpkL3yWPJb681UOqJpR7vL6n2q4LyQcxiBsSQrT90VfXTjhyAgwVd5HonLWpJ6oH2by3tNzbrnc6RfeWcOr1D1yn0IYZLaIrUjXELrWSfnkSXjx8vMuUZKPEQ1Ze4tQ3bHSTOEC4+rjY7x1B0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737577062; c=relaxed/simple;
	bh=v/aoX54tD4iIv57D/h6r7lYreFbk3+DIE42s+kcmr4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=FBgW41XBDUarXleVceNoS2SLWQHc6NCcKCaKZw8k58jwX4m6uFA8i/j6425/hX1iLI7ZS5bKGCnDbsJ4/gAOKF/1UOeE+6caz0HfcSrfB3TRrToZNMdf//M1ay2pUrAmK4pbaqBHQZxS2jwgnUixX/qfeaj2LmqSEeZtV4qMycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=OCwVz1wm; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="OCwVz1wm"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 731E720460B2; Wed, 22 Jan 2025 12:17:40 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 731E720460B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737577060;
	bh=v/aoX54tD4iIv57D/h6r7lYreFbk3+DIE42s+kcmr4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCwVz1wmDRAo8wu0uBxN6707ZVJs7WIf8EXGASSuecte5kZd7y56+dEPS4uRRJMG2
	 b06sEFm8IdLXfMAHFv3Eb+jV3S3J1ykEg5uF22JRyR5sILV69105mmJY+K03oR1b5E
	 dPBlZQYCB9YKO5Nrw8tMDPM8VmCqEaSVFJJqvn3Q=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1] 6.1.127-rc1 review
Date: Wed, 22 Jan 2025 12:17:40 -0800
Message-Id: <1737577060-18076-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.1.127-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
