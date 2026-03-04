Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15193366544
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 06:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772604861; cv=none; b=Bm/xbApykXBC/0/AXzGhLPevWJySLpVTejyy8Hmlj6fn8ZFKGWfCO6USdlDAOpMvevJhRZXBHvKTC98M4VMGsOI3h4oZ+WR+ZgRDZuTaxa61apxZ8lrDW5x7QLH0hVRy3mbC3gTfDH2HBbNOuoXFIcZ6TpaGgZ9r2XQCeThpnr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772604861; c=relaxed/simple;
	bh=vresN8u9k/beaFBXr/OCYEd+JzQkr6Jhnlke62NZxMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ94A7D5INfFaQaSljTZMOZoqnvMz25hjld4UhgUEfhcPxowjs1+qzjTEvVwLMWFJp4/rDd5j7hvXMqJYToDF94tSaqH5rtvxp20QepeW8WKccyf0shmyZ6XZml0JgIJ72sjnSnNjxcnFbn4j+4gmAQWRXDuBwWjb8Akc5MzeN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ryp06EJs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ryp06EJs"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C269320B6F02; Tue,  3 Mar 2026 22:14:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C269320B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772604859;
	bh=vresN8u9k/beaFBXr/OCYEd+JzQkr6Jhnlke62NZxMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryp06EJsq3HlibSq6jsONC5rXFHtKXhe0z4ayWCA+xCb84GdwtpA96+IujhJZPoYA
	 oWRYNptpFec3bCFrhDhdAf5ylsAoVwELeGmRbmuHSNCnksPnscgAtqqb40pHEE97+2
	 mFw9TBo/aMNncsPE96s0ydCyzOTurlO9R7qwqe6w=
From: Hardik Garg <hargar@linux.microsoft.com>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Date: Tue,  3 Mar 2026 22:14:19 -0800
Message-ID: <20260304061419.350300-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
References: <20260302160943.2522184-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.1.165-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
