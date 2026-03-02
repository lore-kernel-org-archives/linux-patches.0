Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7329CC8EB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412664; cv=none; b=A76VEPiLZTKGNmYL9Gw42yDftghk7XrrC0KAFwpVnOfnODBQAKLNWxn4ZX2/vYXmKWGig3I8bF2/2g8Lgt7RIVSRKv4RxhrciytnbAA+UhxnkDMRGpYMI8MDBW4CWKD5fyVGOQbeUD8PxJ/DSzH5JZzg03Lvycj64B2YAnMJosg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412664; c=relaxed/simple;
	bh=G8SrYEjdRYiE+m18Kx6p6t6X6Y8yLSDNYbMjctSntsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii5YQ+hjS92H/DXxTQ38u+xYJjZs50cJi3VQy8+GwR72+mHjH4eKwOE/91nc/+6re7KF57b+5tl2+3pffnQWCTwKPDozLo9Gj61uqpVSY8PW3/f5IGku0ngpFM+H04sYYsbz5Y9/U1tv13qPi0nypmh7Tv6d5Zy915ouw0hB8lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rP18mt5d; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rP18mt5d"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 48B4A20B6F00; Sun,  1 Mar 2026 16:51:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 48B4A20B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772412663;
	bh=G8SrYEjdRYiE+m18Kx6p6t6X6Y8yLSDNYbMjctSntsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rP18mt5dUzvWhFIp/MWrEg6b1X4Erl/s0GfZvRlEiFpgXyUAfyZQl23nBQrFSiqLa
	 f5o9wxGIvVNQ/dnHdQBVh3jNZBCLgx9ykXjfHIVaS6A9gppks0fTZtN9LTrCq+ao8+
	 7yjrMwn8rz5pncMBbUPbvShfATfcGZ9Y7/Ae0np4=
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
Subject: Re: [PATCH 6.18 000/752] 6.18.16-rc1 review
Date: Sun,  1 Mar 2026 16:51:02 -0800
Message-ID: <20260302005102.182120-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260228174736.1542240-1-sashal@kernel.org>
References: <20260228174736.1542240-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.18.16-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
