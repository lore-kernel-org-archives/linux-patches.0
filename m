Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600DE296BA0
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756106455; cv=none; b=GpCDqg3P8DRoFyil62kMxvw5oXgN4zyqyGs7qs/OGGaPVTwKyo+cTbCsDSUm/QYrufmSRqckZE0off82B8mcWu5qqRMEwgS30lD7n7GnVClqCYyNG6OITba+8tZij2oWbgKAJ9YxCxNHPEiBChxdpH5/IaqKwqH9yefTq2+pgyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756106455; c=relaxed/simple;
	bh=58bfE69lKPQpn6bqCAeUJso9UWvQW8nmzGp5gae4qN8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CYBAtX3Bhtj6U9EkU2l0DegQlriWhtYo2/RMLWDeFZy6STOae4OQ3wMzyOPP18gxEpTCxvSlLwFlNtEVnbcCHtpJ9mMzO3zem0ETqLZHJoLxiQ7bdlNaEYhspKE+1p35GbS/wGBhyr24wr/vvtJFxLnB2bF1GDamaFrGJw6J+E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=a6OVE8xv; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="a6OVE8xv"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4c9Mds3gyWz9tfp;
	Mon, 25 Aug 2025 09:20:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1756106449; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kc+jnmb97nhx7hv+sdQ0FxANFqoWSC9un0Xi9kWhsmw=;
	b=a6OVE8xvesJa8ubbQuj3+5/nxjJUXpfau2CgfCyZNweqKaCR8EMeWr6TOfBjCIGVBwTWZw
	LEYsRRntT3Ra6UNOnG2A2IKtSQrX70dM6juu8yvPvKoeQHlvCA6gbZBVgMon9XdK+zsikT
	ite1YpEQHIoHEo4NK4OoBLAA1Qde1ultxjQdBjRFOW70eXfKcqeN7yKuY54tnslr4+6Chv
	Yt+7RXr4at14lTmUScgXIzeQVUWUeLlRs8TNAlEg0mskHos61n/pS+QKrDLNbo3OAoTkIe
	1RWw1OlIzVi8QE3BsaKgaucfVVGMTsYCUFjAjOCIJKtKKOilxf/syzpLwfA7sQ==
Message-ID: <f0f2694be1d40c31ae968677a2d6b8a37aae6cf6.camel@mailbox.org>
Subject: Re: [PATCH 6.16 256/570] drm/sched: Avoid memory leaks with
 cancel_job() callback
From: Philipp Stanner <phasta@mailbox.org>
Reply-To: phasta@kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, 
 =?ISO-8859-1?Q?Ma=EDra?= Canal
	 <mcanal@igalia.com>, Philipp Stanner <phasta@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Mon, 25 Aug 2025 09:20:43 +0200
In-Reply-To: <20250818124515.684210604@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
	 <20250818124515.684210604@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MBO-RS-ID: 9bf598924fa62c3e28e
X-MBO-RS-META: mgp9xnmaiznzmai5zoysqqo9hf5qfm73

On Mon, 2025-08-18 at 14:44 +0200, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.=C2=A0 If anyone has any objections, please let =
me know.
>=20
> ------------------
>=20
> From: Philipp Stanner <phasta@kernel.org>
>=20
> [ Upstream commit bf8bbaefaa6ae0a07971ea57b3208df60e8ad0a4 ]
>=20
> Since its inception, the GPU scheduler can leak memory if the driver
> calls drm_sched_fini() while there are still jobs in flight.
>=20
> The simplest way to solve this in a backwards compatible manner is by
> adding a new callback, drm_sched_backend_ops.cancel_job(), which
> instructs the driver to signal the hardware fence associated with the
> job. Afterwards, the scheduler can safely use the established free_job()
> callback for freeing the job.
>=20
> Implement the new backend_ops callback cancel_job().

There is no use in backporting this to stable, since it doesn't really
solve leaks just by adding it. The drivers have to support it
additionally, too, which is something we will ramp up step-by-step over
the long term.

AFAICT there is no harm in backporting it, but it's just not useful.

P.

>=20
> Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> Link: https://lore.kernel.org/dri-devel/20250418113211.69956-1-tvrtko.urs=
ulin@igalia.com/
> Reviewed-by: Ma=C3=ADra Canal <mcanal@igalia.com>
> Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> Signed-off-by: Philipp Stanner <phasta@kernel.org>
> Link: https://lore.kernel.org/r/20250710125412.128476-4-phasta@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =C2=A0drivers/gpu/drm/scheduler/sched_main.c | 34 ++++++++++++++++-------=
---
> =C2=A0include/drm/gpu_scheduler.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 18 ++++++++++++++
> =C2=A02 files changed, 39 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/sch=
eduler/sched_main.c
> index 829579c41c6b..3ac5e6acce04 100644
> --- a/drivers/gpu/drm/scheduler/sched_main.c
> +++ b/drivers/gpu/drm/scheduler/sched_main.c
> @@ -1348,6 +1348,18 @@ int drm_sched_init(struct drm_gpu_scheduler *sched=
, const struct drm_sched_init_
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(drm_sched_init);
> =C2=A0
> +static void drm_sched_cancel_remaining_jobs(struct drm_gpu_scheduler *sc=
hed)
> +{
> +	struct drm_sched_job *job, *tmp;
> +
> +	/* All other accessors are stopped. No locking necessary. */
> +	list_for_each_entry_safe_reverse(job, tmp, &sched->pending_list, list) =
{
> +		sched->ops->cancel_job(job);
> +		list_del(&job->list);
> +		sched->ops->free_job(job);
> +	}
> +}
> +
> =C2=A0/**
> =C2=A0 * drm_sched_fini - Destroy a gpu scheduler
> =C2=A0 *
> @@ -1355,19 +1367,11 @@ EXPORT_SYMBOL(drm_sched_init);
> =C2=A0 *
> =C2=A0 * Tears down and cleans up the scheduler.
> =C2=A0 *
> - * This stops submission of new jobs to the hardware through
> - * drm_sched_backend_ops.run_job(). Consequently, drm_sched_backend_ops.=
free_job()
> - * will not be called for all jobs still in drm_gpu_scheduler.pending_li=
st.
> - * There is no solution for this currently. Thus, it is up to the driver=
 to make
> - * sure that:
> - *
> - *=C2=A0 a) drm_sched_fini() is only called after for all submitted jobs
> - *=C2=A0=C2=A0=C2=A0=C2=A0 drm_sched_backend_ops.free_job() has been cal=
led or that
> - *=C2=A0 b) the jobs for which drm_sched_backend_ops.free_job() has not =
been called
> - *=C2=A0=C2=A0=C2=A0=C2=A0 after drm_sched_fini() ran are freed manually=
.
> - *
> - * FIXME: Take care of the above problem and prevent this function from =
leaking
> - * the jobs in drm_gpu_scheduler.pending_list under any circumstances.
> + * This stops submission of new jobs to the hardware through &struct
> + * drm_sched_backend_ops.run_job. If &struct drm_sched_backend_ops.cance=
l_job
> + * is implemented, all jobs will be canceled through it and afterwards c=
leaned
> + * up through &struct drm_sched_backend_ops.free_job. If cancel_job is n=
ot
> + * implemented, memory could leak.
> =C2=A0 */
> =C2=A0void drm_sched_fini(struct drm_gpu_scheduler *sched)
> =C2=A0{
> @@ -1397,6 +1401,10 @@ void drm_sched_fini(struct drm_gpu_scheduler *sche=
d)
> =C2=A0	/* Confirm no work left behind accessing device structures */
> =C2=A0	cancel_delayed_work_sync(&sched->work_tdr);
> =C2=A0
> +	/* Avoid memory leaks if supported by the driver. */
> +	if (sched->ops->cancel_job)
> +		drm_sched_cancel_remaining_jobs(sched);
> +
> =C2=A0	if (sched->own_submit_wq)
> =C2=A0		destroy_workqueue(sched->submit_wq);
> =C2=A0	sched->ready =3D false;
> diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
> index 1a7e377d4cbb..1eed74c7f2f7 100644
> --- a/include/drm/gpu_scheduler.h
> +++ b/include/drm/gpu_scheduler.h
> @@ -508,6 +508,24 @@ struct drm_sched_backend_ops {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * and it's time to=
 clean it up.
> =C2=A0	 */
> =C2=A0	void (*free_job)(struct drm_sched_job *sched_job);
> +
> +	/**
> +	 * @cancel_job: Used by the scheduler to guarantee remaining jobs' fenc=
es
> +	 * get signaled in drm_sched_fini().
> +	 *
> +	 * Used by the scheduler to cancel all jobs that have not been executed
> +	 * with &struct drm_sched_backend_ops.run_job by the time
> +	 * drm_sched_fini() gets invoked.
> +	 *
> +	 * Drivers need to signal the passed job's hardware fence with an
> +	 * appropriate error code (e.g., -ECANCELED) in this callback. They
> +	 * must not free the job.
> +	 *
> +	 * The scheduler will only call this callback once it stopped calling
> +	 * all other callbacks forever, with the exception of &struct
> +	 * drm_sched_backend_ops.free_job.
> +	 */
> +	void (*cancel_job)(struct drm_sched_job *sched_job);
> =C2=A0};
> =C2=A0
> =C2=A0/**

