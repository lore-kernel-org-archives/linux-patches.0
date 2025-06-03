Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF85221739
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 20:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982552; cv=none; b=Scd+blZzWYPXhL41At9DLx5zaBmCXf3vWJdN7vK3DDrOPCJqp9Tp28V+mRwwpmqFCM10l/yy2zaWtyKeikvR6+zN/N2ciNDii7D6lI93KyF4D596LkpMPOv0DLavx+o8KJ5Kd8ClBBm1yXhbUjXwUrpSwjZVdktuSTc5I+sUuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982552; c=relaxed/simple;
	bh=igw+deFwgc+7qUGU12KJ75BCj4BVLq/XKj0+rEld0KE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=VRVDN8UNtrR39oKRrR+k6L/OBK//9Cp3Q26SGR68PsGspJ1Bj4vDqbh9P15CN/gjNuI6yCsUwzEOjSnBnUiO5FoQo0p44HkACDveOnA/5nvRcW3XccC32yDRUfNTAc88yUX1AnbEIsHixInR1dsTW4Yrpf18saxVndtkw/qTHsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XMShCJSN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XMShCJSN"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id B4241207861B; Tue,  3 Jun 2025 13:29:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B4241207861B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1748982550;
	bh=qVP0jKBkE9Kde7eGyla+USybbn0PC+c6hyhesikTWUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMShCJSNydyMwCf1bESOql4HCh2prXnfrw+P8z6J9Jdb1sBUhYq1mvSTJ4IV9Ta+9
	 3iX1weYLJxTllDwn6CWSltLm2XNTk1leeWW34ezlLkVLjZU1bh+/2lkUpx6DAvxKAn
	 DV/LqfQau3HrSGRLZIgfPxp1aWX0pzZL/mKTT5Jo=
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
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
Date: Tue,  3 Jun 2025 13:29:10 -0700
Message-Id: <1748982550-6166-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.6.93-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27322670  16732594  4640768  48696032  2e70ae0  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34701581  13853966  970368   49525915  2f3b49b  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
