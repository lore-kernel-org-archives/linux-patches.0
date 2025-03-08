Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CC71F16B
	for <patches@lists.linux.dev>; Sat,  8 Mar 2025 01:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741397387; cv=none; b=JPUYaNpOXmWtxC3NZW0unX2V2vX9vNDAPwoaIt7fEyEdHZAVqqMF7bh1rQoUGMlv2gg4aqK4A0qIy+2+lxkryaSlfztj/kf72tLI1wDCUruPkKSvQN7gRXFy4ueF3+Imyqfcykh3Du14WJyc63QzhjRWKGEoqXkO9Cour13hwaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741397387; c=relaxed/simple;
	bh=BqP4DM+/+IuWr9xFjlNtPFqeLgHhfPnAfbwAYxrh9t8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ihUpan+lg98Koq1niy3JBtAeQu/xERdorsRNQX6Rd2I8yPqmGSMPakaesZfJd79+u74cwDNErElLorGesiQXSrEMFDj4KWTYLScLyxBrml5Fl199URog0G9dve5rFHhWuFytiOOFASxIIucvq/SBAYJHgMjNBaO/EvUpbfDRoFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=p4XwbJnI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="p4XwbJnI"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6F32C2038F40; Fri,  7 Mar 2025 17:29:45 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6F32C2038F40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741397385;
	bh=TTvLsv859XQqVD3qFhNh+GXBq7oLLcfCxbyXedqoY4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4XwbJnI03zOJFK/oL763+6NLiTllnotnwAAAAr8H3k8cVXwmAhBMWdplZIjSuxF1
	 VyNJ5xXSFF4jBZCf1gOTSLxrFNyyF7pP5b3HWU7fWsEyMCdHDobCWzd1Po5lCjG1yF
	 rAT9KqVeVgLFovRdaJxdFXurv38S9B+FpxM7XbeE=
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
Subject: Re: [PATCH 6.1 000/161] 6.1.130-rc2 review
Date: Fri,  7 Mar 2025 17:29:45 -0800
Message-Id: <1741397385-31329-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250306151414.484343862@linuxfoundation.org>
References: <20250306151414.484343862@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.130-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
25843392  11301066  16613376 53757834  334478a  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
31253797  12542616  831080   44627493  2a8f625  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
