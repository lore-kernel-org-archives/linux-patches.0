Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22013E7BBD
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901353; cv=none; b=sZ92A5iqXQcAIZPxND2wDU2hE/U5kiM8x7G+5HDyWBQMnjNZ6ooJrIFu8QpzpfoyhkCbg+41kGjqrfDLXq4Q8tknSVw5Wm6m3GZNurML7cqc5x7rqNEdbMsGtZWoqMTduXbFKAA89YzIM5CklxNUhJyQX+vosWQFEB/gkx1Isa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901353; c=relaxed/simple;
	bh=6MqaQwMH/q7325sYZ6Jc2k7OStmD7Ga4ztfzd9Wvbo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhxab/V9+KuXLeSplzBDW+Gq8lAJ7j0WhXSoAaL57u1P8C8d+Y9gaF5h70UH0sSZJuI+aS71ptOiXPn6zuFL39+w33j87j5AaaUuKnBPGnEr4sKYkAQs6NWyCE5fv/NOrSB1RfwAHtHCOKoARzsSDch+OGBKomUimgtN5lXxmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1Qp8RXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1Qp8RXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549CD1F000FF;
	Tue, 13 Oct 2026 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901352;
	bh=l/iJ9AHGhjv6BfjXp17x1MdBJNg09JJ1k2j6hOJnD3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1Qp8RXmolIvQ+zj7j1Na59enuwB300ytgq5qaGxfb2tS82Vx6ElFRqaa8WRD49JH
	 ir+CeFpG+ejd0jYP5sVkr88qXlxRHfBkZhwGS6dA2O+kUBQOfF5vf1ZvYP/24MvS4m
	 ALZOSH46DgLjFefsK9l67oeKH+PptKJZpud7ugH7CTpZXJUpT0DlhPt/maDIracuVl
	 U2BPD+F+pOPUwvfyKQP1Y3205qvRl3vszWFirDNmVZk4697lRFXqu/tkUAXrEE9URW
	 KQ75Had+xIY4/mUdkIK2Ls7cZjXRlgZ0208q7qWHcc0WFwoG+g4HqYTv78ruzruiTO
	 jVAonQrhBhM5Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id B1252F40066;
	Tue, 13 Oct 2026 10:22:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 13 Oct 2026 10:22:31 -0400
X-ME-Sender: <xms:pz7Oap_3hOHK8z7rX2mpE-CfIWnJYA3mm54aA2qaCEQQD1YfswJkXQ>
    <xme:pz7OantmkxlsXVnZwZBkUWFMOD8-fY6G7kGj7U69zELaAja1WxqyimSer9UXb68fC
    FAj-J5AVwqG0SqpX-XMkHgFWL27y5zo20SsWvlXOLzZz6DWpIvKkno>
X-ME-Received: <xmr:pz7Oatqyd51fpCabUE2vieUEzTFXvhL72_g49WYxDcAIYHB3FD5xkjTvqD3_SvKxB-rwYAlyMzVbEolwHZGeSCxIm_91IrNb>
X-ME-Proxy-Cause: dmFkZTFUB3jrhf7PHq3+eT7KjhsjVrf5GucPyjPlUVwJD+qxtOKQ4UxJ3aNq7QVOyvxcFI
    XivGsuWmmjArwu/P5rWhcnMnQS1k543nuFgMkFKLB6a/+ZwsVGEQwlvX4vUcVaEsgqQokW
    kdNC4A8MLhqwMYrocqm3HmP3TlZLmE5/ow0Ml2m3IM1qwqtT9YGsR29cYhkUszQEMouex7
    nW0nF+UT0ZV0bR63VsDLcaBUdNDQ4yJI7kHZ5GvhAAM7CjFQEn2/aFv+i72c9Q4TnOa8SQ
    sP79dCZbTUu/1JHyM39cVZjLCdsFQmpxRUZntGQjER6aG72FkJ48R4BitpMeTXChC/ocKx
    qCMOryFfK+dFWq+F6jjlHa08kxsMMaPyG2ODdz1WiyBBbv8hIAXiteSa9bPtkKW4j5dH18
    Gw3T5VTqGrRTVXqUz2VTt4epBMA9vQ59irnAnBdfdXh1SK+54J3Cc45rR2Jn6QSSsRA41I
    SRuIe4P/Qb/x7x4kLZsUGy9jn6QrTCl4TICHB6zV+aRGrmXfVr0ZPmn8JglY5zkvmcM5K6
    Dh9IzrvazsSNRvTbzV6esqkX/lXFcxg+DF30PzFD8FwlpYjg+dg1kkFOkAO38zgoiVNVbn
    rmceMwpu2D8xSmPQ4o2Q3pyKkrEMrlEkBOpoYOzHqsN02pAtLzdR0rrFFJsQ
X-ME-Proxy: <xmx:pz7OaroAV2R6agRySCs_qTeAq3bokxuF5S53aJDwIUesIvcSOHc_wQ>
    <xmx:pz7Oasa77V1_HEFbX4TAZM0gKacBMunzPNrKDmB7edrdL4TAj_ULqA>
    <xmx:pz7Oap-3KJafdPiZnozZPuLvvBAfIG6JFoonrwhjLdGHV1Fm0bV0SA>
    <xmx:pz7OaqndADSF4A6KCCjcrL5GzQ1dTjU1JoLu-jYXGPd88qwtObBpgA>
    <xmx:pz7Oamzs3N53WDyqlx0F3i5EGkkXtDTvDDg4TcuWojGWCOr5aEUT6ns_>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Oct 2026 10:22:31 -0400 (EDT)
Date: Tue, 13 Oct 2026 07:22:30 -0700
From: Boqun Feng <boqun@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 177/621] srcu: Use irq_work to start GP in tiny SRCU
Message-ID: <as4-pmlHAA-KpLwg@tardis.local>
References: <20261013112925.062661881@linuxfoundation.org>
 <20261013140916.139338-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013140916.139338-1-sj@kernel.org>

On Tue, Oct 13, 2026 at 07:09:16AM -0700, SJ Park wrote:
> Hello,
> 
> On Tue, 13 Oct 2026 13:32:52 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Joel Fernandes <joelagnelf@nvidia.com>
> > 
> > [ Upstream commit a6fc88b22bc8d12ad52e8412c667ec0f5bf055af ]
> > 
> > Tiny SRCU's srcu_gp_start_if_needed() directly calls schedule_work(),
> > which acquires the workqueue pool->lock.
> > 
> > This causes a lockdep splat when call_srcu() is called with a scheduler
> > lock held, due to:
> > 
> >   call_srcu() [holding pi_lock]
> >     srcu_gp_start_if_needed()
> >       schedule_work() -> pool->lock
> > 
> >   workqueue_init() / create_worker() [holding pool->lock]
> >     wake_up_process() -> try_to_wake_up() -> pi_lock
> > 
> > Also add irq_work_sync() to cleanup_srcu_struct() to prevent a
> > use-after-free if a queued irq_work fires after cleanup begins.
> > 
> > Tested with rcutorture SRCU-T and no lockdep warnings.
> > 
> > [ Thanks to Boqun for similar fix in patch "rcu: Use an intermediate irq_work
> > to start process_srcu()" ]
> > 
> > Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
> > Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> > Signed-off-by: Boqun Feng <boqun@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  include/linux/srcutiny.h |  4 ++++
> >  kernel/rcu/srcutiny.c    | 19 ++++++++++++++++++-
> >  2 files changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
> > index 51ce25f07930e..1f9a226e6fd81 100644
> > --- a/include/linux/srcutiny.h
> > +++ b/include/linux/srcutiny.h
> > @@ -11,6 +11,7 @@
> >  #ifndef _LINUX_SRCU_TINY_H
> >  #define _LINUX_SRCU_TINY_H
> >  
> > +#include <linux/irq_work_types.h>
> 
> I just found this makes UM build for kunit fails like below:
> 
> '''
> $ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/
> [07:00:33] Configuring KUnit Kernel ...
> [07:00:33] Building KUnit Kernel ...
> Populating config with:
> $ make ARCH=um O=.kunit olddefconfig
> Building with:
> $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=14
> ERROR:root:In file included from ../include/linux/srcu.h:59,
>                  from ../include/linux/notifier.h:16,
>                  from ../include/linux/memory_hotplug.h:7,
>                  from ../include/linux/mmzone.h:1538,
>                  from ../include/linux/gfp.h:7,
>                  from ../include/linux/slab.h:17,
>                  from ../include/linux/crypto.h:18,
>                  from ../arch/x86/um/shared/sysdep/kernel-offsets.h:5,
>                  from ../arch/um/kernel/asm-offsets.c:3:
> ../include/linux/srcutiny.h:14:10: fatal error: linux/irq_work_types.h: No such file or directory
>    14 | #include <linux/irq_work_types.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> '''
> 
> Seems commit c809f081fe40 ("irqwork: Move data struct to a types header") which
> made irq_work_types.h is not in the queue.  Below simple change fixed the issue
> on my setup.
> 
> '''
> diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
> index 1f9a226e6fd81..786693905accc 100644
> --- a/include/linux/srcutiny.h
> +++ b/include/linux/srcutiny.h
> @@ -11,7 +11,7 @@
>  #ifndef _LINUX_SRCU_TINY_H
>  #define _LINUX_SRCU_TINY_H
> 
> -#include <linux/irq_work_types.h>
> +#include <linux/irq_work.h>
>  #include <linux/swait.h>
> 
>  struct srcu_struct {
> '''
> 
> Cherry-picking the commit c809f081fe40 ("irqwork: Move data struct to a types
> header") also fixed the issue on my setup.
> 

Thank you for spotting this. Both fixes look good to me. I will let
stable team decide which one they want to proceed with, thanks!

Regards,
Boqun

> 
> Thanks,
> SJ
> 
> [...]
