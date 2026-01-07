Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0EF23164BB
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 20:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767818599; cv=none; b=YJ4FdMSJ0HbMuvUAqWtVHh8BsZssZj+ydR6VDfEjmgvF2UE+Wm4JNxUbq04aPl6Hib0vO8qfjFk9mZtHrWtuyoOb77p5RhpYSHhkWjtu2YnqlWrnO2fX5HWn3/Pb+ux6OtyP68xhNHAZcUqG+fU226OwKzPySa7vFi8OBYzbAvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767818599; c=relaxed/simple;
	bh=v+FVPrY3yViGGtAEU8jHZ8IZ3FYwjW3ZGcALiC/KuVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Kuehb0uGlKdzuTkRUbFW4oVZksOPUsktLgfN2/Iaym+VNWMenNynVutM5v6UuCJm22LEAgHh1N+Ekn4PBMRFun84/JflAoljU5YPKwTT+bRTWNtWYSKu+V+vSTruYIFc501KcFdk1vzDzFqyJDvuOkBc0mvuUatCmzmF907bdok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WKFOl0+1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WKFOl0+1"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8E2CB21244C8; Wed,  7 Jan 2026 12:43:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8E2CB21244C8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1767818597;
	bh=v+FVPrY3yViGGtAEU8jHZ8IZ3FYwjW3ZGcALiC/KuVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKFOl0+1l27FcIfsw3nzJfbcD0Sc/CIvnlOZGdCpN/NETn9WCTUe5sjC/gq3npJ7+
	 40qzvrrfjp79MDia0aK0rY56RR5c1n5/m/n+3kirZVl4NJF0kuv9YR8zl3//omM5rf
	 Cm1VfoXWtwBHAUkenKHi5pbkMniIvNMemZ58Ccqg=
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Date: Wed,  7 Jan 2026 12:43:17 -0800
Message-Id: <1767818597-14048-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.64-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
