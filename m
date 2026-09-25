Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DBB411A0B
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 05:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313960; cv=none; b=YTpvXWmJi1uWOTxHyXcAyZwsDXdnJLmMPSMzbPk1txGt4mxmG6pnCpV/RiYPhT43xbdeoNOMAaoS1VDzqCT7Zt5RrxqcMHt9IqSelAuaXSdpFE3gzdfBVcIZxB9wWxSbaJnQ5gNcSgZyXZC7gvIcITOqU6PiZmecSeNPKYtFVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313960; c=relaxed/simple;
	bh=r1BQkXIkWbZ3bCnsg8ygvimx8DmAW7XJnXxTFcZjgFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QcbQ5CtHGb99lPA4ZAplFKcQyRtduT0MHikpvAd8pznPj2uW9WKQanjqTUVzd7L+wMBoaULSZaCfSH74d9FyRmzRn//hNpIgH/6MXg3KSxzuQ1XCfp6xXzA4DAyCklaEmsSDOySzosJ8eWtlrarzPGRLdNNje868kzziCrJ61Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=CZS7uNtQ; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="CZS7uNtQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1790313938;
	bh=r1BQkXIkWbZ3bCnsg8ygvimx8DmAW7XJnXxTFcZjgFo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=CZS7uNtQjx9YCtrenJBXYnomOTjDeO0tgHgphVauVfyAiU16UyfpTe58OsznrLu/Z
	 3v8DjiX7RNGxWvstqpy62U65z675DuOshLzURufcFyxsSj/m1LAeSzXiOHHeQrnw4i
	 hMcUoGr0Szf6wvF/vMJHIRpweax9aEBfnd7u50rY=
X-QQ-mid: zesmtpgz3t1790313932t3d2c31a8
X-QQ-Originating-IP: AQ9TsJFseA5fWONHRQxu3z2bCzD1e6Uq+YSaWr9BV0Y=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 25 Sep 2026 13:25:29 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9256290536949376284
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
Subject: Re: [PATCH 6.18 000/398] 6.18.54-rc1 review
Date: Fri, 25 Sep 2026 13:25:27 +0800
Message-Id: <20260925052527.1303068-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: M+lvj7Iwo06Ng7krDuHUVW/eP8gIata0ljKqJQI5irBvoXNx00sBNdLF
	F0LTB5nWMZeR8x8GVS51baaVDF2+PTKYuYTPe238r5eUzuz9ExGUp6SNBQWAUZSwKx5hN+V
	o4f5OMaSiE6HnxczmdGaTUEjUrQyY9531pWbWiORr2SkQ00aJERroWNeSiFLs/2owFc5J5Q
	r7l+lrefGX0Qi1ueLisF1E14VPhEyrPcH169S6zM5zgU8gnLa111kClyhdbIkguCbS3Jj4d
	CXg8hRcMRjd6hdf1+4etFjJJiIYi4lqFtGUKJhMhjx1mcJTyAxoamNonMmg9feEZDKVJ1q/
	px9NjpVQ5xXkpCIyf5r8yp99JljBNYeL/GHF6n9wrvTA6892XeWYdPhbtFEBra6Syvy5o3y
	kR7IBpiQCrOhylY6tiN14qVESRdPPtc8MhQDJYUerA08uxBC6idJ0PogERps765Okzp4M7m
	PoXGcjlOCXNfAj4vjZ3hG4dZGcBiB0UHIY3IbBBaIU+MLK4bHuETyxnAvfE3E4/qzB0DScv
	udPKvfjS4sX0C5hbQjIni2e8DYoQpWZUJ/RBvvAxF5iKT5WK0WrQdFt7SiSZhDfgsrn/+ge
	pFoiCPrUAVUTnqY1TU8wPDC+xtJRSAym/8O/143Z/6+LxWP3Zu3vEEthGvIokxqzgLAp98J
	TFebX1+GPKeg14NhF8lO2ghWhkhhJKqLeAJkn/MVNj6GlsDUS3mno1RtfTrYDOYxQygNuLN
	5rFVYqNvXt0C/k7h0ppgj/piFZ/jJhulnxKMgCvT/sZ6TFwqvST9XwBoifmZlt+ZMPraDBv
	lB6ktgD2dwsEgeCI3ST4zDOGAKSx0878r0ONeC+UK62WxKX9AwluZ3NXM9SF87m/G4ous7e
	FID+ncDKbHRyiEC+99goUuVXkQ9L59YrWiXr8aXTeEvPgqR105L+m/B+awQd8goJC4fvfnr
	DlJELCrjWqTwMi4QNoyqy0ccP6coh0I8zX5AH8ZEOMib0ODnLUdPJiHVEa3Z5DrK5zzWNzI
	BX3Cf08qVtpoG1mvU2cjkllALX+4qv0ee/9seixj9VsKKV7qtMQ7Pfn6CUKideagcCRnjTs
	q5GKUpBfbyaSp9AHGJqIJiqSklA+TWI5HB8r5NHaQTzLH+iI/OtKdolPPpWH2ZbgDg/onAk
	FxA6
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Build tested in our x86 config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan
