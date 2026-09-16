Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71B40759B;
	Wed, 16 Sep 2026 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586953; cv=none; b=g8lcxNxugBbGhwsTYniUtQrbFBpwU3wmWsQ5S1bGHZ0pwQrvm3zv6bSrOzYwbcaqyoQja7h/Jl621dID9Hm1BwTor21EtRRWORGbKNhnMlDATxfRyl3wXU/gMrNNFjHMGNrbfz8v5Y72X6hOWeQFsHkL1T22m18faivDPN49tC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586953; c=relaxed/simple;
	bh=pEphxP3uu87dALF01Hvqo/+zcvYmkouZsspTSwduo4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRuwTdn5JOB0eia0g2oadDgAlytUdHvYV2RzU3w2Xr3Q4LAbBgW3L3bmFN4juBJuYFq3ln5CUgLRYtvOlcbUz8RIfV/UaU+vWgO1PX9HsQE0S+bBN+/1XcFWNIt2RrVw1vbbGXKQ6vPrXP3raoMAUbLhUeAMX+J8pXgNlggLHtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTpXTTz/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTpXTTz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53A51F008A2;
	Wed, 16 Sep 2026 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586924;
	bh=0izCBKk6SLFrgtje2UO8p6h7GjeE6rhDGdlFF48Wrdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTpXTTz/T90twzvmGbQmtiirSLeJCZTLpsNk34heIWd0ediWW2WR0kOgP382Nn+P5
	 kkurN0IRz1JqBO+MLSt6VkC9+0tyUvn2U/DwOB+cYpVJ17oh/fi7UEL/BoUU91L7H5
	 R7JCNRAXUppLF7qK+zxn5jk/56+FmOE20fLR4bbyPcQPj5HViQsyfqmwpuD43/cbcH
	 CN8StS+GvpK7FaTMhbtX3CGcMcuBWL554GVR3xHkvlgKrhA2QddckP9Kr2mWOEHHmv
	 8ybKj1PmOIT9XK/oOoWq9yaOuh897OGUq6DBpuVJ2GO8GK3BUAgOdqcaWj6yqtYfw7
	 gbJ8VxZptnxKw==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 0490/1376] usb: fix UAF when probe runs concurrent to dyn ID removal
Date: Wed, 16 Sep 2026 15:28:05 -0400
Message-ID: <daily-reply-20260916-0015-re-usb-dyn-id-series@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DLGKH0BATEY5.OS1S70FJCB7A@garyguo.net>
References: <DLGKH0BATEY5.OS1S70FJCB7A@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think it'd be good if the other patches in that series are backported too --
> but that shouldn't be dependency of the core fix.

Queued for 7.2, 6.18, 6.12, 6.6 and 6.1, thanks.

One exception: 934e1322f18c ("usb: serial: spcp8x5: don't store
usb_device_id") is skipped on 6.1, where usb-serial never exposes remove_id
and re-derives the id itself, so the stored pointer cannot dangle there.

-- 
Thanks,
Sasha
