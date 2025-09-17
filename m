Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EE334BA59
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758132553; cv=none; b=X+kofC4NREzYNJ5GplIB57vuuLrhtm5OvVL9WaYUYTntHtpsnU3h7ygzLYOWJcmzOMWPLM4ufsUHfy1Bk4/Dpl33qP6dT7R0AwKz19wexOXmUIeV93T0yMfVK6ozEibC4zLTU6qedhGVj3r0tsrPbNGk+7KuJ87HeGeUFVwfYaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758132553; c=relaxed/simple;
	bh=A/g6yV8OwHRMixXofvXoksUXU4c9BCDZkHauOGy8f90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=BYSAAiXD4zoWqW8lYit0QklqHHvpTB3hkKd7jyzhg/kBQIu5OALqCOmvkhCK8yiEcmjGCpXeSvPHDerBC35VKm7uOZxgy4Nxul3x0L70IczGJAlIzF/BridK2MeKiWTRd+rxsyuBiPEjWXAc8cvCNnHotwBeCxiAsVTwIzpTsBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Woj+43d4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Woj+43d4"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 88A34211AF09; Wed, 17 Sep 2025 11:09:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 88A34211AF09
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1758132551;
	bh=A/g6yV8OwHRMixXofvXoksUXU4c9BCDZkHauOGy8f90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Woj+43d44IRh35lM/EUdlNyy6kOv2+FP755dsMbAQlIWyCZnjYxBvIPhAPdnrpNMB
	 ofX0bXLVydNIC/9/9Hd73X3BlJXVygWH2BK2U8nHXpEs2vrVR8aS30jXZm2TM0rbgk
	 z2bfRqEThdNWjGNlEvdaRJH+cG0Xq+7LBswZfCHY=
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
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
Date: Wed, 17 Sep 2025 11:09:11 -0700
Message-Id: <1758132551-18432-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.16.8-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
