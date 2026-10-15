Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22A582BAC;
	Thu, 15 Oct 2026 19:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792093005; cv=none; b=KUk20N1WGUZcBHdgzzqrE+bLHbtKh0XtfEOvOgS7aG6BEMfmnVypK0N803bea6yUg16RKQs36SxVN3DoyHTucGFVtLDKIJ/VTkiWYaRXoO4yMl24lA1f6dothy/fuUj5ET+BknrmbrVwGdkjyJsSZP+JeNRR97EJr+A2Qe/HZmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792093005; c=relaxed/simple;
	bh=QVFHuphU4SS+0gzwHHpOlvdAKf609W319rYjho8z2Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk0TVEfLTre30IaxgBc381HxjzCXKZ0PgdDOcjQp2WR65pFIlYcgr2DHbMUYzdVN32KfTzexuQHuLtFiV6hJAVug56EvFDvS8xTnpxlTAb78Esh95d7WqsjRIJBv28ozdX52oB2Rm50XQrQNI1rSLc8ijgNMsTGdIVlv5IjJwto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUiUkdhg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUiUkdhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B67B1F000C5;
	Thu, 15 Oct 2026 19:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792093004;
	bh=tAn77Y0HClmmPwNlmwl14kNKFVqFycKEPSp/esJ/Q00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUiUkdhgB5nq3oObB+giKSAX+GTp1BVvOmGjc90y/CeXShUYo3U3xaz5TyyITGkGA
	 vW27jsLLR5mIgqcfi8S3jaR4fmWXGjNr6jZc4HLNFKJVNc3LJS/240YdPffK4sl8y5
	 G93z0mkHtGLLd5xoXbo4MB132fardC8ydPhfMTVUu8/6xCcom4kbNdp5B/yB9hXm0x
	 /e7RuuAbooCg5VgK/6qbbw8Wch8WATmQ7S6jY//3L9RiowrcbS0BDiHfkSnj0YYHhV
	 ZpNKgHQAPKi5T4poPSpcYa1v/i5PigRDoOpzjnXpSY0Q7PjDrxMHY4hQ0G+epA+iGS
	 bmQt/fcx+Xx1Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Nikola Prica <nikola.prica@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 112/497] PCI: Accept AtomicOps already enabled by the hypervisor
Date: Thu, 15 Oct 2026 15:36:01 -0400
Message-ID: <2026-10-15-1-daily-reply-0018-pci-atomicops-rciep-112@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <55fe666e-77e9-45eb-9a9f-0d5a22abbfd6@oracle.com>
References: <55fe666e-77e9-45eb-9a9f-0d5a22abbfd6@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> 03ec922f0025 ("PCI: Do not enable AtomicOps by RCiEPs"), which precedes
> the upstream patch and has no equivalent at either endpoint.
>
> So we need to backport this prereq before this patch I think.

1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports them") is
already in every stable tree, and an RCiEP has no visible Root Port, so it is
rejected there unless the hypervisor has already set AtomicOp Requester Enable.
That is the only case where stable differs from mainline. It keeps working
atomics today, and 03ec922f0025 would turn it into -EINVAL. The divergence is
limited to that case and is in the permissive direction, so stable does not
need the prerequisite.

-- 
Thanks,
Sasha
