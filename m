Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08C72FF153
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772605160; cv=none; b=tQPwaa3Lz2chthr6dSAXrfgNfNBEq28sKqffQ14mq1swRcxTFA2JhpXZ9LC38yWIKs65aRZy380xyCjN7zvsmZSJ/X6B/Z+SFtO8PxtI8vU8x331a2Idjb974E3BKU94P3NxOCq/SoeF7q1/oLfp1fS8tPzIuYkVjQq+aAROP/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772605160; c=relaxed/simple;
	bh=0TsWnSxXvHDBRzoILO3OnWNm2yXQURGuuwTCsTQeL1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLpdgWPHHHbHSDEjp+ACg0WSzFtKsWUX74r0LZF2AX9YylmLolt8HJ3uFItO+t+B0KIgnplHqzOtFsi84KF5gwBorLF0q0u51dVA4/9JnOdyHchpminCn+H9moKGzhA35VMp6xJq/li2UlrGWdmmxVKkqgBuxqCziLCDgRXiM5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FNjU3JYv; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FNjU3JYv"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id B86B720B6F02; Tue,  3 Mar 2026 22:19:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B86B720B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772605158;
	bh=0TsWnSxXvHDBRzoILO3OnWNm2yXQURGuuwTCsTQeL1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNjU3JYvALd4+iniOWPzhUEeVD8/uz+aa1OP5QalzopDqPWCNoHBFtoT/jk126wBC
	 iihXDoJBD2Xv3t+JhdSOT01eNymNCQJSNFE4j5/7c+/OkkYXYuVxyqjVnNj4Vx4La0
	 OFpUzkiZX/fmLBcX5MmyzvH2nJbaz6gA3pdzjYvA=
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
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
Date: Tue,  3 Mar 2026 22:19:17 -0800
Message-ID: <20260304061917.350541-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
References: <20260302160853.2519610-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.18.16-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
