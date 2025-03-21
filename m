Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BA21DEFF3
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 19:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742584020; cv=none; b=kXNjzClmnnMUmD8rKNC/Wm7c5QHJaWDsymYN2uTN3JxzSzq9LTwNgL/NuGNXqidO8wDOaTr0H1jIOUThnsPb9aUUd20lxVuZcd+uEptY4Foergdk+ZCSLkqf72UhVJAIIAQj2kKogM0t/nbF/VXDdZu2y5P9ey3ZNmu9uRT0cZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742584020; c=relaxed/simple;
	bh=xeb0VYrFDjuIFrinG3f9OP+tVXJZXFR7uo0WRP9bEhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=roiZFp8FKOniM3A3kKjrw0o3Gmv6QealObdsEwlkIQpnqCBEjCIQPYAhBkXPaBvCeAU8wScqae5cgl0CR1XYdmqFTsYsy2bfXCEGmGVQ+SgX+PidU5HpZMNUoD0XtdJe6nPSkhFf8y16pgk5MkJdJVgf9kZtnyQbQwsk+mAD3Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JEJRk203; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JEJRk203"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 5A1982025388; Fri, 21 Mar 2025 12:06:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5A1982025388
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1742584012;
	bh=GPjaquqaM/PHzZB2TIwYl4ycLmtQ0drOQvYW38bTGEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEJRk2038sCoS+Cp096ljhFTThJx9cvQN2+1RADKO3aPeKUtYk0M4w8GJFW7phj/Y
	 CAFphT/OTUMqvjYZdkaEQEXlhnKVUAMlY2BpJD3ppmOOBSG44aKrfgnpjr9FPrnX73
	 I/bYhgGIRPYtqkfasq4r2Xrk5V31DBuR2zy3z8ts=
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
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc2 review
Date: Fri, 21 Mar 2025 12:06:52 -0700
Message-Id: <1742584012-16094-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250320165654.807128435@linuxfoundation.org>
References: <20250320165654.807128435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.84-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27318662  16715490  4640768  48674920  2e6b868  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34684949  13845466  970368   49500783  2f3526f  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
