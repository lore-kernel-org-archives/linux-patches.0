Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F16154EEA6;
	Wed, 14 Oct 2026 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996804; cv=none; b=pZPORxgM7UDpo6VaE1wFCFrSfm+YzJ5Xk0hn1GxiKn+Ze0xXgo1qdSDQ2EnZVdajBn87zKXTKXgUXLWjh/TT1cUuLIajbx3XvVJFNJd/LE0E4ElAcu4gVxIDEbpk5mhD76GOTrpywKxaRHyGMBSjPclvZPXplMcQhPjLbuWlmb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996804; c=relaxed/simple;
	bh=a994G5HDjdwRZVFNiXc4Whao2XM0qFL6cgB336ZfTRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvsIMiUlCmvhNIffMLppp3teIMmgBgaNp4rvliZ40pt0mk6yloetfR8HFuAAH1FtLKzlDiLEMDdn+gNMElcxSGG4VekVe+Jsg9Jbl5Sj3mwifvW8AVXzkBfVpcaJshZ7qxowhPAKr1pG70Ss4miT2TuXxV/CrMgyYWe4p1V32+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSNQ6j/3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSNQ6j/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAC21F000C6;
	Wed, 14 Oct 2026 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996803;
	bh=d5jV0qNd0o3MrzQk9kf8YMzfeQgau/wLUkxp3caTan8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSNQ6j/34EDtAT+DmP9geImndmYCiTvb3CDiT/suRV0s8OnozgMEzf4diuvxHSRaJ
	 EniFFONrBqn+09bEW+a5+NCbXv5rxvnzNQ9BZa9crBxjtTcyUdrjHhY77UFXygBlUF
	 sHcZZln6UFoUlNxCTtqG3tLPsptIjcWd3ED0iYntkZZ+N9WuP9BB4Q/R3zY4dd1rFy
	 W0PW0wiGls0caW9Q5adIsU7iv/J/BleBLRZaKNAhEpHW/8TBl8aLbjcgCuutumW/wB
	 Slhg6qS2cqxNplHujnk147EGQjfqvgobwG8Rjpuh5bfuXpbnClLLhMs0jUzulvEStY
	 doKZSTu4LxBdQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun@kernel.org>
Subject: Re: [PATCH 6.18 177/621] srcu: Use irq_work to start GP in tiny SRCU
Date: Wed, 14 Oct 2026 12:53:05 -0400
Message-ID: <2026-10-14-1-daily-reply-0002-srcu-tiny-irq-work-types-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013140916.139338-1-sj@kernel.org>
References: <20261013140916.139338-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Cherry-picking the commit c809f081fe40 ("irqwork: Move data struct to a types
> header") also fixed the issue on my setup.

Thanks for the report. I queued c809f081fe40 ("irqwork: Move data struct to a
types header") for 6.18, ahead of this patch.

-- 
Thanks,
Sasha
