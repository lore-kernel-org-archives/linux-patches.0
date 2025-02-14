Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE55127540B
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 00:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494025; cv=none; b=jTgNJr9Cf2gwuiMYPIexDkHPHVOXF0I8ZWqEVRdc2YWb0KbqBs0bh7Gxe+OPjO8kTsD2JONZNodA+YBp3Cu5sB0mwontosErKPc+ypDfwOIMiZP1jUFooccLdt6UGgwgJjv94kcodNvY2FZj3tzIwRysO8OjybfsFLT9n9zb/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494025; c=relaxed/simple;
	bh=hYHYbkXhfFLurg6wMe5QMSPV4YrbP9bIjAJSuhRQr2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=j5UkQf/gO6Q2gm0Sty3GI0I8LhhjCrDPAVpDgQXDQcVQtYKHXr/AwCP3Ya77G0Zb7huc58lMum2HdWc4SrtwOdQZW/eOrwnWAhnHpoAt7+4nox0hLZGuUWxI5Bqvc6N3s6sgNsXh6ToanaLCgEV9MPQJiFa+JHRW3kO5O2N0atk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Umd+owOp; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Umd+owOp"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6EDE9203F3CB; Thu, 13 Feb 2025 16:47:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6EDE9203F3CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739494023;
	bh=C1Mty8SCWDlDykTdJTRdhpAR2xCJk5RPaFs6HDdY3MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Umd+owOproz3UzWfoWcvoWj6Yyin8zaltBwHINV7nGa0oNV+RDFFrMAv7GjyQS27L
	 IHp+bvWMfIz7r2igNbVK0xS8Ly7PAKtL6PRUdKnqYD44Qc248DvVPTSGR/TEHyajZA
	 xQMYZquLTsbbZiKhDOw7CeJ3fnGcMGf5pSNvvqaM=
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
Subject: Re: [PATCH 6.6] 6.6.78-rc1 review
Date: Thu, 13 Feb 2025 16:47:03 -0800
Message-Id: <1739494023-22521-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.78-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27313546  16699406  4653056  48666008  2e69598  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
34690958  13850078  970368  49511404  2f37bec  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
