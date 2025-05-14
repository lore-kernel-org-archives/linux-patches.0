Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046C327A461
	for <patches@lists.linux.dev>; Wed, 14 May 2025 17:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747242871; cv=none; b=RPYgcXs7KqJGKSAFBdib6Wv0KwtsZhL5XJYvFnTA8KqPZIms4+8CMcnfRmVf2zXLu5nEEpafsnTIt6XiFf2Mljn6f/+sO7+p7cD3aeZQiQM5XsW/5X6OybuVK2ZHA0UK4pzkwj9huKW2hDPgfc98WX+7x0ngFSmAkbEuGIcZUR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747242871; c=relaxed/simple;
	bh=S/K1zsUF7eLsrRUFZOdB1YfAGqHwutjswN+i2l4kwXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=macF1/8EQrbOTXCeiYVvGe2sze2HBXJ8ZR0sIbL0WFarBIzIHi5QEd2O6i8sU0HOw8Grb1ASPgdeL0T52v+8gmLzmu/ewlJIZ4LdbPyk0FdYKUt9wDgWRsIBXzXXzkphzTEfcnMSxoDv3VP41HihYBqbHF6p0ys+aoMAUwEVQoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RaOwWc91; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RaOwWc91"
Received: from [100.65.162.40] (unknown [20.236.11.69])
	by linux.microsoft.com (Postfix) with ESMTPSA id F05C5211B7AC;
	Wed, 14 May 2025 10:14:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F05C5211B7AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1747242869;
	bh=vhVY/JQGbSryNshzZz8qJI1/wNOosPR4nvGb9r2ZXLI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RaOwWc914e5RgadGPG6SCxAen6STpf/HWDyAPrkvuF7Ctrk+un2ZJnqOU46sOoxLO
	 /EpgvM6BunyNJJe+5Kr/KMDP1PngmEJz4xKCP7QHPwkEfHO9BcaOucDK4AVlAHAykz
	 bigP6ObOIB0tCMbRvmXg6nay+bzxiDLeiPOBtN8s=
Message-ID: <51587714-f363-43a5-96e0-9071c0cac8d6@linux.microsoft.com>
Date: Wed, 14 May 2025 10:14:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172015.643809034@linuxfoundation.org>
Content-Language: en-US
From: Hardik Garg <hargar@linux.microsoft.com>
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The kernel, bpf tool and perf tool builds fine for v5.15.183-rc1 on x86
and arm64 Azure VM.

KernelCI with LTP and kselftest results: Tree: stable/linux-5.15.y 
<https://dashboard.kernelci.org/tree/3b8db0e4f2631c030ab86f78d199ec0b198578f3?o=microsoft&p=t&ti%7Cc=v5.15.182&ti%7Cch=3b8db0e4f2631c030ab86f78d199ec0b198578f3&ti%7Cgb=linux-5.15.y&ti%7Cgu=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fstable%2Flinux.git&ti%7Ct=stable>


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik

On 5/12/2025 10:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 5.15.183-rc1
>
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>      x86/bhi: Do not set BHI_DIS_S in 32-bit mode
>
> Daniel Sneddon <daniel.sneddon@linux.intel.com>
>      x86/bpf: Add IBHF call at end of classic BPF
>
> Daniel Sneddon <daniel.sneddon@linux.intel.com>
>      x86/bpf: Call branch history clearing sequence on exit
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Revert "net: phy: microchip: force IRQ polling mode for lan88xx"
>
> Al Viro <viro@zeniv.linux.org.uk>
>      do_umount(): add missing barrier before refcount checks in sync case
>
> Daniel Wagner <wagi@kernel.org>
>      nvme: unblock ctrl state transition for firmware update
>
> Kevin Baker <kevinb@ventureresearch.com>
>      drm/panel: simple: Update timings for AUO G101EVN010
>
> Thorsten Blum <thorsten.blum@linux.dev>
>      MIPS: Fix MAX_REG_OFFSET
>
> Jonathan Cameron <Jonathan.Cameron@huawei.com>
>      iio: adc: dln2: Use aligned_s64 for timestamp
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>      types: Complement the aligned types with signed 64-bit one
>
> Dave Penkler <dpenkler@gmail.com>
>      usb: usbtmc: Fix erroneous generic_read ioctl return
>
> Dave Penkler <dpenkler@gmail.com>
>      usb: usbtmc: Fix erroneous wait_srq ioctl return
>
> Dave Penkler <dpenkler@gmail.com>
>      usb: usbtmc: Fix erroneous get_stb ioctl error returns
>
> Oliver Neukum <oneukum@suse.com>
>      USB: usbtmc: use interruptible sleep in usbtmc_read
>
> Andrei Kuchynski <akuchynski@chromium.org>
>      usb: typec: ucsi: displayport: Fix NULL pointer access
>
> RD Babiera <rdbabiera@google.com>
>      usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition
>
> Jim Lin <jilin@nvidia.com>
>      usb: host: tegra: Prevent host controller crash when OTG port is used
>
> Wayne Chang <waynec@nvidia.com>
>      usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN
>
> Pawel Laszczak <pawell@cadence.com>
>      usb: cdnsp: fix L1 resume issue for RTL_REVISION_NEW_LPM version
>
> Pawel Laszczak <pawell@cadence.com>
>      usb: cdnsp: Fix issue with resuming from L1
>
> Jan Kara <jack@suse.cz>
>      ocfs2: stop quota recovery before disabling quotas
>
> Jan Kara <jack@suse.cz>
>      ocfs2: implement handshaking with ocfs2 recovery thread
>
> Jan Kara <jack@suse.cz>
>      ocfs2: switch osb->disable_recovery to enum
>
> Dmitry Antipov <dmantipov@yandex.ru>
>      module: ensure that kobject_put() is safe for module type kobjects
>
> Jason Andryuk <jason.andryuk@amd.com>
>      xenbus: Use kref to track req lifetime
>
> Alexey Charkov <alchark@gmail.com>
>      usb: uhci-platform: Make the clock really optional
>
> Wayne Lin <Wayne.Lin@amd.com>
>      drm/amd/display: Fix wrong handling for AUX_DEFER case
>
> Silvano Seva <s.seva@4sigma.it>
>      iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo
>
> Silvano Seva <s.seva@4sigma.it>
>      iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      iio: adis16201: Correct inclinometer channel resolution
>
> Angelo Dureghello <adureghello@baylibre.com>
>      iio: adc: ad7606: fix serial register access
>
> Dave Hansen <dave.hansen@linux.intel.com>
>      x86/mm: Eliminate window where TLB flushes may be inadvertently skipped
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      staging: axis-fifo: Remove hardware resets for user errors
>
> Gabriel Shahrouzi <gshahrouzi@gmail.com>
>      staging: iio: adc: ad7816: Correct conditional logic for store mode
>
> Aditya Garg <gargaditya08@live.com>
>      Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
>
> Dmitry Torokhov <dmitry.torokhov@gmail.com>
>      Input: synaptics - enable SMBus for HP Elitebook 850 G1
>
> Aditya Garg <gargaditya08@live.com>
>      Input: synaptics - enable InterTouch on Dell Precision M3800
>
> Aditya Garg <gargaditya08@live.com>
>      Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
>
> Manuel Fombuena <fombuena@outlook.com>
>      Input: synaptics - enable InterTouch on Dynabook Portege X30-D
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix learning on VLAN unaware bridges
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: always rejoin default untagged VLAN on bridge leave
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix flushing old pvid VLAN on pvid change
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: fix clearing PVID of a port
>
> Jonas Gorski <jonas.gorski@gmail.com>
>      net: dsa: b53: allow leaky reserved multicast
>
> Jozsef Kadlecsik <kadlec@netfilter.org>
>      netfilter: ipset: fix region locking in hash types
>
> Oliver Hartkopp <socketcan@hartkopp.net>
>      can: gw: fix RCU/BH usage in cgw_create_job()
>
> Uladzislau Rezki (Sony) <urezki@gmail.com>
>      rcu/kvfree: Add kvfree_rcu_mightsleep() and kfree_rcu_mightsleep()
>
> Eric Dumazet <edumazet@google.com>
>      can: gw: use call_rcu() instead of costly synchronize_rcu()
>
> Guillaume Nault <gnault@redhat.com>
>      gre: Fix again IPv6 link-local address generation.
>
> Eelco Chaudron <echaudro@redhat.com>
>      openvswitch: Fix unsafe attribute parsing in output_userspace()
>
> Marc Kleine-Budde <mkl@pengutronix.de>
>      can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls
>
> Marc Kleine-Budde <mkl@pengutronix.de>
>      can: mcan: m_can_class_unregister(): fix order of unregistration calls
>
>
> -------------
>
> Diffstat:
>
>   Makefile                                           |   4 +-
>   arch/mips/include/asm/ptrace.h                     |   3 +-
>   arch/x86/kernel/cpu/bugs.c                         |   5 +-
>   arch/x86/kernel/cpu/common.c                       |   9 +-
>   arch/x86/mm/tlb.c                                  |  23 ++-
>   arch/x86/net/bpf_jit_comp.c                        |  52 +++++++
>   .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  28 +++-
>   drivers/gpu/drm/panel/panel-simple.c               |  25 +--
>   drivers/iio/accel/adis16201.c                      |   4 +-
>   drivers/iio/adc/ad7606_spi.c                       |   2 +-
>   drivers/iio/adc/dln2-adc.c                         |   2 +-
>   drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   6 +
>   drivers/input/mouse/synaptics.c                    |   5 +
>   drivers/net/can/m_can/m_can.c                      |   2 +-
>   drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
>   drivers/net/dsa/b53/b53_common.c                   |  36 +++--
>   drivers/net/phy/microchip.c                        |  46 +++++-
>   drivers/nvme/host/core.c                           |   3 +-
>   drivers/staging/axis-fifo/axis-fifo.c              |  14 +-
>   drivers/staging/iio/adc/ad7816.c                   |   2 +-
>   drivers/usb/cdns3/cdnsp-gadget.c                   |  31 ++++
>   drivers/usb/cdns3/cdnsp-gadget.h                   |   6 +
>   drivers/usb/cdns3/cdnsp-pci.c                      |  12 +-
>   drivers/usb/cdns3/cdnsp-ring.c                     |   3 +-
>   drivers/usb/cdns3/core.h                           |   3 +
>   drivers/usb/class/usbtmc.c                         |  59 +++++---
>   drivers/usb/gadget/udc/tegra-xudc.c                |   4 +
>   drivers/usb/host/uhci-platform.c                   |   2 +-
>   drivers/usb/host/xhci-tegra.c                      |   3 +
>   drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
>   drivers/usb/typec/ucsi/displayport.c               |   2 +
>   drivers/xen/xenbus/xenbus.h                        |   2 +
>   drivers/xen/xenbus/xenbus_comms.c                  |   9 +-
>   drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
>   drivers/xen/xenbus/xenbus_xs.c                     |  18 ++-
>   fs/namespace.c                                     |   3 +-
>   fs/ocfs2/journal.c                                 |  80 +++++++---
>   fs/ocfs2/journal.h                                 |   1 +
>   fs/ocfs2/ocfs2.h                                   |  17 ++-
>   fs/ocfs2/quota_local.c                             |   9 +-
>   fs/ocfs2/super.c                                   |   3 +
>   include/linux/rcupdate.h                           |   3 +
>   include/linux/types.h                              |   3 +-
>   include/uapi/linux/types.h                         |   1 +
>   kernel/params.c                                    |   4 +-
>   net/can/gw.c                                       | 167 +++++++++++++--------
>   net/ipv6/addrconf.c                                |  15 +-
>   net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
>   net/openvswitch/actions.c                          |   3 +-
>   49 files changed, 538 insertions(+), 204 deletions(-)
>
>
