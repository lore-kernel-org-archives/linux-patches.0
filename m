Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AAE5A79B;
	Thu,  8 May 2025 11:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746703493; cv=none; b=kUsk8B3R3XygBfOFNjJtZpdSt+ZGVwEK5OcH0kErstF0EOYeYOQJeNT+PttIANvZzfdangM4loXoPKIKJA4MATEzRjZSs/07EaQc07dPDQ2pjTJMpQ1BXbkH/qVFpdvV9BbsUN9STHT9ti/I+afMWVxgiMqlGjC6vQboT1FJdGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746703493; c=relaxed/simple;
	bh=RRwfTGeTIvNyVZy/AsMPNv+peATmffSL6coS5PTf8ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwUa3r9BZOcFQJRWZ31eSD5WEy9MnvEo36UEaKTG3063T0quXDH5p4wA+dxyglupACMIeQEyqhWqAOWCcrMn4IYbqlR073p91pYQgflmvUwD0VSxYE+QUOFR/oF23vo1x5qndiDNVbzg11yPFMOgCpxYOFUBrCpAOS3OTmM8tIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2bQ7BXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2bQ7BXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFC0C4CEE7;
	Thu,  8 May 2025 11:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746703492;
	bh=RRwfTGeTIvNyVZy/AsMPNv+peATmffSL6coS5PTf8ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L2bQ7BXGN3poNCo3gljF/N2EJaFrUuQU6M3QF8NhxIPWJWxQ3FxoljH0E8NPLSVrD
	 UePD9IL/SOD9yOfDRe3WmOjmXC3H7uWVCQ+Lbyn9qnn1LhLM3oWYA7ivDBSdwh3LYH
	 /Q6sHJEMcIk2s1qJPOuMS5S8monUwyOfa7NMj6aM=
Date: Thu, 8 May 2025 13:24:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
Message-ID: <2025050819-acquaint-guidable-5e97@gregkh>
References: <20250507183806.987408728@linuxfoundation.org>
 <864a7a10-ed68-4507-a67c-60344c57753a@rnnvmail203.nvidia.com>
 <2a83d6a6-9e80-4c78-94a6-5dedd3326367@nvidia.com>
 <55d3cdaf-539f-4d5b-8bf1-a2c5f917e81d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55d3cdaf-539f-4d5b-8bf1-a2c5f917e81d@nvidia.com>

On Thu, May 08, 2025 at 10:52:59AM +0100, Jon Hunter wrote:
> 
> On 08/05/2025 10:48, Jon Hunter wrote:
> > Hi Greg,
> > 
> > On 08/05/2025 10:45, Jon Hunter wrote:
> > > On Wed, 07 May 2025 20:38:35 +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.1.138 release.
> > > > There are 97 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/
> > > > patch-6.1.138-rc1.gz
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > > > stable-rc.git linux-6.1.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Failures detected for Tegra ...
> > > 
> > > Test results for stable-v6.1:
> > >      10 builds:    10 pass, 0 fail
> > >      28 boots:    28 pass, 0 fail
> > >      115 tests:    109 pass, 6 fail
> > > 
> > > Linux version:    6.1.138-rc1-gca7b19b902b8
> > > Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
> > >                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
> > >                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
> > >                  tegra210-p2371-2180, tegra210-p3450-0000,
> > >                  tegra30-cardhu-a04
> > > 
> > > Test failures:    tegra186-p2771-0000: cpu-hotplug
> > >                  tegra194-p2972-0000: pm-system-suspend.sh
> > >                  tegra210-p2371-2180: cpu-hotplug
> > >                  tegra210-p3450-0000: cpu-hotplug
> > 
> > 
> > I am seeing some crashes like the following ...
> > 
> > [  212.540298] Unable to handle kernel NULL pointer dereference at
> > virtual address 0000000000000000
> > [  212.549130] Mem abort info:
> > [  212.552008]   ESR = 0x0000000096000004
> > [  212.555822]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [  212.561151]   SET = 0, FnV = 0
> > [  212.564213]   EA = 0, S1PTW = 0
> > [  212.567361]   FSC = 0x04: level 0 translation fault
> > [  212.572246] Data abort info:
> > [  212.575137]   ISV = 0, ISS = 0x00000004
> > [  212.578980]   CM = 0, WnR = 0
> > [  212.581945] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000103824000
> > [  212.588394] [0000000000000000] pgd=0000000000000000,
> > p4d=0000000000000000
> > [  212.595199] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> > [  212.601465] Modules linked in: snd_soc_tegra210_mixer
> > snd_soc_tegra210_ope snd_soc_tegra186_asrc snd_soc_tegra210_adx
> > snd_soc_tegra210_amx snd_soc_tegra210_mvc snd_soc_tegra210_sfc
> > snd_soc_tegra210_admaif snd_soc_tegra186_dspk snd_soc_tegra210_dmic
> > snd_soc_tegra_pcm snd_soc_tegra210_i2s tegra_drm drm_dp_aux_bus cec
> > drm_display_helper drm_kms_helper snd_soc_tegra210_ahub tegra210_adma
> > drm snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card crct10dif_ce
> > snd_soc_simple_card_utils at24 tegra_bpmp_thermal tegra_aconnect
> > snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec snd_hda_core tegra_xudc
> > host1x ina3221 ip_tables x_tables ipv6
> > [  212.657003] CPU: 0 PID: 44 Comm: kworker/0:1 Tainted: G
> > S                 6.1.138-rc1-gca7b19b902b8 #1
> > [  212.666306] Hardware name: NVIDIA Jetson TX2 Developer Kit (DT)
> > [  212.672221] Workqueue: events work_for_cpu_fn
> > [  212.676588] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS
> > BTYPE=--)
> > [  212.683546] pc : percpu_ref_put_many.constprop.0+0x18/0xe0
> > [  212.689036] lr : percpu_ref_put_many.constprop.0+0x18/0xe0
> > [  212.694520] sp : ffff80000a5fbc70
> > [  212.697832] x29: ffff80000a5fbc70 x28: ffff800009ba3750 x27:
> > 0000000000000000
> > [  212.704970] x26: 0000000000000001 x25: 0000000000000028 x24:
> > 0000000000000000
> > [  212.712105] x23: ffff8001eb1a1000 x22: 0000000000000001 x21:
> > 0000000000000000
> > [  212.719240] x20: 0000000000000000 x19: 0000000000000000 x18:
> > ffffffffffffffff
> > [  212.726376] x17: 00000000000000a1 x16: 0000000000000001 x15:
> > fffffc0002017800
> > [  212.733510] x14: 00000000fffffffe x13: dead000000000100 x12:
> > dead000000000122
> > [  212.740645] x11: 0000000000000001 x10: 00000000f0000080 x9 :
> > 0000000000000000
> > [  212.747780] x8 : ffff80000a5fbc98 x7 : 00000000ffffffff x6 :
> > ffff80000a19c410
> > [  212.754914] x5 : ffff0001f4d44750 x4 : 0000000000000000 x3 :
> > 0000000000000000
> > [  212.762048] x2 : ffff8001eb1a1000 x1 : ffff000080a48ec0 x0 :
> > 0000000000000001
> > [  212.769184] Call trace:
> > [  212.771628]  percpu_ref_put_many.constprop.0+0x18/0xe0
> > [  212.776769]  memcg_hotplug_cpu_dead+0x60/0x90
> > [  212.781127]  cpuhp_invoke_callback+0x118/0x230
> > [  212.785574]  _cpu_down+0x180/0x3b0
> > [  212.788981]  __cpu_down_maps_locked+0x18/0x30
> > [  212.793339]  work_for_cpu_fn+0x1c/0x30
> > [  212.797086]  process_one_work+0x1cc/0x320
> > [  212.801097]  worker_thread+0x2c8/0x450
> > [  212.804846]  kthread+0x10c/0x110
> > [  212.808075]  ret_from_fork+0x10/0x20
> > [  212.811657] Code: 910003fd f9000bf3 aa0003f3 97f9c873 (f9400260)
> > [  212.817745] ---[ end trace 0000000000000000 ]---
> > 
> > I will kick off a bisect now.
> 
> 
> I wonder if it is this old chestnut again ...
> 
> Shakeel Butt <shakeel.butt@linux.dev>
>     memcg: drain obj stock on cpu hotplug teardown
> 
> I will try that first.

Argh, that one keeps slipping back in.  I'll go drop it from here, and
6.6.y as I don't see what would have fixed it from before.

thanks,

greg k-h
