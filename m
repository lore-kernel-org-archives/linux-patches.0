Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8C5719049B
	for <patches@lists.linux.dev>; Fri, 17 Jan 2025 02:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080863; cv=none; b=JZipiBDBrtXhv4Ll/PXNDrLg0rYEB3Wigo4x62O6lDGDB6VTPDPwzAMQjEJovQfM9xdld7dytdHYN0w6jmJ5LWZEaBKMSsyjctS26uxtPCQ8jsVI7oE7FHVwJcEUxkIvyHSjJ3P55IQpu13G4d3b34ePIOqTf4DDonIBG1MILSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080863; c=relaxed/simple;
	bh=GIEj8ooPo/MFyeCheFon8Brm/FSACqXVzw1ZT7bDEDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=eJOkVLkbLGJNrAVu4C/C14dVGS5tUNztjgxXfMTBkWJHyvypFrsmdQ7O+aLhnGiLjdvmJ1JMRLKhLlgInnTMwgl+zw6wf2VnEYZhhAsIDfYBEcGezQFakT9Lwypco09MDFgKob+ynmRGkASBnK55Kp/y6RfCDUT44/fP+bChrok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=BBo2J4/u; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BBo2J4/u"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8F99F20BEBE1; Thu, 16 Jan 2025 18:27:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8F99F20BEBE1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737080861;
	bh=GIEj8ooPo/MFyeCheFon8Brm/FSACqXVzw1ZT7bDEDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBo2J4/uJNflb7XFHDSnrF3stBt4FsaoeUVfHHS+bB2BlQTF50MJCKf0DnmEzpWaV
	 tzTu3ltO+i6LxGWLjV1xicmZa8I3eBapLceH6om4u0+FouPhdY2Uj+zmHozcdHXUo6
	 WIwuzm6h3foqVplNgEX8JrNQjiUKybMI/lOi1PPc=
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
Subject: Re: [PATCH 6.12] 6.12.10-rc1 review
Date: Thu, 16 Jan 2025 18:27:41 -0800
Message-Id: <1737080861-23931-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel builds fine for v6.12.10-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
