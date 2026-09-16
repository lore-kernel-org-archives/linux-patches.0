Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACCC42123E;
	Wed, 16 Sep 2026 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586969; cv=none; b=qNHeo+Me32R1SoRm+HojuKrpRgUEQNnOwvbg/2Gl8lBnkx2qv5bpaN+thsmaWyqtYXfp5CqqssQCfqQ/4FuhHO2iTrVFhPVVSVsiMbaM8DX6wiTd5TkS8sUpuKPKL2AtSk3hHi7WBZshXxtTdtHmY78nLwN2U3B0pkMyfU+54X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586969; c=relaxed/simple;
	bh=H56OuvyfJNNShKoh+BJQDG3VZ0B2lxX5pO/MXPLhZAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8EyQHKxAUbDosoLWfhQlDZFoQUCUspVGpD9BbcDoX7kK/4rRuRTyC1ZokiH45UKLX/EXa/B9/tMFt56acenue5DFF02+3Ci2c6IJRdbaDZJ4m83HnvwekplIcu4HWRLMhKwj94KRiedJIiyQWKjfLmcuSDGfvfGCknpVpJ2ii0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gxu2dww3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gxu2dww3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851521F0089D;
	Wed, 16 Sep 2026 19:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586916;
	bh=hMwSwmzTwsA+eUKSStr2tkNVkBrgxJMDnDGVIOOOtWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gxu2dww3cqq1Kk2b+evfbszBa7mHDGOzUUg/5bMH/GBPOSiiYt0S+sDd/C6g9FaXI
	 Vcovld/VjbTxlPXXtJup9dElsMLWRuzxX1L/zLim5QR6/VMGZGsgYbWPgekFlKkFQG
	 Owaphqs5yY+jqrMEeuXy7qvqDfEcgkq9brTrR0ok7vrOGEsLaNYndKEaXSdrx9dwk6
	 T3ty1WdA55EmOu8pxG+k9xlxDg8iQdz1oxDzEgRZeaoVzPfG2pRN2n7oZvZNlMdx/u
	 wqEI1SW/CsU6YbAuasHi3s8vJg76FsLwRZst5Hw2ZT7ptZ9+R8JfjRuo9M/hUw3nBG
	 ezeRpIQLHBi6w==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>
Subject: Re: [PATCH 6.12 1061/1376] nvme-apple: Drop the PRP null check chicken bit
Date: Wed, 16 Sep 2026 15:27:59 -0400
Message-ID: <daily-reply-20260916-0009-re-nvme-apple-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <dc927d3e-e7f1-461c-9a75-259f71899224@gmail.com>
References: <dc927d3e-e7f1-461c-9a75-259f71899224@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I suggest this patch and all of its dependencies to be
> dropped from 6.1, 6.6 and 6.12 so this patch can be
> backported properly alongside the page size quirk later.

All four shipped already, in 6.12.110, 6.6.157 and 6.1.188, so they come out
as reverts on top rather than as queue drops. The four reverts are queued for
6.12, 6.6 and 6.1.

Please send the proper backport alongside the page size quirk when you have
it ready.

-- 
Thanks,
Sasha
