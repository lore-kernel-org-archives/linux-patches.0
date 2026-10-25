Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792933117;
	b=MYhmC/fxWItsMj/H2sOa36Up8mq7J1XrFujmQwoAAsRc0nWnxQiyY1bKei+woeoOWv/n
	 Mv8AjWOYn0nWKfGzVDCHpMixHzU97V8KWayiJTIqhNNlxa5f5ikqMWO0kXmQJvm8vnBfv
	 vUIMjaf4Fxnf9L3j7zQovHiXEwVo0Fy0dp53Hq6sVii7ldv3pJ1JwkdbQXVCB3gT8W8E9
	 XkWRtMCuW0Chlnv1yXc3vSpKY8anv8K/C+2rGjzWeo3BKJYNXO0xwq9C0f7TgC3tEsMj2
	 Tppl3ABAFCf1nI1/hwwvQRBOLFV7NqUXBdenw2fG2ut7l3OVuD8/Hoqiyhs8wV+3uqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792933117;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3yzllJ8+rvuvg0LYjJq3GvvFbCs2pZRYE5PWz9v78Wc=;
	b=Grugz2QHRLdW5MI3KUaVj/MBckxTz8t8xRdyGK4EP7/stVeZ4HUJnGcAOcbKy8RP+BCw
	 DHSBH0cPP8OknT/Zo2Afkh4NMZBZDlnhirMCDmwLTYHjzVjpv5UuTtfLATWhArrIwN6SO
	 6h4qfxdetTsZrCFEA6vUvmSe1tgqHRMb38b/ZFtaTi8vsoxUzgH/zm3mAk5oVZzL1hUzX
	 VTIXWzpttC+Ww6Mzid/hVH5Mqp5V9Xn4ROR5E5VF/zXAJjHUQxMzR10bEcFdFmp2SQ7/t
	 EzMTmeK0U6zt/eBVQyUfO4d3m8qYoqozP+aI4HdMiXBf5dq/8oN75/GVsWbyYVYgNZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcu7KCoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DA8606A31B;
	Sun, 25 Oct 2026 12:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcu7KCoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9569E1F01828;
	Sun, 25 Oct 2026 12:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792933117;
	bh=3yzllJ8+rvuvg0LYjJq3GvvFbCs2pZRYE5PWz9v78Wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jcu7KCoAwaqeDRdFmBUFq3EYgMvna8p8bwX88ffnZQQKnGcPjDV2ImApgPdeuT5Zw
	 3LGvsF1lRVtD+M+/gmzM6KIGXWMGZhGik1YSrlvRzkCkq5iZg0wvEotNjcVC7r/4m3
	 JK2ZcteQWlcmMJwPw6YL/a10n23/inoqBjFemGXk=
Date: Sun, 25 Oct 2026 13:58:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Boortz <bennib@mailbox.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Message-ID: <2026102527-deniable-crowd-d7cc@gregkh>
References: <20261024064731.125251200@linuxfoundation.org>
 <at3xpGSor_VQBC9Q@bb-82jq>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at3xpGSor_VQBC9Q@bb-82jq>

On Sun, Oct 25, 2026 at 01:35:00PM +0100, Benjamin Boortz wrote:
> On Sat, Oct 24, 2026 at 08:59:39AM +0200, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 7.2.13 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> QEMU tests pass: Build and boot tested for x86_64, i386, arm64, and riscv
> across multiple configurations.
> But on Lenovo IdeaPad, AMD Ryzen 7 5800H, it breaks firmware loading.
> 
> 
> 7.2.13-rc2 stable-rc (broken):
>   Linux bb-82jq 7.2.13-rc2-localconfig+ #37 SMP PREEMPT_DYNAMIC 2026-10-25T10:58:13Z x86_64 GNU/Linux
>   [    4.115429] faux_driver regulatory: Direct firmware load for regulatory.db failed with error -2
>   [    4.247951] nvidia 0000:01:00.0: Direct firmware load for nvidia/610.57.04/gsp_ga10x.bin failed with error -2
>   [    4.293594] mt7921e 0000:04:00.0: Direct firmware load for mediatek/WIFI_RAM_CODE_MT7961_1.bin failed with error -2
>   [    5.270053] bluetooth hci0: Direct firmware load for mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin failed with error -2
>   [    5.270059] Bluetooth: hci0: Failed to set up firmware (-2)
>   [    5.285865] mt7921e 0000:04:00.0: hardware init failed
>   [    6.777226] r8169 0000:03:00.0: Unable to load firmware rtl_nic/rtl8168h-2.fw (-2)
> 
>   dmesg: https://benni.tech/pub/2026-10-25-354214524bc50442-linux_7.2.13-rc2_dmesg.out
> 
> 7.2.12 stable (working):
>   Linux bb-82jq 7.2.12-localconfig #15 SMP PREEMPT_DYNAMIC 2026-10-25T11:34:55Z x86_64 GNU/Linux
>   [    4.187538] r8169 0000:03:00.0 eth0: RTL8168h/8111h, 90:2e:16:f4:c1:ac, XID 541, IRQ 99
>   [    4.317243] mt7921e 0000:04:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260224110909a
>   [    4.329703] mt7921e 0000:04:00.0: WM Firmware Version: ____010000, Build Time: 20260224110949
>   [    5.209980] Bluetooth: hci0: HW/SW Version: 0x008a008a, Build Time: 20260224111243
>   [    5.363124] Bluetooth: hci0: Device setup in 152450 usecs
> 
>   dmesg: https://benni.tech/pub/2026-10-25-741af2903c635793-linux_7.2.12-stable_dmesg.out
> 
> 
> The firmware files on my system exist:
> -rw-r--r-- 1 root root   382295 14. Aug 17:40 /lib/firmware/mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin.zst
> -rw-r--r-- 1 root root    48310 14. Aug 17:40 /lib/firmware/mediatek/WIFI_MT7961_patch_mcu_1_2_hdr.bin.zst
> -rw-r--r-- 1 root root   359887 14. Aug 17:40 /lib/firmware/mediatek/WIFI_RAM_CODE_MT7961_1.bin.zst
> -rw-r--r-- 1 root root 84310168  3. Aug 19:30 /lib/firmware/nvidia/610.57.04/gsp_ga10x.bin
> -rw-r--r-- 1 root root     6380 31. Mai 10:41 /lib/firmware/regulatory.db
> -rw-r--r-- 1 root root      762 14. Aug 17:40 /lib/firmware/rtl_nic/rtl8168h-2.fw.zst

Thanks for the report, will push out a -rc3 soon.

greg k-h
