Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B4978F26
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 01:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754011687; cv=none; b=qIbooemPTX1q+LvKI47FY1hVpLjEhfuRzL0p826ok4AaXGY8vOm12G6/yRui1mTipHCSxzcGO6o0wMEC+JKt3fq6Z+MLzgILeuXcJek/Htn6UrIkahkYuU7M9GG5NwMK20s3L6u61djGu1j4eCFY91HafXstqXOtIO4HFr6B1uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754011687; c=relaxed/simple;
	bh=/eUIEFMMUK2svY2crm/P1jkwiyNJ+tSs6gc3iE/Lkls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aVmvf2DBYl8PjfMjCSrb2y0jJXbox4nXw77IswZ+pAtfVFb1NktOQjcTRWAj1c6oH51EtptTs040vbPB1dThOdq0JGlXsUdvDtTrCxiR0jLWQzhRRumPV+rPfRAjypw+DgPP5cVbzljBLO9rder0B2/fo3DvxHKh4ZMYCDHIkxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=EKI7t/KE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="EKI7t/KE"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id CD40B21176F5; Thu, 31 Jul 2025 18:28:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD40B21176F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1754011683;
	bh=/eUIEFMMUK2svY2crm/P1jkwiyNJ+tSs6gc3iE/Lkls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKI7t/KEWRtGprQvmfCBMv+n3cSaJwtLnw4cny3Jj9nxI8anY+dmFaOgea17rEX0O
	 Bo7luvjR3w38x97VJj23cwdk184c3O8bL7Uyxz3iLVzytW7+3WRcTaeZRC3IK/3G5r
	 rBVkUWRejvz/JE6ywOgTKG/vo8ec7xEoMtBPnvCc=
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
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
Date: Thu, 31 Jul 2025 18:28:03 -0700
Message-Id: <1754011683-26666-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.6.101-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
