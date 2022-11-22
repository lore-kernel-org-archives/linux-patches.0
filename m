Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF8ECA
	for <patches@lists.linux.dev>; Tue, 22 Nov 2022 06:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669099738; x=1700635738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+I076UAu55BbcMX+yfyOGHYpp5nuDpbjYkxRHRfMDKU=;
  b=WyGX3zAtFNb+Dhup2VGPAXBJGMGnfJ1i+wK+sAdZqbbgxqt20Ke9auZs
   dyI6WdKlJ8wXpDaz3CIFu8fQjCrNC3n00ggfrqmWlEsJsCkJ1rgbnGX5t
   SaZXBosFZ9wErlFCakZAjD8lh1m4Lydqwin7bMyISC1yiNbuzEq6khjBz
   glsVo/vpDZpgTdsMHHw773l74Wz/0kkUXkKmnB+901WwfZAhtchGLrLWG
   sBJI/T1iJpXA474f/NYBvX0Eh60Zz2uV4wn3U/p3cEWPVoDu9diJOxspC
   9VqtjfOrGP037xDax9UinqnkJdbkxC6HdDt8Vfnl9VaUxA+Q2yzllAOka
   w==;
X-IronPort-AV: E=Sophos;i="5.96,183,1665417600"; 
   d="scan'208";a="222023816"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2022 14:47:50 +0800
IronPort-SDR: p6BEt5NncU9RxtoZvqkRwEsiukWQFswJhzuC2M6a6E0RaYjRYWa6TUS46g+9Ps2GjOhxWdxmr4
 IbySeds8+QZcjpkX+MgSTa95M5VYpJpUeYSDO6XP1lwZEGZeIqgCxsY+mboH2/bEuh496CS4m9
 VdxyyQIpQorp2uF9SIyNbXmxNo3+a8dkNydMiqRHpMUfmE2gdXmA6wzUH23QPmAfp4nGex/5Cn
 r5Nhk828I6kuCngDc7y4MwxKWdzUN/EE88OdN/79w6s2B+G4DV3C3DfQi/+2fKBL0TG6dt7rlg
 LgE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2022 22:00:54 -0800
IronPort-SDR: Su8v8kbX0p2gsEG5S0KIDoRgfsNrRI4u+XFdf2Vv+SLWhbPQZqmdsp4uBArefICaASrU8JFI4G
 2y5dAgNH40gwi9JwKIO213ng90ol5TG9WuNn450hUnkpOJ8ZP1beltpcH766q5JUIDhifrZ/zp
 tQz6mIw3klxEuf7tItTw3fdUQrHEK5N6AHQjl+McKi2fcDUR1L2qMEHBWaNW1Ejl/H1vIa/ZBG
 PUlcmY3BNlXhDTkURuJtm9VgJ96Y87LfND9k4sYl3GTxkUfuqYWZuWJMtEuYvaR8gGBNoeiQnw
 DhY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2022 22:47:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NGZZZ0fYJz1RvTp
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 22:47:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:references:to:content-language
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1669099666; x=1671691667; bh=+I076UAu55BbcMX+yfyOGHYpp5nuDpbjYkx
	RHRfMDKU=; b=HCqKBH+/q4194RNrsfvoOa72dH3aFTetZGM+QT4qaHUGPJbFws6
	UiUNq0VEcREXlWyS+1ckDH7LL7qALCVLlLzoXJKZJ5BKwbP3Sxlz9KqykasiHk+S
	2HP1iwUUgvZb2YrtH8rYeNyHbx96rNjxm4pYvYI6c0SyNixv5UVzodxUHttT7L03
	VcL40/EpmZAZHsTGg3ZkDU20lMHn5BYtmUiGsjWvQV+xV1PN6NTujZ/hW/HG/rWv
	2FTvQENGL733KfBM3NMvVK20p6TWUMBPFEWf7fjYgWFi9Hhyn9w9KkVuoTc60FiG
	mSo2yqyoTWCxDAIwVhzcu4Hz8YxRt4tYZ5g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3cqo2ghpX70m for <patches@lists.linux.dev>;
	Mon, 21 Nov 2022 22:47:46 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NGZZK5Hbqz1RvLy;
	Mon, 21 Nov 2022 22:47:37 -0800 (PST)
Message-ID: <16965868-89c5-6b3a-da23-fd616ab91dd1@opensource.wdc.com>
Date: Tue, 22 Nov 2022 15:47:36 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 12/12] mm, slob: rename CONFIG_SLOB to
 CONFIG_SLOB_DEPRECATED
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Aaro Koskinen <aaro.koskinen@iki.fi>,
 Janusz Krzysztofik <jmkrzyszt@gmail.com>, Tony Lindgren <tony@atomide.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>,
 Conor Dooley <conor@kernel.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
 openrisc@lists.librecores.org, linux-riscv@lists.infradead.org,
 linux-sh@vger.kernel.org
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-13-vbabka@suse.cz>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221121171202.22080-13-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/22 02:12, Vlastimil Babka wrote:
> As explained in [1], we would like to remove SLOB if possible.
> 
> - There are no known users that need its somewhat lower memory footprint
>   so much that they cannot handle SLUB (after some modifications by the
>   previous patches) instead.
> 
> - It is an extra maintenance burden, and a number of features are
>   incompatible with it.
> 
> - It blocks the API improvement of allowing kfree() on objects allocated
>   via kmem_cache_alloc().
> 
> As the first step, rename the CONFIG_SLOB option in the slab allocator
> configuration choice to CONFIG_SLOB_DEPRECATED. Add CONFIG_SLOB
> depending on CONFIG_SLOB_DEPRECATED as an internal option to avoid code
> churn. This will cause existing .config files and defconfigs with
> CONFIG_SLOB=y to silently switch to the default (and recommended
> replacement) SLUB, while still allowing SLOB to be configured by anyone
> that notices and needs it. But those should contact the slab maintainers
> and linux-mm@kvack.org as explained in the updated help. With no valid
> objections, the plan is to update the existing defconfigs to SLUB and
> remove SLOB in a few cycles.
> 
> To make SLUB more suitable replacement for SLOB, a CONFIG_SLUB_TINY
> option was introduced to limit SLUB's memory overhead.
> There is a number of defconfigs specifying CONFIG_SLOB=y. As part of
> this patch, update them to select CONFIG_SLUB and CONFIG_SLUB_TINY.
> 
> [1] https://lore.kernel.org/all/b35c3f82-f67b-2103-7d82-7a7ba7521439@suse.cz/

For the riscv k210,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Also, if these patches do not change from what I tested, feel free to add:

Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Thanks !

> 
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Janusz Krzysztofik <jmkrzyszt@gmail.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> Cc: Stafford Horne <shorne@gmail.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Conor Dooley <conor@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: <linux-arm-kernel@lists.infradead.org>
> Cc: <linux-omap@vger.kernel.org>
> Cc: <openrisc@lists.librecores.org>
> Cc: <linux-riscv@lists.infradead.org>
> Cc: <linux-sh@vger.kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  arch/arm/configs/clps711x_defconfig            |  3 ++-
>  arch/arm/configs/collie_defconfig              |  3 ++-
>  arch/arm/configs/multi_v4t_defconfig           |  3 ++-
>  arch/arm/configs/omap1_defconfig               |  3 ++-
>  arch/arm/configs/pxa_defconfig                 |  3 ++-
>  arch/arm/configs/tct_hammer_defconfig          |  3 ++-
>  arch/arm/configs/xcep_defconfig                |  3 ++-
>  arch/openrisc/configs/or1ksim_defconfig        |  3 ++-
>  arch/openrisc/configs/simple_smp_defconfig     |  3 ++-
>  arch/riscv/configs/nommu_k210_defconfig        |  3 ++-
>  arch/riscv/configs/nommu_k210_sdcard_defconfig |  3 ++-
>  arch/riscv/configs/nommu_virt_defconfig        |  3 ++-
>  arch/sh/configs/rsk7201_defconfig              |  3 ++-
>  arch/sh/configs/rsk7203_defconfig              |  3 ++-
>  arch/sh/configs/se7206_defconfig               |  3 ++-
>  arch/sh/configs/shmin_defconfig                |  3 ++-
>  arch/sh/configs/shx3_defconfig                 |  3 ++-
>  kernel/configs/tiny.config                     |  5 +++--
>  mm/Kconfig                                     | 17 +++++++++++++++--
>  19 files changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/configs/clps711x_defconfig b/arch/arm/configs/clps711x_defconfig
> index 92481b2a88fa..adcee238822a 100644
> --- a/arch/arm/configs/clps711x_defconfig
> +++ b/arch/arm/configs/clps711x_defconfig
> @@ -14,7 +14,8 @@ CONFIG_ARCH_EDB7211=y
>  CONFIG_ARCH_P720T=y
>  CONFIG_AEABI=y
>  # CONFIG_COREDUMP is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_NET=y
>  CONFIG_PACKET=y
>  CONFIG_UNIX=y
> diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
> index 2a2d2cb3ce2e..69341c33e0cc 100644
> --- a/arch/arm/configs/collie_defconfig
> +++ b/arch/arm/configs/collie_defconfig
> @@ -13,7 +13,8 @@ CONFIG_CMDLINE="noinitrd root=/dev/mtdblock2 rootfstype=jffs2 fbcon=rotate:1"
>  CONFIG_FPE_NWFPE=y
>  CONFIG_PM=y
>  # CONFIG_SWAP is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_NET=y
>  CONFIG_PACKET=y
>  CONFIG_UNIX=y
> diff --git a/arch/arm/configs/multi_v4t_defconfig b/arch/arm/configs/multi_v4t_defconfig
> index e2fd822f741a..b60000a89aff 100644
> --- a/arch/arm/configs/multi_v4t_defconfig
> +++ b/arch/arm/configs/multi_v4t_defconfig
> @@ -25,7 +25,8 @@ CONFIG_ARM_CLPS711X_CPUIDLE=y
>  CONFIG_JUMP_LABEL=y
>  CONFIG_PARTITION_ADVANCED=y
>  # CONFIG_COREDUMP is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_MTD=y
>  CONFIG_MTD_CMDLINE_PARTS=y
>  CONFIG_MTD_BLOCK=y
> diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
> index 70511fe4b3ec..246f1bba7df5 100644
> --- a/arch/arm/configs/omap1_defconfig
> +++ b/arch/arm/configs/omap1_defconfig
> @@ -42,7 +42,8 @@ CONFIG_MODULE_FORCE_UNLOAD=y
>  CONFIG_PARTITION_ADVANCED=y
>  CONFIG_BINFMT_MISC=y
>  # CONFIG_SWAP is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  CONFIG_NET=y
>  CONFIG_PACKET=y
> diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
> index d60cc9cc4c21..0a0f12df40b5 100644
> --- a/arch/arm/configs/pxa_defconfig
> +++ b/arch/arm/configs/pxa_defconfig
> @@ -49,7 +49,8 @@ CONFIG_PARTITION_ADVANCED=y
>  CONFIG_LDM_PARTITION=y
>  CONFIG_CMDLINE_PARTITION=y
>  CONFIG_BINFMT_MISC=y
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_COMPACTION is not set
>  CONFIG_NET=y
>  CONFIG_PACKET=y
> diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
> index 3b29ae1fb750..6bd38b6f22c4 100644
> --- a/arch/arm/configs/tct_hammer_defconfig
> +++ b/arch/arm/configs/tct_hammer_defconfig
> @@ -19,7 +19,8 @@ CONFIG_FPE_NWFPE=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
>  # CONFIG_SWAP is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_NET=y
>  CONFIG_PACKET=y
>  CONFIG_UNIX=y
> diff --git a/arch/arm/configs/xcep_defconfig b/arch/arm/configs/xcep_defconfig
> index ea59e4b6bfc5..6bd9f71b71fc 100644
> --- a/arch/arm/configs/xcep_defconfig
> +++ b/arch/arm/configs/xcep_defconfig
> @@ -26,7 +26,8 @@ CONFIG_MODULE_UNLOAD=y
>  CONFIG_MODVERSIONS=y
>  CONFIG_MODULE_SRCVERSION_ALL=y
>  # CONFIG_BLOCK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_COMPAT_BRK is not set
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  CONFIG_NET=y
> diff --git a/arch/openrisc/configs/or1ksim_defconfig b/arch/openrisc/configs/or1ksim_defconfig
> index 6e1e004047c7..0116e465238f 100644
> --- a/arch/openrisc/configs/or1ksim_defconfig
> +++ b/arch/openrisc/configs/or1ksim_defconfig
> @@ -10,7 +10,8 @@ CONFIG_EXPERT=y
>  # CONFIG_AIO is not set
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  # CONFIG_COMPAT_BRK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_MODULES=y
>  # CONFIG_BLOCK is not set
>  CONFIG_OPENRISC_BUILTIN_DTB="or1ksim"
> diff --git a/arch/openrisc/configs/simple_smp_defconfig b/arch/openrisc/configs/simple_smp_defconfig
> index ff49d868e040..b990cb6c9309 100644
> --- a/arch/openrisc/configs/simple_smp_defconfig
> +++ b/arch/openrisc/configs/simple_smp_defconfig
> @@ -16,7 +16,8 @@ CONFIG_EXPERT=y
>  # CONFIG_AIO is not set
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  # CONFIG_COMPAT_BRK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_MODULES=y
>  # CONFIG_BLOCK is not set
>  CONFIG_OPENRISC_BUILTIN_DTB="simple_smp"
> diff --git a/arch/riscv/configs/nommu_k210_defconfig b/arch/riscv/configs/nommu_k210_defconfig
> index 96fe8def644c..79b3ccd58ff0 100644
> --- a/arch/riscv/configs/nommu_k210_defconfig
> +++ b/arch/riscv/configs/nommu_k210_defconfig
> @@ -25,7 +25,8 @@ CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>  CONFIG_EMBEDDED=y
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  # CONFIG_COMPAT_BRK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_MMU is not set
>  CONFIG_SOC_CANAAN=y
>  CONFIG_NONPORTABLE=y
> diff --git a/arch/riscv/configs/nommu_k210_sdcard_defconfig b/arch/riscv/configs/nommu_k210_sdcard_defconfig
> index 379740654373..6b80bb13b8ed 100644
> --- a/arch/riscv/configs/nommu_k210_sdcard_defconfig
> +++ b/arch/riscv/configs/nommu_k210_sdcard_defconfig
> @@ -17,7 +17,8 @@ CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>  CONFIG_EMBEDDED=y
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  # CONFIG_COMPAT_BRK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_MMU is not set
>  CONFIG_SOC_CANAAN=y
>  CONFIG_NONPORTABLE=y
> diff --git a/arch/riscv/configs/nommu_virt_defconfig b/arch/riscv/configs/nommu_virt_defconfig
> index 1a56eda5ce46..4cf0f297091e 100644
> --- a/arch/riscv/configs/nommu_virt_defconfig
> +++ b/arch/riscv/configs/nommu_virt_defconfig
> @@ -22,7 +22,8 @@ CONFIG_EXPERT=y
>  # CONFIG_KALLSYMS is not set
>  # CONFIG_VM_EVENT_COUNTERS is not set
>  # CONFIG_COMPAT_BRK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_MMU is not set
>  CONFIG_SOC_VIRT=y
>  CONFIG_NONPORTABLE=y
> diff --git a/arch/sh/configs/rsk7201_defconfig b/arch/sh/configs/rsk7201_defconfig
> index 619c18699459..376e95fa77bc 100644
> --- a/arch/sh/configs/rsk7201_defconfig
> +++ b/arch/sh/configs/rsk7201_defconfig
> @@ -10,7 +10,8 @@ CONFIG_USER_NS=y
>  CONFIG_PID_NS=y
>  CONFIG_BLK_DEV_INITRD=y
>  # CONFIG_AIO is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_PROFILING=y
>  CONFIG_MODULES=y
>  # CONFIG_BLK_DEV_BSG is not set
> diff --git a/arch/sh/configs/rsk7203_defconfig b/arch/sh/configs/rsk7203_defconfig
> index d00fafc021e1..1d5fd67a3949 100644
> --- a/arch/sh/configs/rsk7203_defconfig
> +++ b/arch/sh/configs/rsk7203_defconfig
> @@ -11,7 +11,8 @@ CONFIG_USER_NS=y
>  CONFIG_PID_NS=y
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_KALLSYMS_ALL=y
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_PROFILING=y
>  CONFIG_MODULES=y
>  # CONFIG_BLK_DEV_BSG is not set
> diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
> index 122216123e63..78e0e7be57ee 100644
> --- a/arch/sh/configs/se7206_defconfig
> +++ b/arch/sh/configs/se7206_defconfig
> @@ -21,7 +21,8 @@ CONFIG_BLK_DEV_INITRD=y
>  CONFIG_KALLSYMS_ALL=y
>  # CONFIG_ELF_CORE is not set
>  # CONFIG_COMPAT_BRK is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_PROFILING=y
>  CONFIG_MODULES=y
>  CONFIG_MODULE_UNLOAD=y
> diff --git a/arch/sh/configs/shmin_defconfig b/arch/sh/configs/shmin_defconfig
> index c0b6f40d01cc..e078b193a78a 100644
> --- a/arch/sh/configs/shmin_defconfig
> +++ b/arch/sh/configs/shmin_defconfig
> @@ -9,7 +9,8 @@ CONFIG_LOG_BUF_SHIFT=14
>  # CONFIG_FUTEX is not set
>  # CONFIG_EPOLL is not set
>  # CONFIG_SHMEM is not set
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  # CONFIG_BLK_DEV_BSG is not set
>  CONFIG_CPU_SUBTYPE_SH7706=y
>  CONFIG_MEMORY_START=0x0c000000
> diff --git a/arch/sh/configs/shx3_defconfig b/arch/sh/configs/shx3_defconfig
> index 32ec6eb1eabc..aa353dff7f19 100644
> --- a/arch/sh/configs/shx3_defconfig
> +++ b/arch/sh/configs/shx3_defconfig
> @@ -20,7 +20,8 @@ CONFIG_USER_NS=y
>  CONFIG_PID_NS=y
>  # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
>  CONFIG_KALLSYMS_ALL=y
> -CONFIG_SLOB=y
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
>  CONFIG_PROFILING=y
>  CONFIG_KPROBES=y
>  CONFIG_MODULES=y
> diff --git a/kernel/configs/tiny.config b/kernel/configs/tiny.config
> index 8a44b93da0f3..c2f9c912df1c 100644
> --- a/kernel/configs/tiny.config
> +++ b/kernel/configs/tiny.config
> @@ -7,5 +7,6 @@ CONFIG_KERNEL_XZ=y
>  # CONFIG_KERNEL_LZO is not set
>  # CONFIG_KERNEL_LZ4 is not set
>  # CONFIG_SLAB is not set
> -# CONFIG_SLUB is not set
> -CONFIG_SLOB=y
> +# CONFIG_SLOB_DEPRECATED is not set
> +CONFIG_SLUB=y
> +CONFIG_SLUB_TINY=y
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 5941cb34e30d..dcc49c69552f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -219,17 +219,30 @@ config SLUB
>  	   and has enhanced diagnostics. SLUB is the default choice for
>  	   a slab allocator.
>  
> -config SLOB
> +config SLOB_DEPRECATED
>  	depends on EXPERT
> -	bool "SLOB (Simple Allocator)"
> +	bool "SLOB (Simple Allocator - DEPRECATED)"
>  	depends on !PREEMPT_RT
>  	help
> +	   Deprecated and scheduled for removal in a few cycles. SLUB
> +	   recommended as replacement. CONFIG_SLUB_TINY can be considered
> +	   on systems with 16MB or less RAM.
> +
> +	   If you need SLOB to stay, please contact linux-mm@kvack.org and
> +	   people listed in the SLAB ALLOCATOR section of MAINTAINERS file,
> +	   with your use case.
> +
>  	   SLOB replaces the stock allocator with a drastically simpler
>  	   allocator. SLOB is generally more space efficient but
>  	   does not perform as well on large systems.
>  
>  endchoice
>  
> +config SLOB
> +	bool
> +	default y
> +	depends on SLOB_DEPRECATED
> +
>  config SLUB_TINY
>  	bool "Configure SLUB for minimal memory footprint"
>  	depends on SLUB && EXPERT

-- 
Damien Le Moal
Western Digital Research

