Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930A621CFE0
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 22:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742424262; cv=none; b=QSm4mtJrq6hWN3pgETTkeqcmifJ9o4LYIaMLRbapkzjkh3y0YtWJcDPrltaOnqK8xPs5IJ4vVqPJm9sO2PLQ0ItIRwvJbO46TxihF5z+rA1O6SZh4KGSGYQfexmPE/p0WsyEH5MRu/Pik9J90JX9VlhRrP+XjCQCPUtiecu7BPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742424262; c=relaxed/simple;
	bh=m9ljIg8QBHL1cuxpV8tltE/AaeCCSx7zVCWfERz6T4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=WK/rGJ9xVz9KtPkNED/qI1hw8ajqzcHhLSIJhM14jp2mZRWuncxEsM2ysldgQwia1+/1q4apLxYfLTOkyYmOwuc2BpCf734zJYBGwZ/ZvPwPWGnr9y7jRe/OdzbOlNE5SZ+HbKO0v1aNWt3NA9u4ATiyL9s7f2tYPlUuhUmWy7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hwgbp43k; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hwgbp43k"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id ED29D2116B2E; Wed, 19 Mar 2025 15:44:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ED29D2116B2E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1742424260;
	bh=9C5MNkeDfrgXTGKRvO5cwd75knMbSqXOloI8ZEJQJhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwgbp43kq+XfAw5RvAtwzlGshINCmUO7NjUaEuLNG4902VRg711BcRuOq2BPTrxuw
	 CEHaozpbdVLARQgTfXPm1zexQqJc0xVxUdlvDotwin8aAWDj1/KCCGpcWacS+IlitT
	 nRUquiZCzMWRptqIU42cbtbRvsU2r3RbtTWctJfo=
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
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
Date: Wed, 19 Mar 2025 15:44:20 -0700
Message-Id: <1742424260-8830-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.20-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27756679  17715502  6393856  51866037  31769b5  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36408168  14997185  1052816  52458169  32072b9  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
