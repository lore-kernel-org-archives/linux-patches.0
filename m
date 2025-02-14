Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2437E1A2385
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 20:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739564074; cv=none; b=eL3/9ojHQd/14wsShcpvMtzsGLfFTTIJpahRZNteFATa1flMnbW5BEz0KlNUuHpDM1gVVYp7QHMnxvitGAvDfC7e9raidppzp+ef8ixYKQn+8/Wrc9GuA86CHSQrWrNqngfd1g/4QAKCmIgKwV5FyCkEr8JSWDHKzx6GVrCfQmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739564074; c=relaxed/simple;
	bh=0dx7+68+dScFaW7LTzR5LyI/y3rAoAUupeHDZk/6URA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=abxwp4w319fOfjwhQxwHm0dw7ZUsQWJOtAFXkix2wGv9jd3iZ0oiEkm239OBgmFkVO/BzTU56eJjjV33WMDQiw1wTyYBEnhEBooq3/LdjxtB6Mqzf+IqQIsV9iM7/9/hZgttB05UJNXhxMmNaWOvFU4IbnlmNs2vAt1x7jj1USk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FZ9vkrLP; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FZ9vkrLP"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id B94C2203F3FD; Fri, 14 Feb 2025 12:14:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B94C2203F3FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739564072;
	bh=1g9n76IHVrgTG9ynCb1Z6mm4K0pO73Af3KY+3NyjrjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ9vkrLPFAVyqjW+fjFfoyeuoFvbKxcCt8CswpuN1lrkU3bXNDOCLjsp7xphFP5gT
	 8+0wk0sqKgyBmIHbAThDydjjttS2lb1te3+hvpHo5g6k6UnlCWPUZBhgyOdgsH05AI
	 wiUatmANGrMoKUllUeK0Z6vZ8bMkO+dDE4mQemy8=
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
Subject: Re: [PATCH 6.13 000/619] 6.13.3-rc2 review
Date: Fri, 14 Feb 2025 12:14:32 -0800
Message-Id: <1739564072-4589-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250214133842.964440150@linuxfoundation.org>
References: <20250214133842.964440150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.3-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29934996  17832042  6320128  54087166  3394dfe  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
36656348  15080113  1054416 52790877  325865d  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
