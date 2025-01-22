Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F43F216394
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 20:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737577519; cv=none; b=OfWL9mb9iqo14LRKvpv9edlEbol28iHVNs6tv+xUP7qmAtYaFqWS67GgeQCbmN7ogmvW/lIFiXm9BFPGxaoGwHYVNviVnyac08LcJm1vNRTlUnmQAuLaA7Gm4hIs48tXR/LkgqSPz1X9xBkiR9bXyumYAg1Z1glgoyWk0RE6Hb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737577519; c=relaxed/simple;
	bh=+0Q+5WnA8VL6H62OXToKzJBO2MRKsocb9AU3vwgzv+c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=pBTU/W5Sy1jRT2mX6dEklVIbdgBjtpp6bSVnksJbyvagk10XPfZE7N3bp+03DkJDqI5InJI8y72PtFjASLTJzSz/djxtb0iy0Z1pdu/DUOuOTJgh+ovOBaVryXyivnwxIFxLxpe17ZwB9muWF7QC3vBf4jYG8ByVAKA2rPFBU74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MT/MGK7O; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MT/MGK7O"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C66E220460B2; Wed, 22 Jan 2025 12:25:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C66E220460B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737577517;
	bh=+0Q+5WnA8VL6H62OXToKzJBO2MRKsocb9AU3vwgzv+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT/MGK7OHnh8r07tSypMiG1nb33FF50pESb7BoxEj/4yZHbMSVTIiwx2to1EuAfTe
	 KP8IkLbToBM++9iqK+QgIKfhOXEaUCMULHqzQpFzY1B8nPmCWSIqGo3y/r+6J9VusJ
	 TBR0H641bgnk/9StKoyvPahq62OqQ7YrjAv7FTX0=
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
Subject: Re: [PATCH 5.15] 5.15.177-rc2 review
Date: Wed, 22 Jan 2025 12:25:17 -0800
Message-Id: <1737577517-19161-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250122073830.779239943@linuxfoundation.org>
References: <20250122073830.779239943@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and kselftest tool builds fine for v5.15.177-rc2 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>
