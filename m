Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CD02FC037
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768591556; cv=none; b=HcYg4Q22pFQmUCeb3dDyJOvVYDq20xXfbIPshbVt4HnK2AUMYxn80uj9gK0pS3UuyHaqBO+t/ApHP1MIP4T2iNC81I826CobC9326PtJ8GcETOfoJXoTRCV/R8652bdP3iIu3VXVjMpGvW+kjdjluLmI9vCxjRd/XPszNpXvEq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768591556; c=relaxed/simple;
	bh=UWbOGds+A+X21mOfisbJzSWtLaU4PqS4SoFhmzJiBMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDQ7W6VyLhw7bfU2Lz4XD77UIy1Gnh6UrVVpx7jyHi010sHoN+jwoL+iGZVxgiusQ2raMii4XOsD/WDFgV4A++golEQH/BC+2rzwKxLsFmabpye2ZXJl7BLN8BQKmhS1slPjFBhVEcMk9D0ElQE9+eCIpuB0Qjz2W5OfYEvFTpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=R4jktjhg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="R4jktjhg"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id DFE5720B7165; Fri, 16 Jan 2026 11:25:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DFE5720B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768591548;
	bh=UWbOGds+A+X21mOfisbJzSWtLaU4PqS4SoFhmzJiBMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4jktjhgrvKrQtQSXxOid9RosZJacYEmfvU6O17Cpy1YaCxUxS2qXuDwxeZIKJfyJ
	 CR19udujHaJvX9JpJsxg3bgDSwPblNoT3ikMPa3EhpppIBu6GgPYI04Qyo9f+7LzuC
	 h1E7gTfXzHZbr72Q9rmwBDAKyGtJcpTMO9fZJuIQ=
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
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
Date: Fri, 16 Jan 2026 11:25:47 -0800
Message-ID: <20260116192547.280044-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260116111040.672107150@linuxfoundation.org>
References: <20260116111040.672107150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for v5.15.198-rc2
on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
