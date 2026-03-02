Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADC52BCFB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772413009; cv=none; b=loWriAw15LSLcV6wxCBTA+4DFy4S6G1E+R3H/v6yGPbup0P5B0cv3E9kIBgMY5KTA5HCos9Vf4ZgtCT49PwEolJwie00d9bbU5hxIBC1vHmF3CF8SjzHq0foNFLYBHM9br7Xt0bmKCSwUSKOPRHUvVNXHcsrIj5Jv9LO9/dulJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772413009; c=relaxed/simple;
	bh=PSw5HeOrvSVKRKKFI6Unj9OUKoIJPBRnCWIKHhtwuAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL2LGhZyjVWLNVvv7x8WbcVhz3jzi36Jby7IdDi9hlP8Khtuid6KJxXYQSCbQwLyZBJmBg3KCRcQrGDYqWT7FoXTfLk9MKojopEWh3+fRVEnC1Ep71Ms5CZHesxqtxUWcCgctbJQ7O2HcCTZebWbEj0l0ZBeiPgkVtgaCtfcus4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=QkvXiaA/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="QkvXiaA/"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 0DD6D20B6F00; Sun,  1 Mar 2026 16:56:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DD6D20B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772413008;
	bh=PSw5HeOrvSVKRKKFI6Unj9OUKoIJPBRnCWIKHhtwuAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkvXiaA/6j0aTAYcHNVQ+Opg9TYCB6wNqeO9I4b6Xyspz9GiZOZ+Vf2TwjOVv+YKB
	 VuGAOy87xk7hT2mIiBJP4o0fqngCdIo4TTAdE/o1J19iVhS4O+N0PGvOL7Lvirs0dc
	 3HVKFAXRvfCXdeG1URraFJOYu54BCwUpS6lpysDk=
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
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Date: Sun,  1 Mar 2026 16:56:47 -0800
Message-ID: <20260302005647.182416-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
References: <20260228180001.1567994-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.12.75-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
