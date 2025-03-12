Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D177282F1
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741799542; cv=none; b=XZTUmomHH/z1XUOemdloUQ9AJiC9S/+OcnMDDH7rVtLm9D7hpTCiFlbAOBKreDBE2rQMEWNr5QWpg/XA7dPTGcB0/p9NRMYRB0VFCY0Hr4HLNBOa8ajEZY79XM1b7RVFMv8yiq7BOptCmAZRXe2+dZYIf6YORZBTBs7nSC4uTFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741799542; c=relaxed/simple;
	bh=EQx4l0eKrvYMHLDu8wi+jHEJQR2ghRI/jchw4ZNVe84=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=bbm5r74cCcR4EJAnq7/EQMK6H2pGTQqm5EdlNaJymMkIxQBo9rIOVoYCJmjN1JtGgSA2KW832sINQlcxbVpkBI8veZ85rBFz9PJkJ+ROKgpUzoU1MM4GxHjP/mxP+iJuqVt1WVY0WF+0FFYqFPj7Oo23QzoPKh/pehfwop4x7V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=DLFXCAPu; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="DLFXCAPu"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 105BE210B152; Wed, 12 Mar 2025 10:12:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 105BE210B152
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741799540;
	bh=frH46tTfpQZS4kolQ8MKAL3pomG+/c1d4lygbCZRq24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLFXCAPu+uTMxOurHBHHlR07RqZx4iHz/Nx1qRDd/nsJNDCSIq1I1vHYnaGS2vhTJ
	 z8CRC5p7b6b5c9m4yK0eVQpIVTCW9+KdKNRH1FMe4QpVvMaeZuG35mwtabzGag1V3f
	 8Bf57WhVLe59XQ3cleONzapvo17S6nTHIUoVCYCo=
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
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
Date: Wed, 12 Mar 2025 10:12:20 -0700
Message-Id: <1741799540-15792-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.131-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
25843392  11301066  16613376 53757834  334478a  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
31262050  12542632  831080   44635762  2a91672  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
