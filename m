Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1C8337107
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792303639; cv=none; b=Kw+NKvTVv4AihYEwXuCTYLFJY/yNtn6AJQ+woeneJlIYQ2G5cnC3z6cUcxtwoQLl7Qwt3qUk0gdyabzqVcgv/UgU9Ci3KYJoDTnFLF2LirT0qkcD2dpuViFgzTpaz9uk3+FwRxBEiAGHMx5SMY8m1Da1EY2MttE2pcaBn9Clpw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792303639; c=relaxed/simple;
	bh=MYeA79F4gysn/ytdbjjwEkNsYWX6g2TeZwc8XW/RHnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NDKyimMKlnP+c38sBxa6e0f3+UgPMQrUvmrm4ATvBk5itWwO5EQU7KrYgsG6PZOVsjR/gZyqXMvMrH+BpolOFmNL9eZ+O5gztcS68bmNkPrsmHnKr/3Yn+qH06bc2/AawMEYhc4Xyzzw1l+Ga3yP/OOQleXrDA7/Etf7ozOb7hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=CUCCCZrB; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="CUCCCZrB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792303569;
	bh=MYeA79F4gysn/ytdbjjwEkNsYWX6g2TeZwc8XW/RHnY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=CUCCCZrBndrBi6Zza/M5o/zLEEqOdqeOlzACA6KMCMOUmKACGQ4MJH8dM8xDF88Zh
	 hWyZobx1xByPnKJ9bdD1uat56TElqgDjMaHp+DdnrozJcFIwbnpbA2fRLlNkvvI2yd
	 CHM3nKGqX8RtDTA/SCeHFrsjsdwwK9zUJwjnqcbM=
X-QQ-mid: zesmtpip2t1792303563t6518cbe4
X-QQ-Originating-IP: TfUEmIIjGMJWlLPdtZbA/P3w9uYTQgCMIwWjoveJHMY=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 18 Oct 2026 14:05:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14433060652057131945
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
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
Date: Sun, 18 Oct 2026 14:05:55 +0800
Message-Id: <20261018060555.1449984-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OAuAJXx9C3e+ROQ3HmEvgE70PuMyzgrLb4QBpLl/ooGYP/t54vG6SDhp
	YSH5wJm1ZzJKzfQdkS6qRc5olmnHJW3qtZW641o0ulBgdghL8q1vmKnMiJ5s3dZtqcVf/IV
	WPC3etCzceoKnkYy8o+WCLEOvl8ZJccZiqfgwmRLt6zFI01yzEsxRryifKG9354vTW3A3sx
	T80aegPr/oYVJBDtFzhkoA5uzA43edWn3u/cpVauP9sEnp+PJpvboMdkHTprs7cLATDSjGO
	sCM06Ql6YMfEj0PuGXqVZ1kQVEzEZaGo/EhH+HTB0FvWiVAM/uuL6PJ2QC3sn2oNSo436fK
	EA9dyjhiAFdCmCMlPE0lNGS1Gs3QKl9w/PHdNiXUD3FygUhkECbKU9atEDK94Ymi0ZOVFlv
	4vVsNZjgZCwSQtAKdKzTthcVQEJg24hTzcGD2XKpJ061hG5HAODPw8ZP2jwnMDw0dZVKe1A
	GwZuWSXxJtgBKsdiqVGcK1N/H+Ptkdqd9X+NWGdGoyC4QiLXalKKagRYJWpEOlUtkg+eemo
	kt9kxtLFWdvSP2/QVbDlkK46CACINmAhCL8x9p8Lpm6RLFL7V1taHR+kXs9YtnFiSzVNxRA
	8pqpQ1KkYrR/5ZDYACHtfaTOLYLSRqbMD1KGtTafVSQ+1raKi5LC38Tbmi7fs3/ZULMbCH3
	ztapGN0I0EXGMRz/cg5OdFQx72XywUuTFS2NFBXBfyxNzrhRC7dyAvIagfeBnq+NVOPoh2T
	IhCpZuPDem1ZGPAlr4z5rJJbs+rBgZecf0GIEBeQM4HUtFaAp//fGchYnnjESE0CNv/YxTP
	QSpdrcU8ZGNz3pGWN4dMyLfH10kpO+0DSFdeElF4GUzGkZn70uMDJrR+QIqGE838Xll8GNl
	+h8l2wVOceaFD0ZCOTkcbEbEpiD/cjN0lBBUf3VNWyhLV1jIurGeqN1ifdM6ADmp4fKdvBX
	QqIwgt2lvZnFcrMwAwrmHF4owjiE1BnVUAMiHitHtt4WV14dHEtJCN3gbApu/Hn+ZSjbmby
	ju0IHg1PdC+W9xFHvV3QdWyZdJoWiohtVd/7EkFfuZn7X/6oB6cIM8t60k0hodA5jcDp+4I
	vAMhGmx79F+
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

Hi,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.160-rc1-arm64-desktop-hwe-g47804a4b5884 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT Sun Oct 18 12:56:32 CST 2026
Linux version 6.6.160-rc1-loong64-desktop-hwe-g47804a4b5884 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Sun Oct 18 13:15:31 CST 2026
Linux version 6.6.160-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP Sun Oct 18 13:33:34 CST 2026
Linux version 6.6.160-rc1-amd64-desktop-hwe-g47804a4b5884 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin18) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Sun Oct 18 12:37:56 CST 2026

