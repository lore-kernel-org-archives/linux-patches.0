Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDA9445ADA;
	Fri,  2 Oct 2026 21:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975447; cv=none; b=AjICPFh8k63JE5fB1s50QUmsa3tx8TSl7fdoUVWC/da1Y+vtCiqhpiEcyJaO3KcpZ13c8w07fByj7Ag4W0Jh5ZhSwFoMgsBpkZhWViXGoNQF55HbbuGNkCqnxLeBnGrO9G0hrqNzInSFOkvlfjqeN3l7e+tqCzDwkec6P8jDvZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975447; c=relaxed/simple;
	bh=XPLDu6F2ntIQ4YglgW8qhwflSfICufIKTYBNfWKaO9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPbpFJ8zfkfpLD6ji7FCu0g7wHYNgACsEtmbL65nOIvq8lZKn6YSxKWON5C1oxPBlhpKY2PPifFVG3zQ/C8kt0SnhBCQ+AHmT29L1TkEdyUzrT+obv4OUAYKX61S2s2r4RK4p/bkZvMQIVtq4HTtOcB6g2Sy8mr9HK1mVTLzlOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LA1c8D5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LA1c8D5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219BC1F00898;
	Fri,  2 Oct 2026 21:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975446;
	bh=BmnnJlIxsaPAhEd4QXeBudSDLNrVN6zWW8MhOIVWxoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LA1c8D5tkxy6olG8ElsFc2/knxyMBSRun4knXL6dVMpHHoHtT+sGq7k6sE67bk/UQ
	 Fmq1aM/+34uHbc40BR2N1tQTO8ecFhCR2kdN0vX+Zd+CJMbNgcNAy26cYM2+pVPFOA
	 /qlFgZKszI1Af85CjjrN2Xs3NboNkUzc0BBurofcDfHtKix+aNMZbeXWuphCbvd+T0
	 PJmu+sCV93TpmaS9GRis8U+50+nWUx3sPTVb09xvjXdKcQ1kiA+AmQkkeotTQcKSMc
	 UBT35f0ud0uK7VtFm9xdHJhcBolxUjMBMtrEH0HwS8+VaFWGJCs6WphNhiDytuK7ZS
	 KN4Cfn0PO69hA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 092/877] neighbour: Use rtnl_register_many().
Date: Fri,  2 Oct 2026 17:10:33 -0400
Message-ID: <2026-10-02-1-daily-reply-0007-re-neighbour-skip-default-parms-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d26d9da3-5d91-41f5-9270-863f34c772bd@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152416.722458210@linuxfoundation.org> <d26d9da3-5d91-41f5-9270-863f34c772bd@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")

[...]

> Lets drop this until we also take a prereq ?

Greg dropped the series. I've queued the neightbl_dump_info() fix by
itself for 6.12, thanks.

-- 
Thanks,
Sasha
