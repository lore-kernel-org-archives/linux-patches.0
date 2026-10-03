Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3D237269A;
	Sat,  3 Oct 2026 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991037; cv=none; b=qiye9xQ1+IbMO+gSXWMuYj97nfp8MDMtxxuxB1RvmmjnxPcz119iJUF6XqFsjyjZDxBshLD3oQntDFtjyvf/9ds2bYYIEDLmoL8fzHnpG9uHAdqg1BG/ZP9TF3lv3aglsX2l+0+J3x6PBiTzJWeYHhEnh/JGgTzkxhIL6R3S/JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991037; c=relaxed/simple;
	bh=x58q0I+dfYC1dK2J1uHBgqbj2a98hdhe6Q1Bd/ygK/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEDkCxl2ln/ZClU98CJz45YPoaLyUVKqD2jC10NDVMeFNWCU7lvHTzYlSi7qi47z7utC42cPIK3KjcrepRfYqZysUOPNszzXDyeCHbrhjQjIkkfXbj2bUM2IKETEo4uE/LIHTDe2wXIhQ+j5LfaNrrYxjxI84SVTZ5TywIoPwLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPiyHQZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPiyHQZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495231F00898;
	Sat,  3 Oct 2026 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991036;
	bh=Kz/jwBC0h14fDo+khPhGV4mcwriCrNJnLVAUvk5C5Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPiyHQZUHoPuGIjHNuXUdYF1TigwUSDpGjyaHWWLTQjknxdAU6bAjyjrFQbkTfFjS
	 gLImWGRY9JHFcIlKIt1sYHRNp2nYwCurqgL3Ak50pHqXietU1pLxeZtqp5sNRfbLmd
	 jNB0hS2MNc50Bkylz7Yc1d/YhcOuxE07s91YRy6f06tP9J6TXVGFE9QrJaT98vH6Cm
	 C3lSFNxwmbNsCP8XS5pCXpgCBga/2FN5xMtT2X4BTc4CnTGN9OpXeVohtCNTKomtBF
	 UfSRA+8o7rG+xnljEaGL88dHu6o7SEoDge3d7TwYMi2vZGkRoKHzgzJZfqTvGvdLma
	 OAJ7YljlFoXjQ==
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
Date: Fri,  2 Oct 2026 21:30:26 -0400
Message-ID: <2026-10-02-rc-reply-0006-re-bpf-dev-bound-prereq@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a0e22b8a-ddc8-41de-82f0-503edc57a1b9@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152423.316713397@linuxfoundation.org> <b3ccd2a3-a51d-41d9-9374-68a392d23ccb@oracle.com> <a0e22b8a-ddc8-41de-82f0-503edc57a1b9@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think we need to drop this until we take the prereq as well Greg.

ad27ed7d2309 ("bpf, xdp: move offload check into dev_xdp_install()")
is queued for the next 6.12 and 6.6 releases.

I'm keeping 6db1ce73e985 in this release, because it independently
closes the BPF_LINK_CREATE/netlink path. Without the prereq the
LINK_UPDATE path stays open, as it already is today, so the fix is
incomplete but not a regression. Dropping it would leave both paths
open.

-- 
Thanks,
Sasha
