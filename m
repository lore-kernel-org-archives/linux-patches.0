Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F69307AE0
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757440136; cv=none; b=H7rU9TrLYYFlnUcvoYLlm5GPfbqd7vw7wpdqpLNIlWg0dYdP/yfW20dPZITJcID/AVvU08cQtETE2YRn9YLQkfUo2yiEQCtNQ899QIq6RGxPIgOYVUn5TzZgrl0oO/PyXhMvLRQj8ny5qz9EpggHpVOHDZePUGH9aCf8M+dBGgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757440136; c=relaxed/simple;
	bh=HXQhWtuEecKNJ1jLqq8OlzqmkH1O+LQX/OpFaicZzSE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=o3yzNFEt33/z62AxttMeMgj/PTmbPj80NzP/whi17JB1ELdwzDCkrBVxgYNdQZPFXb+DBasbCuzwCHC1/NLOeaaGp0EDQBwKq7AXbAuZ63s+82X0qSDnynNIx12sWSUVSYLGAjlBFJ3XyUk8+cKqGBe3GDyj+mTIAb/ipMTbBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=PNfwpsID; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PNfwpsID"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id A3CC721199D0; Tue,  9 Sep 2025 10:48:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A3CC721199D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1757440134;
	bh=HXQhWtuEecKNJ1jLqq8OlzqmkH1O+LQX/OpFaicZzSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNfwpsIDVquO+eEnJ5nmQI1xsZitBqSIXm2VUvbUT5gvJ3Yqbq3txldzAREGRD/BW
	 MoN4QmndYoI4MIOGllNwMowdQnWuQv8xyIgkojyf8McANZVKxc+AhaZGtOSGuCu+bp
	 VCLbjJS8681/lM6BZsZASsNTLoLAMyYA3yNdG0Is=
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
Date: Tue,  9 Sep 2025 10:48:54 -0700
Message-Id: <1757440134-17880-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.16.6-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
