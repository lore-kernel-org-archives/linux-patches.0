Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AB801519AB
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 20:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739564036; cv=none; b=qTlBfjO5TaNoMl7rpoBDKmzEur8FrAoG5WL3DY18j+YzJZoTGL1p0zc9vFGnagD7nAzXGFpJEHfUthxIXVEp8kwryLyIB+583V1yvDb63k9/UBaohKzKi84P3NhCXuAOASvkqsrAR3PgOwbrVAs460pe9EnwIByF2UVKEiZMA3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739564036; c=relaxed/simple;
	bh=zYFjsSotXE6vZheU7rAWUZZUF0Srbvf5lz8jgDP4fJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Knw8u8H7FjBW6cPg/Qshj8pNoIt7rAaiqTVx0cU+8iP8BfPivRmPQ+ODdnwL96RBHjIVoUH+kQ7NvuTWxHKBWp96MG32cGKe1O8TA4tYYowmWbaNvmCr8yXnx5lGwNxz3OqDTCH3tTyVi7SeUGpSIf4rvFVb4MxkvLlBxT4+8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=oTvGVUHD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="oTvGVUHD"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 0A173203F3FD; Fri, 14 Feb 2025 12:13:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0A173203F3FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739564029;
	bh=xJZlUceidVSAwmHXnWZ5CvBGMLEhcbu4V3OND3upxOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTvGVUHDyTkY6gElxdAN4TKdMsrfsxdJtk7i/iF0mqle+hhVOUX3p8FvAr8s7ffM1
	 lkEpGzUNS7090wnFR6+JZVMHzD1yEqKSn2OzHe+sTZlbMPzx3qxgArkq6b8/3Q81uf
	 hXNghAtIXPapKpPoKmQvNwncdiWGgOCxPVbkMVdQ=
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
Subject: Re: [PATCH 6.12 000/583] 6.12.14-rc2 review
Date: Fri, 14 Feb 2025 12:13:49 -0800
Message-Id: <1739564029-4365-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250214133845.788244691@linuxfoundation.org>
References: <20250214133845.788244691@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.14-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27753245  17708814  6397952  51860011  317522b  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
36370691  14991881  1052816  52415388  31fcb9c  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>



Thanks,
Hardik
