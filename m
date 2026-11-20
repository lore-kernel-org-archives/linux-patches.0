Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207169;
	b=2MbJ9qRzDNr3IrqcCLt87aBNhQobmTH614cE1G1JF2Sxvpt/k60Uu7Ux3GQODxmYKdp4
	 lD2/ojI1igAADtUaatGnaGU0+657O9pU3/RtFUnvak1bOJQ8xLcTlS+x/lIVllKlpj6XZ
	 QsDXgkmo2l8Vi02yzWr5SnoPI/FnkcD+c3qr9WNbG9i51sl1AOQOKslaLn5HPpyEqkt8Q
	 f7kGJkVrQJcisEdrgrqzfzQVRDCKhhVSJzgb2MnCupwMbAglVF8UoL4RyzrwrApFWULXH
	 J0Xvgu9W4WRAr14NX56ThC6i0rd+1mGaZav+0chPtUr6rGyew9Ul7J+NBnTJz8aqG7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=9WRh3lMhqGX8fLFGpf319A/rK37D7i/I4aDzmNYd/hw=;
	b=aONRBQ9X4SyVwA2pK6AVd6F6gXEV80hbPjeiTk4AW4UE7Cs58wFUK1Wg7nTh/yUhYu6m
	 BkPCBb5j1DpATZFjRnMfJroIZnpWSa3Ll+qiGOS6X32NJ+3Gctgxg1C7RzWFf9+1kStbb
	 qnh3wmLZhaSe/Myvc4myaF/hYIE3y9RTZLA1IHBO+CQSMnwK9SzN77YA4IJBIS9uFpdsq
	 +EQg7fS3wJeceqmRhIJOtgHaMCjHI9LRvM4s6NSkAWZyG532swGWLK40vDbSWYolF4j84
	 SK+J5VOONXi58W1f55X9ZZlS89oqTjA+rGVL4hMO7Rlb1kB/V+9p5tyYO9JMe3kUO6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hB6QVgRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEBB606A6DF;
	Fri, 20 Nov 2026 20:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hB6QVgRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598181F000E0;
	Fri, 20 Nov 2026 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207168;
	bh=9WRh3lMhqGX8fLFGpf319A/rK37D7i/I4aDzmNYd/hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hB6QVgRj9lfcwuew3i5ykPAtyh14DvqR6IoOeTQlOrIlD4h2s7YQVvqe2U2D83m3m
	 tgkRUlt8Yzfybq0W6gAvf/jbg5oyqtreNjiMvwxT19bEqqpupkNk6pq2qaxSYZatM1
	 FCZEToxLN1eGZMtJZDW7Ux92MPvMSDfHa47PvVNSo2ecJvIpLl6SsnBraT0IFuDrSK
	 J0acXk03segCE1WUfD87TAni0Y/VsvI6szqYALyiB2hWfGCqjOErKtS059L1HKQevu
	 CIKZfFL+SEldN/0JZOpdK8PbjQNIehAzc/Y7lZUmteMhRtObJr+2USiBVz/N/JiSSU
	 egQKttY/6fU1w==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0819/1756] perf/cxl: Dont share the overflow interrupt, and keep it pinned
Date: Fri, 20 Nov 2026 15:38:52 -0500
Message-ID: <2026-11-20-1-daily-reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <8d1be42c-3ecc-498a-a4b3-3c9ed2f2bafe@oracle.com>
References: <8d1be42c-3ecc-498a-a4b3-3c9ed2f2bafe@oracle.com>
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

> I think this needs 28b2b667f48f ("cxl/pci: Add the PMUs after
> configuring events").
[...]
> Could we take the prerequisite first ?

Queued the missing prerequisite for 7.3, 6.18, 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
