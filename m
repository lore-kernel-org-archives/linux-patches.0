Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE941DFD8D
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734107646; cv=none; b=CPhaboT+fT0tdBt7aCkF1hp+coX3ilaYFCyBLRfWnTISc4gUoXdkEy6/mybFe+/QfCXckzdJnGtCNHeFlC3ZRZ81XuP9zlq9aZQEJ8t53K8XsCqG+muElgGle2jgOg55Yhal26fCEEtDemwqnH7JVG7sD6tbzKdCTQGPi9ZE9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734107646; c=relaxed/simple;
	bh=1Ef5wJsPdtoNUYRCxMaw2f65Z3IqNmiRmVmgTc8URWA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=KhWkdHV1E27fpudD0olETo/PQdh0F0lRX15aHdJbWh35Micm7rA/0LrNt0HpShjva8ZKIdRfs01X27i5Z6O10eQiMW0zo3c3b9NeAFtxk2SRHVqDWZvupIIJl1k55NVPnqytDGvz+KD3WAJvOkGI605rZ8HssOUCVIWOmafa2po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=P38YC/uw; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="P38YC/uw"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 91A2C20BCAD0; Fri, 13 Dec 2024 08:34:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 91A2C20BCAD0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734107644;
	bh=1Ef5wJsPdtoNUYRCxMaw2f65Z3IqNmiRmVmgTc8URWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P38YC/uwa7jg9zMqzCcWGSfpmjGvWFSxOaPs08tS5mAcYaJyrnT8pyrgSUSJzjUYY
	 xRxGZ9TKJm8Gi4FoEd7nKa4/W/maaHJMn+g7NAlmR1IqFA07H9O9cSBChoxzB/zFit
	 nJ4N4fI0FUVzl7LZgiADHsyp08QosvQNbJvcM6d8=
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
Subject: Re: [PATCH 6.6] 6.6.66-rc1 review
Date: Fri, 13 Dec 2024 08:34:04 -0800
Message-Id: <1734107644-30986-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.6.66-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
