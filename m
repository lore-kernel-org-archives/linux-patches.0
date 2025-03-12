Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9CB198E76
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741800374; cv=none; b=YsAyNRm4QJaqFSuBS/c2Fe9qOP75sxj3TU9YmXOp+i7oDVBAt7u5K1f837JD7TUaMx7FfScSjkEUDA1Fdt+2lyGMObof8Wo4D50VsDQeAt6/ylIWytBt517YWiQFBVG3gCCvC79ByO/ZeBwka+jtDnREsJabCjjYWfKGdbo3XoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741800374; c=relaxed/simple;
	bh=JOWnneXAyqBfqddBG5tsff/Auz+WF75L9dIWo0FxoKE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=M3jnsTx3G0n2HrTZDUduDMHFu67mx5YAz5JtkXzkpymNmoPk8OIilOzlId3RaQB/c2RfFdrwJK3qVqiSmIlot6HfTnHppHDYYvF92Xd6Fax6CQQ82gAqStuY5EqSRVXVxOrU2iTQ3EFaXIp2soqDI66BQNoUJQX47T+4SX9BYGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jy+JBRqS; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jy+JBRqS"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C1B8F210B151; Wed, 12 Mar 2025 10:26:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C1B8F210B151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741800372;
	bh=5svUKRr1DYZIIpqZe+Y0nxIMjCWyuwNYeHx2kgMYoMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jy+JBRqSQhNhU8PNtHuWhNwaHXoSSSl++t7PHTOs23mnPq+N8iwdyFSdKJfw6UAjQ
	 ww9RbYv7dI9CEC+dJBzOfcIcnQ5EixrO2htofA1G/hyuHPrr4xLB+dNJ4Y1YNzHbOf
	 guIgOUr28paP1jlNP+Ea11fCkkNNGvRYGYVY9vFw=
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
Subject: Re: [PATCH 6.6 000/144] 6.6.83-rc2 review
Date: Wed, 12 Mar 2025 10:26:12 -0700
Message-Id: <1741800372-18626-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250311135648.989667520@linuxfoundation.org>
References: <20250311135648.989667520@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.83-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27318015  16713718  4644864  48676597  2e6bef5  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
34688768  13844986  970368  49504122  2f35f7a  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
