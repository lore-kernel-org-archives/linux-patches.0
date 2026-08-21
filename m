Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4629928641E
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338633; cv=none; b=gCBJH3zkJzQVz4q9K7f7/DFOgr5bh9CDg9TYIvtcLw+VlaZnnVLh4J98gyMAw6WQwxa6LhkUD5/YNw/jaQLbfoaSZFGuiAFvD2c4WVplL6+0H/xCGDnAlW1xz7PG+TY0kkVDTIujKi2ep8lIGE3LGJAlyJsKISGcCgV2Tjl24FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338633; c=relaxed/simple;
	bh=vi1uZjue0uyZHjCEutf1Bu3+T14eZwAUOFQt47DDIWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKv9vy8WVCopoS8xirxDAzhpcDRFrvl02pR6kwjWY3fDT4dyE6T2WqpEv8wWpURAb2i0iq0Px9X8bMoEV6XlEeAzgNITVBBGUvh5GzC0Mm+sYN5D3aZ6yTYE+WYQo2HCDpfgd1iiUrKjevL8H5nxWXpABAINisEOrK2bFOqlfHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=EpKaJ6hy; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="EpKaJ6hy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787338600;
	bh=gfp426rClgrRARODXDTZsXb3WsMN4S0MxVUsFp+3eso=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=EpKaJ6hywEIWqyAaKWv6OKVOkHGTYE1w54DFbo2DvysQJtU8HS0VM7IZ0wISn0C3v
	 f0E/v2Jfl5iPS8A9ykVnxMviHOQ06whCDU4NkOfiHR+KyalAwKLTvcIFxGAxFPhYB0
	 hFtfOO1/Ubtisa8X9o56MWG32h9rx59vpSVzWYaY=
X-QQ-mid: zesmtpsz6t1787338594tb3b9d28b
X-QQ-Originating-IP: qWPptjxjFrzvRafst1u8kYT73qeCR6cKQmBnsisQjRY=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 22 Aug 2026 02:56:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11226042413714028733
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
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
Date: Sat, 22 Aug 2026 02:56:27 +0800
Message-Id: <20260821185627.3499541-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MX+1SEN3H+wApG6KIYG0gxZYJpI3rtMnSC+ZOJ9kCZMvRogRXPQSwmC0
	0x0Q31WI7pHPXLkM/ofnF5uFISuL2VBQP5I9kQPBdaJT/Qr+ewISJhllri5WLDEySdeozhz
	7w2vP5gmqpSvBBAXezz0tzpuesumFWNssKg2DdRVM+k5eq89rBeH/EU0rumuUOqkU7wlQHZ
	J5fNRdLzGimBM/HPCI/fiGnGgL3JKDYGOu4ihRrBffKt2bmL0IwE8rhkULADWu4QPXJJhhB
	m8ZNEvGGrSo4IZA3gaxCTSqOx07S+4DogecEYgtbvRQG+MCdKOzJ+G4AgJOjvTOaY8Eopo0
	oFeyds+LwcGXKl6Ahw+O0X/vIjyU0NCfU9WiY3a5gEr61si03ck8wyC/BCvqrW+NNryJdcS
	m5fRInV1E51V2uq0m7UOhjpkTmowFO3i7GiRYN1ESHt49NrpBpWzPpCGgLihbqtIpHlN9Ib
	ngbAm0AugHpBetUiI2LhkxA6k4FF6i8/V318kCoeaHWydlu5OparEP2RUQBuMD84aYZDv8c
	lOopm1NSfpBfouhOg3G+ebf3BCAFEs8n4KfhaY8bSkiqjiR767MH+ZVSbYTJDEecBQIz8ha
	MiTjGiWRzHMLBAycmBo8nOkzH+KaU9oSA8DwK8lVffpdDdcoTy40qluM4OHujqSTQAj/FhL
	fP0/yGfIvXldjZjNXgC6e+cjPP1196bzkZMNobfx3MfeKo+RzabSyYvC+/jOWHxbjpN+N2F
	Hw92sWy3bJZoaSWaI9NnthnSeoSZ0EW7VfGRc6nRBeZ6ZNcQIVWb6I0Svde1Xtv8wbnWKZL
	S07E7b8cAfmG04ij86yLVUZ4RNpAYi9iVoCCfLlbj93ldgqntHd0uucgKDkQe/c630xsxhd
	ODab5I/3u3AIZ5QadnAzQc4UGQw+A9u28TpMh4wRCOURPPQ4rEt5D8EquYIlLePpp73WNvy
	X/izJf5JXsnr8KvjLoqzu4KbIuxTiYrvrjS701HRGit8mea86MgUxWxrFBGFQumxkdygRyg
	05NqQ+5q6+/Ks0fwTaL6wCguxsa59abICfZq+fWJYaiRbEYWLXegc5TBfkPJ7e1i5zTmy0Y
	w==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

Hi,

Same build error:
  CC      drivers/net/ethernet/stmicro/stmmac/stmmac_tc.o
drivers/net/ethernet/intel/ice/ice_switch.c: In function ‘ice_aq_alloc_free_vsi_list’:
drivers/net/ethernet/intel/ice/ice_switch.c:1816:23: error: implicit declaration of function ‘__struct_size’; did you mean ‘struct_size’? [-Werror=implicit-function-declaration]
 1816 |         u16 buf_len = __struct_size(sw_buf);
      |                       ^~~~~~~~~~~~~
      |                       struct_size
  CC [M]  drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.o

As Ron Economos wrote:
> This can be fixed by reverting commits:
>
> "overflow: Change DEFINE_FLEX to take __counted_by member" a5c50a3af39c74eef1a15c39924b0e1f4c6a43a6
>
> "ice: make use of DEFINE_FLEX() in ice_switch.c" 858a287aeaf8a690fd3c769e0ee2247f40e44b62
>
> Unfortunately, the Bluetooth commits have to be reverted also (because they
> depend on "overflow: Change DEFINE_FLEX to take __counted_by member").
>
> "Bluetooth: hci_sync: Fix advertising data UAFs" 50d4431fab38c15c9ef405b6c7e13c0491f29928
>
> "Bluetooth: eir: Fix possible crashes on eir_create_adv_data" c4fedbbb5b925228321a359b8a3949b207cc0a62
>
> "Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1" cf931b0c0a6a5b8b70da339101c0df17cc068488
>
> "Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings" 88dd9093e398c68467d8e9c8b7fb630aab05be05

After reverted,

Build tested in our x86,arm64,loongarch,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

Best Regards
Wentao Guan

Log:
Linux version 6.6.153-rc1-arm64-desktop-hwe-g0ce9d61969cf-dirty (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.153-rc1-arm64-desktop-hwe-g0ce9d61969cf-dirty (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #4 SMP PREEMPT Sat Aug 22 02:08:37 CST 2026
Linux version 6.6.153-rc1-loong64-desktop-hwe-g0ce9d61969cf-dirty (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT
Linux version 6.6.153-rc1-loong64-desktop-hwe-g0ce9d61969cf-dirty (guanwentao@uos-PC) (loongarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #5 SMP PREEMPT Sat Aug 22 02:26:01 CST 2026
Linux version 6.6.153-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP
Linux version 6.6.153-rc1-riscv64-desktop-hwe+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #6 SMP Sat Aug 22 02:41:52 CST 2026
Linux version 6.6.153-rc1-amd64-desktop-hwe-g0ce9d61969cf-dirty (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC
Linux version 6.6.153-rc1-amd64-desktop-hwe-g0ce9d61969cf-dirty (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT_DYNAMIC Sat Aug 22 01:47:48 CST 2026

