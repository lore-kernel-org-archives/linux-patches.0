Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9E3331A6E
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670149; cv=none; b=F3EpB0JbbxfLqTBGYmT/9EYboTXACL1t6lr9aDe41QOtZI8YBycEVgO0r4SxTrLk3x3E6T5Gj8rlrH2NQx9zx3XhhgI1XQgeOhckzENHSaVsDQAXFrYPuje9+CUVkkp8zOISavnx5GcfwASglr1YO5xw6twz6mIT5B13vlpzUpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670149; c=relaxed/simple;
	bh=w6N+23p4TjA/JKiGf8dwSJbqMKnmOvwr0sZIMbB8PJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsFQJ2G87fo9YojfFeZguZ+hYrWoqrxrcc+iiMnGDXIkcKV31QIi9VGY8vkYzNYMaHgRP5uwvmod6T4UopTZVU7BGCBfgZJaEwRrdPiQoj1vICMpBmGN/m9NN/RHBOsYb5Wb424oDTnnn5K1deyxjMaEQ3ThLQonsrtM0J4sxUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qAPbbb+u; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qAPbbb+u"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 0979820B7167; Mon,  9 Feb 2026 12:49:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0979820B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770670148;
	bh=w6N+23p4TjA/JKiGf8dwSJbqMKnmOvwr0sZIMbB8PJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAPbbb+u8ceEkkZKBT36nYLjnftfCzzprlC5GwaacdNv1Ply82yntnRthJdMS56RK
	 nB3Us4tTBPYrpILubGYP20qyUpPBoekDuY7fMME5iAbyI7GJ8Uvutc8p0w60Yo1X02
	 rjgrVzLF1Xbc3+iuIDyX6+vGYX9vwv0SLpDBF7C8=
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
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
Date: Mon,  9 Feb 2026 12:49:06 -0800
Message-ID: <20260209204906.1215862-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.1.163-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
