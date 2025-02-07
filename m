Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13CE7194091
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 23:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738970201; cv=none; b=ePSUrmbpBWgbxj+6DgUikw2sMyrXIChEBp60WG9FGqXy6xbYdD4hwzJuj10QevEFabA9HeKZjyWo3lquD5Suav0V79EcaSyaiiODxsKehF1COrmR89t5KVrVFdAGl257cs9beT4T+Farp6UYt98qeUR10kRnlUMm4PYXxFU5XqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738970201; c=relaxed/simple;
	bh=elTo7tm33xyEuVb7Q03QiIaHG2n1C4DSWRPF8CIqPFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=rWYdowu0LI9/QTGLp8L2Vlo6gcLc1fdQ4gPVx0vDkgdKZQTB5XmpVpZt8bOvdoguVZstDkw58R+kP1z7uJjVfLTXFc9mHMuMH4JVo8VDcvL+xxnsxsnqvDR4nxEG0OzwBOEdJ1fS4tL7CkfKDPWRPdoqr4tQfimDlVssWgPKL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HxX2lXfW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HxX2lXfW"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 74C182107303; Fri,  7 Feb 2025 15:16:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 74C182107303
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738970198;
	bh=/h9bndaqCJz/Duc+GJgNKWPnYhqPpY5vf+iJnO+FKUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxX2lXfWVZ0tqRDkb8fUx2Ab0X9O6UO3Dp5hKbi1pcR5rwBzzRiCqcbk9yp/GA3eO
	 r5utmNottkmjVwBSWaiHPloxiAE2I7YaMEawVFr3bm2tCtHMx3c/YasvSEXeX/PonE
	 1m06YuIQJN3d5H1+6CAkeYqcgxvGVtiyMQyjbe3Y=
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
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
Date: Fri,  7 Feb 2025 15:16:38 -0800
Message-Id: <1738970198-6607-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
References: <20250206160718.019272260@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.2-rc2 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29934254  17831930  6320128  54086312  3394aa8  vmlinux

Kernel binary size for arm64 build:
text      data      bss     dec       hex      filename
36656132  15075873  1054416 52786421  32574f5  vmlinux

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
