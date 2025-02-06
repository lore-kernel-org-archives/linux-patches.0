Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A76F4ED
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738802428; cv=none; b=Cr6tBib2g+WUQp7cej7Bu5no00sp0PiFZ+bOmjAeECcQfCqwcFmw+FxJ7+YDVTYwWqa+al6/MNhWrcEg0nl7oH7pmzHIQU2yj9YdT402luM5w2V0VI0W/dq+RYLtZ+WdZeX78xS4VmWxbJBltcpOnkDmHj05MVBCGO1/G0LtOSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738802428; c=relaxed/simple;
	bh=2gcmewSNCs1rYEw6/auIliKLembJYl1ijg4/FCsFzwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ujpYfmTdfIlpTKAWqzqjp6H1PeNbN/3t8pYA4B3MCsfqht+Vp7mo7WM/vHW92zni6WFQBp3yvEVKsoQ8zBSgpxs+yTLRf6eCPLC7E2CMnUhgRTNXvBVmm7MAelS2TlvuswWhtVH2ri1pDqhVKQy37feEMipPmQJqpE+fvoTvcGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NArn4Ehn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NArn4Ehn"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id B8DA1203F59D; Wed,  5 Feb 2025 16:40:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B8DA1203F59D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738802426;
	bh=o9pxRZ5D+TirzYAIHkhdLuS0mPP+I9Xajs1MpkehhCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NArn4EhnMBXPUDdE1lmRY9Vnx41KSINRNKoYfYXRUzBz8IAeaaiz1QK/U0j2P+HkI
	 YHt5dHokC4FOqrHqjNXB/7IRrLEg7sJQd4U9uovq12ONzFJP0WKt3MQzIHhqocrvT7
	 lFBC4ZTbQF6Otk7Z897gVTJIQHunt2RwUUqRC/xc=
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
Subject: Re: [PATCH 6.6] 6.6.76-rc1 review
Date: Wed,  5 Feb 2025 16:40:26 -0800
Message-Id: <1738802426-6863-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.76-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27313564  16700078  4653056  48666698  2e6984a  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
34662827  13840370  970368  49473565  2f2e81d  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
