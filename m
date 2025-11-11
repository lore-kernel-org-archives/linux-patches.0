Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21C51B4138
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 14:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762871458; cv=none; b=nYotkI40pEeNcBaMeCApMGAVP8GGfsSXrczihXATNNeV+rFJfJv+Y70iosz3cKILTLXVHOwn+hFTayMin5vk8/TgYhQuLd2GgWGwhiIX59Scle34gFz8GzaCyurWr5pK/hQUbKfmzaV9jVT5xL+PpKN/AjX0Dt9iYHi9Vc6oZLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762871458; c=relaxed/simple;
	bh=gokWTlM/07eSfLNWHq/SmnZzV9ExteBa4WCGRC/HiLM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5kT3V6LAbPtrCykoz86v98IOIsbma6E5juvQBcMn3alkj+UH7LK4d5a8h1eF0cfM+5vEq/I/8gOsOtVlq5eh7poToCjy22TdmNmt6u6Gu7Tf0TpvvMsrghU7uHbNuV993wlW+u8hLXcYeQH9lL8oH/rYWi1idNJxc+zUUCYSHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZOQ1D+U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZOQ1D+U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762871455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gokWTlM/07eSfLNWHq/SmnZzV9ExteBa4WCGRC/HiLM=;
	b=MZOQ1D+UUWzqKiw27WiRi/oLebG9D8wfxVQWmKfYU2b5KF6vBg2OCfVWZrXkccVR+ti4UY
	ja0eqC3XNfgSRVLibm9hiayqz5m21qtcE7RSjUrCvgjvG1Lw+EqNp2H/UevskVPsljaMFU
	URIWsBV8fuLuLSEP+2auyLBgDuBOX2I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-Xap23YlpMImHn9tUD4657Q-1; Tue, 11 Nov 2025 09:30:49 -0500
X-MC-Unique: Xap23YlpMImHn9tUD4657Q-1
X-Mimecast-MFC-AGG-ID: Xap23YlpMImHn9tUD4657Q_1762871448
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477563a0c75so24252355e9.1
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 06:30:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762871448; x=1763476248;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ogR+cOwcd72jgQoTAFtAdbDI3BPnqSizGCNP3RzMtIM=;
        b=poXArExrXfSNaUUPoMqvrL+pLF8xdBprLiX3ILwjqK/biC3uGqyhtrIAdTjxgudxer
         CFY/KJIiSVa+Mzl361eeNy3lAxFn1xfuhANPQ1wse6unYPvbixiVJTjWMk/ZVsarvFDS
         hczWFYQtYSQr17Tl7ZLP39FvN0YD3wFCosfzVKeeDWWtO3fyZ11Q3FW1nkRK0iPxfWAo
         8b8K4v4zoKCb0+yTAKXVptlJ/N/c6kb/EOADSrixQ1tpaqDapzROCiVM/CKYVXQTAEKB
         UaoJTVJr9tpS45SZPYdKsJzDEup81p9yIH2GJaG0Tu+JTmk1VJSZxjONU5+tQct5g5Il
         L2nw==
X-Gm-Message-State: AOJu0Yz7BdvOBebBvOtYOl54fTR3lfOjCbTne2yKMTJzwl6TwQ/p6T7K
	5AyucX5JtNAD1avZZRK2qOVliwc+KVJNJYhXwYqjWtshhjJRBV9ntePfAeUdJT6t9Nw3iFUVJKq
	Xpri2PiiwaSwHi+8ln/qdqzlY2K1tklRdwvUiwYzAfnbUI0IXinul+YQLKNs=
X-Gm-Gg: ASbGncsmLdk6OcSq/0L1j5cTa5fvmlWhKuTD2Wp1z+oyU4RLfyYVS/Xm32iMvyu6yYM
	uNuQJw/dTx/Vth4S6UMoZNIBlGCZl2/wLyJppe2DjsABjrtRBuG5izXD0zFSZUgD6d1+//OOepS
	+QBSy5855QeQopGEnu51+ZVUtFEz/aBECvbEu1vr/N+FCgypLZ0D7X1uPQB+L+d/yAEe2Aub5mW
	bIfGobVsXYLEA+mU+n/+tl7hcZ3peoHhXUQQQNB9GViFTiyosRyrwRfBhU6FChGkxO7gQEfqYjI
	Uor8DFR/Ps5Ccb02f1HCJILuj0iJMA933UvQpBiEaedRCqvDrJHVDuJW6A8r0xr9mLpFswaekYD
	VvzrY5liz7X77DC1c4sM8FIhi/w==
X-Received: by 2002:a05:600c:1381:b0:45f:2922:2aef with SMTP id 5b1f17b1804b1-4777328f2a6mr123871465e9.28.1762871448189;
        Tue, 11 Nov 2025 06:30:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGug/PeuPcxtjEEu7qSWA6IfTJ6My/ez4ZrKcgwBAQv1Ogvzt5befPXheYjkD2Wk7l51Jwk8w==
X-Received: by 2002:a05:600c:1381:b0:45f:2922:2aef with SMTP id 5b1f17b1804b1-4777328f2a6mr123871115e9.28.1762871447736;
        Tue, 11 Nov 2025 06:30:47 -0800 (PST)
Received: from [10.200.68.138] (nat-pool-muc-u.redhat.com. [149.14.88.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4776bd08834sm261513135e9.15.2025.11.11.06.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 06:30:47 -0800 (PST)
Message-ID: <b239f2abb28d4e5dfc36c67bb6b88975a63c11e6.camel@redhat.com>
Subject: Re: [PATCH 6.12 084/565] drm/sched: Re-group and rename the entity
 run-queue lock
From: Philipp Stanner <pstanner@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, 
 Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Alex Deucher
 <alexander.deucher@amd.com>, Luben Tuikov <ltuikov89@gmail.com>, Matthew
 Brost <matthew.brost@intel.com>, Sasha Levin <sashal@kernel.org>
Date: Tue, 11 Nov 2025 15:30:45 +0100
In-Reply-To: <20251111004528.857251276@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
	 <20251111004528.857251276@linuxfoundation.org>
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L-QpL0zna3NGzzhhYBiTdoUA-v-psDWecE2qV4EXz_M_1762871448
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-11-11 at 09:39 +0900, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.=C2=A0 If anyone has any objections, please let =
me know.

This and patch 83 are mere code improvements, not bug fixes.


P.

>=20
> ------------------
>=20
> From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>=20
> [ Upstream commit f93126f5d55920d1447ef00a3fbe6706f40f53de ]
>=20
> When writing to a drm_sched_entity's run-queue, writers are protected
> through the lock drm_sched_entity.rq_lock. This naming, however,
> frequently collides with the separate internal lock of struct
> drm_sched_rq, resulting in uses like this:
>=20
> =09spin_lock(&entity->rq_lock);
> =09spin_lock(&entity->rq->lock);
>=20
> Rename drm_sched_entity.rq_lock to improve readability. While at it,
> re-order that struct's members to make it more obvious what the lock
> protects.
>=20
> v2:
> =C2=A0* Rename some rq_lock straddlers in kerneldoc, improve commit text.=
 (Philipp)
>=20
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
> Suggested-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Luben Tuikov <ltuikov89@gmail.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Philipp Stanner <pstanner@redhat.com>
> Reviewed-by: Christian K=C3=B6nig <christian.koenig@amd.com>
> [pstanner: Fix typo in docstring]
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20241016122013.7857-5=
-tursulin@igalia.com
> Stable-dep-of: d25e3a610bae ("drm/sched: Fix race in drm_sched_entity_sel=
ect_rq()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> =C2=A0drivers/gpu/drm/scheduler/sched_entity.c |=C2=A0=C2=A0 28 +++++++++=
+++++--------------
> =C2=A0drivers/gpu/drm/scheduler/sched_main.c=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=
=A0 2 +-
> =C2=A0include/drm/gpu_scheduler.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 21 +++++++++++-------=
---
> =C2=A03 files changed, 26 insertions(+), 25 deletions(-)
>=20
> --- a/drivers/gpu/drm/scheduler/sched_entity.c
> +++ b/drivers/gpu/drm/scheduler/sched_entity.c
> @@ -106,7 +106,7 @@ int drm_sched_entity_init(struct drm_sch
> =C2=A0=09/* We start in an idle state. */
> =C2=A0=09complete_all(&entity->entity_idle);
> =C2=A0
> -=09spin_lock_init(&entity->rq_lock);
> +=09spin_lock_init(&entity->lock);
> =C2=A0=09spsc_queue_init(&entity->job_queue);
> =C2=A0
> =C2=A0=09atomic_set(&entity->fence_seq, 0);
> @@ -134,10 +134,10 @@ void drm_sched_entity_modify_sched(struc
> =C2=A0{
> =C2=A0=09WARN_ON(!num_sched_list || !sched_list);
> =C2=A0
> -=09spin_lock(&entity->rq_lock);
> +=09spin_lock(&entity->lock);
> =C2=A0=09entity->sched_list =3D sched_list;
> =C2=A0=09entity->num_sched_list =3D num_sched_list;
> -=09spin_unlock(&entity->rq_lock);
> +=09spin_unlock(&entity->lock);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(drm_sched_entity_modify_sched);
> =C2=A0
> @@ -246,10 +246,10 @@ static void drm_sched_entity_kill(struct
> =C2=A0=09if (!entity->rq)
> =C2=A0=09=09return;
> =C2=A0
> -=09spin_lock(&entity->rq_lock);
> +=09spin_lock(&entity->lock);
> =C2=A0=09entity->stopped =3D true;
> =C2=A0=09drm_sched_rq_remove_entity(entity->rq, entity);
> -=09spin_unlock(&entity->rq_lock);
> +=09spin_unlock(&entity->lock);
> =C2=A0
> =C2=A0=09/* Make sure this entity is not used by the scheduler at the mom=
ent */
> =C2=A0=09wait_for_completion(&entity->entity_idle);
> @@ -395,9 +395,9 @@ static void drm_sched_entity_wakeup(stru
> =C2=A0void drm_sched_entity_set_priority(struct drm_sched_entity *entity,
> =C2=A0=09=09=09=09=C2=A0=C2=A0 enum drm_sched_priority priority)
> =C2=A0{
> -=09spin_lock(&entity->rq_lock);
> +=09spin_lock(&entity->lock);
> =C2=A0=09entity->priority =3D priority;
> -=09spin_unlock(&entity->rq_lock);
> +=09spin_unlock(&entity->lock);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL(drm_sched_entity_set_priority);
> =C2=A0
> @@ -507,10 +507,10 @@ struct drm_sched_job *drm_sched_entity_p
> =C2=A0
> =C2=A0=09=09next =3D to_drm_sched_job(spsc_queue_peek(&entity->job_queue)=
);
> =C2=A0=09=09if (next) {
> -=09=09=09spin_lock(&entity->rq_lock);
> +=09=09=09spin_lock(&entity->lock);
> =C2=A0=09=09=09drm_sched_rq_update_fifo_locked(entity,
> =C2=A0=09=09=09=09=09=09=09next->submit_ts);
> -=09=09=09spin_unlock(&entity->rq_lock);
> +=09=09=09spin_unlock(&entity->lock);
> =C2=A0=09=09}
> =C2=A0=09}
> =C2=A0
> @@ -551,14 +551,14 @@ void drm_sched_entity_select_rq(struct d
> =C2=A0=09if (fence && !dma_fence_is_signaled(fence))
> =C2=A0=09=09return;
> =C2=A0
> -=09spin_lock(&entity->rq_lock);
> +=09spin_lock(&entity->lock);
> =C2=A0=09sched =3D drm_sched_pick_best(entity->sched_list, entity->num_sc=
hed_list);
> =C2=A0=09rq =3D sched ? sched->sched_rq[entity->priority] : NULL;
> =C2=A0=09if (rq !=3D entity->rq) {
> =C2=A0=09=09drm_sched_rq_remove_entity(entity->rq, entity);
> =C2=A0=09=09entity->rq =3D rq;
> =C2=A0=09}
> -=09spin_unlock(&entity->rq_lock);
> +=09spin_unlock(&entity->lock);
> =C2=A0
> =C2=A0=09if (entity->num_sched_list =3D=3D 1)
> =C2=A0=09=09entity->sched_list =3D NULL;
> @@ -599,9 +599,9 @@ void drm_sched_entity_push_job(struct dr
> =C2=A0=09=09struct drm_sched_rq *rq;
> =C2=A0
> =C2=A0=09=09/* Add the entity to the run queue */
> -=09=09spin_lock(&entity->rq_lock);
> +=09=09spin_lock(&entity->lock);
> =C2=A0=09=09if (entity->stopped) {
> -=09=09=09spin_unlock(&entity->rq_lock);
> +=09=09=09spin_unlock(&entity->lock);
> =C2=A0
> =C2=A0=09=09=09DRM_ERROR("Trying to push to a killed entity\n");
> =C2=A0=09=09=09return;
> @@ -615,7 +615,7 @@ void drm_sched_entity_push_job(struct dr
> =C2=A0=09=09if (drm_sched_policy =3D=3D DRM_SCHED_POLICY_FIFO)
> =C2=A0=09=09=09drm_sched_rq_update_fifo_locked(entity, submit_ts);
> =C2=A0
> -=09=09spin_unlock(&entity->rq_lock);
> +=09=09spin_unlock(&entity->lock);
> =C2=A0
> =C2=A0=09=09drm_sched_wakeup(sched);
> =C2=A0=09}
> --- a/drivers/gpu/drm/scheduler/sched_main.c
> +++ b/drivers/gpu/drm/scheduler/sched_main.c
> @@ -176,7 +176,7 @@ void drm_sched_rq_update_fifo_locked(str
> =C2=A0=09 * for entity from within concurrent drm_sched_entity_select_rq =
and the
> =C2=A0=09 * other to update the rb tree structure.
> =C2=A0=09 */
> -=09lockdep_assert_held(&entity->rq_lock);
> +=09lockdep_assert_held(&entity->lock);
> =C2=A0
> =C2=A0=09spin_lock(&entity->rq->lock);
> =C2=A0
> --- a/include/drm/gpu_scheduler.h
> +++ b/include/drm/gpu_scheduler.h
> @@ -97,13 +97,21 @@ struct drm_sched_entity {
> =C2=A0=09struct list_head=09=09list;
> =C2=A0
> =C2=A0=09/**
> +=09 * @lock:
> +=09 *
> +=09 * Lock protecting the run-queue (@rq) to which this entity belongs,
> +=09 * @priority and the list of schedulers (@sched_list, @num_sched_list=
).
> +=09 */
> +=09spinlock_t=09=09=09lock;
> +
> +=09/**
> =C2=A0=09 * @rq:
> =C2=A0=09 *
> =C2=A0=09 * Runqueue on which this entity is currently scheduled.
> =C2=A0=09 *
> =C2=A0=09 * FIXME: Locking is very unclear for this. Writers are protecte=
d by
> -=09 * @rq_lock, but readers are generally lockless and seem to just race
> -=09 * with not even a READ_ONCE.
> +=09 * @lock, but readers are generally lockless and seem to just race wi=
th
> +=09 * not even a READ_ONCE.
> =C2=A0=09 */
> =C2=A0=09struct drm_sched_rq=09=09*rq;
> =C2=A0
> @@ -136,18 +144,11 @@ struct drm_sched_entity {
> =C2=A0=09 * @priority:
> =C2=A0=09 *
> =C2=A0=09 * Priority of the entity. This can be modified by calling
> -=09 * drm_sched_entity_set_priority(). Protected by &rq_lock.
> +=09 * drm_sched_entity_set_priority(). Protected by @lock.
> =C2=A0=09 */
> =C2=A0=09enum drm_sched_priority=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 priority;
> =C2=A0
> =C2=A0=09/**
> -=09 * @rq_lock:
> -=09 *
> -=09 * Lock to modify the runqueue to which this entity belongs.
> -=09 */
> -=09spinlock_t=09=09=09rq_lock;
> -
> -=09/**
> =C2=A0=09 * @job_queue: the list of jobs of this entity.
> =C2=A0=09 */
> =C2=A0=09struct spsc_queue=09=09job_queue;
>=20
>=20

