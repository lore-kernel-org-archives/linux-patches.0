Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFBD3B6363
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 11:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776770270; cv=none; b=aFOqy4drvoDA1tKv8PbJCixmuyFTPssXasllovSybxEWj6PRzC2UtZHhomiNuZBjeSMlbBkKl8VF90WICl0g/I2GTgSipcm+zmpG5DZGtbjsabE3kV5XcjEYHgvFKfkaP0IU8WYkcIt94oUfcukJUufDaGPQmyhVmc/Jv8OopvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776770270; c=relaxed/simple;
	bh=Y56t0wmAE32zViZuf8hZJhYzxrKVtfh+UlZVUuHasKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ms3KTaj6MqTZ0j2rfkUM9xSfzGqddQiMIJD4GiGsOjJ4xw7HtNzdRDc2qj6b01tX9b5mnHqzdjv8oYzXVYVbUMJZm9Rn2ZeOZzGfDohdCncmnTG7iOdLbaLxZH62oqRwZfeqtSJmZ6yXj3e6V5OTJDe4xxJ+IFdAV4sfqu2P6OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=QxPD1/w/; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="QxPD1/w/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1776770248;
	bh=Y56t0wmAE32zViZuf8hZJhYzxrKVtfh+UlZVUuHasKU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=QxPD1/w/fheRrBwfzHnz79vUiqh7vFd1rIYSw9QbEeppUyIF7S3vVC8tXftorrs6k
	 ikCbSTgIwSIozkjZFcJlMYKV3ptIGxgWA8mKU9UqLb5/eZlC2RnEPHHWwdXm+rPVJG
	 I93PcR5n/pqpK7/GnaR7pJKlcthcfqSk82qXOT9Y=
X-QQ-mid: esmtpgz14t1776770241t24fc306a
X-QQ-Originating-IP: PgtO6fYtjq71wOcExxHFlwUdHZBlLY+GdPCI4226Oyg=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 21 Apr 2026 19:17:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17719987415262611358
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
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
Date: Tue, 21 Apr 2026 19:16:02 +0800
Message-Id: <20260421111601.51467-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NJL+bfc5gN/mU/QdHlxlyeWw1gRq1J6zEfsP8T+SnM2lvEFEa5hLkQKq
	RD0Xzt6o+/M2PONnc6ELbu9yMu4d9+fGxmmiswBCnMIzpU6FYE3MUTj63v2YfU8mNLRK7IC
	wYpMz+JhzjNRTZaV4FpyOWw7pdyiEe3h1+Qf4E75iJe2JMOws6ghyYUn5/OhWkJnWFdamg9
	QEJjFALnkjH0X1MVCmQ7YMcXB9B9pzB+AiVc1cyQb+SSTbveIFbaoAkslbUqAK2L7gLuG8P
	c6oeeUaej7fCYCHjCEXe7wKXmm5w6HK/NMyCCvpD4P6je05SqC/HlQZBP4j8rhOxEh5JuSo
	LUL2PV1HXrcD7sizOkPoT/jD6ALUhfg2EsA29/ltOaW6wBydgObPTusGdg+G5OIPBga95zc
	MrVK2b3LKunw4WooVIHs5NPzIgU3PD3Kk6iPnIwfaZA1MIgUGOSytoWQOdjBc2LQWbBUTkU
	IZGr8DweuA/scTO/bXQIhqffqrE/6S/9yBvyrWpT94wY254j4dc3dgjQ7OYcfdvOd5+7bfx
	povWDMWZ/c/oh3oc5wdf1BJ0wERPhGPyWvrP3UWkuWLbJXO+9RWWeyfVxmoJ09/R+qA/Xk2
	DRU4G+i6PdWtvKd6zLutCwGRg+ca252RbPMaEuES3j/nePyhEsNGLpjf/aScxcMKPvxzC0O
	Hh3aN8u+e2Nlq9Vy6DXqape/lnR5o4Ed7qiF4THXOK21Y9Ve7uddZe70AX8iBqvKr4bKwRk
	h8LIbG2rRkTJBJkRLo+WYi9tBRw9e2n+LQXgjJINyQZ2PoJ9j14P/SZifmJmVlROz+C9QDX
	2S0FY48XK5rKukK0XkiGS38JRM/bJh/QraFsUa2sd642P2kJ5rar3nLurPJVNxle9hU6fh3
	ML7WD3uAKN0nQPnNi0j5reYp/Bvr5fg596hd6mZ2G0nhzh1WN+A8gkGm3s+e72t4ojWmmg2
	H4tgHJZO7qI+QWNmfEGKfLz5opQrDtpHWug69xcOaVf3QkYsnZCgSRdnmupneywqBNTjmaa
	m9vqtdWReazlpbZGmk8lfhJc09Gxrir9rsvX6DJl3RV5AhA26dKCiQgyRnX3RqMxjD0uz7G
	FlJMW++Acg3vdIodS0x7/kJEKJyPIsNBkspN/qx3ammNi6Nn+sK5dY=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/decbc7d88fbf68488a7d90e46f6d3e59

Log:
Linux version 6.18.24-rc1-g79c8a3af6b8b (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.24-rc1-g79c8a3af6b8b (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Tue Apr 21 16:18:20 CST 2026
Linux version 6.18.24-rc1-loong64-desktop-hwe-g79c8a3af6b8b (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.24-rc1-loong64-desktop-hwe-g79c8a3af6b8b (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Tue Apr 21 16:42:38 CST 2026
Linux version 6.18.24-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.18.24-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Tue Apr 21 17:08:51 CST 2026
Linux version 6.18.24-rc1-g79c8a3af6b8b (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.18.24-rc1-g79c8a3af6b8b (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Apr 21 15:52:00 CST 2026

