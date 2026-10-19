Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAC428E0;
	Mon, 19 Oct 2026 00:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792368868; cv=none; b=pgSez2RIyiTfPv7paS/dWeEON0PezfQEl7NjARQbK1Qk99QSxkn5Xj91mPX//X8AI3lc1D3JiMtZPe/rDd9WCBSS7lye6yI+/Xo+iw4ssQMtdihLq08pQvgFBLbs7G/VmNuZLYa1ZfsnYT7wvhuG6Pc9hiRjcevvGQWW78w08dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792368868; c=relaxed/simple;
	bh=y6OOLL5R5mEFYI/4IgictQqBmuJMmuBgbTGDroRZ7n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubt5daZCoRoihPmYNyrxNtcfrt91ddquN+AqhbT0vizBtfX20BbbQesIMl3btf68mnAVCwk/h8xSF7aFbBYMZ7ypftZcpVOHsjIqgmqqY3ybT6foMvblOlIdez6oUShrlSmMUVedFvPqiQrNUS8JikLP1ZCooMvqheGKFk5Kkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4eBuQfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4eBuQfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C241F000C4;
	Mon, 19 Oct 2026 00:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792368865;
	bh=Oi7uZ1jdUdcNpHhuJLEwmzrkoAenyV7pceZvmXs8Gic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4eBuQfldV8Qs9zOm4NRcTEgta2UkyZwGvV5SuQ436gEkdi+X5IivNOifCs/xr2b/
	 WnvjYrG+kogsx8Jchqt8RhAXoLp4X4YbkMW3CjC+ihv+0j4jFCht61QrWd+6hgNgpf
	 kBsLHGYBPEpaBb0DoDsNIhvmQv4eM8b5aSWeiDXvZ8q3SmnsifhbighuxHkFdx0rnp
	 nt9X+GQy4ws/LdvlN0X3bUvP3/q019oCJeQmGLcpLJCRURKmSA6B+FdksStDOeIyjg
	 r1gHetw5xJwtfBcIe6TUACE8MLesbtRB/GCp63YN/Ms5a1vUNlF1cwfLg1sEjqmGI7
	 ccjOqLM+lsWsQ==
From: Sasha Levin <sashal@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	boqun@kernel.org,
	gregkh@linuxfoundation.org,
	joelagnelf@nvidia.com,
	patches@lists.linux.dev,
	paulmck@kernel.org,
	sj@kernel.org,
	stable@vger.kernel.org
Subject: Re: Re: [PATCH 6.18 177/621] srcu: Use irq_work to start GP in tiny SRCU
Date: Sun, 18 Oct 2026 20:14:16 -0400
Message-ID: <2026-10-18-1-daily-reply-0005-srcu-tiny-irq-work@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015061400.35195-1-ojeda@kernel.org>
References: <2026-10-14-1-daily-reply-0002-srcu-tiny-irq-work-types-6-18@kernel.org> <20261015061400.35195-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 15 Oct 2026 08:14:00 +0200, Miguel Ojeda <ojeda@kernel.org> wrote:
> Hmm... it see it in the queue, but not in -rc2.
>
> By the way, for completeness: the same backported patch happened to trigger
> this same issue months ago in 6.18.y and 6.12.y (back then Greg dropped it):

Thanks. I looked at all the older trees that carry this patch. The
"linux/irq_work_types.h" include in srcutiny.h needs two prerequisites,
2c2bd11caba2 ("types: move struct rcuwait into types.h") and c809f081fe40
("irqwork: Move data struct to a types header"):

  - 6.1: the patch was queued without them, and UML (TINY_SRCU) builds
    fail the same way. I dropped it from the 6.1 queue.

  - 6.12 and 6.6: both prerequisites were already queued, but after the
    srcu patch, so only the intermediate commits fail to build. I moved
    them to sit directly before it. The patch contents are unchanged.

6.18.y shipped the prerequisite together with the patch in 6.18.57.

-- 
Thanks,
Sasha
