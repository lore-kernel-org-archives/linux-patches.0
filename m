Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6081AF0BB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412840; cv=none; b=jRr17/MZKUQFA/vkp9SO1QqrHKpsLNzwxxyjI2/uVQaLpG5yYN7Wy3N+vUdgx1UyCShNIaNbDRjuue0qCOC8HdSRkF2n2iarTdGtTxieqcT4YKSlJvH7wU0oeuVw84TXlMXMFFm51DMUIqdoHqVS5tak8JcBZnsarkqB6TZj2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412840; c=relaxed/simple;
	bh=5dAimY1fjAKzF/F66RG1pYA2ze4sGhCksA+0w6uOVTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/ZdOva2FwhNsswmGl9JtKtbgKMo++//E51yWPLZcv/z7CfgqbGKjdzi2Tvk5XFIQqn7P7pWcidWb6YT1PfD2WHpoiuk8GkrxpvhoYoW0++C85psoPWCieSLJq6+CHGVtZ3X0luaT6m8gYH5nh13Y192mxKfY48EGKA4zBSEirU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mrAkgiL6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mrAkgiL6"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7A05920B6F04; Sun,  1 Mar 2026 16:53:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A05920B6F04
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772412839;
	bh=5dAimY1fjAKzF/F66RG1pYA2ze4sGhCksA+0w6uOVTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrAkgiL61m6IT3WLQeJdEeeh1bDwJiewgFHBGKVu8Z7cSiXHdM2gPSmU0B4QaqrcD
	 eKKEF5D1/VLYYXzN8z87HOTZEiSGFsm/Y+yrr2itBWT8cInVZN+GL/PcUuQ4G0SOTo
	 SweFRuCOTQzcK+wKQ+pBJ8TS8S+LPqS16EtR8mpM=
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
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
Date: Sun,  1 Mar 2026 16:53:58 -0800
Message-ID: <20260302005358.182276-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
References: <20260228173244.1509663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.19.6-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
