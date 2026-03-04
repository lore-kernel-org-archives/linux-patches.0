Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F2F37F8DE
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 06:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772604740; cv=none; b=QmvobUFsCZzJ7srRn3OsY9Pv1rRy6k7XaUmEe7FlD5UfFtL7BTcYDkRMQHIrtH8VFZrCd69UQboVnFAUmjtHehyOCPul0w3T4K9LrHGP5pUcOoOXRb4a0QykZEDeEthXSoV3fSY1ifvj8ufjW2jU+V6XeBzIiuE/1Sd9vPZW5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772604740; c=relaxed/simple;
	bh=pO9Ib0ItAfFUn8RtO59Mf4wqvzSIBMH6HSmli4NBDis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRdaEVegsxlpvGWfvJqcS8zWaqc1397Tnz0FdNANtjp6/u7rG5qkluTchtd2q+zFcBhfm7Va9ziHXfeq2gx2WMYB/2k8c6U8Ke+2IP7eSPYrK90SlYlW0mKhDyO3eY/ZB5W9kc5StrQfRhYs1z10wtwzVrctnnZFsWulN4oGUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lNETZ7r9; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lNETZ7r9"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 5834120B6F02; Tue,  3 Mar 2026 22:12:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5834120B6F02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1772604739;
	bh=pO9Ib0ItAfFUn8RtO59Mf4wqvzSIBMH6HSmli4NBDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNETZ7r9ByGKkL8gtnQnKrs3yPUqa7rOeixZcfCyEme3ka0BQ9CohHIJUBrokyzKM
	 QJOQq2KmQJMAifykF9/nvzQFx/1fBZmEVHgSiExUpWwHhJNfPldLdHC8sdOp9/ELRE
	 CZg14HscXLUFMa7PWfgynPTT/TT9YeerHN3QZb5E=
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
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Date: Tue,  3 Mar 2026 22:12:18 -0800
Message-ID: <20260304061218.350205-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
References: <20260302160955.2522727-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v5.15.202-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
