Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA612EBB8F
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803639; cv=none; b=WRPXNkwDvGyO0qmMkZnXXm287joy/UnAFecHMZ2/A85juj1rBhTHjnyW1KXoAI7DF7x+O2wsxTENU820aBpttmnW6yE+JUinfpDZ8DdnzUD1NEUcfPqQaBJMlfeFT9qGMZ/ainqUW8090dt3LaR5JEZg2UkWObtvEKW9C2Zvzeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803639; c=relaxed/simple;
	bh=x22OYxAyQCg2/fTNwkq0tSM4TnF8ZIF7XWk3PrRG6Dk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=D+BY9fE7+BnF4zfrfQmotVhUJQvRVB7qvOHrMhUxkUYxdfZzRx5FhoCwY8BM4UcbuK05jX8uERKz+poq3eUWdpQm1NL/eC7Z7kWvNIvM54GvZSVaW1aHT6ox+YtdMhjiN7C+dUHZ5ZCCXf6YO/fR91PBI7HbHWASIZw6THT8rn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=U76azCqh; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="U76azCqh"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7E9312120E87; Wed,  3 Dec 2025 15:13:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E9312120E87
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764803637;
	bh=x22OYxAyQCg2/fTNwkq0tSM4TnF8ZIF7XWk3PrRG6Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U76azCqhKepcwwSRh8TqAPdNAWMRUjOM4mgkuZEAh8HlAKIiRMiRMAcBPZHXBwl9N
	 IuhZBlpjNiMMyijL83Ro4fj428YsT9z0mZAyJxHw6EvZ7dIDRfghFRtZw7RpEVAk+a
	 b59KoGzazQZ8qq6lAheBLs7FH9onxM+2GPJtqjoc=
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
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
Date: Wed,  3 Dec 2025 15:13:57 -0800
Message-Id: <1764803637-19878-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.61-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
