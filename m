Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A184248CF;
	Tue, 18 Aug 2026 15:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067797; cv=none; b=KDfNZpx5wccRqAnrcSwolYe/iDsjHCdYYsdxqgVmSh0CPLFvhNd09h1tj7FJVatvlt9qNrPhn75Exe6Wz/FZWSGYAlfDJE7SL3f9mYk47PdcOD4C1WtMq3+5/skwdypf3YLQBkEw+Aw+uVj5OrUJtnrmQgI5mzm0fukvmVOs20E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067797; c=relaxed/simple;
	bh=yfLPTYWhxAvkfKOpOnt4Edq2rV+hG0GeAgfCWReShKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amkXu8Aq/eHjCGkwynujAfFwK3fBKJWpBRXUHBMje2KNRdcJyEcAoh3i6yQHBMcS5yejf1zViz8vohYqKljU8MlM85Eq17jk5Pdz8hP/gpR9BNuvqWjkg4IatEhbH3Lb2Qhk03AhdH8PvkKHxQ+UeaBNnVokFEc7VOgvIsvTTZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+EORPPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+EORPPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39CE1F000E9;
	Tue, 18 Aug 2026 15:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787067796;
	bh=kEep+OcYz0E5/SRPxPYiNUa0pvlO7TWxyphz4YCOatU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+EORPPgIpC4VEHKgtHuJsd/rGxttAaKlkDKnyKFNi51F/5WGrOnSlRaLEcCBsOzi
	 ESZRgAA/BWEU85QnZXOw8ILuIhdJxthKn8HSwwwGzIJSHEt3GPUqvBY5u7F3SS2yBu
	 ouVaRAkvEgSnH8ue1zkxNqG9SLd1QXlPS/2Wiar4OagEzHr0ckB0+e/7wxewA5zAcH
	 0SgoC1wT9TVg9meMlOxFkQeXVGdS1mDl4gAUuQVPu2w68V8mXqlEgChJAQmFYxdw6F
	 cGhULezR/Fv4ekYMCg0DnWo2kO9FLyuvM+3uwVvPeSHgjWoA+gNysaTArIl8DvBHlV
	 Q8nogKvZ8gfVw==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	linfeng.sun.dev@gamil.com,
	mst@redhat.com,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Linfeng Sun <linfeng.sun.dev@gmail.com>
Subject: Re: [PATCH 7.1 065/271] vhost_iotlb: bound map allocation in add_range
Date: Tue, 18 Aug 2026 11:43:13 -0400
Message-ID: <20260818153252.GA1958243@sashalap>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8C74607E-84F5-46BF-BE37-7F04B62D865E@gmail.com>
References: <8C74607E-84F5-46BF-BE37-7F04B62D865E@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Aug 18, 2026 at 11:55:21AM +0800, Linfeng Sun wrote:
>For subsequent kernel commits, I have already requested the correction
>through .mailmap

That part is already sorted: b3cfa692878e ("mailmap: update email address
for Linfeng Sun") is in linux-next and maps gamil.com -> gmail.com, so this
commit will resolve to your correct address once that reaches mainline.

>If it is still possible to update the author information here, I would like
>it to be changed to:
>Linfeng Sun <linfeng.sun.dev@gmail.com>

The stable backport carries the author line verbatim from the upstream
commit, so the queued patch is a faithful copy of 1ed35ac7f3fe. Editing it
here would make the stable authorship diverge from mainline, so I'm going
to leave it as-is and let the .mailmap entry take care of it.

No trouble at all, thanks for the heads-up.

-- 
Thanks,
Sasha
