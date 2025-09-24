Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0052222A1
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758697055; cv=none; b=diCJ6wlGRbG1/bZbUH1NVBowuuV4YBlIJNC1/p/5ly0Izetgd4qK/9acxqtXDc8HYl8+uo0GpfRuo2tgWv8uSIvdh1XIkEEq0EAOB2aFVoyQgc0VMQCngJ8ywkV+JtMGJtmc16ySz8bP82pqZwxOCGEMMCxTA+sf9kEmDd7geyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758697055; c=relaxed/simple;
	bh=E7enFAgAQqnaDQxfrHOF90YJfPYjW1vzkxftZJ4VaN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=EYX3XbtpTYSXiD7p6JBzG6w0qu2T0Il9HM8HZfCivZKuw9MRv/SW6NMRwHYgQUb3S1cbRcaUpRIN0gZmqn38d1Rg4dmIxtJqM8MHyzwpImMpttC5BbafBWBbZsbXs3gR9/pFk7sZEgzWRe8351RZrTOxq9ab5uPazmLwlNGiBNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=LY0yAcB1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="LY0yAcB1"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 5578E201C94A; Tue, 23 Sep 2025 23:57:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5578E201C94A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1758697054;
	bh=E7enFAgAQqnaDQxfrHOF90YJfPYjW1vzkxftZJ4VaN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LY0yAcB1XGSb6LwdS/wzmVZ63TpfCuJ/svcjVNfO34KgRvcFRg7WGDEK/b+5JTin5
	 Yr03Rkotos2JQJhN2mfFgWTiR4j6L7ngBnysuvLeLwO0+bIub8WioQOGSMWGt3ka0h
	 TqpbM7XA7iB6t3VPw24F0HItIhVnXPE2T6pYJTO4=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
Date: Tue, 23 Sep 2025 23:57:34 -0700
Message-Id: <1758697054-969-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.108-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
