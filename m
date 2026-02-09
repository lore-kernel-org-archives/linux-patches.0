Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F8D217F31
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670407; cv=none; b=mBqTLUYcm/gSXrIIrSTHPXX0tf/r/rzY9ifcj/2RDWIe/UBYawjOTb0hgh9GRjZ4VPq6fqdTQGZCAPEyJpr3qjmPCsY81fIL7jTXNH7xWH3WKgZicHcs6bs2+c5NhvCoZ0hR1rh/v725akuTgTCP0CajeBlgRKKbo9E3uv1N3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670407; c=relaxed/simple;
	bh=xURu2Rz+v6jTL6BOahSn4AzbIM9sHZJvyxXLtRkHAUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8tPVgWvV9hUDD9Q675h2gGYUiiUHWo2wS036NPyWWvckyTCI424Xzhz+w/db78QvkbmlzAiJ+0Z0gizGU3pIetVntTMLkHQvTwIOfbO+VWewUz/Wat2f/hnCHVaZMrJrj2h2X+GThHklYqy9EYfZdoTmeqNmXDaFIdrAz2pI04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bjr82Oqx; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bjr82Oqx"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 2138420B7167; Mon,  9 Feb 2026 12:53:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2138420B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770670406;
	bh=xURu2Rz+v6jTL6BOahSn4AzbIM9sHZJvyxXLtRkHAUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjr82OqxBI1gQQb0lPWDaM84P1FbmPaeuSlnSCIawbKZrNMuVhQsThLU3NogXLwcd
	 FYklfXoRlwGJuDWndrm/OWe0LncYBQzxUVf730G8Dgm0uVW1Iwxfeuv2S8heZNZ1OB
	 uwvJHUtG2TdG1MpGfq+XRiNvQmryJVLr/f+iZ4Mc=
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
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
Date: Mon,  9 Feb 2026 12:53:24 -0800
Message-ID: <20260209205324.1216044-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.12.70-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
