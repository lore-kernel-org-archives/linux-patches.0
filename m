Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCB83559F8
	for <patches@lists.linux.dev>; Tue, 28 Jul 2026 03:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209940; cv=none; b=sXdSnoXMcwZU9NhFPAExeKZqMKSDzXpYF2DTyLeiCbZXyZsgzI0LdpmJVWnSub71u67/CkT2NMx7Kx2Ar9MhIXPGDAGtN42rKTsHi21D0SvsyM7jXLbkjdmfcrHC6ToZXcXT1VQhXleCXviQLBhnoorHIxJa0lqTFEifANx70Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209940; c=relaxed/simple;
	bh=2eXpiKvubaF4VodsTzMjIDoCZQpZR/9vS4GEsI9JFTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ClixvagjFk8vdxMDvkSOzD+U8OpYuXPzhEqULZXjJKZwlm1Z0mjjgGQxY2J/YlDqvr4lnxWSsc+/bytU7NxhzyD0xsFmtielmakva9c3nY0f9VChDapPMI7U4UrlY9To1XOFjrW7ufG/tiOdNmtCrSSUY2nmdiYXpqG5OXJkUGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=OPSWTFxX; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="OPSWTFxX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785209902;
	bh=2eXpiKvubaF4VodsTzMjIDoCZQpZR/9vS4GEsI9JFTs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=OPSWTFxXo/erczALoOApBaqkUT1OYeAArAb79ayLHI/trIQI2PxJXLeIJXOXJtI58
	 3RHmYDvwiWdzHcFGsy2+rKJO4I7ZoG0MCeJ4hBoPnohnF6FNzTAk1T4eQrtkVY8t2K
	 JuI7D+j3OLpB3oKZJmjHo7gSQ4mmoUkyz6Ofvd8s=
X-QQ-mid: zesmtpgz7t1785209893tdf295776
X-QQ-Originating-IP: GkTEerGl7J7CT4cqQ6aoeExvPjtG2+B017mh9DOkrOg=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 28 Jul 2026 11:38:11 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11166998439360330487
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: andrii@kernel.org,
	ast@kernel.org,
	kpsingh@kernel.org,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org,
	xukuohai@huawei.com
Subject: Re: [PATCH 6.6 0772/1266] bpf, lsm: Add disabled BPF LSM hook list
Date: Tue, 28 Jul 2026 11:38:10 +0800
Message-Id: <20260728033810.1870379-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260721152459.140898269@linuxfoundation.org>
References: <20260721152459.140898269@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NAtipnnbTPea+aNH8FRrsJRoedTR8oAzEsT7QDaygReON/uam/m2P4/A
	AUTt3NizVZUVbvcor/5Q/yKFtZN6FoMLeVn/jp25zuT6VH14C4IZ8j6Hb3yQdQ74Moeucoc
	ghQhRMdmozEXRtNhkm+Na9ZIgoB26gLzBg3ls6WhETIeH+r+RMUAH1LdEpFY7Un2oXDzL/Q
	BDzavWPTM20HzDt3mWnkg5nR4ZICdil1S5RBPeI5Gi840fKAV0fZaaol2ZrmQ0hIt5AVwCx
	QoQE059G5wrLlD5JH+GWklS/8NiXBJkoxZWu3y+GXnYeXsX6jWDl5Uoja+dh2imdN3dv90L
	wcqfJh3LgLWGevhDebkkkZB8Ofiql4JhgZjchUcltRHDKSqvLPcaNdpPxeSqecPpAj8QMSc
	EGgJGkwXsydtTQIjmNyNDE9kPQg9JqVxt1IcRupuRolFLiA+Ro9TEJskevAYVqrbNUpBuJM
	gqHJOPGzCflNIAPEeRJ7jyvP+Jwr/L8LjeZvLhHOfGuMjovRuE3FI5iPzkWtleTlifvqimW
	s3v5FokilzoTf+ZIfX52H2Maj3h9P76WLB2MEsKZS/9ylCqoGjaGmDRds1ztu8bWr0ElE9H
	TZ/ycNxOcO/3+qKY2UH1KwxrVEkCK+J+oOy19aL83MBjmAP+U5Ae0vfKPFwSiHoVK8AcZ/c
	eBbLanUkLkBTjGPhmCgNX3pJtnzFhd2M5qlXzouWnEzgrOmCblpHj2iAsulm4UA8R3hDe6F
	RQ3lIN2VyhvQ0T3/AfsTDMX05lPHDpZNT+NPRZkC3EmwCYm5od4HrN7U7rWpN+YlhE8FqPG
	A0CLw9h4pF/mlJxrN4RPb9HrZUf4zhKJqMUKCNxGw5hqkq/V0Z+sWibXdnkjMW0DAhy3KEa
	n19VW7YAiYYoW7+O5P0ufCOgzYG4gArMHoYHJyZAUtOi8qrjWCXU0ZoKoGsA8Ym/yLsTJqm
	b+DiKLHR6hEj3TuoZDnSnr7XMxsgL0XkMsTrXsV26t6RqChVmoM/neHw/JQUsA9ySP+ztMr
	1WK3ouDqekz4y5xTRT5k5/uWx5ztE=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

Hello All,

backport ("bpf, lsm: Add disabled BPF LSM hook list") for v6.6.y bring the new
build warning for us, let your know that.

and the lsm_getselfattr from a04a1198088a1378d0389c250cc684f649bcc91e commit
("LSM: syscalls for current process attributes"), I suggest that use a not
upstream commit to just drop 'BTF_ID(func, bpf_lsm_getselfattr)' from 6.6.y.
Maybe 6.1.y has the problem too.

BRs
Wentao Guan

Log:
WARN: resolve_btfids: unresolved symbol bpf_lsm_getselfattr

