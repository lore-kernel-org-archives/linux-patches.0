Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049BF23F369
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741799702; cv=none; b=fkphA+DwQRRTHYKLJTfj2SuseBXeg04RH3+h6HNt4xwAk2bTidQzMoTIOaRuU8P8W6Gwd2ZBOo8ZH+SpB4AQMP6Dqo93dWMAyjHsBGm0dVXH0UYw1uWBrzxdAyXt5LZCyvUcQSyXr/iZaR6hluzLLMEW2JOWWzD3GEi/4yKzuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741799702; c=relaxed/simple;
	bh=PCW4+YTxybVsdIbd+UfGJDXkgVT57tu4q0z62rBdrB8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=kzNKrnotJKbWa+Y06Rrc9Wgc5rI0k1jGCQ8gpgkWGN3dvCZl8k8Y0+/p6z6c8gcDHugfzKJPSqdPnzomb5OhIdQ/6HeXO5xYmVFGsLImsfmMYYFnhTbqW2lTLXCmGnYps5Eo5z4kVhe6k8PrMoBhFgCVF1HJaOuU6K/0Dz2/+K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=md1FeBEc; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="md1FeBEc"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 5AC05210B152; Wed, 12 Mar 2025 10:15:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5AC05210B152
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741799700;
	bh=UF7fDVeDMyuXkycPhMG827Vw2rF6G3MVLKFqxQrD/ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=md1FeBEcTrDsrKAHbIXuVjtLO2lHrE5b9fHW5eX+uONO1KAxnP08895tTdmVRJghH
	 hufpHk1/9mn1hLDnvmFi7Crvv4Vt+EfgUqt9BXYacRlEGFlwxWHMh9CpECo+DstGzC
	 aNuJ7sHssN3LE/WLUUMn/loUrGgnmc5+UsbIPzgQ=
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
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
Date: Wed, 12 Mar 2025 10:15:00 -0700
Message-Id: <1741799700-16263-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.83-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27318015  16713718  4644864  48676597  2e6bef5  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
34688768  13844986  970368  49504122  2f35f7a  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
