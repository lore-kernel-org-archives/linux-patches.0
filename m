Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C432AE8D
	for <patches@lists.linux.dev>; Fri, 17 Jan 2025 02:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080704; cv=none; b=oLqBrXZW4DgNyc0psynG68sAgGHcEmFIam4zbRm/RJ2gxqOmnc+76qIiCIoRS9sUNa6qiV3VR8/urTg4A3x9bSw1kKj+h1OyTIpAP+z4TQw1paZZw+JpPQHgTAmGdPYm6+OYx7SOc7uUk5MWNBfV8cuvhcNYyy2r46qrkhWwXCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080704; c=relaxed/simple;
	bh=K66+KBx0lgtFW+ZOCmttgm95Hz1kk6u/sIgx91pWfQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=PiPUP8oFoHNWI38ViUEiOiX49A71wsTKsXDcCHWQ1m3zPWwc/URA7iN6V3YirQTBZl8qIsEW9EOe/PQJUJOfrgrMFw1pYcM7OuUOvG5xqJB8wsB+/5ZoXs1QIJRkDmtwgVxxIaV4O/YCLjxMTm53TjSCNe/BV7LCCu4ldkV2Fb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MDIT/uIU; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MDIT/uIU"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 3221520591AA; Thu, 16 Jan 2025 18:25:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3221520591AA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737080702;
	bh=K66+KBx0lgtFW+ZOCmttgm95Hz1kk6u/sIgx91pWfQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDIT/uIUjMkmQFNj8iWCBwmJgnL1i4x71GzljdXVv6Bju7VT21kr0yBYf0rYnzcTc
	 ETcO1vibmY/I7hUhbYYVAI7pT8DtjYYgFUje3w1VHkva/VbJxrkTblPayLdqbg/ReJ
	 h5ACweBO2TkCoMy3t0HVkphtKA7DXevHIphqXnlI=
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
Subject: Re: [PATCH 6.1] 6.1.125-rc1 review
Date: Thu, 16 Jan 2025 18:25:02 -0800
Message-Id: <1737080702-23479-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.1.125-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
