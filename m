Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F7917BA5
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 08:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738397661; cv=none; b=cvNualeZeBvGNJ2Obtz8w/TxJk+OUxjalEWAQJe8Lobzkp6QWrUNV/N2TPo62c35xY8Hgj8e+4AcWUhsupt5i+UYeAmZo0vYNhEm3pJZVAWyMl1QuE8dvxUbtcu4iIRMmSf00kSKTNaoJfqogz5Su+KT6ntkLnVVuU6p13C6oJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738397661; c=relaxed/simple;
	bh=hKT5i4V1rD8KTYmymsV+r9iPWQFXehkupzM1h59SsVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=XnTwwPxwcPH++RCnFGXotSw+A2OyYnE6oASqH7qBJgEhEGmBKsfpZQcvgSVAPAryfhXaqkkORFNyhEzymeBVCpXLzm8RKNT+B09/4+PVxnUeW46Nzdwt1kA0iI2kcyW4qPmc60Wh/Uz30FVIL2lzmPUTIULTiV9J+koiKevGLyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=F0FpWNEC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="F0FpWNEC"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 63578210C332; Sat,  1 Feb 2025 00:14:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 63578210C332
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738397659;
	bh=hKT5i4V1rD8KTYmymsV+r9iPWQFXehkupzM1h59SsVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0FpWNEC9nvqCqhWRVG6HlhUrrH6hczXwGiVgWc6qRjVsBbRn3gUSbSk0t5QcDvTP
	 KHCftjB6XnjQXfOJrokiF5IZln5fIv5uLd7AK2VnmHPirvUoMbmxpqkZ4dTOTjAf18
	 w8OjeQs38g4DTRUaB5ffWzZyzNeFbX+aEgqPEXl4=
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
Subject: Re: [PATCH 5.15] 5.15.178-rc1 review
Date: Sat,  1 Feb 2025 00:14:19 -0800
Message-Id: <1738397659-6940-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v5.15.178-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
