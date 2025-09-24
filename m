Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11C6266565
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 07:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758697302; cv=none; b=r/0O3zEzbtWqqFefpsLieqxFQ4q4xQ/13/n+BruyxkZWVifKoiGCGhsqmr5NlBNsKlae2namToQzb6UUR5mulJ7tcymNGUOGXmrafCxv+mIIH95jXBB3+BfBF//fXLnNNm+1NTpRYdclwMqqpdoAS2b8oSYySbLxLbgYbgGFj7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758697302; c=relaxed/simple;
	bh=hcxKt38UwlxPp1CbO5CCTUdqoeHIX+/dj8wIo5uGxOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aB0+LLYe1d2VnZRh92YFj9pLpABmySk8+88ujwZO2Voyc1we2mTm9wz5XwVkcMkLOs9OV2EizAeR44e9u3ZFC6dWpgVTqA8A25Ri0hjCkwZL1P2huz8bm8bUSLWhXDnvSOhabWgDxsiSxT7uxA7tVrjC1Wz3FoLRjDr/KMCjav8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=d/T7jY1i; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="d/T7jY1i"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6563B201C946; Wed, 24 Sep 2025 00:01:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6563B201C946
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1758697301;
	bh=hcxKt38UwlxPp1CbO5CCTUdqoeHIX+/dj8wIo5uGxOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/T7jY1i1F7x4tP/xmHbKRXQKlnIN14iRtwD8pPIAw1YXWY071dAkUYMjOC2CCjXG
	 H7utHSJ7vRSRK7EML+kIV+DYJrK9LgxuPRxUQW9KUqtEwpN6xi57Nj/+Gabglieb8+
	 /eCBEmad2nW4uFTO4FWTYBPXAhKtTvgKj0SVRsUw=
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
Date: Wed, 24 Sep 2025 00:01:41 -0700
Message-Id: <1758697301-2036-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.16.9-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
