Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B6C800
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412182; cv=none; b=Kb3T+JlKOnpK6lEIMuPIbRyXFV/kpjf1j8v3uuhsQfZuhQMySNXsf6mkdEF5/hX1G38yM6AoJTB/A7OztC3Prw4ElwUU1ddOmz3POWbzDZPkFjWDgSBfhsWTauHZ0lFwYQ+25BT/tn6XFQpCJtCnUcUWRU5WwshIGO4ZVT/9+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412182; c=relaxed/simple;
	bh=ffMynF6ZpvGPlQZY34iKM7vHqKwuO2S1uFZDnBWeKsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPQlj+gEZYHGdzt8+r5ZHZCJEhOkMOks0jz0WN9VgX9s9oXSzE37ldNV4gSXBGCho6NcN2OLkp3iAxb5a7sIRn/w1WrqoTzcbPKTkTewh2ckfa7EoJH77nd6Q5NPru2jn/UHfOrf8o7rNStT9CtAj4LPBL1sbI2ckTlL1aNlpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=BI3gzNg/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BI3gzNg/"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7ABC120B6F00; Sun,  1 Mar 2026 16:42:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7ABC120B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772412179;
	bh=ffMynF6ZpvGPlQZY34iKM7vHqKwuO2S1uFZDnBWeKsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BI3gzNg/R1h2QZBh7nmXW6IQpcjYPKPDJfnPdrETF159aIuoPTyTtAWMGWXNMAz3Y
	 +aPzHqGZ9O0voDDUZtPgwtJdS4Whn2dxRHu9OUnBkvAr1pUTokSG2nWpQ6tWbyCYZa
	 hnP57iPX2gCSvxnfQJr+e44eX8M9g/loCwSIInlw=
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
Subject: Re: [PATCH 5.15 000/164] 5.15.202-rc1 review
Date: Sun,  1 Mar 2026 16:42:56 -0800
Message-ID: <20260302004256.181782-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260228181458.1600528-1-sashal@kernel.org>
References: <20260228181458.1600528-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v5.15.202-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
