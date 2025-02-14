Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F1253BE
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 00:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494729; cv=none; b=A+DrySInLJdtDQOIIgKR2PQM2U58nesGoIuWjxjwrvu9/ShxNrL/dMguQdM2kCFIKGCpujerPG8yTfDg6n6jSrgErRE2OT9z9l+OxPNdTwt+W/3FyQf6R/ONAGKeIZxKkCapL4BFe4xq8EDJvvUIL+ZjKYziRbcsq7ASlIUqtck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494729; c=relaxed/simple;
	bh=sES3N0KOCj95wUW1kpcBsWvzb0jA4oJ+pPvo/7OVEpc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=WI2N7HCDUB/DLhyRhWM12WRRGWJCQ4mjwghYeBFBjsHv5Ry87LplMlXzTwMOJGhXZpJ4AVqQzSH8PG41G4rU73kDhMMe3FfM16jG8zH/I0uCqLqO2+7neaO5UGUPuEm31nrqA3HjvjTFDY8T3ywj0E2g6iq1T7+flIxeMjEu5LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Fq6ZrS0c; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Fq6ZrS0c"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 42C56203F3CB; Thu, 13 Feb 2025 16:58:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 42C56203F3CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739494728;
	bh=lw5OAMpvD91SmqoTd0RZGp90OwCZ6vSzyyb/Cz5IKPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq6ZrS0cZ8JOLt9tvxxFYN2gEj0veSvJPxmRtcnMfkGl0BEEK6E6lNQ89mkDnADb9
	 R4byienxSrMKZ8qJial4iCYtlFDY7dX5Eb0IP3tXnA/CEjK9NR/2/c9jOr2yKBSfHi
	 5Tfxins3IkKcPuKO13pdUemxV0ANX5etgYv+/obE=
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
Subject: Re: [PATCH 6.13 000/619] 6.13.3-rc1 review
Date: Thu, 13 Feb 2025 16:58:48 -0800
Message-Id: <1739494728-25049-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.3-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29934888  17832018  6320128  54087034  3394d7a  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
36672710  15080089  1054416 52807215  325c62f  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
