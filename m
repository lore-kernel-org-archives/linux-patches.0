Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219E832C950
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765399410; cv=none; b=Qn2Y7pbtZsYlBV4zjI9kLmwiiW67+7WEQCa3L+/JjJX92Yh9pPnLJvFrK5kz7zoz+y3niRmupVXPQahLlbRToleq0Kz/aJM0eDaEtdQBHUUzN3X3T0iunKIWgZS0iLXKRSQRtGB/1tw4+9Ilv7P+xbJs5mncI21MSb2FQydgm9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765399410; c=relaxed/simple;
	bh=KWOsoxWn6i4p7fdNH+WlLyJASgKrzXDJc1A6cetki78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=L36cvgE5gT1fv6Wi2DVFmfcYxEW8uwVxcP0dhBjHf39RZJlSrBCju77WnH4/bMm2qq1Jy17BuUCj/tTtyy2azZcK+EHPTSfP8yjeAoaPXCsWk7ams/6jO5+8b2YRI4/gS+GuTciFxqAgPw00d5uonpu6WZHHpKfLFNlkUivwqSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Auwu/KLT; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Auwu/KLT"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id BA0D0201D7EE; Wed, 10 Dec 2025 12:43:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BA0D0201D7EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765399408;
	bh=KWOsoxWn6i4p7fdNH+WlLyJASgKrzXDJc1A6cetki78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Auwu/KLTJCOr1iXFbEK/mZFina2cwPJSgZlSkGy9/3ny0MFGw0EFATHumwjQsnDDx
	 eWF8uvfIV6WNw/BdJJBruwp0mb/1icaA6zlrtIu5oRJKBLuYU8/3f7XoNza89QeC3E
	 euh8Dmu3gINC94f+71nOn193Ssnb/uYjt/aw9tR8=
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
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
Date: Wed, 10 Dec 2025 12:43:28 -0800
Message-Id: <1765399408-4403-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.18.1-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
