Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA5F2882A1
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 06:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761200849; cv=none; b=BZof+3zpfBMgFoUp29efoYbjF2XRATrFAssohO1YO1cE9hD0wgOW9250a/Tv245l8/Id+gg1G9v4gn6ssPSfB5Zy/rh22jb7c2bZOdFGjOlYHwY7DHztNeg5ykw/tpCwmc4XZtA5rOHyE/Jg3XwnGSoyQl2lwQQOCmVya3KK9/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761200849; c=relaxed/simple;
	bh=R9jo7BtvZ6JhmVkIW2hQsom+ruYR7ebU0XhMaXXSS8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=K/nWVmYL2cUo1pKPHdXnqPcYeyPyexRHva2ILDl//uNjwvUvT1DLHcKxCfI3vrqm8BKHTW/MUJlWsW3ON1ymCkAa0HK98sKym7V35rjt4p86bFiibYUQDn7jQuw5H0nDZ+511IA6N4eDUF6jT0iaB8CC6GG8KUL698v+QFbaYVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=f9zKTfN2; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="f9zKTfN2"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id D195F2065978; Wed, 22 Oct 2025 23:27:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D195F2065978
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1761200847;
	bh=R9jo7BtvZ6JhmVkIW2hQsom+ruYR7ebU0XhMaXXSS8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9zKTfN2Yn849GLIth6iXHQyY44i9RSOukvYKbE69F1WSRdUfZoGQRKVd1mqdRp6M
	 hXD2zu7/FI13ETKgoMyXTDMYWBQKEdlYuvvzsy4KH4Bx0SFzGm1zY6bgKsbFVJ4TV6
	 mqnZxdUdQKtbfG3MKgUabFZgoHpAGCwCLfCv1kII=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
Date: Wed, 22 Oct 2025 23:27:27 -0700
Message-Id: <1761200847-18764-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
References: <20251022053328.623411246@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.17.5-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
