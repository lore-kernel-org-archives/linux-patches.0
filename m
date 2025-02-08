Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C901DDE9
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 01:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738977432; cv=none; b=JYo4O0DaNKbWc4vEl/CNVEXiTuu5A1MOPYvKf5rccGiB4IO2StMK6FONdgiJQ9HTBzkaBYYwXQxPtpMXJG68FYujaBP4VEh0wuYfsqhano3YUWdVH7+b0MZdOE1MVoXeJsuUJQQP21lwwXDESyigE0B/8zeLrvvz7fmtNbiDN0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738977432; c=relaxed/simple;
	bh=1/NoNJcQU+vHt+6ylsKXvzc/5cGuR8tXVRZ+eiNXcVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ZBw/Fw4p34KeBcBd1SYTctQ77VNdxPl/VnI10ZbnSKFsYOn74MiTt/61yAx524+/lVrB14OxHZY4LvpObvNMJh0+ZB/y8iv+DPHBBO5BOeGi5sXUYbDpW6vY7ldlBw89/GCQzsby4f2MI5SbycbM5CIT7SFvXks5lViI7QsofhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=PVdJxsR1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PVdJxsR1"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7B86D2107309; Fri,  7 Feb 2025 17:17:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7B86D2107309
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738977430;
	bh=NU+vJykwsGs0IGzQf19QVLnmgWQvht1kBLi20hBTMs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVdJxsR1hoWIoUT34MW7HONWec8WlinU2rne8N7UHuwXKeQ83VHEYmcfGaYUEvhO9
	 JtgdAl4wsNNbfeLputH4514szUzKm8RDMQoW+EPsn1LLvWB7GeUkwJXEl9ibMYcpiW
	 p0Ti+YfpyOWsc/HkeXWvIB47RcjsFdRP+N1MAKvA=
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
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
Date: Fri,  7 Feb 2025 17:17:10 -0800
Message-Id: <1738977430-29694-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
References: <20250206160711.563887287@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.13-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27752168  17708638  6397952  51858758  3174d46  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
36374219  14991749  1052816 52418784  31fd8e0  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>



Thanks,
Hardik
