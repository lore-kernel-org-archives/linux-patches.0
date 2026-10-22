Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792665923;
	b=mZkkwufP0YmppOQDpcikAmNTjnDwiHOk3wPwBpFv/e5u19UX908pJX/WHg7mIo/MpIrR
	 KKqJQzu7K5JUmjdBFhGouKgGzGJfzstCNPegwME0+iRPlJuCU0rqb9WgKXCsK1wGwFtJq
	 iqKVV0FtKiNWqaJvvPYv/ddG5szQ3PWftHzEIHR+DiVVqEwfWDk6V81hRO21q6PlIl28J
	 drQIDnOeAtIUMQACEB8Mbq64XRJ8Dm23mOEGP1j5Bm3A9dmCHxhksuXNDlRRiuzBTZ9fa
	 nt5ClN0QoKAHoTFl0DV2MZuoviTByRVHyWNgQiFhl+sTcB6V/ER/u82dYTEWW6qFPjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792665923;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=N9HHi9fwsvtU7offP25Wt0v5zoGj3/L7qJNeRlZeT70=;
	b=EZuZ4Q/M7Mb+F8GXhSR9ozG6gBAEcMLQs4o9ud2DUXBVvxWmAia6iGA0qQjKlNzSsevp
	 U6z8rHYA4tfMxHMPCIrS1s1b1miSqXbP0bt1+oicWlla5C2Fhsk+NRvf6hRfq+0g1qDFU
	 Ej0mrff7V6JgA8GMMdB4mgBh7cvHLSxGkx1+hepHM7DwaeQpbQtGsEIe77jgZ9VL0SUM1
	 QnYhnWf9/9il3pNR0wOE03zbTz60xoy1tfxLCcMXyt8M8g52WoeVzJXT3OH6A5zeKkaz7
	 UoWpdOHHZv9vJNo0q2L4Rej2rIFo2Jzj9lLyV0agrX0tOxkVBRzZ9zNJrSBpFPxhZ2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ysvry8ZX;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790D9606A31E
	for <patches@lists.linux.dev>; Thu, 22 Oct 2026 10:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 790D9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ysvry8ZX
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99D682C41;
	Thu, 22 Oct 2026 03:45:18 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D4D23F7B4;
	Thu, 22 Oct 2026 03:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792665921; bh=3X3M0isCHv6Nxso4ETuGI+iVhS7OfF0HzavL3Pe1L5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ysvry8ZXBjN5H5Sa8n2Coo4qA4hYONE9ARB0xYkDq400NhtvRacaBACac238WWGzK
	 gtdPXPBH5l1VXOSE7ctgVVxROasRRgctXfzScNG7d5P+8MeRRl9OLEbnWm73LoO9UT
	 5NHiXmkt+7hHvmraRUYBIdQh1z3a6C67ph3Hl4OI=
Message-ID: <05e5d99a-c12f-4fb9-b632-2301f21d54c7@arm.com>
Date: Thu, 22 Oct 2026 11:45:18 +0100
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
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1792443633.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <cover.1792443633.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 19/10/2026 23:07, Reinette Chatre wrote:
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

On an initial look through the patches everything seems sensible and in line with what we discussed
previously. I've given it a quick sanity check on a couple of models and nothing goes wrong. Is
there any particular shape of system needed to exercise corner cases? I'll try with monitor only
systems and control only systems and do some more testing on real hardware as well.

Thank you very much for taking so much care over the MPAM side of things.

Ben

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

