Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3422F3C3D
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750270062; cv=none; b=P+3U/ZSod8jqlsWElHA0S9Pq8gPpIGhulFZJqEymgpKya6t5IwxDPA6wlYynM2cHSEMrHdbbKlgmgSzp6n1ZSEUWAXTxFN9EqfXW86J3GgYpAepgNmB1QJ1Q2Pwp5x5nL1aoNVQnULCHGXf32Jl6OR4pghNP5eIFJDmlpUFUDTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750270062; c=relaxed/simple;
	bh=woULyHaUBk5zuuRaY2CQ2JQCVQW5NVgM6t6CJOPuINI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=jF8dXtj3ZM1F79jnI9MfZ8befdzwr3PzIZJX9qpFU7THAIBrJP0zpK7jvn4knAJYqadM4zz+XFlez3ed6fvu4rjXb7hknuDnzCpOxBuvNqbKDDytjjeYy7Zlj2sWZ59A+W9WtGcl2gA0UdklHUwRo32qXirLvfhcEuV67GqYw5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=GssJRV0i; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="GssJRV0i"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6CDD5211518E; Wed, 18 Jun 2025 11:07:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6CDD5211518E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1750270060;
	bh=JpOtiov0jWkZ4Ezie/yIIYnf/xBCV9YHpokW0wLWHR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GssJRV0ipsTYxJZOD41cXvU2NfTdHc8LR5ua5qRUGq3YHu6wVaEUmSPDaOHr38o1G
	 XQl4eysvoeRqm6I4yvDhHes2gfw32eSx01ZcOWeAEnpMOqYE43Ih0FsPNZb09ayPW5
	 iFpD0pKUQgLwhHu39BITJMbFdu1liV3tCOrThhmA=
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
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Date: Wed, 18 Jun 2025 11:07:40 -0700
Message-Id: <1750270060-30222-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.15.3-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
31998596  14275846  6250496  52524938  321778a  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
37335273  15435305  1038736  53809314  33510a2  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
