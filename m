Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C5E8F58
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 03:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753328973; cv=none; b=Q0Jdr9zDDUz2e9g3YkXJbvoH5b81ah/wcBm5XYONp0qalOT9l7OA6ZQJG6L2GMWrE7tgoDI281hedHBkkOEHva8us+TpY1n8/+S8QcGSC4m/cmqUdBCLeV7jfo74231KwA965U2LLo6JthcfyaenU2yDwOcunPesBbskmyGbr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753328973; c=relaxed/simple;
	bh=pDeP7F16BsjwmoeJizrbHOuK68cJqCQBom5tiGPDMIE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=BmMuwRFiiI4/497y1438I8/uytHRmQloNajpY8hv1owFGHkIqCv1d06uB/N2Epf88FeOWc2NU8h8Xm6hCOC6Xs4hhFMCvnEvp3CeQN3lOTrMoAVXuw/tN+nl7u/9/XngY2eBRF5069nmkqB6xqqB8TLWVROGajXLu37/U/yIq8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dJnVBTvp; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dJnVBTvp"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 92E7E2120394; Wed, 23 Jul 2025 20:49:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 92E7E2120394
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1753328971;
	bh=pDeP7F16BsjwmoeJizrbHOuK68cJqCQBom5tiGPDMIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJnVBTvpF4otbsUNFIABaJpLQpxPsUoJzbtILBp4WHlkECnW9D9nk5DMKoOf6xaPV
	 Cg4k3GKGccNISrjzW/WvItxOvrmzU3LzDmLzYgrLAbiVTQXwWIZScOuSD9aGFMe6vX
	 m2hT/6LsUIypS13q8NOOX6H22R1puFj8ATgJXJwI=
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
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Date: Wed, 23 Jul 2025 20:49:31 -0700
Message-Id: <1753328971-17760-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.12.40-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
