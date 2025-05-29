Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5237222D4FA
	for <patches@lists.linux.dev>; Thu, 29 May 2025 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748536187; cv=none; b=M4Znxft1MiGApZTfcoYBLvZiejXIR8fydwYe+n8zkfY+tbkRDhxeu2ARiPjn01gb9moZwtY45nWLdyQvp1DDVqAWQbGG3Ef2F+LpBdd8KeuuaLLChAOtvbe1JZUMbdKt9x5zugBbEG7L1H70ZH5MLXC2FNnWeVOyUpqpxfxdQ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748536187; c=relaxed/simple;
	bh=WR8ln3Og3hq/9CPAhTrgZrpsQ6jvZVj3v56O46bNG1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=unTWaIWTLGQfmBxYCDN0qnLnKaSImqEi9hoTMHNHIMejicJyQ/xr8D9PbMfFhhWwOsjbimUbVL6xmYHVF9gWn+bYa9CZ1a9Xptso8A6BFCGv1LR8zwUTcM+p7FIJn2pS3KVJWwIoxnPFA7A2wy/NYhhT6uRXvhDAj1InxGA+OzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FesMWbSW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FesMWbSW"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id B1E552078632; Thu, 29 May 2025 09:29:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B1E552078632
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1748536185;
	bh=WR8ln3Og3hq/9CPAhTrgZrpsQ6jvZVj3v56O46bNG1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FesMWbSWBRVcUdqvNHfeRY7oqgjTFdgztvRc3wDsc0Oli7WP34sYSTqIkDUQ6jgJ2
	 1ZU3eQnD6DE1bFNL7+QrSk6cOlnDBwZjtoPQr6IIaDyRSEPVM3vU/d7M23SUx5crsT
	 SnRFglieUxKjUa/UkQTicWbMyFM7qQ5r74fq3jn0=
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
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
Date: Thu, 29 May 2025 09:29:45 -0700
Message-Id: <1748536185-5619-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.12.31-rc1 on x86 and arm64 Azure VM.



Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
