Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6713A1E5739
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742488044; cv=none; b=bYMrWEu4i4FPjq6fd2eeeROwxalZq8+voT07rVItPVnVoQ7zYElE+/9/3pbHpkjMb7TyTKOATwOIFG5lBotn7DtULnOQl+/anD6VMLjsPYOQwQ9BNa1duiVBiNgzEJkTgtyjnMXpxb4FqLs9uxkTFd8r4s+1RAEcJGR1om9+58A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742488044; c=relaxed/simple;
	bh=bfhieFFF5xFk6YbXZg31H+sZx2cavKu2QXKL1UtFJM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=gKqbaES7Mn6v4zcOx3onY2hqmCynysfcndapDurh4vAdrRJjzpc+l4W91Bbt5TfAVzqS0o4eWuxdFmhGSmZ951mWi+rA5M+WdgCYorcWbcoqkeK1NiP6Sra4l7uZIX6+FterXYuyjCwn8K+59/DYN/V6eol96CQ5PqjoCrokdGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=DjPOXP8K; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="DjPOXP8K"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id D85A32116B4D; Thu, 20 Mar 2025 09:27:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D85A32116B4D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1742488041;
	bh=k46qvSEd0Lp8ccJUs1FV6dMFtYIyo56KkHz/uKLy7zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjPOXP8KQjLGpzJ9B3DVK53xn4qiuw4bJbB2jEyNo/j7MG8m+UfSV4o2v/fv+9Ud8
	 VYbl/N+WMcHL5Y6NaoH58Tjnf2jlOWMeALo1Cm4C9QusiROL6I/OVtrwBM9LMGw5QA
	 GSZDfxIfuabgVRp8X+9ee0RF9OfEv1ihjqf+pJgY=
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
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
Date: Thu, 20 Mar 2025 09:27:21 -0700
Message-Id: <1742488041-4614-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.84-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
27318662  16715490  4640768  48674920  2e6b868  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
34684949  13845466  970368   49500783  2f3526f  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
