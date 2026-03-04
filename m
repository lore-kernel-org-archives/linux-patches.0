Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C74541F4CA9
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 06:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772605007; cv=none; b=jSSO/nPlInN+I9yzOOuHLeEn2B5vVBO3cZBK6MmybOBxwv+TsoACuY8i04K6S4m86K2JKQmaN+yx6y5s/tOT7Iz7UZMYVxPQl0iBOG5ODvoDJipU08SXY4aFqj+bjakVCZ5+zcerH9jTENRNzlcVW63c6oOQKUE9cyzm1vPOilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772605007; c=relaxed/simple;
	bh=X1hrlUuZ3eh4bJ4kULtEVHQb375X0fIwOA8HrbpS2/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/5z7dJ/BQBeEAKTkY3ApfyB9ZndQtg5VgBzjGXRKKi9Teu7YkqCCudMpgp7JXAokoIaNyscE5x+mEGkc0RGQPrYcj1zchiylYe8SW1YPu8qtuHzd2M8a7DNuUAvR8LO/4mjvn3pYpxzfl+EFpXfCL8IIu23FcjWaxauQ0g8cic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WtdsgiYH; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WtdsgiYH"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 80D3020B6F02; Tue,  3 Mar 2026 22:16:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 80D3020B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772605006;
	bh=X1hrlUuZ3eh4bJ4kULtEVHQb375X0fIwOA8HrbpS2/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtdsgiYHA2i9oQJxMCxV9ifTyMlWfwFpUw8l/Zo5WmGQAYzi7+JPJzYd4j1m0LWKJ
	 yeM0xdPu4NAAwkzSdunL+m+ayTLgBU04SNVZlwR9nV0maa6yOuMbuNVsxYZyp33y3J
	 H3oZeQEJLnPBfoouXnbxDlWNzk6+jqbfsLGb1YC4=
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
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Date: Tue,  3 Mar 2026 22:16:38 -0800
Message-ID: <20260304061638.350439-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.12.75-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
