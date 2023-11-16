Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EEAD50B
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="sFWml/w3";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="tDte+n07"
Received: by nautica.notk.org (Postfix, from userid 108)
	id E65C6C01A; Thu, 16 Nov 2023 08:22:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1700119326; bh=UGteBNk1MfmhOR9aXzCP79/I0BC+ccGkg1SeZSW7BUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFWml/w3jG2yJKR+Qm5LfgtjpFQFRuh1kfYAMO7QWzeCK4M+PG2RBvMZdKje5WxLQ
	 1VdcSpMy8NGNJmX9tUtj3pRMX1fHf/fVy+BP3D7dtwADdIrARijdyQnvuie4VA2AbN
	 SQifqxmDP2ZXeg0QOprwysBGUBTpBfKvH2+CUdoE60ED/vftO2gKHKDScTfh4Av4b3
	 j7bTRSuE4CYtr/MmCF2Sva9/qxJTAQzwyL31XPjn0iGK4/IxXf3F5bXm/ZoHO7YnxV
	 9ksPM6wVUq3QSsYVffhY2JO23WoSH20Q0FepjVYO5iiflb0kxeF0uMVrOogST3MTEU
	 D56VUSdpdVTqg==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 1E26AC009;
	Thu, 16 Nov 2023 08:22:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1700119325; bh=UGteBNk1MfmhOR9aXzCP79/I0BC+ccGkg1SeZSW7BUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tDte+n079n7PTU601fuxNcjLBrTKvnVs1mbSaaEt6o8MdgrpRDBE5ZuThOEzUCi0i
	 rGwo9fPlT9gZVAKu7k/uUlHXJVtm3LpiDcTWbbl48W0yK1d9Lq7qr22ALeiEP/1pSb
	 qVHIAFzoPsbKlv9rqpikFE/Zja3tHY36iqddMK/7J+JGDDjOGTP9w4V9TWmwPcYgpg
	 YyBemiKaqc32YZRTX3PzEvOsYYemHGI7mw9N8wDBxH3A673UuVd9cWIBy+WDje7Co3
	 0BY1RsUE9wmHab8v6y0RB02Bil+BxYBanyRJYCsLtwaY3fN4hstpGZrQY3Wvujiz13
	 vX7YlQ+1h4qPQ==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id a19c72eb;
	Thu, 16 Nov 2023 07:21:57 +0000 (UTC)
Date: Thu, 16 Nov 2023 16:21:42 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Message-ID: <ZVXDBtXJS7kWUqNG@codewreck.org>
References: <20231115204644.490636297@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Nov 15, 2023 at 03:44:35PM -0500:
> This is the start of the stable review cycle for the 5.10.201 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.201-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet | Asmadeus
