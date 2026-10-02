Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1EF3D0C09;
	Fri,  2 Oct 2026 21:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975442; cv=none; b=LbEO+C8xxzVp5d/QSSQxtnGZmMjw9PfA+q22d0VgpqHgyYih/2Z8NVQw6cmKUMyRLmgMEZhXREiZKD4IaBIPxPrYr/SSNkjm06wGG6D6zIuvC/y+ppbRuKGJAhs2Ca1Z2MS3mqm31i4RUjfTbEUfSrJDYnq5X0XPcbV55b0W0S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975442; c=relaxed/simple;
	bh=hG09OKmYxQPA86U3mD2W52lV1yBddktuLtslPjX0LfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3x7rgD2VUWnqnjBS558+5IhcPdOmCRI+uPLXu78pF/kGKJITrL4oeBo5qs9Eejah8ZwF1hYVUN3Rvb+++BxEIfbv56RYYsy4cvCQkA0dast4Yd4rjTVokgtQWH6CN4q2THmCN5SoCFN97QhLf46UQeLzxWRi9CpBaYpx5VSJ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COMnSLCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COMnSLCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3BB1F00893;
	Fri,  2 Oct 2026 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975440;
	bh=XkgphlcH784B14QTAVhkLukSzgKaLO+N8V/3efghooQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COMnSLCU3xl4eEjxD1DixEr0kRk8EBWEpSe2DwGCMWXMw50n+brjFpaesbuMPOAPt
	 44JofORNHxRdEQ6rB6t+z+C/cHvxXNhHW7WIgDkA8eq/IPTjEmq2Ysp5fHy1UKpF6N
	 ISYRfoHSHCQPKAyB5d32BkpcnkQaRR3vh0E2ri+OmDUD3HDPmT4sdUsBLltvKlZBfx
	 XFKByk+2FgoypsT/DRaYxe3v1f4+Kyb87f9xD4vbCkemO13mqEEA1ykvZ5bCYfy6RJ
	 HwTJpvrLL7QIixfXtKYI5Qq5PNeQcv1rDS5yljXjrMt7gq75e6CztsAvVBEg3FwO2p
	 kkgrZ7X6Z44Sg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	co+ac0a8c41de69121d@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 400/877] bpf: Reject dev-bound-only programs on other devices
Date: Fri,  2 Oct 2026 17:10:28 -0400
Message-ID: <2026-10-02-1-daily-reply-0002-re-bpf-xdp-offload-check-6-12-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b3ccd2a3-a51d-41d9-9374-68a392d23ccb@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152423.316713397@linuxfoundation.org> <b3ccd2a3-a51d-41d9-9374-68a392d23ccb@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y needs ad27ed7d2309419a129078d781504f486b1b469a ("bpf,
> xdp: move offload check into dev_xdp_install()"), adapted to the 6.12
> installer, alongside this fix, thoughts?

Queued for 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
