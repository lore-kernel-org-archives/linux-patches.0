Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98316B67A
	for <patches@lists.linux.dev>; Thu, 16 Oct 2025 00:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760573151; cv=none; b=QAdsHRyhX9cfYGDxbSk2yRHjGad+TrHLUpk4BwHYW6wpD2rLfEt1e77FxF0zS3QrIlNSTL43q9NEiEWq8CsBBbit+Po+aDuhK3MStPHJseVL+9/ld2Gr6wcWYuETjJGLFCpxBiOsaftB1aucIxlpU5TP+UwgE6GrQYF9w2kYoaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760573151; c=relaxed/simple;
	bh=mF8DJBtCc+Ug9ubwwJhIISeRTGlaB9/PCq3LYeDrrdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=OAA1Ab0+MBhu3vITKiAm6CyuleS9jdM+Ezj7fk9KIr+mXzw9tH16PGi7YGHSF7huVIHMaYomkQYZ/U5cJh8N6AdgbJ5azDW8SHFqbJ2KYmDMd5hae5yaIj/esyWpz01+bPPwWbRiPyhgwOkmWKJD804b8+zZdWYhbqIg4Xa1W0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=AfgZj5v3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="AfgZj5v3"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 4D28921244DA; Wed, 15 Oct 2025 17:05:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D28921244DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1760573144;
	bh=mF8DJBtCc+Ug9ubwwJhIISeRTGlaB9/PCq3LYeDrrdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfgZj5v3lgZ4fV4hDh2WUnHLprQuDVXGNGEnmHtM1BoNg8qQ2q0x84Gyn8E28fB9X
	 PSrSAjmr9YCUGDhvI2QX1TfzqqblRgaEUZRnuXoxXEpBhlHDtRN2YBaZLRGE0HxAMf
	 dk/dQ6jmiTgYMrk07em89Hm3AVLmLFHO9l8L7Cnc=
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
Subject: Re: [PATCH 6.1 000/196] 6.1.156-rc1 review
Date: Wed, 15 Oct 2025 17:05:44 -0700
Message-Id: <1760573144-28384-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.156-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
