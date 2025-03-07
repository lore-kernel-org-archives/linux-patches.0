Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E0124FC03
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 19:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374883; cv=none; b=tBi9d0ozkZUHuTM/TvYt10fUwho5TS1g23nviF/3xU4SRRGhz4DV/c1tWrnaOOpRzJI7EXPicNXpbc95XfJ2DKJ1VbuQAkCWg+IT38AwgB8TiIKHf+uYnFL/zXYk/p3HqyPPN3FRdV/al30Q6tiXA9NVuK07IAD5HliqaeV23cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374883; c=relaxed/simple;
	bh=ut1jCbJ6TAMfhzfDmj7s2D6RvkNTw+JPeEdsVYj8q6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dMB+31r+eaWeK96oBqnIKkVZSaDnWhT/W6r9Lapq9HnL3+8zvbz/Xzo0cSMJlhXlJi/PQWIP+vTPmzuMrKEMV4dXtaBx/2D/SKOPf/uqI/5q1KjzK87QUfVvneuuJssOkvSTFYgOk2S0hPpsexokBg8Gquf7M6Q6MCxMyJ0YPo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MoW+4SGr; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MoW+4SGr"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 90FA32038F37; Fri,  7 Mar 2025 11:14:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 90FA32038F37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741374881;
	bh=jT5flJtW+Sx+B3QqUFbgWhGSYtG6eziGnR2ghVcK3QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoW+4SGr4qwDajmdbdybgWCY5GrtYkn4uB5w5pdBzdT3eFRDbayCGSeDBQ0yBbNVj
	 bVQo5fsp/EI5tkrgp4OhsCrKaJU9DD8s2OAuJgVqFc+h3CmZdXHFES7xuJbHcEzejX
	 LrWNI6zmYdv0UTYa3nKjqkFFdlBsEKFEv/q7J7So=
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
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
Date: Fri,  7 Mar 2025 11:14:41 -0800
Message-Id: <1741374881-19155-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>
References: <20250306151415.047855127@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.18-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27755354  17713522  6397952  51866828  3176ccc  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36390288  14996757  1052816  52439861  3202b35  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
