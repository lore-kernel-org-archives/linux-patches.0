Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9955E3085D7
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750269738; cv=none; b=PeX/jbavFj9Xcp7cNKFVuw3+HBCFRd8Dc/Vus0cDHTd9k7orDARyE0m5wommf0liXwDBTrMfucirq8H7Kx5miej3sVZ5cW99D0b22C75d9+DvXMiVIHmBcgwp+7mkMhsQqEjCNIDTw+T49JiNtZNG+Upv/ya467IEpV5UMynrmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750269738; c=relaxed/simple;
	bh=J8qm0KIxvDABeFAbOTa/JmNQ+sdVdGPfkXdpFFrTCSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Z1pcF7eLbrump+dZ63YmXhQyB9JdLDk19mrkoaiWPc+izS8mW6qVYP+/tYWi8kBNuakwluX5yVG3RdnI9M3G21JmA8lKP++z5vS9MZuUk6bWjR2E20x0MspnfgPPmfI2/bzeEmwI1unBXqoh0G939bBGB0aG0V2XmqBHJkpz6CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iDcLV6/O; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iDcLV6/O"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 0610121176FA; Wed, 18 Jun 2025 11:02:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0610121176FA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1750269737;
	bh=rDfd80+cYWJKoaG2bdjZmVVVUOstotsIHopxHl0Sj7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDcLV6/OXfTwiOotVSGp4N8AG/KR/W1MlD4d0ojyOJtcT5YW2ZlDBt4CZvAfQ1te5
	 SvnkJQH7xrQM8ZWY21norqL+edXNp8+EoDhBjleG6WnmgPksektoCWB2RSepWAg6bW
	 ESG4U/kLrM2Iip8FXtH0/HL2lftQZshU9gAtpkS4=
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
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
Date: Wed, 18 Jun 2025 11:02:16 -0700
Message-Id: <1750269736-29190-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.12.34-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
29860466  17729102  6385664  53975232  33798c0  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
36428814  15006645  1052880  52488339  320e893  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
