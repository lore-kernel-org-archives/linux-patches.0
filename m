Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3549E2E03E6
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751572547; cv=none; b=ImmvuunQGk8T1Spr6EAgensHck9YHpTi3z0a1uK1JbKn78kKyo4y4HtX+dTlTLW39CzNCCpg+g8mGYRqmvUuN6QLt/ObTahNVaJo1RxoYfqc4bJ33pLK8RkveFg1/vjiTvTV8J5TM13EPqKJphHq3PnREIhHU9b5TJRPEHoCC7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751572547; c=relaxed/simple;
	bh=gcER8XDIpI10TxUAJrhiKAbp8U+6g4nzkJM+XMYVbuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=uk5u9ZkjKke5MXZxc2QrZY+S7qIABANeNpju1mNfKTKPwWgXp8pO4o7ZxQQyOwKrPrVUaPDBEf8LNbb1FlF9EMdQbsvEIoxT5ya36y5gBgwbj23oxuuqjo81R8iV0E97lE1bVbuhAqVoVT7cYLnXfqcgn3MrYYQqZdRzriv5Oqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=kMJNAAhM; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="kMJNAAhM"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 9E8BE201657A; Thu,  3 Jul 2025 12:55:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9E8BE201657A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1751572545;
	bh=/wUhaLKCzKuyBar1XW7kNa4ENfVXsm78ZGXhusUX11s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMJNAAhMBzP68BgeMRrMBUFrCv9cedK0Je83o0ZTogGI2Zn5NzCiA+NNQGQJALA1M
	 fH9a9Qr6ZcBi05IP0Apm2Pfl5sPdPsB53dFtm3AYxbPFjqy9EMa2WuyIZFyEOnrGI2
	 2wN0kgxzBcxCPJ8r8BGkXSlFi+sBMh+Wft4EgZVQ=
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
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
Date: Thu,  3 Jul 2025 12:55:45 -0700
Message-Id: <1751572545-26923-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.12.36-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29861525  17728782  6385664  53975971  3379ba3  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36438156  15006309  1052880  52497345  3210bc1  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
