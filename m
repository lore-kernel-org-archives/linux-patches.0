Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491523AFB1A;
	Sat, 17 Oct 2026 03:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206029; cv=none; b=oGu9jOpVz7fxUM8jFo438VapL00YjogIvM5Kbs3xLRjQAFX8ktk1JfJ+sPKGVbgCV/6MgsNwJmTGnVXaZhFVI9qY4zhFizWavHnqKmaeStwqs486nm8MUBfnC9K51aeHWbM6V/s82EkV4+m8FXX5xMsmb7oS9YgGyguX22QitHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206029; c=relaxed/simple;
	bh=vvy4zJAV3UlyMlmeV+ctFgaSdC1YE+gUxx83tdmHN5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlEh50ULh350ptRzxDgvJaimyEp9ruPqjwb9ihzJ9QCSFHml+IDmEgyrPHgNFFMq6k29qz4ssjLbBf4Bok0emrV5fzbuNt5dYWrcXWBGf8SDI6tv2RoTNEAuhOMkXSAjuh/v5RfBbl1QGMFZFuDGsNgFtoBe4Ogzay8InpbmoqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjPEf34G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjPEf34G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89CA1F000C6;
	Sat, 17 Oct 2026 03:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206025;
	bh=cXUvX08LONns5CVCTL7b+CiSPnCfwfd59r6p3GqxaA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjPEf34Gczztx9aXkQE/pgRzNmm9qIpw1f7fCGqv8nvFSDMJe+g9HElS35IYO7mXa
	 1CouwZf9+3Vqmfa2v+NcKSga+b5xF5LXbYdzO4wjMIuY4UkZNHkYHcE+kBf0FMwf+w
	 H15Gmhpulwx9UGz8rqPy9pQ/mCRBzXU5knsPov8NRaOn3pnwFDXc8qfweWvmFX2qUv
	 OZayPVjIvzrK5zQoup4eSr7hbA6WhT5r8fctSnXY4BSoe+aCqB8cFE4yIT6Jh2W0kr
	 e0w2Vacdi3uMmxNQEErwFOZuv3yWjNjIJyc41fSFqQN/O5MReT7rtlqAgRo2Vrm4pz
	 7sYlUDBedMeYw==
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
Subject: Re: [PATCH 6.18 177/621] srcu: Use irq_work to start GP in tiny SRCU
Date: Fri, 16 Oct 2026 23:00:06 -0400
Message-ID: <2026-10-16-1-daily-reply-0001-srcu-tiny-irq-work-types-6-12-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015061400.35195-1-ojeda@kernel.org>
References: <20261015061400.35195-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Hmm... it see it in the queue, but not in -rc2.

It was queued after -rc2 went out, and it is in the released 6.18.57, ahead
of the srcu patch.

> By the way, for completeness: the same backported patch happened to
> trigger this same issue months ago in 6.18.y and 6.12.y (back then
> Greg dropped it):

The srcu patch is queued again for 6.12 and 6.6, so both now get "irqwork:
Move data struct to a types header", along with "types: move struct rcuwait
into types.h", which it needs on those trees.

-- 
Thanks,
Sasha
