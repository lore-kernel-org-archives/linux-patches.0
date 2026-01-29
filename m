Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6222F6562
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769716173; cv=none; b=i0rkWGj8Hpo9xmSdlUgAZ+eRSE/UTO766InICbpViN0umSpwhRYqdjQv35x0BxJRk4JZ3D9IxyiMesg4SAxZwA2eEiuqe1U9Ar8UjWCx1z0LIUcZD9tCblyNkSq/41UbgWja4UwZiVORzAVBcArCY4P1a1mbZuAesqZuMGME3Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769716173; c=relaxed/simple;
	bh=Xz0XrW7WMoHDP9Mj9wNbclt8JPeZeXpGWFCXCT5vKsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=civ91KQU8eGehlObf3sXNMpzKUvht3dQ967FF14rRSnN2Hj1k7/o5IFubq3KPFed+DECLQqDrEb2ebrPqSmNN60yBofdg8wxzQmEsqmBwvnSwKhv4LJasFMiJbvMsQ8qxk8mzOMVIGEvO8EeO1nQ4an9FulXrzhmcZOnly1CuYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=c8Lr72JS; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="c8Lr72JS"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 36A5E20B7167; Thu, 29 Jan 2026 11:49:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36A5E20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769716172;
	bh=Xz0XrW7WMoHDP9Mj9wNbclt8JPeZeXpGWFCXCT5vKsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8Lr72JSuD5KqTGYGe2LgntFcYPDR5l6hceAK2ePxwVAgVbVjy36/47tm9XISV1ID
	 cM348j5I1WkjkZ7MOOBggwmbBi4G+QqCDfb09DFoRVz6NOe/HPdzNk5hOttBT4e/nX
	 1PR/8vzjW9gL1Lhh7YbhFn4gRaBWkZW5F9O8Ptxs=
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
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
Date: Thu, 29 Jan 2026 11:49:30 -0800
Message-ID: <20260129194930.582689-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.18.8-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
