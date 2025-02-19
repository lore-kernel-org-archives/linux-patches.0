Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8C18468
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739988988; cv=none; b=rMAf7Se+R2WJnPKKUJWG8EtAB0SXqWFcNzRapGYcYbQNNg1SVxNFLZ/ZUi6eTxt9L5t1GMrJ5DjQDHpeTtFmcOYb4jgZL++EUj170iTEKCf6hklxHmAgSOIh1TOqJD2dCCrMn3jKRdhY62F4483q56FaS1endVwkeWBmOwdU4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739988988; c=relaxed/simple;
	bh=akI0546pfRIjYzR/u+u9whwnCMLnCxOQv4k4uHEnrjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Em7/NnzG9oYhdOqCP3h37QaqQs+WYHRQyy8EaJYfgUcHcm9JaBTJ/xNN6QO16LN9iX2o8GHD2tcx2pzVyQoMVNd+NijFTJzxYwiuXciSIFtHpNwsoBf6DCqpkCvzahcggZfiDow7c26bXfs4jFXOSvFonWcnxKeVJ4HuCg9gCSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XVikDClB; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XVikDClB"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 398B72043DE9; Wed, 19 Feb 2025 10:16:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 398B72043DE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739988980;
	bh=/tbyy15jtkD+YIlhPeDwG0RbGFyTTd24POTg6cbT8Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVikDClB+OWPn/lPKUaMrYabYimTUAhnd+oBb0XS2yz5LH+C3G++Dm0B87nPZfMVp
	 wncojABGKGAXPT63Ysct5ZJAGZ1B2FXq35We02CHDIruk2aSQs2Sfi3OznqVU0ic4o
	 qD7GW52Z5pKjoWBpPpu0orb+K5hxSJoiWqzJIsnw=
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
Subject: Re: [PATCH 6.6] 6.6.79-rc1 review
Date: Wed, 19 Feb 2025 10:16:20 -0800
Message-Id: <1739988980-8213-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.79-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27310300  16707994  4644864  48663158  2e68a76  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
34663631  13841778  970368  49475777  2f2f0c1  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
