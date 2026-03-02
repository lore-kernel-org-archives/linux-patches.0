Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1455022B5AC
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412327; cv=none; b=uB27ruc3HxunPxa3+1owTZsKtU4ckgTrJf7vISxd27LVf4MH+Z0c6eEAMH2CrOFHDRPVaOVxv8c4AoKKz1zIkz5F5fNX5SqgPDQFOPD6H28XSoGvVvz292e9auHbcyzs5c0N86js1Vh08pONiwKhu4FSavqD8ZkvxYKzMz9Z5mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412327; c=relaxed/simple;
	bh=kN020dNgNZd1iMeEXELmhmNDL04fj45aGELEMRCDYV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ09fGx9JbG28OKIyBFlalvt2lcKeMxHTzaf/a3FYusrqs0fQUMqe88B6FeQMe1Cna3YlikjZibjVBjB9YMjYgQ4T0ZjPLcBGlA99ugorgicwdpnnGkNHOSvPNqWblp8PguuApvcRL4AU+Qe17GzoSU5MrTXkSxXZepeiV6Q0ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nTyy7kIh; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nTyy7kIh"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C6CB220B6F00; Sun,  1 Mar 2026 16:45:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C6CB220B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772412325;
	bh=kN020dNgNZd1iMeEXELmhmNDL04fj45aGELEMRCDYV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTyy7kIheX1LNztwBoafy+UW5CL/wrPiZXJZ10n8x+YUxB0aqS2iT+fLXbyC17wKf
	 OHNO4dmTfC93g6GrjBL7nhdYqn1txMfGJVHXi/zpQNtQm56OFLE7Tgq9+vnJDni8ma
	 y+iekbsdRrfBKXoUa0Ys0Ezbizf3avSiKHzK+mhI=
From: Hardik Garg <hargar@linux.microsoft.com>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
Date: Sun,  1 Mar 2026 16:45:25 -0800
Message-ID: <20260302004525.181909-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
References: <20260228181119.1592516-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.1.165-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
