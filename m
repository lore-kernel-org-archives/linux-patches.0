Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECEA345EAE
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 08:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792310792; cv=none; b=kRAJhgI/uowMR0swEFM4xayitpRZ5z7Z3e7k7lI3ChW6dmRTRzzGGbbE8UDNRnxypdbvPAnt+TEeRYQV3ATGiQGYLqy+rqlL4/Jz32UJ6C/IBEZwP6bJi7KS3SfoaOvq9N0B3YGD2Ih2lEKLUKjZ8xpBZL375OreWwAECCnUSS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792310792; c=relaxed/simple;
	bh=TOnAVyEK+04cMOfsycnPsuY3HAxNe+V2VOvmkupQOI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pzbgSG11FfoHYZZiwYpF5mH0RXPQ2vmt4sAez8nyJQSN55z020TEkp79csuVX5PCCzMxqXgpXYUWfa3zq3LF9OJ6kzqd8RLjHxm3+U4FJNlUFBV5qe7hkzWrR5WXLPa5GLOAd3Nb3VcYxXLx9D4eEhVZzin+XwAvpfN8QT7kWcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=pKklwc6W; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="pKklwc6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792310765;
	bh=TOnAVyEK+04cMOfsycnPsuY3HAxNe+V2VOvmkupQOI8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=pKklwc6Wg9KZ91VMtBG1vhQYMY8dbeu9tVe+lOFTTh2T0eE2K0GHac44HHCs9GyY6
	 3IQCrLnOxzjRykJDF6zRGlYBD1Vxf3ZN39xszLQOHtNk2EQZJtMiZL2Cx1tjlieI7e
	 +9iAGB7kUtsjVzmYgD0S7D474V++fp+i/xcbb/vU=
X-QQ-mid: zesmtpip4t1792310759t03841159
X-QQ-Originating-IP: MbAfE2g+DSik+IzecFblDwmmIriWgwV/1JDDtkxUcfs=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 18 Oct 2026 16:05:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14395054749382422729
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
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
Date: Sun, 18 Oct 2026 16:05:47 +0800
Message-Id: <20261018080546.1474756-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OFyf58EP9GzUkkduIxlBIKwrEq8Suu1wWo1l7h4D75q/gMS4YGqDJ4qC
	Zpqw4cn7XuObT8+/SKuLZ4MeJ31rbuqJw7Y+NVkxmgfBGt0d/nFjAAUfNEkFM913I+lY82w
	1xpYuwAihyxFuIzR3VFZDu0e5hlWIERxiU+3OvZb6B1BrScWsnhbHgnHyRgDoq+ECs3jrzR
	lrgGrjSPeYhwP7eOEQfjg0s5q3iZZIipDpr/C0adzbPKoRbggzSNZ87v1dtTiUbibtu5NDb
	VV/tX/A5wyfB1UIHhxvmNAsEY+3Cs9I0XeLVnFy1OsXvxUTcLXJJXY9K3RMBcYMTMrLv8I2
	6+Xch++wkIuNWkPw8MasVesw1zs+M8cQIpgAVIzdUeVhjpqXXpndrr8glWL4l/N/c8JJWOm
	JzCpWrodBcsVGSaWLLgq8PrOtkaEoGawAlsa9o0gqQsRwfSMlxQNJSHucOdxd4Pj400hHF1
	VJl9FhSsW9PWJnmUNC8aCeW/Wrih8pCZnyIGxKez7Ot5hXshbjCXj+yd8mF7LNX28IKghoD
	i1P3V9ScMEk1/yFArzm7AQ9WYLSdjk9tNiOGZBuCKauZsddAX8SpRXhqxumLZYvGe+ghO/W
	qt2Ln9PH+rTsfHktchkRX1Dln1RqLIe0++9Lwwdcm8NkWZHgD8lY32BNv3v1AUhIs+ilzPm
	r7HN1T7Up6rEug8bs5ZB/4yPzFhtyXFXeGeRCOwPP29QR42tIzPwTFRbN+vdh3/VcJUU4jK
	jDx6LjMNSv37nm+0/ogAFtt31d0XvhFiSlExXw71WNq8nQ0NmFpUcJLjbsN5kThDVtp8fAq
	xQ7pFsujoH6lsncQmITN4qtz8XVKyHB8xg3c67aWX7m5GQPTLM5Ec7H3kcoDC9f6oFriC7h
	iyz7uPeRnm2rEOblhuGHPB6oGgsqu917bDGkQgQDBa6Bt54iZYMf8omKVNYg9ar49ImnYc+
	yG3dyT/phAZP58hbZVNZ3L5twnnd8YcEMwRjamxBYSxXTvrb6pmBypdhHW7XbMSsL2yTVmZ
	0vg4PXPC6gmNTeRF/LAPvxVep68EzPbACwjPD42DC9mxkn0JeHlIuq9kK57gOZok9mC+1c1
	AVXHv7KPV8GtKcvzP7rmxHaM5TsUA9CtIICP1h8W2TTPfRGHw8NTK59eUhRkaQ4YRxDE+uF
	3GfS
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.18.58-rc1-g73d1ddb7c097 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Sun Oct 18 15:09:15 CST 2026
Linux version 6.18.58-rc1-g73d1ddb7c097 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sun Oct 18 15:30:09 CST 2026
Linux version 6.18.58-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sun Oct 18 15:49:28 CST 2026
Linux version 6.18.58-rc1-g73d1ddb7c097 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun Oct 18 14:49:12 CST 2026

