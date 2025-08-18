Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF8A1ADC83
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755557466; cv=none; b=FTPe8GK4mdCDjkTkI91TSlf9wOpH5GDhsrDA0PW2rpZIQPzLxhYv+lBbnz5jv3E9vgervgAOtPb+q6ekgUUcgXpIOiohHIn4TyQ+2F0IKLxgS/plbZ9FdK32ml6xTb2isx8cUx/zx8PmOVa0/SnaM1KlebEfJ5vBFypJ9GJaYcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755557466; c=relaxed/simple;
	bh=rroISPl003D1rKJy9f+OWvTrPACCxw/3r1WT3Ct7X34=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=qeMdSIOBr66qXAHZhWie1L7x18yGdVePekgm/awrEM/0MJ2rYhbMkFLX2Lsdh8Qap68jm+ACTnREDPEOcTKpE8EUbH8i0ggDYtvv4jHgHCW4EVeW9F3P2PGQRo59QHfSILFZwBl8m2T8c7+iQJycOIRXvDkVHgbP7kCxfqpiSM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bJamyyQd; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bJamyyQd"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 800A92015E53; Mon, 18 Aug 2025 15:51:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 800A92015E53
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1755557463;
	bh=rroISPl003D1rKJy9f+OWvTrPACCxw/3r1WT3Ct7X34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJamyyQdKDAQ1lxSvpcDCI790L1htKL6G+A4kWHjwXEthrqhzJl4W1Y0asw3erUQb
	 kWwwfG6T1LqlkXPne3270S9OieEArOJMTDx1knLhkIMo0Dt1Yav4TGXKaPFc6CneEk
	 HekL8t0rBEJNAkuD6i6EwIPBxWXjNk0Y0RnuvRDA=
From: Hardik Garg <hargar@linux.microsoft.com>
To: hargar@linux.microsoft.com
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re:  [PATCH 6.16 000/570] 6.16.2-rc1 review
Date: Mon, 18 Aug 2025 15:51:03 -0700
Message-Id: <1755557463-14842-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1754011892-27600-1-git-send-email-hargar@linux.microsoft.com>
References: <1754011892-27600-1-git-send-email-hargar@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.16.2-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
