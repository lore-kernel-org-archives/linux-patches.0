Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A152ED87F
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803457; cv=none; b=HP2pspqYCSWP9y/Sn+Q8GNWL94qeylg7PUwSL64+QZJmEdLyV3+9Q1vFroFBGxkDGtRh3sdP0bMpZnf633NwIDGc0RXO4gvHO/T9Xqzq8VNhTFySBDPNF75zJvP/6L+gbyZUwP2b2JNLK0NNyV9W8XHnMp3yqu8j6OBdsvdPRCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803457; c=relaxed/simple;
	bh=bqoeSjyDSgFKSb5xLjZ+3bO9otOrc1oZhzHYzXuPV+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=o9XyZFOmoFfdAu4g4TRoq2gVv9STysLvHulu1jFfUSmNu+eFRDE/hzq2e6eXk8GvqpJcCo/T3uM8OZrRhYqA24xHKBpdz8vR35fhUBEnV/qo6U2M5+aMd1c7ZN/t5jvOtHXM/A/h5ypw1Uu3SoPrUJZ3phQNIVkwM2pp/y8PzrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CSx2WkCr; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CSx2WkCr"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7E8132120E8B; Wed,  3 Dec 2025 15:10:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E8132120E8B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764803455;
	bh=bqoeSjyDSgFKSb5xLjZ+3bO9otOrc1oZhzHYzXuPV+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSx2WkCrYuI+h3pTiCFwWv9X18OrojiRndOGFEPmU07x0eA0dseBn6cdjnIAHOxvE
	 p2EvZkYhPtmq+suml/OSw490L8ND26pXlqxX7hXL01bEcS2bF7DJ7hmeOC6HUcm9WQ
	 2l8SrGEJnfnXsU0uvCNJGqtdeQA0AGc1y8vZ4oTA=
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
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
Date: Wed,  3 Dec 2025 15:10:55 -0800
Message-Id: <1764803455-19133-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.159-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
