Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2601C8EB
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412525; cv=none; b=gFGtE8GU2b5Y5xgjsn0iuRbiUKHd2FQiN4B61UbeJrrlLy/lMtxx8I/ElllrOtSddMeYeMb5Bf0tEUNLihyhL4KAt7UvWxA6chYxlfGXQmxphCoV0i7lO90rwf1APIazA+TQjBN6haTI2rw9fNdIbloTmWrK7aS804xh2mOW61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412525; c=relaxed/simple;
	bh=BR1O1he6PPCMO8FScHiunGasIstkotycKge37INNBcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6rfaEbPsWBtPVmgPqZOZf247cvr5ZQADzb6mag9p/o7IVIy0IwbmrDntEaP/paUuR+4/Qf5GwDfa0/aCdFZ9lyugMXTt97eZHp0DvV3kdfmtuqP5TSaBq0TnHB2oMBoSvd71VAowKsKfimRl49clAgAmZRmgo1ME5GIKYyiKdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MIe8Fl9p; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MIe8Fl9p"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id A602720B6F00; Sun,  1 Mar 2026 16:48:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A602720B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772412524;
	bh=BR1O1he6PPCMO8FScHiunGasIstkotycKge37INNBcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIe8Fl9paepaG8TviAGcYVf1uNVjLsux5QUUFSBe4KGoEAacpn7oQ4wifB54+dNGy
	 6VlCg/SAm2k4d7cCp/2NAdBMxerboCVAguDvnxJjbe88qgPJHJFN1it8bB+eqW8JyS
	 QQi2CLfdHbDLpQv5FdKhvQAObjQcjlp6hWb0oYew=
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
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
Date: Sun,  1 Mar 2026 16:48:43 -0800
Message-ID: <20260302004843.182026-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
References: <20260228180659.1583364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.6.128-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
