Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBE5146A60
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735241320; cv=none; b=qVJYWqaa5H+rEnEH/0ZIxbfKwsnoG/zGatl7Dr6meQIrWwoXZuxpjlzc24yGzant5pXZPUd+uswTcm6vWa4Uhy1v0FTao2XTTOpLqhqsnduLpKLlQf11oG0So3r4OpvXung7oaJ0rD9zYq2t8nVNsFAWu3zBIZsSVfwf4kIp5Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735241320; c=relaxed/simple;
	bh=zqYKVe6i60kqrncDfNqM0FK+F4Jn2x8VTiHY91wF0D0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dlSazlrYG5hiCyBGak2zw4XdYX5tNQ5VRCpuF2fqt45pxR8Z0d3qtPXOOTo1R8/O35heEEhY6rY9TuwM1c7fDk4qJM3FcjBkNZmqRxFWauRIe2w7GsFF84rVORWrsAXv1FiECaOkJ0ODKUgPyuCnEc9FsJ1Wt9uPamSk5rFafg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=opqLCxq7; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="opqLCxq7"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 3D185203EC22; Thu, 26 Dec 2024 11:28:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3D185203EC22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1735241318;
	bh=zqYKVe6i60kqrncDfNqM0FK+F4Jn2x8VTiHY91wF0D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opqLCxq7Yj2KWh/tqo3iIcSkYmn8pj+VllNLGJEq7mSPaTMzAiEcjjzQQTszIrc8I
	 0HaakxNCSaV5xcbeB8BRWJv0w+FukbmKnB4HzG4OT8No93BntsDu5uH9HlAvMVermc
	 yAt+VjMKBp+oIbuT/uqrEZRbddYtETbpEPHr2YAo=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6] 6.6.68-rc1 review
Date: Thu, 26 Dec 2024 11:28:38 -0800
Message-Id: <1735241318-21475-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.6.68-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
