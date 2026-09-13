Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227073F4854
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327461; cv=none; b=pLsouYwfz1BrFKwTcvDcALq8vJWuJfFJKlsWzhEyqrhodM++TmHkwbcfUl4Bz/2CQXPsoUo/+GOE2F5F61LLbiC9cYQzDZQgk6iwLA9Hp6yDPUEnmDrJDaf/Sbjy4ZEe0RVtbNBf2gejCug5MF7mnRIcJ1XX4Rln1ZNLsqFSaRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327461; c=relaxed/simple;
	bh=MsBIWxnGB8efzWyVPfYnG4AD87LpmzRzjMaFRa8rZ6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QqThBaODeqAei1C6JseBm7XjBrlf6H6LxynV2H2AkHKWR+YeoIneI4QWM3cEZ0kot4xlVRKOoB2qdUsdtM0WjHsRYO16iq5u4DHtVIYC0GkDOiaxin1sqV59AkdiMh3IoiHgY/Ma9KRxl+OfJCl7hOwlk/aBTp59D9XFpCdO1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WTFsTJAv; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WTFsTJAv"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c2790ccso710286f8f.1
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 12:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789327457; x=1789932257; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MsBIWxnGB8efzWyVPfYnG4AD87LpmzRzjMaFRa8rZ6s=;
        b=WTFsTJAv6HXBHHbaQKtIOLeltKSjGljlacE7BkvNvKOXTWDLoZrgEmshu8RIOKzet3
         Et4psl351pO2cBBr1U3aHmuZKzKxGu4o39rBC7ncaeJ0zSblip6LASKM+/NK+6JmCWSK
         LnwPocU8ffzvjfAhjsJc97F78Bxx4QfV3DJpIfXa9UhqV5HZyEEwnsTeA6ZwGik6cG5v
         9+RbPw/IxhqjPQIjMh+SP9uh/Ul25/2gKlkcc0T5Uz/bzYL/lDd3vZgMZzLvXDgzXhk1
         MbcbXetf68Shu7u89jNeYghB6IFwJDBI5RKfXfoacVG8xF/FolRIwWNTAuV2g/LNHxf2
         Ni9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327457; x=1789932257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MsBIWxnGB8efzWyVPfYnG4AD87LpmzRzjMaFRa8rZ6s=;
        b=jLeIAq0Ja/w96IrFDevtGBNzYpeFJ7ZJW0tIhf65GtofZi+0OLxEbfdGljFJ1QVRsX
         ImyYt3wohyYotb/UFzHFeDVXSIWQyNdUSn/mXnBR4QSjvmzOFnk64PEPqO1EAJcmCk3J
         0lp/mOk5+bc/8zl1yuGdC7wb+0NhT/3JEHGCfT+ZAYB73C+cV10MYrJX3QDpZTuM2IYd
         1xYPWY80n5kZy2Tn0RfW2ppU/G5sMCfwHlI6zMCsjqF4kotvvpzdVj/WyluKBjnGme7a
         jVgthx4UomAS7jkA1waS04GDTLXrafJaj4xO00yDxp3G/QGCTLl5puY5b/S47SZfSOeb
         EX/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxer9X1OpXHVB5QdXcdhDJXx0gfyaFEDUoTNsYsqrkiLImVvRgDPQq4LDpAYVFke4sxYcKTrIN6@lists.linux.dev
X-Gm-Message-State: AFuF++nsKq1ISBLEhsPQqICfSjihK52OOaEQ+R6eKER0DQlzjwVfDGIO
	ngzQi/iDeP/Guu8zWKe5cIC1cfpZgKf2guGnvkKFZuZnNofmOKlsn3pw
X-Gm-Gg: AYBFou0HhQFePSGfphGfcwPgn+ZqG+N/K2E3/6F0Hw811Rb3aL4w3MkaD1qyc6J4MnJ
	3Zmwfzm15y6hVhNInRVNUEZfUEg3WcwliFtOtkWKncDJrkZ4bvPTmGQq8nQ3jHPZ64h1VADEao+
	nl2r5pRq9wwKnHgFdX+KFTLgtRM6Ya1nTyoWR57JIJ61E4xIwLr6989BzxO1taP9H0HPaoc5sY0
	xONYRpTl9in90jzdPdc4wK1qUH1DXbOtagmnHiB3Q1exIg+WMT/CKeiO3MO8bCguGUHnD1cD9jV
	EIsaS86YQm0mk8cirTgVNjNW3JacfThUgX9cbLElB0dUsB0yKwU43+ZMfuMrsh3mY5NQ2Ro8vmQ
	3Qm05emHhtu9eNQDVtdVB9XBBPMNnqcU3DBy552ih11u2FbgczIuJh/68Gp+a5QH3rSxKPshsZf
	fvrJPRvPUfiCB1PPJAV1Nm6VtifwrD17dyMe6VGg2wzWPHv5SRxWqZVatwE+DFiLgeEDURB/zVA
	9UsRY1mYJf3D1blZ+nw2QSZxGQv1D+bu3cWB6ByST8j9dEk44xc5gjBbCHEP27ysA61USBBjzDc
	HO+CO4HA3CDP/v8R9BDB83J1fI3XxsIMePS6Zuj6+ElPJwMObW5cy51u4jCUNN/tBPCmCJFx4IU
	dmw==
X-Received: by 2002:a05:600c:c493:b0:49d:2607:4ada with SMTP id 5b1f17b1804b1-49e619bf31cmr259676135e9.14.1789327457062;
        Sun, 13 Sep 2026 12:24:17 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c2a419sm373655895e9.7.2026.09.13.12.24.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 12:24:16 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 0435/1518] bpf: Sync tail_call_reachable with callee state on entry
Date: Sun, 13 Sep 2026 21:24:11 +0200
Message-Id: <20260913192411.2427-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065633.289865658@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org> <20260912065633.289865658@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 6.18 backport of upstream commit
54c27ea6dadb ("bpf: Fix tail_call_reachable leak") can also be included.

This patch resets tail_call_reachable on callee entry, but 6.18 lacks the
parent-state restoration it relies on. Returning from a clean callee can
leave the root state incorrect and make the x86 JIT omit required tail-call
counter handling.

I reproduced this on 6.18.52-rc1 in QEMU: the unmodified kernel hit a NULL
dereference in generated JIT code at ffffffffa0000118 with CR2=0.

With the applicable 54c27ea6dadb hunk applied, the same bounded test
completed normally and stopped at 34 program entries: the initial invocation
plus the 33 permitted tail calls.

Thanks,
Karl
