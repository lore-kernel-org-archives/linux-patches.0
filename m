Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0A91EBFE0
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 01:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770340926; cv=none; b=BIfmQSm4ABbo3MJvmyl+1FDO4Zbi6Ptpa6cDLl7/5hdc1aJL6lDkcEOEygyoZC75QjW82UHnA9xiVHshscPE7DMerH7Ln95jQlH9AZQ68EhVfjVK01I1cszfAlivZtktNyKNjNij/7gty3/UaHVIiIx+axRBwvPc46U2bS9zc/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770340926; c=relaxed/simple;
	bh=R1iVsnBd0MDfXk0YgsXB+NYtO7cv53O7qK14tfV3jb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDW8PuPqWzo++J7XRvXSbw9pDuDBF8w5VwbOPY1j408Axrt/SROf4JvxCXpiHItLhSRAWKe4+/lqtKhq0e3PPXMvqQOandroHVheNqS1g2OHEUCqgDroFET5gvbS5Uf5WdDVTtV4ZszHo6CBSgwWZpDrfDg5gjOFhElHhjmyNno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gxQnYKRW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gxQnYKRW"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6344220B7165; Thu,  5 Feb 2026 17:22:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6344220B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770340926;
	bh=R1iVsnBd0MDfXk0YgsXB+NYtO7cv53O7qK14tfV3jb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxQnYKRW8KVdLAKtv3ix9pcfSICpODO+r0yO+twIOiKcsFmPhXtxYevE/TlbCe2RK
	 vtHhb2+16yIsDQervikJUf/1MuM9l7GMQYtNEQ8jY4xkYjvyIWUYWmfnb4zLnZIDg5
	 EdGf9JebmXk4b3rapjEXvbDntf1YakwtbjynFEI0=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
Date: Thu,  5 Feb 2026 17:22:01 -0800
Message-ID: <20260206012201.960531-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.12.69-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
