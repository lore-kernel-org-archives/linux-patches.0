Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658A723F277
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739997862; cv=none; b=E5b5xx0GjH3ja5JatpqCLTy1RG1AWMN0P43CDjBfwSf0XKF3BJryZGs5j4ekADAuo5oJWK1LljvoLWpDfFWBT3HfM9aqTktGonNOz8bfQKg8CDVQ9QrhMjPDgB4xBipCooBd4I4EDbr1KOa7hqonHSEeNPh6iQ6S0X702hIkJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739997862; c=relaxed/simple;
	bh=HqMPpDJfCUpjwwI0URhYUGNCSpxIIyG5WI1nAnOX3z8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aHniqvBIbj5ibHAfVNyb5qO7nXv4jSNg5gg8ijommCj/hp5V4dzt3hDLib0840dHL+YG7276qjPkjg+/nA9zjA7X26wNgYTZi7O12LVzyAGCP2hjN4acGAPpIGbVUl4IlYSiXHY5viCjxPgLi+iQClZGfm9Fg3SsdQkCNqJT748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=I3q0QTgG; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="I3q0QTgG"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id E668C2043DE3; Wed, 19 Feb 2025 12:44:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E668C2043DE3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739997860;
	bh=fTABdSCsI4/O94Q0ogqhgbcLDTy2sOOeXGAyIkB+9hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3q0QTgGdLOBz5R/9/U8MgzYOdQMWS9Mz9iQxJp7PGNxLWsWFK8t4zqg2Knxj4ubs
	 K5G1roZeTLgR8Ie4tozwZnKg4QTYCObrCO5LXOY3rFysh9idlg424736TfEq5myk1/
	 qVQEAk64eGzAimIK1NUmViaRPf6cyfhdjLk43kU8=
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
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
Date: Wed, 19 Feb 2025 12:44:20 -0800
Message-Id: <1739997860-5095-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.4-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29936018  17832618  6320128  54088764  339543c  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
36657094  15080445  1054416 52791955  3258a93  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
