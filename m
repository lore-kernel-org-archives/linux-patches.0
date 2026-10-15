Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F0A45FFDE;
	Thu, 15 Oct 2026 06:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792044857; cv=none; b=ks482SV7BKRanbgQv0EQiSPGvhPWFEXJlCltGq3mFvTk1lBZKoONhzKrfSfwtQRWvk3D+6WX0GcmTIK3xx6t5n+XdXttbJNrHHeFO7/MbEDxpUR1DR5TS1/Csukhyn4wRREWeDBq1QY8rn8pNh6MXeBoPcgIi5JevMs9dlBZavg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792044857; c=relaxed/simple;
	bh=6V/JH4EjwjFNA8zCuQZglVJOjbpFOu3Vte0F7eOMntM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFEpASSdfAmEdG89E4788UC4k33RycZCFfXeOV/HnKB0w9bEC5EKAEHWekn0fYjwESl6vHJJO6l0nnHDUrdlnrqHpdeEfH8nRid3dGBxefDKdBWVJbcuw2Xkf0yeDxL/ntJv8If08E0fk6HGVTaKda6F5X8oWwVuuEfEcnw24xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6lR9SPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6lR9SPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B751F000C4;
	Thu, 15 Oct 2026 06:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792044848;
	bh=GEDdrdVUV/OJaskTzqK9AQWt30vPW3VmzpddhYXsn6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6lR9SPW2wKn1SABmheD+J+CqPSqmct32VffukMgJnZhxJe3queI6Z3vnkQ6Vbif7
	 PGikugjIPN5bNAopfF1NmLq91vSwn0DnJyHq7FQ+qZgcO+pnvLjtaWdCVvleNph8pw
	 LkYgZqacTXXO1LkUCr6pgQjTq3PsrhszKTFRLmh5GDUB+M4p2qoFawvTz7w1Xz7nUN
	 AIUfy6QW6oQmNxY78GjtlWNAi0n6D3Ex2HQgxbubKYpJntIm6BBkhY+9lwvLh916bu
	 cKIYMpBo1oE4IgFFqsqYviJlN85bX4eiK4scVgQbugsimMo6PCAhjaCZegXeUzNZg9
	 YAa+yX0sHWcsg==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: boqun@kernel.org,
	gregkh@linuxfoundation.org,
	joelagnelf@nvidia.com,
	patches@lists.linux.dev,
	paulmck@kernel.org,
	sj@kernel.org,
	stable@vger.kernel.org
Subject: Re: Re: [PATCH 6.18 177/621] srcu: Use irq_work to start GP in tiny SRCU
Date: Thu, 15 Oct 2026 08:14:00 +0200
Message-ID: <20261015061400.35195-1-ojeda@kernel.org>
In-Reply-To: <2026-10-14-1-daily-reply-0002-srcu-tiny-irq-work-types-6-18@kernel.org>
References: <2026-10-14-1-daily-reply-0002-srcu-tiny-irq-work-types-6-18@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 12:53:05 -0400 Sasha Levin <sashal@kernel.org> wrote:
>
> Thanks for the report. I queued c809f081fe40 ("irqwork: Move data struct to a
> types header") for 6.18, ahead of this patch.

Hmm... it see it in the queue, but not in -rc2.

By the way, for completeness: the same backported patch happened to trigger
this same issue months ago in 6.18.y and 6.12.y (back then Greg dropped it):

  https://lore.kernel.org/all/20260421095549.47476-1-ojeda@kernel.org/

Cheers,
Miguel
