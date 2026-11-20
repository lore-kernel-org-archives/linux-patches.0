Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207167;
	b=f6TOlMyORyhBQ0z0DhjgM+FbQ+5a7CwUiYGLiPF3yFvPqo/IgmRTtsl+RaQcc41RGX8t
	 miUwVYrCGR0xe27qIy48Bb0TXfV/ZPUCpqQaP2uuUHiG19itPCtO0cKtYoNO5YW2AlV5L
	 AU4/87EZlX/u/bHz87GVi72sqXjaXCgovwm5NXlUd4AMv8SPjPwu6N9ZX3uMrB9lk7CC4
	 NGK2U25xieHrah9FAvVJN70B4tNenTCerg2OgUj9MtE7UKni2Z/pwqwJHo5X/EHftjs7b
	 vTvB16HeUwk5KI1u9xJHOxh27g7AnQd+c8hSSvb8jI25tQ/ZJngwFy5yyzrvMfp6haA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LSH8huXbtkdEaicZiDrj7pV6Rv+QBDLOAstg1Ubm3uk=;
	b=R9s3IUq26FEFzYzhAA+YuCOSmkS0Mb18CI1AtB/htfGLY9LQNJR93vKUOKZvLiXU/Swy
	 VbMfUm5qwB01Ql0Jg5m1iRO/m/OM4F0/st1JtzPjKTBw/K7DesNTaks45paDYU7SE9mMH
	 5E5Ge06uHuvfgOhVoTcoM66aLhqDIib4j2OL7rxFgmmLsXsj9KW4MfPr0WsGVdeaEY4Ww
	 p/Zj6/rtBTVZWTnrYqCc9R1XGncdI+4Sq2Pq6s1ip/x913aQ3C1AarB8t6hAFmH6MJO6R
	 65YKZUa04v5KG+LsT0Px078PHMYThygR4WPdGYr5XT0JI//X9+JgTlbXDV38+8xohzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pxz46cYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C0A606A6DA;
	Fri, 20 Nov 2026 20:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pxz46cYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0F21F000D8;
	Fri, 20 Nov 2026 20:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207167;
	bh=LSH8huXbtkdEaicZiDrj7pV6Rv+QBDLOAstg1Ubm3uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pxz46cYFXVSZ0QI0hmOCW3jiWKO7pfdxrnM1ysgocY0nfIcBmdkqFB+eDkumSxRR0
	 brhx4PPA71O1/8QMgtdPdnLfuYM5QrtkpYORnpVJH6L6wMYsrw1wQnTLi6fBBZRNAN
	 CZ61zplgkNi2YmEESyzCbs5yUTzQR8G4QXd33fnLm3ffKd85niiP9K4enH8Ywx1W7k
	 t6/22zsCeQ2HkqlhDFbFGLGGXPeXsiKBf2lu1GF0xuF0zlp2qs5witJ3ZIJbHamLGx
	 wKmhtHJqUgkwmhGlGXlIZJWFhMQoExz6/0K/hXEfQ/ZEX9+uVIXBlZYPIW/qDCu5OO
	 aHNZuSr45zRTg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Li Zhe <lizhe.67@bytedance.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0074/1756] mm/hugetlb: fix mremap deadlock when PMD sharing is possible
Date: Fri, 20 Nov 2026 15:38:51 -0500
Message-ID: <2026-11-20-1-daily-reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4496ebac-05bf-4350-a12a-8d8808e6553b@oracle.com>
References: <4496ebac-05bf-4350-a12a-8d8808e6553b@oracle.com>
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

> I think this is a needed prerequisite: 809cbe72ace8 ("mm/hugetlb:
> disable PMD sharing for UFFD missing mode").
>
> We don;t have that in 6.12.y, so should we drop it ?

Queued the missing prerequisite for 7.3, 6.18, 6.12 and 6.6, thanks.

-- 
Thanks,
Sasha
