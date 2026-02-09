Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F70A32142B
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670044; cv=none; b=JsqMWmKPqijBosgPVbQ8cfLtuLW7QJvLWatNpOi5jxw5sjd4o+ivD4SueSsmWP8OVcYFFN+WJ5j5d29IXI1J9OHGjBrHATycqR8KrvCG20w2hUL6qFI0HfKcri49TxcpwwdGQUwI45j8UzQ/cdDeF2DtHDFXhesCNg/fC1rzZic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670044; c=relaxed/simple;
	bh=agDbkYbhKh4T3UhZ02+ofvdu5IGM1bWT8FnUfNRul5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1VPk1qXap8AsGgLzK7xaxliej/HtW5Y6tEyrUhrdoCcC5CkfIfq3s00gplBzHyqZPfDd8u0XIQaSGOjpuYo6DUJj3z82dFrEcJTwrBsxyRyPkxjbKPrrPJBIDWpVtXomKirqEX313CzpddP3fEE+bt4V30DbChu0q36DFqfyNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NqQoCR0B; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NqQoCR0B"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id CA27420B7167; Mon,  9 Feb 2026 12:47:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CA27420B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770670037;
	bh=agDbkYbhKh4T3UhZ02+ofvdu5IGM1bWT8FnUfNRul5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqQoCR0BqGnmOc7aEu3GB7QMnT182qnLPbZMuP9d9dK00sbeJFIp0NOaNxqVC8FJl
	 qFqAehdFVHPSGdLWA/mm5yN26sVlXOZqLphQjRq38I6XeWrXAKnlJzpaf0d+9L5aX7
	 qrTRUSRon9b3jtvG7KJg5Gx4DHxARxVT7eZXxrX8=
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 5.15 00/75] 5.15.200-rc1 review
Date: Mon,  9 Feb 2026 12:47:16 -0800
Message-ID: <20260209204716.1215716-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v5.15.200-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
