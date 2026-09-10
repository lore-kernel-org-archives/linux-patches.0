Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961F331E846
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789043184; cv=none; b=utUXFL4R2zlv127xEnGUdxCQz76H2mA/AaSiHbFoovXvchCEVEaV7bPQEat6R56p6L7hViEGQJmb5WfDctZvz4gzvtShC0aSYx7YFsUOgp7Bbnc+u/XtuxWRpNO87UR8hGGTCRlxoRd7+ey4CTGTCTjHBnlZq86AwEKh1govMy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789043184; c=relaxed/simple;
	bh=IwE4JaM445mvUMo2/xkQG0Y/CS/sbR5Z1WyaY2XU3XQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HVoSnQv0jIDs2jVTPXh8JICmLp9a+VtM6C1/+1vkad/o+ozx+PPQWGOWmSkXK6Jie1qoJEUqDmIlMXqW/Zp+HrJxT1DEwGU3X/67HiFJMHXL/EoJmrzMo+mf13S5DEURQSO+iUgHFEufxY0yurxjwGavDmV7ahVSzBJ603aKSHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=GSLf5dZd; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="GSLf5dZd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789043122;
	bh=IwE4JaM445mvUMo2/xkQG0Y/CS/sbR5Z1WyaY2XU3XQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=GSLf5dZdSJXtKJk0yzOvTmFYjp4ybkSVzEa8IRhHN5mwHjrZOjkmTnPbtym+ZJYaz
	 0k07V1vFXcsH5utYBu2ZTNDf5CEc1o6O4DZ0yBpXLCem43YMRwDCik5N9Hqnscnlfn
	 KX9eLMGanPGPRTIHinYB6eQ/iokY6lBtHms9+GbE=
X-QQ-mid: zesmtpsz1t1789043115td9088851
X-QQ-Originating-IP: WW1GG0+DvR5K/zxkJ6FVKn9A7L7z+jHvol7nn7XxNf0=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 10 Sep 2026 20:25:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 18235711230818459501
EX-QQ-RecipientCnt: 21
From: Wentao Guan <guanwentao@uniontech.com>
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
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
Date: Thu, 10 Sep 2026 20:23:36 +0800
Message-Id: <20260910122335.182598-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: M5AZ9zH6FprOLkqhbqUhOPABg4HPFEwP0godkBzcHScUOGMp7b0ggp7n
	5rBIW2oKEnC49jqcCBqfJRyJG1nESjS/Vsg5hDQ4LKfwefRi8TwELSeI+x/bo8D/4AFPd+U
	XAM6ksUWMJxrJKaqAFBRjdIqHUQ1qiFoBS2FzEaheTw9E6R/B3pELuC/HKrRB8FsR0eYicM
	JrwmzfC0O/BgQu0rx86tatPPBAMV7OqjKnAZHmJgi1v5edJt+Hdr28DUk4M3AlGg0uYZzW7
	GKkgtDeTPPKMxBk/eRViMe256EHidlzxzWlt7efjXkPI2eT1E+0pLgnejJ5p28mW+G4d3eJ
	vl/itgosiZwPY3p5GhOEnpal07jRSNyUx14rwEjqPp7/rhKoh4Zp0c2eO5Vo4JI5sFo30bV
	pPtHV1kFn4k9x2WT2oNPhGDDhM/jVh2m43J7IGfRZOj8v3s+MuTcIP8wutcAQ3kCBVj+JLx
	njE2NwIS3Y9IJz4RhFKVBANqYptxTAW2VjimfjNDFfkP/fXuGhmbeRNrW+K76oKvM5lISTm
	LkejFNsY+lidN2GceCraVG9v3c1s30hCSIKisDR89itTYD3f8tEcZPkhijIp2+SqOk/rfsu
	7urVOQlxOJNy/ev6r1LhouXmdc4Lca50daUF5DATGUTh3mUiTjyPHViuarelS3Dj/nJXf3M
	sW6bd7m+XQBe228AxYi3XuvR5WnuHEbk9oYZvsauYNCaEuM0zp4BRTr+vykFmFDbfawNypa
	JFxAXTSvk3HJhVlQKIBu2YD6f4W0nB5UaLILsMOvwWcrIeUOo4tMRZunuXHZRgKth7e/1Vm
	h+XZsNbycsb8Nz9yrMTjGbT7eiEdRBTqY33qywHCPEcytr3Lp1ioEfLvzRLnXh/i+sqlBIX
	vcPcvAmCS3exsPqdAVVMA1Cz4YKKASc+Z3VEpng8/FVWONxWYSSxDiL48wMgu/uEDa/Z/11
	SBom3qfc/6yNp6Do6MkWeM3NimB0MfKSGP4u8Q93IHAnE+gg8lZTCspduQZ9+EWr/PO9GUm
	Zt4v8CNrS2uGD9ne8hfIkkaxSvc//6KH7WrPsoxPH9HUIqvv+2goM1ciJA07+i2t4QbrLlL
	msQ+lDglmFj
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Build tested in our x86/arm64/loongarch config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan
