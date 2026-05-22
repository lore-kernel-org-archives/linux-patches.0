Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE635675F;
	Fri, 22 May 2026 13:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455565; cv=none; b=JjHL+HhhF9jXacCifky/wPq66E881kVTxqi+beB8nUVsQaANPLrQDARuuyMKnlVsnt6Sg39bkzxTNLsrQ3GB4936WFJvKZgnHKPbpwBnofo8RSVFvjv6cLy6Wmx2rNG5uVDRHBBhvk4weAibNT09y/WnDLIwVUmTMeDHEgpnwmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455565; c=relaxed/simple;
	bh=xHP99JOSb7QXdOdGYHj8nJnQwp268iIMFoEmZ1tmNZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IcYXhpqNGlrw0ExsMBo8BQecWlrX+CGkKQD9LgnCIF6LQg8k5que3GpSiB1aGiTFaYWf4aEtVdOmjL64xt8z7WvNxJwGmmlzfrwY/DIRvgtHn1Y4kiQyokfXUBVFuA2O3kWTSE9CMVbEyazcz8xVYU/EN86MMK7LWxYRDelHaw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLtxUYmM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLtxUYmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9901F000E9;
	Fri, 22 May 2026 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455564;
	bh=xHP99JOSb7QXdOdGYHj8nJnQwp268iIMFoEmZ1tmNZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLtxUYmMZY0TnFtclx7kgoRGfX/ERw6VL6tZbcUEh5Nc4yPnahQCPB8xiwQjeF+bU
	 KKGikSBu26knMFZZRQjZMVaaG9qAQInyeaXHke6UjtJZcYIWyPmPl5qD2ybupiMq29
	 GWY5FQftWcvKidivgEWkV4jh9SQYf7w+A484UgzffOmTs6zIIm18B3b/7mhLLTWNza
	 1Wwzgn1O1cBGAQJBITKCXwxHYeVueOTiPMG3MsuSyhM3J+3mL0PKdke1yqof4SRPWw
	 +mDth16krBOcbwZFSz1eQI0B+ZaOLZ6pxkAwhpEMAHS47NT0w+tyWH/aLrpWtl2c9W
	 yMMtDYDu8+a4g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 346/666] bpf, riscv: Remove redundant bpf_flush_icache() after pack allocator finalize
Date: Fri, 22 May 2026 09:12:28 -0400
Message-ID: <20260522123641.rc-drop-46ee1342b887@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b8ef921f-e2ab-4cfb-b75c-89e4277214cf@oracle.com>
References: <20260520162111.222830634@linuxfoundation.org> <20260520162118.730164877@linuxfoundation.org> <b8ef921f-e2ab-4cfb-b75c-89e4277214cf@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, May 22, 2026 at 03:27:13PM +0530, Harshit Mogalapalli wrote:
> Upstream doesn't have this problem because this call is removed in
> commit: 6798668ab195 ("riscv, bpf: Remove duplicated
> bpf_flush_icache()") but this is not present in 6.12.91 so I think it is
> incorrect to backport this, should we drop this ?

Dropped from the 6.12 and 6.6 queues — 6.6 has the same missing
prerequisite. Thanks for the report.

--
Thanks,
Sasha
