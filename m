Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078071E5B7A
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 20:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751573552; cv=none; b=tCiHtqU4ABzUjAoiUeXsfshNMxuUeePPebY5gTxQoehAGiHu1s7/S14x/JB9+5pixfE/HGHj1SB565WUGOOgeag8rO5CZ9P8HhEd46Fy09EhIB84E9O3M9KG/hnuCjul+10IS/TCZ4l7aqVgLtrBp3dP68EuHTyBEJQSSvvpMMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751573552; c=relaxed/simple;
	bh=gmh5ZoAgGsJKG8haTIpWu74Cwifbp8iS4hmC9GfBIAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=IJ4+HcgjstZ7qp8rwdIjGk80YboCemk6X2jPOibPsnPuVDvlheEVzfT5r2pN2cBiT/bAs8W3q5osn6YHK3tzgkj07OB56z1SgHNfjA1O6YYHEnvqw5pb8Hl7kTrfdEs3pfYjGlasKCtTZ2v5Qu1U/fzlewVkyesrxohVOHX7ecg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ls7eTFKZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ls7eTFKZ"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8D6F3201B1B1; Thu,  3 Jul 2025 13:12:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8D6F3201B1B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1751573550;
	bh=fXBcnpF5wIVxCrRcCZEh0GIQXdpGV1Dnj7t4XrnX4c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ls7eTFKZsvKQoWNUQapIL/zkupcDpzjxGfr7c1sN7smhoClWtQu99/wGy7wBisfWu
	 rozp01tvzgZmxExhvPH5k532LdMzj8zUf7+pC0KrohrXMBy+gHbU5aB1GKuhxJi+Od
	 6QepbLaA+tnxDTYTSLGBBj84EBkFbnTaNH1KvgXU=
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
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
Date: Thu,  3 Jul 2025 13:12:30 -0700
Message-Id: <1751573550-30344-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.15.5-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
31999332  14279706  6250496  52529534  321897e  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
37335764  15435073  1038480  53809317  33510a5  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
