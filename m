Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6170C213241
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278386; cv=none; b=AaqI7RRhJ45QdPq9D/jfbwHL8zBOlqxEAb+ROom2D7JDemkitzkr1/WyZb4/ZtkyBRaLJMSpy1fAVXwO2a6ReZxgRIRz1AazYQB5O9MGmvT+oHZ5ULy1WPDyMUafeKv+JqnjsXBxd5OMoOXFbBtwXK8wWgldaYQnZLag1LYqmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278386; c=relaxed/simple;
	bh=9cpEhC+ki2l6Yht/wjynUsUcQvr+j1ftFSHd8Q7RNgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=RPdJdC9R5tWZXRElqs6oK2ViHjhXMLGCte5UmQKrO5ZKjZxL88bIiIaqXQVn+V2SXaVZezlubrX2lWP1M8nFlwGQoa9/j+XZalnbvNsFumSy0QNpnjFsh8K2zyehqkdlP9uqlbTTO5QrdxXA1kXrtdhFBALweybD239Us91UcSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=E5frRR+L; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="E5frRR+L"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 0676C208A7B8; Thu,  6 Mar 2025 08:26:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0676C208A7B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1741278385;
	bh=kNfr/L670GSDlHM0Leth2bBQUkfW2x4tORl2rQ1OFpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5frRR+Lb7WMr+bunrIF0hRXKNyY+kOxABZhvFCAK/3jayUb3rl9BgxWqCOWHiDQH
	 vwf+Aef1XkCW/u18Ik41iGJW+vM94V5mVKY+t5Qm0HOHBUSZ7QAiFvGW541qidgszk
	 GJKozX0VBe0a58ywhwIX2rMSah8RlmcedztqeAuM=
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
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
Date: Thu,  6 Mar 2025 08:26:24 -0800
Message-Id: <1741278384-31251-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.13.6-rc1 on x86 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29936840  17836986  6320128  54093954  3396882  vmlinux

arm64 build on Azure VM fails with the following error:

CC      security/keys/request_key_auth.o
arch/arm64/mm/hugetlbpage.c: In function 'huge_ptep_get_and_clear':
arch/arm64/mm/hugetlbpage.c:397:35: error: 'sz' undeclared (first use in this function); did you mean 's8'?
  397 |         ncontig = num_contig_ptes(sz, &pgsize);
      |                                   ^~
      |                                   s8
arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is reported only once for each function it appears in



Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
