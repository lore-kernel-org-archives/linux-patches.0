Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6501A9F82
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 23:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419324; cv=none; b=Bd4wEDuTiuNtMQgMiYgCmUtd72ovWFEFwiW7fGoXNhnI6a6CZRtzjvx8aF3TIiHGqcZMo3jE0mnfX2Fo5InHxGWbp/x2ZhJruCghtF0Pb1KYo4qmEvLzl50bpegxOfGktN2tBWAbQEbZweSV+nrkhDW4T6s7hVPTbRPGyghf5iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419324; c=relaxed/simple;
	bh=M8agSZOwcWfimBDkgOFeHeQd9fVu5qd0yh4Gq79yOd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOsQ87Lo+L42uhGhrZs+N7oHKwIpwlNGDxWR/UfPvWutceh9bXOvk/ekRtn0nan/B9dWaWCDGQtt2LkafVH/f9L725xn/gHjjSh1DwVps6AEpH4n6dcn+rPnuIQYj4Co0X6t9/AbbU9qSNZ/dXLK7VZjg1JaxPFkWljnGr92VHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qVMK5fHL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qVMK5fHL"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 676D620B7169; Fri,  6 Feb 2026 15:08:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 676D620B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770419324;
	bh=M8agSZOwcWfimBDkgOFeHeQd9fVu5qd0yh4Gq79yOd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVMK5fHL/zkM0ChVmqC1fyjoBTaTiCohr3R+9UXHIfemlOYPy8sFKoRcFwsuXURbi
	 9Uh0yj+ZwAJxNa2QKQrWckG5wTYyTyY8E+n3Emd5VF8PpUB4S75LolOZ9IoHGPrqim
	 5RgmmeMfP7vZgZhNiTVtTKtLq7YHcYqszc3qLG58=
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.1 000/276] 6.1.162-rc2 review
Date: Fri,  6 Feb 2026 15:08:42 -0800
Message-ID: <20260206230842.1016109-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260205143450.492803005@linuxfoundation.org>
References: <20260205143450.492803005@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.1.162-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
