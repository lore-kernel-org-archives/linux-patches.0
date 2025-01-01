Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31311366
	for <patches@lists.linux.dev>; Wed,  1 Jan 2025 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735691682; cv=none; b=AhjhAw3V6fpfkb1jERyP96lnKpukl3t6KqQPtmNNNAkY4Ydj3WWAFywbcSMs7A5DQ72rayMeldMK43VxKnlhAANs4WdISUS6HfamPmewfoDA2pQzzzqnxk7oHH58hUVaKzTJSUJ9rFXRzxWum24wMqjmAPFhYvD1WFyXV/fsIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735691682; c=relaxed/simple;
	bh=12Q24RX9vfCFdnoWffhIwDL8WqMPUZWS4FweXO7hnOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=S39pJYnWHl9dfvdnFJabSLAP98aQERVtQmdWOsfoaiSHKhVZSzYfsb/YVMWKRdgbGsU8FqECqms2ogDn8u+FIdZLvXlvBucvz8YIp4EGz51S/M2VXBQK2aAwgGrMCfF5A+vJY0wsJkkWUXBy7bOFPDsaexZoS8HgDP8Jsn+g/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=svciVSpW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="svciVSpW"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8F48B204676C; Tue, 31 Dec 2024 16:34:40 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8F48B204676C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1735691680;
	bh=12Q24RX9vfCFdnoWffhIwDL8WqMPUZWS4FweXO7hnOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svciVSpWV+DwSymstvjCSSt6KqlP3BNjFtx5PPnZwPxKL6UswDQnCWenatpY/8zNX
	 eEEflm6frb2pyAF19PeX5Sy4dZbFdgslZeAqiEm7DJ8a/ArpgbAQIzVr1h5B+3GB2t
	 n7iKNk7Yi1Xoq207WWAOtmw3UNKVtXdhrOiv5xt4=
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
Subject: Re: [PATCH 6.12] 6.12.8-rc1 review
Date: Tue, 31 Dec 2024 16:34:40 -0800
Message-Id: <1735691680-2455-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel builds fine for v6.12.8-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
