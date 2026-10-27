Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793072530;
	b=ui7wTV2NfkAyTd11TYvCXVsMWATXFX/osU/FjVNfStUOyp5gW4FH04EeMtx1jmLab5Gc
	 KXZEuA/vvqUKCSljAftYouQid4je9rAJfl8No2Rrotraaaoo/kSV7Sv2yfOGiwxbZ4Iga
	 3xcm32Gd0WD2GyJmAhR/3VxunXXqAjRzC8svtn81fSQeQJDKltvxH/+3CSsuynDs8SowP
	 fSE68VphAXAZonAn/N/lQ5XvQ0pWIq/ZxkMDgv2Y3NmNfvI6WReEEzb17co83+/oxz7eh
	 6i0DRYVR7upBWYXjz2+wwKTKitxwm4S1M+jjARxoV6lae7UxEPEgs6WVdzHY/rXqqsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793072530;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=YDlSsGkPiCD2jaBiZMMJ7ZD6fj3FrxVPQZM0mqrVkUo=;
	b=rFPzDM1OquYSQLNP0WzcKn8N+uLmGXsIMiw6sSaHI3SRedlW1n1Q/8TtuB/u0AJ8LTYd
	 0vQFRdcLTwL12LMOOK3f6uVcQy59RSx6xsraO+gxSxYaVoa0EwmxnxQaO+0vkw2xDfug3
	 B7Ir8/KujrNivoflcAvfcbn5HYAfL/zN3vwnlkPv2nyHkmxMNfgoKO5ZFR4TLXW1xZMLQ
	 TkuUTBZmt0KWCXG64xBG1oZTO0ptck44NkSoJhrJcMt5Kz4dHwGH1qOspIBrcC/99Mxdj
	 1exfevCg/7yCMKvjl+AkRiotiHfB6vfZnocqm9BWkODU6Izosy6Tr5OwmliVeo8zHiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Ve8Rl2Ol;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E2606A31A
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 03:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 258E2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Ve8Rl2Ol
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YDlSsGkPiCD2jaBiZMMJ7ZD6fj3FrxVPQZM0mqrVkUo=;
	b=Ve8Rl2OlROcGd6JfjoBap6gzrYog0dukM4EGqiglM7cUOhIPim1yGQfqo7DvPO8e7s29+WLz5
	e5xFnapvOYPiJHZ/sIQWb1FedKQ4KAgvUgpsBE7MLMvukG2c8kUdX4Pcv+HFRULe+j5z+jgdkTf
	xGLQB0/tbrmqdxxXrOySlpc=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jDGWq33R0zmV7W;
	Tue, 27 Oct 2026 11:41:59 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 00BFA40592;
	Tue, 27 Oct 2026 11:42:05 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 27 Oct
 2026 11:42:04 +0800
Message-ID: <9e0521af-4ae2-4a53-bbd5-2d86cceb69c3@huawei.com>
Date: Tue, 27 Oct 2026 11:42:03 +0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/10] arm_mpam: resctrl: Separate MPAM domains
To: Reinette Chatre <reinette.chatre@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <yu.c.chen@intel.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1792443633.git.reinette.chatre@intel.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/10/20 6:07, Reinette Chatre 写道:
> RFC v1: https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/
> 
> The MPAM driver represents a resctrl domain with a single structure,
> struct mpam_resctrl_dom, that holds both a control domain and a
> monitoring domain. On a system that supports both allocation and
> monitoring, one instance is created for each domain and its two
> domains are added to the resource's control and monitoring domain
> lists.
> 
> Holding both domains in one structure requires control and monitoring
> to be done at the same scope, and ties each control domain to a
> monitoring domain. This does not fit the proposed support for multiple
> controls per resource [1]. There, each control of a resource, for
> example a "min" and a "max" memory bandwidth control, has its own list
> of control domains while the resource keeps a single list of
> monitoring domains. With one structure for both, every control domain
> would come with a monitoring domain of its own, which does not reflect
> the resource.
> 
> This series gives control and monitoring domains their own structures,
> set up and torn down independently as CPUs come online and go offline,
> in preparation for supporting multiple controls per resource. Along
> the way it stops failing CPU online when a domain cannot be set up,
> and adds checks when setting up a monitoring domain.
> 
>   1-2   Preparatory cleanups of domain allocation
>   3     Do not fail CPU online when domain setup fails
>   4-6   Separate the control and monitoring domain structures
>   7-9   Checks when setting up a monitoring domain
>   10    Comment update, kept separate for review
> 
> An earlier version of the domain split was posted on its own [2]. This
> version incorporates the feedback from that discussion. It gives each
> type of domain its own structure instead of duplicating the shared
> one, sets up each domain independently instead of undoing one domain
> when setting up the other fails, and adds the checks in patches 8 and
> 9.
> 
> Patch 7 turns a WARN_ON_ONCE(0) into a warning that fires. It is a
> separate patch because it is not clear whether the silent failure was
> intended. If it was, the patch can instead drop the dead
> WARN_ON_ONCE().
> 
> This is an RFC because I am only able to compile test MPAM changes,
> which is also why the patches are small and each change is justified
> on its own. Patches can be squashed if preferred, for example patch 10
> into patches 5 and 9. Testing on MPAM hardware would be greatly
> appreciated, as is any other feedback.

Hi Reinette,

I tested it on a QEMU with MPAM rebased on v7.3-rc6 and all pass:

1、Resctrl mounts，L3/L2 each report 32 closids (control IDs)
2、Cache and memory bandwidth controls
3、Priority, min, max, option and hard-limit: write, read back, and the

   emulated hardware shows the same value
4、CDP mode and usage/bandwidth counters
5、All builds pass without warnings: arm64/x86_64, debug on/off,
   self-tests on/off, resctrl off, ACPI off

Test cases: https://github.com/ruanjinjie-eng/mpam_testcase/tree/qemu

Tested-by: Jinjie Ruan ruanjinjie@huawei.com

> 
> The series is based on the for-next/mpam branch of the arm64 tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
> 
> [1] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/
> [2] https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/
> 
> Reinette Chatre (10):
>   arm_mpam: resctrl: Use find_component() when allocating a domain
>   arm_mpam: resctrl: Rename ctrl_comp in mpam_resctrl_alloc_domain()
>   arm_mpam: resctrl: Do not fail CPU online when domain setup fails
>   arm_mpam: resctrl: Split control and monitoring domain setup into
>     helpers
>   arm_mpam: resctrl: Give the monitoring domain its own structure
>   arm_mpam: resctrl: Rename struct mpam_resctrl_dom to
>     mpam_resctrl_ctrl_dom
>   arm_mpam: resctrl: Warn when no monitoring component is found for a
>     CPU
>   arm_mpam: resctrl: Require a component for each monitoring event
>   arm_mpam: resctrl: Require monitoring components to cover the same
>     CPUs
>   arm_mpam: resctrl: Update the comment on monitoring domain setup
> 
>  drivers/resctrl/mpam_devices.c  |   2 +-
>  drivers/resctrl/mpam_internal.h |  11 +-
>  drivers/resctrl/mpam_resctrl.c  | 325 +++++++++++++++++---------------
>  3 files changed, 181 insertions(+), 157 deletions(-)
> 
> 
> base-commit: 8ea457f746d915d55f78b43d33b1cd618f3d93ad

-- 
Best regards,
Jinjie

