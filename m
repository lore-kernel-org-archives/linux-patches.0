Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 871392F5311
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 23:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419250; cv=none; b=TboU1nEwQjCkZDTPWvprKoD1z0YYRhb/wepFSgaBwNGKx6t5acfZfdFd3J4KvAec6EkpJurxg4ICfeyxlzLjFelT2WGBiJ0tmrEBCBqxF639PQf5cOv1IVJ+2DzzlYu9g3e6CHiaFA6AU7ZPdu0f1BOZG0OrUan4e3yE/wzvNkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419250; c=relaxed/simple;
	bh=VfkRQMPGfKBorcTBi1Ov2ZcJJ3VJmArm3raB1cCNs/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5rBBUbUQzNPEaSQlrn0MB8wsYy/Wqn0+ev92RmeQX41FP5QHSJpXqPo9Vo0TKBlZDmOWx12xJLnDn9BgWjKmcSkWM2O9ks7nTGZzd1Mg7vbPOWLQQLM36tXhtql3bXnkWVxXIUXW5tQ54PWuWz3Fm1leS1kfaYWSy802SzjEXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nJ0lzS8E; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nJ0lzS8E"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7ACEF20B7168; Fri,  6 Feb 2026 15:07:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7ACEF20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1770419250;
	bh=VfkRQMPGfKBorcTBi1Ov2ZcJJ3VJmArm3raB1cCNs/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ0lzS8EB2LmdT3ALpafa4DPNCNjZ4HmWwPxN2c3eQ19eA9MsoaN2FFyg6BH0a9+P
	 w5vyMZe7266us3fkYG59GO1LX9tHwSrvTsAyVL2M5V0IA5JyZn7f+T0EZgGKhDLye5
	 fNMtt/aj0ZihU3xRHdL2SsfW2+PSz5Hybn1IvDF0=
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
Subject: Re: [PATCH 5.15 000/203] 5.15.199-rc2 review
Date: Fri,  6 Feb 2026 15:07:28 -0800
Message-ID: <20260206230728.1016050-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260205143441.536029503@linuxfoundation.org>
References: <20260205143441.536029503@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v5.15.199-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
