Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F622E7166
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761110326; cv=none; b=BgNIXPeCz5Ok/+Nm3RXl5HgJHcJH4u4sJ6VVaN4kkxOJc9812kZERbS0w1w2bN0wR9CjwFLAV2WrJloRY2q2OGZ1GfnCF6VJgP8lx/Q7u2QWlzKsMu/MOsHU99DzGLCT021+jZHocEAoVBYDRFxyjVp447fptV7/V7rdVlIuTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761110326; c=relaxed/simple;
	bh=GFrpW2dy+w/py2zGxbu0iJ4pUjfgjuKFg0bx6eOUyq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=XFbuFqyppVOVAmX9RVp1skooRf716Nt58uyVzV1n94FRiKlWo63v1L+sEWqsOaTBlKCRTcEqf70dWuFI1X1sE9R0Lf+PYOfbMaqZEEgdz4qNBN0LcWS/MuFBnkBdpJRyL7TAVudg3en4hDAnrvO/T604kqQQTFaDee38VGq1qwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=pRrGvP3B; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="pRrGvP3B"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id D299D201DAEA; Tue, 21 Oct 2025 22:18:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D299D201DAEA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1761110322;
	bh=GFrpW2dy+w/py2zGxbu0iJ4pUjfgjuKFg0bx6eOUyq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRrGvP3Bqjb7Gj61ehSUiwBfxpsf83tcqYBLkTdqEEjmJ08ocJB4wmCUdDXOTTmoX
	 cBSGBEw3AgpPIMHlnbEbp7UEFuNl7gxtlJ5mpDiY2ugbde3t9MiEHKWSfnEYH3Huv/
	 xLyrnZLy2iR7p4kfM/B6NfC0o1huJuqVtesfH/o8=
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
Date: Tue, 21 Oct 2025 22:18:42 -0700
Message-Id: <1761110322-25322-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.114-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
