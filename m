Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B671A0730
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743197949; cv=none; b=UllKrASP5veMYbz1F5ssQ3UKCx29YmTOREipiuPSm7TWAPen4MOqVeQeDEgIcoOwOKR50OxyDo0vrtVg5K4gkIEUxwlON/wpXrJ7LH3msEK4UTh+BX0B9YSX620N3WvRoBfCETbI4PvoSWzJrdXeE9uveTI7hHE8s8PQglB5Xc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743197949; c=relaxed/simple;
	bh=DQDTrQLhMzb6sR4+0c8ViHURa6KbmU20j1Ff8g1ZiWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Wpx6Nj6y6ZXYEnF1ghv3SR/K57E7vzzSJgWHTQMl7KhrJqXXnfHGcBhc4KCSVjBdq5MZe+8VvUGZ3wmwtyENhAVStAzloNYPPhGv+qXstb9wDTAUT4TWgXCgu3BbzClLdNUKnt4utSRF70dEjPdyr0QaXdKybZrxc1G1hTkS0sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Dwf1xw/P; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Dwf1xw/P"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 937E22025640; Fri, 28 Mar 2025 14:39:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 937E22025640
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1743197941;
	bh=NluN8Nh0F+jg+nys1gPR5DT7JxqFS9Cp+4hpM5K7JVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dwf1xw/Pnsxplv+nVKG1Y322FT9KrLyOnk0AbcH0+csZbwVdWhYl5Ixm1UFUA0HhD
	 tujHbXizKtwHiLgsLt0haDOlnoZgPviSSED9+LUZnBy4DWvdUsrrBRVA0F6agLH0mT
	 nthjtdsh/it6h9RPy/6tMbSQotoevR0zje108Avs=
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
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc3 review
Date: Fri, 28 Mar 2025 14:39:01 -0700
Message-Id: <1743197941-20416-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250328074420.301061796@linuxfoundation.org>
References: <20250328074420.301061796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.132-rc3 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
25843869  11302614  16613376 53759859  3344f73  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
31266274  12543696  831088   44641058  2a92b22  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
