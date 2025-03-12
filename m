Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8621F4CB7
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741799392; cv=none; b=sHpgEeDPhyv0cm+Aw36VNwuECQcDdI8FUZBG6vd37o/1ISFFUi2R51mNH/zjrh9YmrgVTGHcVQLuoVW4fDrHH1SCrSOFOwVa+ZhPuRmMMw+E0AJkfvT6UAXQiASVAqNrmpHuYcI8GyvSoXK6FI1NlxvgI3FAnLV6nSifx/7Vlgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741799392; c=relaxed/simple;
	bh=jB/qWuqYO06xfhdi+CopyNEuGLSUIBtuQb64A2uzIDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=YvEqmrjyAMV1K8B/tf2Fra48IlG2cxzQyGTUwfWOCeF39Fgxfc0Vr1vAxCCOO8vugPXZ7qIhIdlNOQD9zdVPHseiz7GfXqJPancD6Gr1w+LsskuaFOx9604zWw/UTenDM6UColnpK0wdn9BY1o5JDiM6Dpkc/TlN5Pin2GoW1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=fxQJKEv6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fxQJKEv6"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id A051D210B151; Wed, 12 Mar 2025 10:09:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A051D210B151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741799384;
	bh=lOBVfaNvoVsVwWCDZXhgCtWs2eWoqiLQksEtbnCmwBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxQJKEv6is+gstnk0hPAv7I1y780HSKDEXFnqyQcYLE6EPGHyoDMQtqYGMI5924vR
	 MN8Z28uiA+/GSLiwqCCEDLHL0srCKSgZfNDdMG0+vVHDXA3B457aLq22NtznUt2ZqO
	 2nh5DY5F4uxXJQTjkttC/KxRo3cCdUPk6PJ29CBU=
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
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
Date: Wed, 12 Mar 2025 10:09:44 -0700
Message-Id: <1741799384-15189-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v5.15.179-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
23546701  11254934  16400384 51202019  30d47e3 vmlinux


Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
30786457  12639912  857980   44284349  2a3b9bd  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
