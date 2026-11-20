Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207189;
	b=q7H49k6G2BoYtR8jpnxdUV6yI7rMKW7tIJhk050UM7K47LScjGe5H98ejPlymarRngf+
	 +mDMMjjlqxrqZTu65TznxPR19PmOqkLrDbRKGKdcpSW86lxPvc5DYCtNwyjLF3i6jNOVN
	 LIs8bP/sqUiU7J/3+XbkW3OOiMjXEqv/2P5WHBLojOvBLLlt5qQ1foNlTtw72w5pJQ+i7
	 b3EzLb93N4MSYAu5knnnx5mfKVfa1IatntcXMrUjbE8PEPdEZSKrG9G7abcGzDs59PZR5
	 s2NmxlJdtFkn4oVTdW3tGhivzivexU8nkP3ASVG2cXRfroRS6DSmIThJ3zK3VxP+aXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=EmN12LhlyKkznDZAuIyzpKEQFrQZD3F1KizYRUQ2+9w=;
	b=GLBli8lsq4DH/j2fTtRMtoe2ewXCzOrKKrXMCV7r1G0byu3ypn9st24Jdtr+8qQ+SOD+
	 S3VE+8dBsiX/4lTmGVZEyL1zsGLL5583/OCIXIVXxgKxfrVUkon2gLBlF1KgxLcWLZj9i
	 WPMDx0nngjUNhj2gEHbfU4NLKeQ4dw2Z4Le1qVdhhWx7dW0Cr1AuwsEhsNvzzlDaSnGBW
	 VmmZbqvTGkHAV0iBjW14kiL8pHYK8trPQoMqwz6QvCHKfKPAUF09YZG/OeELVXSgdEFnm
	 O6DCxPv1paFj/NqBlb6HYHGa1XeZCkN6JuVlN47kG7gznN7AWecpjyLOAdFI5NTZFbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F64s3+T8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5100606A6E0;
	Fri, 20 Nov 2026 20:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F64s3+T8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A46D1F000D4;
	Fri, 20 Nov 2026 20:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207188;
	bh=EmN12LhlyKkznDZAuIyzpKEQFrQZD3F1KizYRUQ2+9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F64s3+T8fuLH00iUjzg4yTLy5SsxOuUtmhWEK8jzVfJOJ0i4lsvxkwfkWQA5PIvMr
	 LxA51uCQYi3P1zGEP90uIJm2dw4PNpI1lwVSUKMWIJUM18/gLOZAo9iug6sI/lFkLy
	 kZQ2bNbRrskHVwSGZdmwRx/TPb1xz6NrrMjMpR5+tP/ZyLwRyB+t1ZCiFYKJN1dSea
	 2qxUkJCVS/zVTCWUnjel/CT8eGL62/ovx8foSIBza3CMpdtzT0UFnNE4gbBAdM4S+H
	 OZ9IdbU8RI6uYrpG2pVOtlV/pJe1z49TtD3HYb0aEpxX+0p7ZzI+Taq8ptXtX5UXfd
	 9c4kN1BH2Dgcg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0609/1756] scsi: ufs: core: Serialize AHIT register access between sysfs and host driver
Date: Fri, 20 Nov 2026 15:39:05 -0500
Message-ID: <2026-11-20-1-daily-reply-0016@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a66ae595-37bd-405a-8ce4-d29da68a70f9@oracle.com>
References: <a66ae595-37bd-405a-8ce4-d29da68a70f9@oracle.com>
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

> Upstream supplies the failure notification through 6efee14ca0ae
> ("scsi: ufs: core: Always notify POST_CHANGE even on gear switch failure").
>
> I think we need this prerequisite before queueing this patch.

6efee14ca0ae ("scsi: ufs: core: Always notify POST_CHANGE even on gear switch
failure") doesn't apply to 6.12 without the v7.1 vop rework, so I've dropped
the AHIT patch from 6.12 instead, thanks.

-- 
Thanks,
Sasha
