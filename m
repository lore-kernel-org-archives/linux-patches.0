Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00BC2512DE
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 17:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758646957; cv=none; b=lzv7wUs5of2o7DTSGsB0HMU087Q5McpGkP5piaKF1lcl9yX+qPLxb/2h5H8oh2ndsStti4GGpmO72xbgRLxZr+V0t7qXp3yX6LuX4qX3I+oO6U7M9MecfUrFaibITGgvObFysQ1KsmRYp53j+VJzvXvPzlur16rZuTfL4zpgEkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758646957; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LNgSSTKUhLKc6x10EXhbZ0s3NJ50dMVwT6ieoUm8Lg86pNepi4lGd+O5eVSHVZZ63whOf5RUgkiL03jwdmruws7RutKlM5wXc7SbSnc2OSUy1g+LNnURkot/6bPARh3u1cwwPuIT9G7WaneKKrndhItzBFb97jsj2LQ/hbz2Ceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=ZW0NuQrl; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="ZW0NuQrl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1758646908; x=1759251708; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ZW0NuQrld++N4h08x0kNs4Ux/Q6BrF0uabI7G9yk+Y2Euc3DogGZzKDhcrmCyf55
	 pOS1Nd42AeAJE5XEtIgVBfi2q0RSDoSRqDqwr2CT0RaPs8uzlVnPK3x4ZMDURXXDc
	 CsxKib7XiSmbrU06YY7UBV/Ft3hBoKB50w3YNoTYDpUT5xjiYsxMFpaH7ojeUyHjJ
	 +SCSyxTyooVrXmEE5e80Y3qr+NSKrD+HG+K+nzCZNgsypYxM1RiyZcFjGZ3hwCEqn
	 WucAKIYnA5F1EBZ2HdjDeHlQVckT2NPMlKONf9rhA0D+HbE/he2RtYt51jKJT//oi
	 nlZxMSvdMl594H0roQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.209]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MK3Rs-1umC8r40II-00QGGx; Tue, 23
 Sep 2025 19:01:48 +0200
Message-ID: <fd5e45d0-e94f-4ebe-bc23-64360fab0a52@gmx.de>
Date: Tue, 23 Sep 2025 19:01:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192412.885919229@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:p1eE8tLbotFJkzMo9qTZH7XfdquOcS0xiktzFRIPmI174qNupiK
 uMabBKRLAxG4DlAvjvneThP2lRnz0YxUBr/TCYesQ1mQLeWJjK4A7OgSU1Kqamn3y0A9aBU
 OIYKsVE7wCM+o8YaIAhUpsCKHVH02oqL0JKeY2MdsaRHKyxf2zYNCYxPstMvFGAHjOJLus5
 wDNPWQreJ5WIs7t0Q5Z2Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:q/FwFBH+v0U=;qaydfvTVZF0YiJJzZYkUhUT18RZ
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

