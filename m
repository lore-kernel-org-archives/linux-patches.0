Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3488339856
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670476; cv=none; b=Zl5FEKyeE6B1SqoyfhsBiyGw6JTTLVO4sNKnYmwdZiCQJ9EOhlgnDPj0ggzj0zqe+6IwObnaKshRur7qYrEsX9wwgwkzbxZQOFx6lbtdsNySp3vbyhu1jUUAEPjeBcAB8U1+5ODK/6E5cSj9rK8vrgZcaiYz4tVyuIPiGp36NJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670476; c=relaxed/simple;
	bh=+Xh6abvJ4ZsOo0ZMiT0/ttKSi1QTdyNuVkOUe+3rhjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAtrx7KC8uCgfrScgVLJS69MxcteofJrJkZTJh4l69U262v6NrDuhbKcJAs75wxU2WH8Rqwk49cOWeH9Ru0cnyVbYsbgtoIF/ILvd4bZz/0AQKvJAJzy5Byzl2h23RP4wegVYa3L8Fkbhz8eRKjBDVDgpxHcnpO7dy6R6uzkQiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ieqollNQ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ieqollNQ"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id DE2E320B7167; Mon,  9 Feb 2026 12:54:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DE2E320B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770670473;
	bh=+Xh6abvJ4ZsOo0ZMiT0/ttKSi1QTdyNuVkOUe+3rhjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ieqollNQ4xCr8s6b1i+x2s1nyJ4isb+C5halxFdyzcOC4zFBJ79Xj7S26iNtgF/S5
	 qR+ijINGZIbh/oHukMh117lXdQw6X1IQT13lDWf0UiIU2eI45htEbyl2k9+YHA3dRD
	 rtv4iOxVJih18AD6Mvuw+uuhJ39z5nOKDqZd9QYE=
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
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
Date: Mon,  9 Feb 2026 12:54:32 -0800
Message-ID: <20260209205432.1216109-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.18.10-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
