Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1FD1B4232
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684719; cv=none; b=hBJ6RnYhc4SXpm1HOvqXlqkkxyYrYv7atT9V8UfJ3+QGlKc40uHHH53XEY5e6uYD73N1ry9lMj0NeVfvSiO/XY1kKGC2oUSaQ9A3KFCBrkhz0M2tqNolWSQi2YdUylLlnGSuIrGv5d9mZu+qKdvigltSlFs5ZAP389vi22eT9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684719; c=relaxed/simple;
	bh=oiHwJ34EYK260i2RgAofqbxSI8vZHVcaH5HYejXdjaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=rUIiD1R1J7kx75ZjbG0gLg22/Mets+we2xSAYR9+N5XTcTJGFPlsvh8LCVWxpZmFCizomupY57SvpujQsbJC0hit3CUQJIX7ZZyWj6Nn6CcD74qVN0dTTk0tXT56P4mRVJmoDxMz4mtlyOfd6egj1XzaHYPoLkK19Yz2ouRslhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=AyBaHhp+; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="AyBaHhp+"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id B8BAF2046769; Tue, 31 Dec 2024 14:38:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B8BAF2046769
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1735684717;
	bh=oiHwJ34EYK260i2RgAofqbxSI8vZHVcaH5HYejXdjaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyBaHhp+QCAFNf1yTMZPxanptl3wsj3phgE2EBQ2B0/COyVH9rUhms6biOWB5ZeFs
	 PUDDnW79xYsmOdHK0GEib2TSiYdZ3brcY82aPNihJ+CJgMmu0pewRNO5/YxMhLyUIE
	 zgQyTOZzHf+b3qywecsB/X2npaxdB0yoXwiKfbDA=
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
Subject: Re: [PATCH 6.1] 6.1.123-rc1 review
Date: Tue, 31 Dec 2024 14:38:37 -0800
Message-Id: <1735684717-20948-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.1.123-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
