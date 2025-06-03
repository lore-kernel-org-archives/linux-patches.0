Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501781C84DE
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 20:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982813; cv=none; b=qR2Q+e8Q67GAsBL50juAK8lVsey8JaFaNBjxUGnVFbhkFeRj5etYI8n025CPo4ZysoBLzMpxImwwIU3H9HtlDHpQF/3dTL/frkC1UWaQZcgWf8klpzNMRnuyQTJBE29KgB3bCj0xAdvn28SpwUzhArYHXcpOAOaurR7WIazX3W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982813; c=relaxed/simple;
	bh=jlZrooBu729LENn042oThPi5X1Q2ga+Zf/X1aB4zxXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=R30GNbXTIWFBQ0sOtELeudDRt1eSeVbmuD7CSnFpuZJ2iUwUqkUiBmuYClW0FRtj5vCAO85A6E/HeUX4UTKyI583Cv8eXzlgsnakkS48OigTol2iRQ3Vv5nIL0zOMtAXiVtmEvMjM43HhsvNIZwpWIa5o16QUaCczhA6rOfLrO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HHLKUEUl; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HHLKUEUl"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id DA2F3203EE0A; Tue,  3 Jun 2025 13:33:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DA2F3203EE0A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1748982811;
	bh=Nny55qEA7MSIsuuGyCFFS7Ug2zkkjHkuqrLH3+Gvp7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHLKUEUlOl7lD/20n/fQLQWfOOyig1YaCPUW97dCPXXxWkhwtEPzBbOcTyGqVOORf
	 CTefZ0H0ZrH93p1HZJ8STit2vS1UecpvK79ebYXM3CZdyeL0MjsheCSABty/S1shF9
	 z2tXQDN9l746nrm3Qr58yV/4ybJVMBCstx9sFm7I=
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
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
Date: Tue,  3 Jun 2025 13:33:31 -0700
Message-Id: <1748982811-7116-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.12.32-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29859850  17724758  6385664  53970272  3378560  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36415263  15006501  1052880  52474644  320b314  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
