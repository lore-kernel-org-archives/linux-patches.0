Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E122116F4;
	Fri, 28 Mar 2025 07:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147907; cv=none; b=O8/IIoKpGZbHiHbtaSepMboY5JfiKvtt50ofLlk1oXGoft8ZUyhk5ROwkvR9s40Oog/w98zLu2tRBwUj91GnedSrkbchx+iKv+wvzLyzn0oKO9zjpPuuQIWE+U8WTnt3V9y5bw2K9Xsy6KNk+migtVfje9JMF2dA8orMP6cuOfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147907; c=relaxed/simple;
	bh=rTnaUEQd9PwrdeAb1F3aH0eeGnSINU7XexxI6tv7+KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IIbCQ2GciUc7Qo6QkYqZY6+mKf1lQtr7tRDS22Rl6fwRcAY3wE/LWKDg87OHB2s5BW0oACP4i80+dcddGWn6TG88TXYbbq6oVJ38uQUGshrQet4T8EZto/M9SUjW46hHlm+B7aJZaDaWwXcocus/MhXJQAUFUGmda+VnUADWmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsr808DU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsr808DU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A2FC4CEE4;
	Fri, 28 Mar 2025 07:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743147907;
	bh=rTnaUEQd9PwrdeAb1F3aH0eeGnSINU7XexxI6tv7+KA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dsr808DUQ24pHNQgOztbILSRNQXznMNS1AweSSwIFVNJWd9g/qDmbdfzKf7KXYDs5
	 712rz4W0XsUxVTXhEUStJ6ns+mJAoCLGcRAo7Qy7H7xMfg9pyufhKy34gMfFlBPKut
	 eWW5hkcavPUm32yFPsx798dY3lQUdJkkjwoDt+Zs=
Date: Fri, 28 Mar 2025 08:43:43 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
Message-ID: <2025032828-lively-simmering-1849@gregkh>
References: <20250326154349.272647840@linuxfoundation.org>
 <b93abaf4-1dd5-42be-afa3-539172fbdd77@drhqmail202.nvidia.com>
 <a2814133-df50-4251-b397-fbe734df6196@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2814133-df50-4251-b397-fbe734df6196@nvidia.com>

On Thu, Mar 27, 2025 at 02:35:06PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 27/03/2025 14:32, Jon Hunter wrote:
> > On Wed, 26 Mar 2025 11:44:27 -0400, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.132 release.
> > > There are 197 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc2.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v6.1:
> >      10 builds:	10 pass, 0 fail
> >      28 boots:	28 pass, 0 fail
> >      115 tests:	109 pass, 6 fail
> > 
> > Linux version:	6.1.132-rc2-gf5ad54ef021f
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra186-p2771-0000: cpu-hotplug
> >                  tegra194-p2972-0000: pm-system-suspend.sh
> >                  tegra210-p2371-2180: cpu-hotplug
> >                  tegra210-p3450-0000: cpu-hotplug
> > 
> 
> 
> I am seeing the following crash ...
> 
> [  195.052638] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [  195.061551] Mem abort info:
> [  195.064467]   ESR = 0x0000000096000004
> [  195.068244]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  195.073551]   SET = 0, FnV = 0
> [  195.076604]   EA = 0, S1PTW = 0
> [  195.079741]   FSC = 0x04: level 0 translation fault
> [  195.084614] Data abort info:
> [  195.087493]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> [  195.092971]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [  195.098040]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [  195.103347] user pgtable: 4k pages, 48-bit VAs, pgdp=00000001063b9000
> [  195.109801] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
> [  195.116605] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> [  195.122859] Modules linked in: panel_simple snd_soc_tegra210_mixer snd_soc_tegra210_mvc snd_soc_tegra210_ope snd_soc_tegra210_dmic snd_soc_tegra210_amx snd_soc_tegra210_adx snd_soc_tegra210_sfc snd_soc_tegra210_i2s snd_soc_tegra210_admaif tegra_video(C) snd_soc_tegra_pcm tegra_drm v4l2_dv_timings v4l2_fwnode drm_dp_aux_bus v4l2_async cec videobuf2_dma_contig videobuf2_memops drm_display_helper videobuf2_v4l2 videodev drm_kms_helper snd_soc_tegra210_ahub drm tegra210_adma videobuf2_common mc snd_soc_tegra_audio_graph_card crct10dif_ce snd_soc_audio_graph_card snd_soc_simple_card_utils snd_hda_codec_hdmi snd_hda_tegra tegra_aconnect tegra_soctherm tegra_xudc snd_hda_codec lp855x_bl snd_hda_core backlight at24 host1x pwm_tegra ip_tables x_tables ipv6
> [  195.189033] CPU: 0 PID: 87 Comm: kworker/0:5 Tainted: G         C         6.6.85-rc2-g0bf29b955eac #1
> [  195.198237] Hardware name: NVIDIA Jetson TX1 Developer Kit (DT)
> [  195.204144] Workqueue: events work_for_cpu_fn
> [  195.208499] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  195.215448] pc : percpu_ref_put_many.constprop.0+0x18/0xd8
> [  195.220924] lr : percpu_ref_put_many.constprop.0+0x18/0xd8
> [  195.226398] sp : ffff800082e73bf0
> [  195.229704] x29: ffff800082e73bf0 x28: 00000000000000ed x27: 0000000000000028
> [  195.236829] x26: 0000000000000000 x25: ffff8000824aa720 x24: 0000000000000000
> [  195.243955] x23: 0000000000000000 x22: 0000000000000001 x21: 0000000000000000
> [  195.251080] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
> [  195.258205] x17: 9397548220450a08 x16: 010100001748ae3c x15: 0000000000000000
> [  195.265330] x14: 00000000fffffffc x13: dead000000000100 x12: dead000000000122
> [  195.272454] x11: 0000000000000001 x10: 00000000f0000080 x9 : 0000000000000000
> [  195.279578] x8 : ffff800082e73c18 x7 : 00000000ffffffff x6 : ffff8000824aa720
> [  195.286703] x5 : ffff0000fe924a20 x4 : 0000000000000000 x3 : 0000000000000000
> [  195.293827] x2 : ffff80008249d8b8 x1 : ffff000081eb1e00 x0 : 0000000000000001
> [  195.300953] Call trace:
> [  195.303391]  percpu_ref_put_many.constprop.0+0x18/0xd8
> [  195.308518]  memcg_hotplug_cpu_dead+0x54/0x6c
> [  195.312868]  cpuhp_invoke_callback+0x118/0x224
> [  195.317304]  __cpuhp_invoke_callback_range+0x94/0x120
> [  195.322345]  _cpu_down+0x150/0x328
> [  195.325742]  __cpu_down_maps_locked+0x18/0x28
> [  195.330091]  work_for_cpu_fn+0x1c/0x30
> [  195.333831]  process_one_work+0x148/0x288
> [  195.337834]  worker_thread+0x32c/0x438
> [  195.341576]  kthread+0x118/0x11c
> [  195.344798]  ret_from_fork+0x10/0x20
> [  195.348369] Code: 910003fd f9000bf3 aa0003f3 97f98ae2 (f9400260)
> [  195.354451] ---[ end trace 0000000000000000 ]---
> 
> Bisect is pointing to the following commit ...
> 
> # first bad commit: [e56ff82e1e164ccf815554694d97bcd3dec9e89a] memcg: drain obj stock on cpu hotplug teardown

Thanks for the bisect, I'll go drop that one now and push out a new -rc

greg k-h
