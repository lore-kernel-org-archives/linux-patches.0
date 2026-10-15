Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B5881724;
	Thu, 15 Oct 2026 00:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022931; cv=none; b=N1ZDwDxiTAmeva75Llis7aQiZk66g9S3ye8t8dxdkfpykbZox03+UkvbNthqPwocME9gPhPlfo1HgneH4PZeg/rM7iw9/H5+RZitLRU3FlNy8cjaSlm73kCtsR9eyzWbgzrA0N/ICyyVa/9KNHShgJEiI+U3iGtijEPK5TGrLok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022931; c=relaxed/simple;
	bh=zySB44Hi6stWucx50q/A4XLI2CO+CQ3BqhvgxRK2k8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/zN9bQlfYuRT5cxhAEHomORbQ+QmEKULZL2nBsSxG5e3nWgHMd0covSK0JUbsZ/Ne8NedU4NAmAt+HBmizLbvr/+AfdDpClzG7kxtzS331WhLL4iLr16HuUfnoU66EIpauLvJkGCXvMQlumnMv2BUeZU3teJTtCQ+8OFLE817k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4vgA04O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4vgA04O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D741F000C8;
	Thu, 15 Oct 2026 00:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022930;
	bh=ELqfEN1q7IMpmcLd0nAwzQ7X/2Uj5mg6A44N4pcFdqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4vgA04OubaAnjRLa6NNmgZocgWkpSZoLvdpGZ7GtrxGIdekDhqs+wCaorSyH3bad
	 Q/1RzllluDsvIKc7g9Ga91z4oyRlaPtzBwRGRpyA9rdOgHbVl/OxxCsM279sjKVFnv
	 aQWkOXiVYoOy4AC4S6T+5B05czWHpInDpxF++dseJH9s7bmpo2CAZsntfajmB9eI1G
	 Q/r4fJol7hzmj/dke4umBihRuPQhI7Bs2FMt6hX37wIzE1aPJF5nXly6TFVAHGTL6a
	 mjgKBbBEy7JCg7CFfysVPtcpDMkDHldqCx5tB6Xvmv2InUzPCUlhLR1UI8qZ+kBGcl
	 CLtJYB+cgoW/w==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Junnan Zhang <zhangjn_dev@163.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.12 487/497] net/packet: call packet_parse_headers after virtio_net_hdr_to_skb
Date: Wed, 14 Oct 2026 20:08:38 -0400
Message-ID: <8794a5240e93445a8afca86a@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2e6da5aa-4301-4b9e-b224-d54a3e0521de@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112919.435445950@linuxfoundation.org> <2e6da5aa-4301-4b9e-b224-d54a3e0521de@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> So I think we need to take this prereq commit before this patch.

Dropped from the 6.18 and 6.12 queues, since 44378d02c5aa is not queued there.
7.2 keeps the patch, with 44378d02c5aa queued ahead of it. It can come back
together with 44378d02c5aa.

-- 
Thanks,
Sasha
