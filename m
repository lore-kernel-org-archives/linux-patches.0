Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721953939BE
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585326; cv=none; b=cCObL6Ff5N/PaqRC6sGKiEet0xNfyBuhtmxO+WPDgX9aEgxFZ0lrYB7niLg6wwhY8Wz3gyHZyQaUUtcNjlD6sMnMxuIekjiXBZmTCLQcLu5p0CRz+gSFMFns3vtqq25PdjfcSDYM57x1RBGf9qBc6IpcRvcEe9P3Ml8FIpr0cos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585326; c=relaxed/simple;
	bh=zmS0/Hv0A7vO6GqeUoRkYz8BWDYQPyKLoyEgnebY5oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjXUW4RztV3eqBxkAeGoGj/fLTqpgfolGzSxBkHjdjRW54KDALlHx8h6xVUMmjc9AQIQSKOiH/eNj5Rqk5E1KhLlqowq7/+pBwv6bLwGOIoFdbr2pAkhoxJ/pHQDlTznXmliEI6rGXoEWCJfh5ayfsKJnLoYA9lgaCAKXFH9PcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=axVmUYz2; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="axVmUYz2"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 02CAF20B7165; Fri, 16 Jan 2026 09:42:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02CAF20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768585325;
	bh=zmS0/Hv0A7vO6GqeUoRkYz8BWDYQPyKLoyEgnebY5oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axVmUYz2vZaNkeHplMc4bgjtgrMUBg8qj6xnxJYyz1td0BSFtJ/WLWd3jNnA7liD0
	 ES38BMaxm2YlST09hM/YjXnywn+VIIdq5w5hVLkhAefQyAh3YTrOFvlTfrx1BY6Q8l
	 hcpbhkSEj9xomUUzqUHbSa7/croVjWa3sb91ue3k=
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
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 5.15 000/554] 5.15.198-rc1 review
Date: Fri, 16 Jan 2026 09:38:01 -0800
Message-ID: <20260116173801.273812-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for v5.15.198-rc1
on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
