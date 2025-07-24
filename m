Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0681D5ABA
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 03:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753329148; cv=none; b=dqnvZ34LndDoOWw6FaoEqKzNfStyEIhzZfaGRHRw+4WLC+n/XmxMPeez+Pflf9ggYo+1ojzleiZfpt6HtdC6h4HuFXmGzMUKaCXEPXb7ZL6UqwrWK2y3/lJwRRAZZ1ruJApT0VhJgkFQWX5PY7vCkEYAFSrSNGLHhORiN6egxZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753329148; c=relaxed/simple;
	bh=9JCjGQpwIKGiEEOWLHPrC5uODc7iTK+iWKX7YBy3zkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Rl+BxzfmzmX5QvuE9/YpFe6/f+x03h10Wv1S8/UNR2y7Qek/HU+7dY59BeDF8UGl410KZKG4VtqcPkEopovPC7jKOa+An4T2Tgc0WsgUR66zBqeyINaajtxQAMp9Mou6OOvVMfV8p647Bd1kkb2o4wIWkUYIufGWaE1s5b8ZYes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nSBctJRV; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nSBctJRV"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 144E82120398; Wed, 23 Jul 2025 20:52:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 144E82120398
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1753329147;
	bh=9JCjGQpwIKGiEEOWLHPrC5uODc7iTK+iWKX7YBy3zkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSBctJRVgL86ELLR9mSun/Pp1xq4KLxdUWKqG+MI3HB5AGGp8XpynM2heS5ddbWy7
	 5NOmPtjwaFJ859DiUB71U9fpl9jGZi/So14jGjwJel3+tKo6fK6EShoYz3in0lScXg
	 G4YxGNhCUOBmR8wxWOe1FfB5ciODueEDLAOqIu7A=
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
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Date: Wed, 23 Jul 2025 20:52:27 -0700
Message-Id: <1753329147-18384-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.15.8-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
