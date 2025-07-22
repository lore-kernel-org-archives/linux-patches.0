Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A9420CCDC;
	Tue, 22 Jul 2025 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753206640; cv=none; b=p8EZ3NDvkv7MQrrp/qEheySxTNGst+rbV1isyqlHkO+i8Q0p4AFmgeTDE3DyWBaFj6T8kVxMYDHe/J1Ii1BH10iyX86e38lntWdyP1IB62zJsyOEjEAPwcacpVuBEnp4gSsqTGNg0UGf0vRdylysmiP8fkZU397O8LrWeDL96Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753206640; c=relaxed/simple;
	bh=RHgnezT9Pt8p77ESMl4boYojAS9YtmiQZxQR4gjanFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpzTcnSuPe4EvBBEsDdyLSP8pH1Ik7bsyZ297g88uFojdE8hOfNuw004t4rdBc9UJ2qH4bOfae3Htu1RvXuRktM11udeycWVTkaq+USSR1JLp1nqmR4NZh6ttt0uInaqT1dkiNA86SYuPzoz2BUL6BbOAlifmu2YWX3zrFdrgDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vuof5oj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vuof5oj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B4DC4CEEB;
	Tue, 22 Jul 2025 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753206636;
	bh=RHgnezT9Pt8p77ESMl4boYojAS9YtmiQZxQR4gjanFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vuof5oj8wEKj0yg6VHHkPWuVKyRSNszc+1H0/QZ0dPGli2GvzwjtlyZkVrTswMmNt
	 sgQBjYSKAD1p0cm4pSnEf1Ii9rrcHVqeg4DspnjX65B2Xgg5LXFgjQzt8SUQ4K6d4d
	 ykzP+K2vYrDuAAJDsawMliuBKeloOvUSq3UEeu1wSUIBkB2yXAyrAIC3JQrCjNlCNN
	 bN+oqIdiaFUQOQwg304i3ugsmQOpwtuTy3chdczYE/AcjRVK/GbDL7O/Xi0gf16j1k
	 QO/GxMoPoW7Hhn8S7mgIlvAmV01IPAkF5Q5346B+LaT2m6+DICz376ppRf4T2g9jg3
	 DbLn+4aiYSebQ==
Date: Tue, 22 Jul 2025 10:50:28 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	clang-built-linux <llvm@lists.linux.dev>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Message-ID: <20250722175028.GA1163440@ax162>
References: <20250722134345.761035548@linuxfoundation.org>
 <CA+G9fYs_6KYHSF6eyeFmewDxYGqqD70kO1DuB0_1qwCPV2LjOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs_6KYHSF6eyeFmewDxYGqqD70kO1DuB0_1qwCPV2LjOg@mail.gmail.com>

On Tue, Jul 22, 2025 at 11:06:26PM +0530, Naresh Kamboju wrote:
> Regressions while building allyesconfig build for arm64 and x86 with the
> toolchain clang-nightly version 22.0.0.

This is a "regression" in the sense that the warnings are new but it is
from the toolchain side, not the kernel side.

> ## Build log
> mm/ksm.c:3674:11: error: variable 'output' is used uninitialized
> whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>  3674 |         else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix pending in Andrew's tree:

https://git.kernel.org/akpm/mm/c/153ad566724fe6f57b14f66e9726d295d22e576d

> drivers/media/platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c:45:7: error:
> variable 'h2r_args' is uninitialized when passed as a const pointer
> argument here [-Werror,-Wuninitialized-const-pointer]
>    45 |                                         &h2r_args);
>       |                                          ^~~~~~~~
> 
> drivers/media/platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c:133:7: error:
> variable 'h2r_args' is uninitialized when passed as a const pointer
> argument here [-Werror,-Wuninitialized-const-pointer]
>   133 |                                         &h2r_args);
>       |                                          ^~~~~~~~
> 
> drivers/media/platform/samsung/s5p-mfc/s5p_mfc_cmd_v6.c:148:7: error:
> variable 'h2r_args' is uninitialized when passed as a const pointer
> argument here [-Werror,-Wuninitialized-const-pointer]
>   148 |                                         &h2r_args);
>       |                                          ^~~~~~~~

https://lore.kernel.org/all/20250715-media-s5p-mfc-fix-uninit-const-pointer-v1-1-4d52b58cafe9@kernel.org/

> drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:3365:21: error:
> variable 'hdr' is uninitialized when passed as a const pointer
> argument here [-Werror,-Wuninitialized-const-pointer]
>  3365 |         skb_put_data(skb, &hdr, sizeof(hdr));
>       |                            ^~~
> 
> drivers/net/wireless/mediatek/mt76/mt7996/mcu.c:1875:21: error:
> variable 'hdr' is uninitialized when passed as a const pointer
> argument here [-Werror,-Wuninitialized-const-pointer]
>  1875 |         skb_put_data(skb, &hdr, sizeof(hdr));
>       |                            ^~~

https://lore.kernel.org/all/20250715-mt7996-fix-uninit-const-pointer-v1-1-b5d8d11d7b78@kernel.org/

> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2728:13:
> error: variable 'diq_start' is uninitialized when passed as a const
> pointer argument here [-Werror,-Wuninitialized-const-pointer]
>  2728 |
> &diq_start, 1, 16, 69);
>       |                                                       ^~~~~~~~~

Pending in the wireless tree:

https://git.kernel.org/wireless/wireless-next/c/81284e86bf8849f8e98e8ead3ff5811926b2107f

> drivers/usb/atm/cxacru.c:1104:6: error: variable 'bp' is used
> uninitialized whenever 'if' condition is false
> [-Werror,-Wsometimes-uninitialized]
>  1104 |         if (instance->modem_type->boot_rom_patch) {
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I need to send a v2 for this based on Greg's feedback:

https://lore.kernel.org/all/20250716172903.GA4010969@ax162/

> drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c:1066:6: error: variable
> 'crtc_state' is used uninitialized whenever 'if' condition is false
> [-Werror,-Wsometimes-uninitialized]
>  1066 |         if (plane_state->crtc)
>       |             ^~~~~~~~~~~~~~~~~

https://lore.kernel.org/all/20250715-drm-msm-fix-const-uninit-warning-v1-1-d6a366fd9a32@kernel.org/

> drivers/gpu/drm/amd/amdgpu/imu_v12_0.c:374:30: error: variable 'data'
> is uninitialized when used here [-Werror,-Wuninitialized]
>   374 |                         program_imu_rlc_ram(adev, data, (const
> u32)size);
>       |                                                   ^~~~

https://lore.kernel.org/all/20250715-drm-amdgpu-fix-const-uninit-warning-v1-1-9683661f3197@kernel.org/

Alex said he picked it up but I have not seen it appear in his tree yet:

https://lore.kernel.org/all/BL1PR12MB5144E40FC1D87BABD459A0D6F750A@BL1PR12MB5144.namprd12.prod.outlook.com/

Cheers,
Nathan
