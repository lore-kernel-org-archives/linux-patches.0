Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443E425A621
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 08:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738397806; cv=none; b=oXDJAWl5C5xaJWgCgzwg02krBq0HA3m+vIQN95TKCv/JeBDBJWgR3Ru9ZjidhAGUpDM/rO+iDLR1BJ6pTsCOg/s4dk6LzNWVSr0HCKZ6txaBzWeafooZY4YIOv1qDpJuUBQ+mXpdS8G6UEZGj8vBUX/10b9UpuSp5GsPUlcX2GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738397806; c=relaxed/simple;
	bh=Um6Sc958hRNWXV+ReXdNi2blKRTvVE8ndQGHksosRE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=EWC4iMHCGK4P8tiEeFm5xRpXAPAuYVBh2lm2AS9i7hnCYAXgntNJ43SJsPeVRQm+Ud+9SQtF4GZXXF3MPyzv926htaHWWOP89ku7G9ItiQsg7oT2/WqajOLHPJSs1kDSXam2BJEoqSPKsi3rIbGDXrJkrjUrkLwJzVH7Q3j58ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XCDgHQSU; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XCDgHQSU"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C45DB210C333; Sat,  1 Feb 2025 00:16:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C45DB210C333
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738397804;
	bh=Um6Sc958hRNWXV+ReXdNi2blKRTvVE8ndQGHksosRE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCDgHQSUm4Uwe6kdNFO7iOAn1NwhlSVQSrxAF9uwJD3wKC14rjinFlv10LkLviM7J
	 YKzuFk50Y1sqEUFk2Dt4HIoPhEGin/J9BMSlv/Adlx+vzPjLrrlOO//wNqZVLqXe3X
	 4NEZtRnfAkP63scLHZRXVdjr/tQTfcj8zO4of7Zc=
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
Subject: Re: [PATCH 6.12] 6.12.12-rc2 review
Date: Sat,  1 Feb 2025 00:16:44 -0800
Message-Id: <1738397804-7673-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
References: <20250130144136.126780286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.12-rc2 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
