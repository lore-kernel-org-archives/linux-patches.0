Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1E13081A1;
	Mon,  8 Sep 2025 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757344480; cv=none; b=D0rVh2DVLGViqfhxTPny5RaHb8OR92/sutxuFh9xCCJ9a+mpNWfhRUuVXWlTdo1qXP8NEyOGecu49QaVihlfqqYHq4lFyV7yJP2e86Zh9alEO8p5jIF7GA01MhCm7GMGBnMCm/fXL5lQHb7vMZbmzfNuhXZIQ1gX1cn2mIvOgz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757344480; c=relaxed/simple;
	bh=79P+uiW/3Rx2XvqTOgtNabeggJ9RJOW52VgPPXBiopY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1CqSuve18Criii481QuSaWAvQ7wTU3/IwzgsLY6h6UU58+g3FItpECS3Zyqc1FRuKO0C08PL4wBCNYU2KW2aBEUt9x2t6fO+9u07rgmJi4SFOlu1bAz38Fjk3tXxxffWWz+XVUmLpZMI3UG+vQqBQrRCp+Cn5bfyc+CZgJb950=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wd0+horH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wd0+horH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15EAC4CEF7;
	Mon,  8 Sep 2025 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757344478;
	bh=79P+uiW/3Rx2XvqTOgtNabeggJ9RJOW52VgPPXBiopY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wd0+horHyogQWpsC6Bw6EBOn9REsFgN2iyt3WQqsGWQ06OW/abB6va5XzvrZcA1K6
	 j9aywViLIc8N9zZ3wG2/J9INgQXhgR8iuf4RQ388thD0oe/IiHxLy/n3dDWvNosJwb
	 e+vcCywDdZimLHRIeK5ebSwU+BeD23PdlFw4Hb5E=
Date: Mon, 8 Sep 2025 17:14:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, linux-tegra@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.1 000/104] 6.1.151-rc1 review
Message-ID: <2025090808-distill-amulet-ef73@gregkh>
References: <20250907195607.664912704@linuxfoundation.org>
 <cb958521-10f7-4301-b1b8-54784e3d88e6@rnnvmail202.nvidia.com>
 <62ac3da6-25f6-4432-8b92-8e9ae60aacec@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ac3da6-25f6-4432-8b92-8e9ae60aacec@nvidia.com>

On Mon, Sep 08, 2025 at 04:04:49PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 08/09/2025 16:01, Jon Hunter wrote:
> > On Sun, 07 Sep 2025 21:57:17 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.151 release.
> > > There are 104 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.151-rc1.gz
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
> >      119 tests:	111 pass, 8 fail
> > 
> > Linux version:	6.1.151-rc1-g590deae50e08
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra186-p2771-0000: cpu-hotplug
> >                  tegra194-p2972-0000: pm-system-suspend.sh
> >                  tegra210-p2371-2180: cpu-hotplug
> >                  tegra210-p2371-2180: pm-system-suspend.sh
> >                  tegra210-p3450-0000: cpu-hotplug
> 
> 
> I am seeing crashes such as the following with this update ...
> 
> [  194.854833] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [  194.863956] Mem abort info:
> [  194.866939]   ESR = 0x0000000096000004
> [  194.870869]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  194.876385]   SET = 0, FnV = 0
> [  194.879609]   EA = 0, S1PTW = 0
> [  194.882919]   FSC = 0x04: level 0 translation fault
> [  194.887972] Data abort info:
> [  194.891007]   ISV = 0, ISS = 0x00000004
> [  194.895004]   CM = 0, WnR = 0
> [  194.898136] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109eff000
> [  194.904774] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
> [  194.911948] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> [  194.918345] Modules linked in: panel_simple snd_soc_tegra210_mixer snd_soc_tegra210_ope snd_soc_tegra210_adx snd_soc_tegra210_amx snd_soc_tegra210_admaif snd_soc_tegra210_mvc tegra_video(C) snd_soc_tegra210_sfc snd_soc_tegra210_dmic snd_soc_tegra_pcm v4l2_dv_timings snd_soc_tegra210_i2s videobuf2_dma_contig videobuf2_memops tegra_drm videobuf2_v4l2 videobuf2_common drm_dp_aux_bus videodev cec drm_display_helper mc drm_kms_helper tegra210_adma snd_soc_tegra210_ahub drm snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card snd_soc_simple_card_utils crct10dif_ce snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec snd_hda_core lp855x_bl tegra_aconnect tegra_soctherm tegra_xudc host1x pwm_tegra at24 ip_tables x_tables ipv6
> [  194.983279] CPU: 3 PID: 13107 Comm: rtcwake Tainted: G         C         6.1.150-00926-gd2622bc051fa #6
> [  194.992848] Hardware name: NVIDIA Jetson TX1 Developer Kit (DT)
> [  194.998870] pstate: a0000005 (NzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  195.005977] pc : percpu_ref_put_many.constprop.0+0x18/0xf0
> [  195.011654] lr : percpu_ref_put_many.constprop.0+0x18/0xf0
> [  195.017296] sp : ffff80000b1bba50
> [  195.020698] x29: ffff80000b1bba50 x28: ffff800009ba3770 x27: 0000000000000000
> [  195.028045] x26: 0000000000000001 x25: 0000000000000000 x24: ffff80000829c300
> [  195.035376] x23: ffff8000f4d85000 x22: ffff80000a19c898 x21: 0000000000000000
> [  195.042699] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
> [  195.050016] x17: 000000000000000e x16: 0000000000000001 x15: 0000000000000000
> [  195.057331] x14: 00000000fffffffc x13: dead000000000122 x12: 00000000f0000000
> [  195.064650] x11: dead000000000100 x10: 00000000f0000080 x9 : 0000000000000001
> [  195.071968] x8 : ffff80000b1bba40 x7 : 00000000ffffffff x6 : ffff80000a19c410
> [  195.079289] x5 : ffff0000fe928770 x4 : 0000000000000000 x3 : 0000000000000000
> [  195.086600] x2 : ffff8000f4d85000 x1 : ffff000081e9e740 x0 : 0000000000000001
> [  195.093916] Call trace:
> [  195.096449]  percpu_ref_put_many.constprop.0+0x18/0xf0
> [  195.101747]  memcg_hotplug_cpu_dead+0x60/0x90
> [  195.106259]  cpuhp_invoke_callback+0x100/0x200
> [  195.110843]  _cpu_down+0x17c/0x3b0
> [  195.114398]  freeze_secondary_cpus+0x124/0x200
> [  195.118980]  suspend_devices_and_enter+0x270/0x590
> [  195.123926]  pm_suspend+0x1f0/0x260
> [  195.127556]  state_store+0x80/0xf0
> [  195.131096]  kobj_attr_store+0x18/0x30
> [  195.134962]  sysfs_kf_write+0x44/0x60
> [  195.138766]  kernfs_fop_write_iter+0x120/0x1d0
> [  195.143353]  vfs_write+0x1b4/0x2f0
> [  195.146905]  ksys_write+0x70/0x110
> [  195.150454]  __arm64_sys_write+0x1c/0x30
> [  195.154525]  invoke_syscall+0x48/0x120
> [  195.158419]  el0_svc_common.constprop.0+0x44/0xf0
> [  195.163270]  do_el0_svc+0x24/0xa0
> [  195.166719]  el0_svc+0x2c/0x90
> [  195.169905]  el0t_64_sync_handler+0x114/0x120
> [  195.174401]  el0t_64_sync+0x18c/0x190
> [  195.178211] Code: 910003fd f9000bf3 aa0003f3 97f9caa7 (f9400260)
> [  195.184414] ---[ end trace 0000000000000000 ]---
> 
> I have bisected the above failures and it is pointing to the following commit ...
> 
> # first bad commit: [d2622bc051fa9f17af1ac06d4169567e8bf8fa2c] memcg: drain obj stock on cpu hotplug teardown

Odd.  Ok, let me drop this from this tree and 6.1.y and push out some
new -rcs with it removed to see if that makes things better.

Thanks for the report!

greg k-h
