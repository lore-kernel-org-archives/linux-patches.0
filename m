Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318766;
	b=JGmCb9V7aRLNL+CAtDemQhDHLRiZCT3+7ykgIhbIyh9JT/QpNEbwQ07LqovdmPB6/xWI
	 Wi2hLjAJXvp3Q+Ht00t5W5MvWo3xIHVVMNCUBS2Et9KzE5OJLZnEvaqt49PPk6shhy7n+
	 4Q7Fqg6XgWC9gRJTh2mE1jU+Fq6kbjn+SmGZMMpcpsxxFAMH2x5Zv8AI24OyO8xnxjxp3
	 xxcwj9jKiMIS15NzhxV+yaXo25ZnNxsjR1EvfaGZKuC5ESWrPuBriwvV0j9YiUmw10BXx
	 AwVc2cqDfRVLoVCkRj+l9psTASpCJCBPpm6a1TxaOK9q70R5++47YnQAHJiM0Gpwp7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ARZos9Oyp7IlG0S1npOfvHrG1IR5VnbGnlLf6uVLOPg=;
	b=d2qW+cCeLuRRLeZ1Fi+FqJS5WApCs0GLtZhU72ThSvxplNlfAmLCVF7jmzumnvzFANal
	 0YF6aMqXrqhP3fTkdh7MZ/lwazNu6Jr1LRa1ZXFbX/Ez4wGt6RHPHMprth9fpDPeqAvTI
	 AB16PFi74Ixga/wdy7bQIQc0mXCR4Ja/bF62o/iOFqXAmbjkySCmDs4wtxo+vPK0dx/nu
	 EcAWPvG3fJwwJA3mcJ+hZFQ1u5jt5to3r42786bZzk51LYhh7aeUab2hfPc+0Iq3UthKk
	 rdZdqPuJO9CrVXPsYAU/LApn5EFIaLkSTXaCarQif6y+dP1qs8sM6pePe1PU9a6CY/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LQ78X01m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA0606A320;
	Sun, 22 Nov 2026 03:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LQ78X01m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277BB1F000CA;
	Sun, 22 Nov 2026 03:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318765;
	bh=ARZos9Oyp7IlG0S1npOfvHrG1IR5VnbGnlLf6uVLOPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ78X01mDubekeobbNXgbX57VKsdjsGg+ryiIKmweWw9yMsoct1SxmWcma/SPf0Nc
	 z/epq2M4C5HEzHC/M0nxPefied+1sK9cPmvl+gROOe37h0iRHeX13ElRor8tTSE+qO
	 3SSjoBUtmmC9MzAxE+iYNBHcPJ3IhFymMSvIlU1lWpDOmv5E0Qf4pRzatmSubBLTSD
	 t77vvENPonqlblB8bk+ksh0r0YztfYRWAf/cJjrLaVXWXoNYZ8K6hlHDviW1sgIuHI
	 dS7UOshfCvMaV6JESyxyvtdB/fOWips2lHGprlh32mzeuWtgjsTfo+qMUl4ACjplyr
	 TG/R9cHPxyNJg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 1964/2214] RDMA/rxe: Create AH index and return to user space
Date: Sat, 21 Nov 2026 22:38:51 -0500
Message-ID: <2026-11-21-2-daily-reply-0008@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <866e1857-f714-4150-b3c2-12c0c3573d41@oracle.com>
References: <866e1857-f714-4150-b3c2-12c0c3573d41@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I suggest: Supply the indexed-pool setup from 99c13a3e2965 ("RDMA/rxe:
> Change AH objects to indexed"), including the flag, bounds and maximum
> count. Or drop this for now.

Queued 99c13a3e2965 ahead of it for 5.15, thanks. It keeps 5.15's
RXE_MAX_AH of 100 and only adds the AH index bounds.

-- 
Thanks,
Sasha
