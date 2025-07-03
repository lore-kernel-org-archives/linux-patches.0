Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E25F6A8D2
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 19:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751572004; cv=none; b=ZeQeqvuyYVfc/pvYESf4oReq7KVuYeliecM5pwq8hex8GL76PC8QHV6RzmwzUBtDgTju2SZ3LpgytVLiXAyWVIQCqQqUDt0MbXcUqsVKejjnjydiTvcAEMv2mXskKGFrx0F57yVN1Q7UMBIYViNgV0VZMSEUMpTU1L0YIGBBWvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751572004; c=relaxed/simple;
	bh=NuR8GaaOyZM6TXxffQw2LvgqVLC6Lu3w71EEFCX+SFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=IlsedlWdgiw9sLhLVN9BMn/j7QCjeHvZqvRAFShhehVtftu5rLNSKFswuRtcOR7+tg6EFNy4BDLvjOAlxUgowhzED5n2YVWmr+5LRUyinUcWapxuOljT54cXwVB3PVZjwXsXaFGAyjRIFk8yzUu+We95I9MCWvNHOwyVjQAWAQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eZD31DcI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eZD31DcI"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 876C6201657A; Thu,  3 Jul 2025 12:46:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 876C6201657A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1751572002;
	bh=4Geo6PELkZAKTU4pC4Px2bcV/rn5BFInkKG+LLRBNsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZD31DcIqjWv6tAl2CvPtVhObQC/eOQhCQsK0Jo8KbZY3REwaXfS0OxTx7QjT2esQ
	 kzukTbH5Vrisag8r0IXr0NxiEAfKoeree2K6N44SaqR9+I+kPFVltlCjroljt+XJ8J
	 Op9x6XxbMWCU+LhFelAl6Yp7KbfC6hLr9h/2+5KY=
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
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
Date: Thu,  3 Jul 2025 12:46:42 -0700
Message-Id: <1751572002-24950-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.1.143-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
25848764  11309150  16613376 53771290  3347c1a  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
31276540  12551596  831088   44659224  2a97218  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
