Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CFA3207
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 00:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738802586; cv=none; b=J5z0mzNDBligNY4PuTT1zQEg6W9tcailWL0bKWX2CzPvvZ9XESnjisvf6pBo6vj+ZVanO+3QBv5PgR4n3VAGSp6gWEDmuptGSyjsdLzwF4SLO4X7LRhQHAKpgk7Ao2smmRNif18QEKSfRgJ52CC9Kqy+fXEqHUG47URa90kj46A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738802586; c=relaxed/simple;
	bh=CVam0VoRlro27aOD85pFmHY/BVhpvSSqgMYdVCgMOTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=AIgulQTjn2E2Ze2SL+o+9LHsiMpmkq1rpZgZ+AXKOlbnKSAvPMMo1I/+NBEJoVEbcJ9rYEFxJ/rqDeoMu7fJWQV8szQvhBoMzK2VQGOOAKwWE3C/PKgGvCJ2RJmXOK0axI0+I/906EB5M74i1mhLRZs9IxYcnw9fUWq941dn7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nYM5y1x+; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nYM5y1x+"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 011FC203F59D; Wed,  5 Feb 2025 16:43:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 011FC203F59D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738802585;
	bh=SzpZerjWhpXXWQnk7unro/Q81J60Yam8AxZGhGncv4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYM5y1x+FwhoWjVPD7GAss3U5GypcwmZqUIfc/pkcrhO3O5mMTwTZbc55AP4t7omP
	 L/NVtBkMu4uKSyp67zRumqHIXAd9k332fRcQjL10neGi1Tkl9NnExeCEiWgh5trmaK
	 dGzgX60nilY2z0cbKclSPJ6oaPbejFZxjvRKFP4Q=
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
Subject: Re: [PATCH 6.13] v6.13.2-rc1 review
Date: Wed,  5 Feb 2025 16:43:04 -0800
Message-Id: <1738802584-7549-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.2-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29934632  17832666  6320128  54087426  3394f02  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36664336  15075873  1054416  52794625  3259501  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>



Thanks,
Hardik
