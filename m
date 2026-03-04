Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 746FA33067C
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 06:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772605277; cv=none; b=bTrju8fAb7QxoKS4r44nmZx4383q1qwWhIfEEH6oDw/I/c9VIg5QsFMhQrV4//bAA2Y+ul0vWbYiDkJ1in/DmXWorUAQfWSm+78Hfl0DP2OY+yKKLLWVa/LxQxDmSnDTos3eFR7dh6fiA/hoyzZm4WoX6PFNDWL67lU4A9dGTAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772605277; c=relaxed/simple;
	bh=l4C59CEJoadNPz3SpTD9vrPWtETOG+CLS/TfxJjccPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F70ragh6gwPw7W20BHtcifUhca5vJITwQMpA9FWsY+Su0i3+JY9XN3zd05k11TY5wzIS1S+i9kerYBVcLIQXliIuioAjgk+SFIl+n0ROgF0jTAdp0/745bzqNF/ILao5WjJu2nsGisj8DafQEotJEazCDxNO//amlgbIzEz1UmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Jm3ctDw9; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Jm3ctDw9"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 2B4BA20B6F02; Tue,  3 Mar 2026 22:21:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2B4BA20B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772605276;
	bh=l4C59CEJoadNPz3SpTD9vrPWtETOG+CLS/TfxJjccPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm3ctDw9EKwIVOekmmWdWffX0hzZ2ATXF+g7M+OgIN63pPGStvBpuxqiBGe9/EPwl
	 H4jPunOGRDFHSnmTBTCOVFIUA/WzNc43CfC8fEoGR6XTRkiRvOSngmV1FUW2b5OOqD
	 MORxZVKy1Tvrifp9FUbDwAYaL3qWGQMF6KGg4AGY=
From: Hardik Garg <hargar@linux.microsoft.com>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Date: Tue,  3 Mar 2026 22:21:15 -0800
Message-ID: <20260304062115.350642-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
References: <20260302160834.2518716-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.19.6-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
