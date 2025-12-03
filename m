Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470942ECD39
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803539; cv=none; b=t6s7N16vRG1crR2GyC3YWCY8TAFYDolghSN0nLQdqVog+agTsMm1W/ZgSFMS26e0hO364oLXdfE9j7N7SrjrBkw7t6d/xd1RCDF2Ttf5hdpkKuTg0Pbj07d7t+Wc5AKbuxR2Lwb6SF/D8ykVLcmN75kKZuZIkDWNeS5CkaMCiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803539; c=relaxed/simple;
	bh=azL+xZ+gBn1h6cRO/O6ilDC4SAKximJLsFKuMO/hfDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=COOH38D/BgXHaj/LXICN0QkL5fcHqxhU67AupeIws/hHX/fMNZVqbDsaM6psCGj8uNiubz7vUvPOT6mGNcU8xQsRccS3eBxKGnDN7FsSsJgzjJ7W+LCOgpJlwk2ZuT40dIygE+nYdj7SPI0UBwlhQ0aaVrv3pYpwyLcNxhoaaY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=X22/Xtd6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="X22/Xtd6"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 1AB8C2120E87; Wed,  3 Dec 2025 15:12:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1AB8C2120E87
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764803538;
	bh=azL+xZ+gBn1h6cRO/O6ilDC4SAKximJLsFKuMO/hfDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X22/Xtd6C6/e+rdA3Rpykbyaj+c6Am9xLEAilPv9RPLQ4+YKXsH3102HosrUGM0Uj
	 EsQYrkcmdCv6hS9R0DfGcxozix9BqDnd6WK0xhNzvW5O6UckhobFt5auTw+XnjKhfE
	 1pjs4KtgA3wAowAJWWqN82fasoL8zSGPK/hI/ydM=
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
Date: Wed,  3 Dec 2025 15:12:18 -0800
Message-Id: <1764803538-19489-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.119-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
