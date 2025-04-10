Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819AA1D89E3
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744300767; cv=none; b=FLl7q9Rg3JDtK4gFguKtdUXl/cvdXzR/f26UO7ZLYsvHE/W/fRRP/mqChABfgpdVt0kMRK8Y+ZE1j/RSwwKNt1u/MVwsAIygIGvKBip6cSiq3XBuKIoRjWZ+6O5v3SfD8U9Qf6DIcLP0oOxWf31jIqOixFPPqXIhNSl17Xhg9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744300767; c=relaxed/simple;
	bh=3M0zWsbwuvbLpyJHDE/fsstHBTwjrOr2OyiOM3n1sgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Hw/8eCSvqT6ZD4f6PXtu6A+79XMpak1NV6Y0spCA6HSFC0StfH23WI+QhbPDAEq0A7Z/P0NmNgVAgKrVu2ZYAXYyACVgSlnkMr/FR1frHSR5f1tZGOKcEoGUrcj/Mjr/SC9F1p9Rxp09L1WgL8buRwWsRDFNeMEJk8yfM8/QSsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mwCU9uQZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mwCU9uQZ"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 111962027DFC; Thu, 10 Apr 2025 08:59:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 111962027DFC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1744300766;
	bh=jPUClCE8gOyShEIMhLmdapTigr2jh/jZQo9xP0ie6C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwCU9uQZQk6EMxDFvb0U1taYL0BqCHEy6EHXVvCO11rTHa6nY/H//xS2lwSLl8G2S
	 +lCQIRyldnr4MjNBmbx+xTh6+50/ZnLL1b3x9yDAJ8SmwyMZuX7m/mZ9S+mlVxkco4
	 ILVDp9k3OpMrdeaqpG3DEfM9VJOtCQ2GDsvUXkK8=
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
Subject: [PATCH 6.6 000/269] 6.6.87-rc2 review
Date: Thu, 10 Apr 2025 08:59:26 -0700
Message-Id: <1744300766-12503-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250409115840.028123334@linuxfoundation.org>
References: <20250409115840.028123334@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.87-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27319683  16715810  4640768  48676261  2e6bda5  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34693512  13846810  970368   49510690  2f37922  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
