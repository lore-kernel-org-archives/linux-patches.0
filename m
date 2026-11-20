Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207200;
	b=16h8/UEzrWJEoGOhy+nRm0gKeX/hx6q5ezT5SnG5Rf60MUHNy+PXPlEN9EMLdneruNIQ
	 kYSDzo1jzPG/LU5lg3NjGdjd3O6a5oi2VrsUogLcxsBGWxu5QhXzHGcjPPHvsopJr0gtT
	 ulHphroiCQqCY+bmnJqRiacdrhUqd/azd7kA8sSTG7eF2rPtfY3inbg1H31honzYfQwDy
	 jHdDczgBzBFZ+eTjz5jZ++1Vhr2AM52rvE1sO0seXGjV9ZIAGCEq2PCkXl35kRm7Ohrg4
	 R+G5CdtMLhxBA/k6MqLl5cYQ/xZNoCajniCGc9gVUSgaP1coku/q9rej9bPgMcxFW+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DCVjU5dyWpapwHwgmpFCYM6C1HgcbYl838gMaGuFvOQ=;
	b=GYqTkd8729Gz5JsYEACxmWL2isdmwjkDf9rnAq0JwpNIrzNV1TZRypB4zr11Hhq9g9jC
	 TVLPlNLvKp/m8sXou8tEdXJDfJMR9I3rVEI3E8s7FVEV8k2GolIlLjem0r5mqrqcghfpE
	 jFypw/BW4Ouh8LfNhpwiJsLq4vxBqFqQVCdHjJYJuVAr9giSFB81F37e0o+5gPsotdDNB
	 zJXxd/vk+t3JHgc86jJh8cU5vs8En2T6t5RAvptYG66zutGNdgRpH2rckLiYP8HH5vA3U
	 PLIrJmNfuUTFde1Z6z0mXQ0uc7ggDVJJCTkohj01U97R+tk1/NvU7X+s52Pfn4iUe7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZETKozk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC55606A33D;
	Fri, 20 Nov 2026 20:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZETKozk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A978D1F000C6;
	Fri, 20 Nov 2026 20:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207199;
	bh=DCVjU5dyWpapwHwgmpFCYM6C1HgcbYl838gMaGuFvOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZETKozk1WbINvW5bOS+p2e1qsJr+CYTni4sG/wEPoO4X2zofMaK7C65ftXMWdtsS
	 O1WJb36exOe1PYAJRNOU96FgWCgWv4OmhpWNy3UmOwG6/HGN/1wNDEeQMoOBvnVVdm
	 Sjs+XZBOH/u1uq08QKt7UJFH0JpHjXKe2PT3WR0XQWF8z/GofQZ0WqOtIkR96WwPxa
	 Z8ol4IJ2lD5sKqGc37wLnfBiNuobZxkPvizsvgnq43kZ58P/2TBb1hHWjsmCN+MnVp
	 SZeO1i0Yhiu5FL2iVBOQAo4jASX2tnoM0IY8FLgSjJMbMi00l/9a+63tzyOOkUNfEs
	 DPrvYIapIzMJg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	SJ Park <sj@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Colin Cross <ccross@google.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0091/1756] mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
Date: Fri, 20 Nov 2026 15:39:12 -0500
Message-ID: <2026-11-20-1-daily-reply-0023@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a4f52715-73e4-49ee-9bc2-5b09b2195f42@oracle.com>
References: <a4f52715-73e4-49ee-9bc2-5b09b2195f42@oracle.com>
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

> Upstream supplies sticky propagation through 64212ba02e66 ("mm:
> implement sticky VMA flags") and 6707915e030a ("mm: propagate
> VM_SOFTDIRTY on merge").
>
> Should we drop this patch until we have these backports ?

Dropped from 6.12, 6.6 and 6.1, since the sticky-flag merge propagation is
missing there. 7.3 and 6.18 keep it. Thanks!

-- 
Thanks,
Sasha
