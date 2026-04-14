Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EA52DC762
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 07:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776152768; cv=none; b=OxsKmWsp56NVKbfnxsal9pE7eXlPF4SldcUldUPT27aSsO5HMiOiw1y+nrj69b/rRLwhiRXdTx0bBO7X6cXCcpVtV8ctNoBlCx+dkishBi+DGaZDmTZC+ZCgxQzxAQGRMBgq5j9MEUeMKlF+l58SDeQFdtpeLXybima+lc9puR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776152768; c=relaxed/simple;
	bh=2SvYolvgomNB05QQPc5Ipj8Z5sJ0NE/Lr9Y1GU7mXn0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ter7sFcmBkOCRlPIs8JkaV8G9opQhfXz14ybugqZzxzujn1doSvSmriYrFL3BncO/rhQL1kU4gxWZOJKv92YaYg/vsK30xZCevDw0kVMs076nXUQ+iSqjPCGVTEPQQVgHkYLLhJiruEo2aCizKcBrdeXPwlDdc/LI0nuwHR9+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=jXBkWTEc; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="jXBkWTEc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1776152749;
	bh=ijOBe32OJaXUt6Lriy0B3ACja7Vy3gV1h+L6V+TUVU4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=jXBkWTEcpAiuqzv0/u4Ep6zru0sVgQeUyLB3Q6ANgUyVpNXGusR1lkQbTYWm85Ovc
	 mqjw8aD2AA4ZUCH8vTfNri0DJEHtFXrZ9aXEybAR+WPvuNGWRwPXngpKq/PtozBgTd
	 MXd2prG4fwtSTC6HHgl5RFPHlql2VxMeTpl+OF4E=
X-QQ-mid: zesmtpip2t1776152743t05dafc70
X-QQ-Originating-IP: 90aflYS48oZQTIzKwDmOLG2ZMpBlc0zy4H4mJgn6gkM=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 14 Apr 2026 15:45:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8781629494817420186
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
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Date: Tue, 14 Apr 2026 15:44:35 +0800
Message-Id: <20260414074435.2566765-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: Mrs0LwfWgKNgOj/6Cpu1aQXurFmSIv/YEmjSw12Um/NY+9T83bLABCON
	9VbWT76ZfJP5nlY3bB0LxNupp852n5ptHh4Y/UUDAtoCtELsz3g03c5N89dYug9Kf06T36L
	irY3tETfLQx5647I9cCfh83GTKp8Y8gHdYX95cXBRx7dnorOr0981JEAVYJLYfNEbbMRWkg
	DSlYbJmdZYsO1WT0OLK2UW5aDX9fsT9cicPPDebytCp2BVtmDsCJkBNHzpj3rq0oHTEW6AZ
	zCu2eq8wiRKr+Jws6bUKqnDHk7y7InR76geha5P4z97gR2xJRja2Wpgiz1dvV/2ec23XxsN
	tk8ukC29uyRH69okHlY1HUUyGCHcblwaWkK1nR+1/cXT1524AYmh9bQrUzSLBuyI/h3PK77
	aQ7z4k6fK9jUX1eY0TkY5ZIoy5AKz5d6V3H7qyxJK+5+ZaNY+381aQft9FVzsVYcs5Q4NU5
	kkkvkkl48ACMUqPi2Om1IIzDowJvN3l9hrpPspsTClYLFNInktwpvhJmo3KaHiilmTEDRyA
	8NqlN/1No9LUt3KkeU0MCGgRWXuMW5t22JUrjqnNFzfxFb+NugCbfY7YoDOJONz8czboVHO
	iH/cye3u1x7ymRMZk1fE2YODuCLrubHaeQ1PVWVd1P5R9hN85IMGSWIumtC+kaM8fYSnCvI
	6h1u2A+cn9JThPQrHmInH48CgKfHODS/b+z1vj+KSACesRzm8qO/XtJxisO1OV+5JLePGOb
	JP7Woo9dL1l6c0ZckFJiwF66uO4GOsk82RB4XDGUlGCNGSwx8GzA6NOPSjzzRvzeS0w5tsv
	yRxGNihgMy/4/VdnR+9K3oF8ATh/bkPvM2Uyql7elUGxT8JsA5lONN/eHoEpaI69dEcC6CY
	5hyobmAyXc2GVt6/qNw+S42JmFOcVOyh920pv4hqnWUWJyVTer3cXDNfHR4VNuhUDt4NUY4
	zaU6YTjiaCz4jz5Yb9gYtNaX/JtCu0XRQVKlpq7amsGC7B9ihOIQ9RvR9eUMCZDR/upzxJg
	MsBhgbb70O40EEtWVrwwnrTiFo28QdbVVUzI5tpjc5yVLTiltoE4DMn9+ct7s=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

BRs
Wentao Guan

defconfigs:
https://gist.github.com/opsiff/decbc7d88fbf68488a7d90e46f6d3e59

Log:
Linux version 6.18.23-rc1-gc600baa82c20 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.23-rc1-gc600baa82c20 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Tue Apr 14 14:39:43 CST 2026
Linux version 6.18.23-rc1-loong64-desktop-hwe-gc600baa82c20 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.23-rc1-loong64-desktop-hwe-gc600baa82c20 (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Tue Apr 14 15:04:09 CST 2026
Linux version 6.18.23-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.23-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Tue Apr 14 15:32:22 CST 2026
Linux version 6.18.23-rc1-gc600baa82c20 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.23-rc1-gc600baa82c20 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin14) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Tue Apr 14 14:13:29 CST 2026

