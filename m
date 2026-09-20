Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B01533DEF9;
	Sun, 20 Sep 2026 00:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865245; cv=none; b=q5MaQBXGt/xXbQDh2DuhM3CQ/H6Ypw9oXOIY/Dp/KmjlM8jUZkh7ZsW645E0BOYC0zSo+pO4X8SRmF/xVnkuY8oqcTim/B6vbzl67xL5DWe75ez+NkP3bF8W47YmFiiYG7zb4bThtYjCC6yHdUm3gtDiUVowSgd2fCUPpgzE1Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865245; c=relaxed/simple;
	bh=mu51icW85SI+uZN4Hp1fKOx09oxb4bcXI/HZ2M+zOHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk6Jc53+pkcCr+2HJSRigfFOmvOguI48PXgOeHRf8cQ+3tLjw6PBdn5bvdf3rkPca+qcFY1PYsMyayNRl8Ql82hKlgfGQvGHSLlFJAt6qxcSNBp+KqDkujKuacaRDyME0RJypeU64Vh8jKMhSoEPPtkr2xotswBQLd84ZrchygQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNq+OS+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNq+OS+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EB51F00898;
	Sun, 20 Sep 2026 00:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865243;
	bh=EXnaZ7ZUGcKJoOmnjHUiQ4zTcQbBaf+IMDdhwdz/aDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNq+OS+wxJzLUPlgcgE43pDGPJqkdmoAdgid8g6dnFlWieLcZ5vMwbKY755GfRqty
	 w5Y9HbGe4tsS8v5b6BayOYT1g8pJwJLjp8sZLi151ghhCfhNPRkg2fy+4GZBPN3pJH
	 Nuc+zNRnLZBZ763pJZ7aAL5kfwimPTHUoFbZQ+62KaGkmqkIMlazelybBiLHTqS4Fq
	 p3tymWB+0QVXAhcb/5If0ohYg1ayqKaZIBLf1Sdtm2hZV3Hl7T91i4PNyKbdLGi/W/
	 dk7PwUQq3s1Qj+z8dbOAUMa11L1P2rHv/tafon1Il/GDAz3UWuO26jxhQrAW9EdFef
	 kAiLxaVWrtCiw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 424/935] bpftool: Update btf_dump__new() and perf_buffer__new_raw() calls
Date: Sat, 19 Sep 2026 20:47:11 -0400
Message-ID: <20260920000825.9-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <51f57a9f-3960-4d8f-b6a4-26ca6985f35a@oracle.com>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065536.549009682@linuxfoundation.org> <51f57a9f-3960-4d8f-b6a4-26ca6985f35a@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 02:09:33AM +0530, Harshit Mogalapalli wrote:
> So bpftool does not build: LIBBPF_OPTS is undefined and the
> perf_buffer__new_raw() call has too many arguments.
>
> Should we revert this and followup patches to this(this is pulled in as
> a stable-dep-of) or comeup with a downstream fix ?

Both breaks confirmed on 5.15: there's no LIBBPF_OPTS anywhere under tools/ on
that branch (only DECLARE_LIBBPF_OPTS in tools/lib/bpf/libbpf_common.h), and
tools/lib/bpf/libbpf.h still declares the 3-argument perf_buffer__new_raw()
while map_perf_ring.c calls it with six.

-- 
Thanks,
Sasha
