Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F158482FF
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 03:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753328431; cv=none; b=cgj75N5TUv0hbGG/NAhvkBaV1+/z9Cp7rIu8C4qk2mcuf7C0A1Q1KVSKXxB0vBq6HddeBsJbPvRN1aqTBwympvRovAD/4U5DeWh3b7rjpAJ+NubaXdaAsTa42s7vOnMl2lj7i7bY7yOmsCtwZ0ZmNZzLEzPm1w1WypAUxbuvZ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753328431; c=relaxed/simple;
	bh=Ti89NfXW5ceLJwEwTq+SB4qWkVwDTjoSNvmEQ+wWMF4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=BZvhTFAGJr7/byZ3iUF9wTy5jyVGHRR4yz2oP6O2DNns4XzjxOtft3sSc4oxJql8gpkSCnV0qy3qqdLcM/muSuoEmh/DosuUIR5e600hRDxaTokoDXCIH1h8MIo4kakoEttXvq5ilQDaiXteU3dJPwi2vFFNhBSUVUEkDAZ2qN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HOtmont3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HOtmont3"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 066AB2120398; Wed, 23 Jul 2025 20:40:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 066AB2120398
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1753328429;
	bh=ODgHEBDsxjvu/jObWI0VErMe7aqUCsGUIxr9XUhPiwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOtmont3mD60H7wxQGcQ6B2PYhgzucD3HukLg1E5ou9hYsgShAA0gk3aGCk6POOtv
	 J1XoikXFP/hL47jLCmu6VkWklkBD1nspT4MIZiRWxfvRV97jcWVqCrmQhJI+FYcyuY
	 YXDO+bQYB6Y8fYF4OIktPLonB7B1bVzuPSpHIGyk=
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
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
Date: Wed, 23 Jul 2025 20:40:28 -0700
Message-Id: <1753328428-16014-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.1.147-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
25849666  11309394  16613376 53772436  3348094  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
31289540  12552036  831088   44672664  2a9a698  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
