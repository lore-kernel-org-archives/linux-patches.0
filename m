Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EB44D8CE
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 20:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765399209; cv=none; b=uedH8Y9fDpbX6qlJYDo30L0s8EJ1dOxwsaFZa6BCumKAq+BhefU00m8RUZk7ivko3aoZTATqBT9o4mCzeq0GRfA4ov6CcZKHik5OjXlibhbBjcbB1A+Mhx34HBR6ksm44n5E1pVt0TT+TKgkFPbWhFi3jNF5yOBSFW26UR9b9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765399209; c=relaxed/simple;
	bh=O9lAxXs+y4Osn4icivYB/sxvGkBePGWMQ0pzj7mHYVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=EC3lsvX9i3YtOLZuvX+4UIqk2/2fkqiU4k4y9zTMVFiWfFwRTexhnxsW/qdojRKSGjJv1vUbEhOx2D1qoQg5xUXTWkRWFNXIzf1rm29dwZ6l/B75LK8cGYXctoJUzoTfsf4P7mzKW2x23ARlgfeItv9MQpg71ySdZWWD2BLzGFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CtvM+h0a; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CtvM+h0a"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 4FF16201D812; Wed, 10 Dec 2025 12:40:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4FF16201D812
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1765399207;
	bh=O9lAxXs+y4Osn4icivYB/sxvGkBePGWMQ0pzj7mHYVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtvM+h0aeJ77qw/dw1yaa8VOwzn0cS9cYjtvb9KJkq+hmyM1Da627gIGV5SFYRlps
	 4TKr7ISEE5YwA23DU24CtrC6hRhy22WJe6kVut+eHeWXl/iYi36XYeuk96VtXu7t2J
	 UObgPg8QYPwpK3yqDrEAeQxMMzto0avkeWwHDeQQ=
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
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
Date: Wed, 10 Dec 2025 12:40:07 -0800
Message-Id: <1765399207-3774-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.62-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
