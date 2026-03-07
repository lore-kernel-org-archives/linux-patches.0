Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88247309DC4
	for <patches@lists.linux.dev>; Sat,  7 Mar 2026 03:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772853789; cv=none; b=LVtL3z9px8jqR5rsWGtT9ztVJHxZgG70AJgkCxEwomZj6lsa1RciignNxKBTIA1OyLPtJWcVsZK/3mYeyuyUJSNsvfie4S1gscekwoimdqYjqLsiS8Gq7wWbocMKWBr0kkQPhyRwibQ7VBerGemoDXJ38rV42lvxKKsyEowouy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772853789; c=relaxed/simple;
	bh=yl/5Y/nXTvOWLCUjZ9vsmgVgWr8lK//l1u24qGNKCsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJFcpH+rP1qt1C6OFtv1Lgj2hMsV2kxO0I6Z+j1GJMTMoHjoKSVEpghIGho079SD5zYIfdPMJCnNBxS0/gSXsndXAN1F84tN21LPaa8bjCcuy/dzsiKv3IMC7No0pJtzN20Yc+D5fQqRTBbkgTZ/KKkQm2vg7PdwkFxgQYcTTHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4hnsGs0; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4hnsGs0"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-483770e0b25so84476265e9.0
        for <patches@lists.linux.dev>; Fri, 06 Mar 2026 19:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772853787; x=1773458587; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/JIeptY94fGiMe9NnDArQDFW08JE5xRTT4JTPEDHqCQ=;
        b=E4hnsGs0G3nuzYTZT7mcJSPn2p7/DqT6l4+eMR3Blf6yQX/rHXtuvFSVxLfPcGg7SY
         FZBu5E2nCsOLHmldCWDm2miq+c4xIjghmWvZxWa2YtvWF9p4y0G0OxwmbtWN8w3mh8q5
         z0eeU6YbDMna7iVOsfrylk9m5c0JFbGI0HVZL1VhBNWBm9szXQiCYPJd4QMnf7Llu7Vv
         EKt6iCrW1sh4igsoaq+u8PyC2bbMw07FzqowHpmP42ZSiad26f8eSnZHvc9fBWdlvQ6m
         82VdfEzTnDxpwsjwMd73UVuCdjKSTGMApc07qXSalCq68B/EDspvduskuZ8IG5voheDQ
         JAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772853787; x=1773458587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/JIeptY94fGiMe9NnDArQDFW08JE5xRTT4JTPEDHqCQ=;
        b=Kswh4dwUoegFiZ0LdSIJgAvVlMIPo3kRz9GogMyC75TZe+U17RWr6Xc8UvU9OgqSRW
         bqzRllCgt8+jdinCqLkuHzWuvEPkJOTH/YZE+oZ/Om4ut9JeCSqbRxC3Hat/8cd6fglg
         /+bMrDr5OMZJVB0i3Avg06lAESoRQhRiJcGn3Mgp/y5TTiMgR+3Amr/nXhxO5CVNnG17
         tFmNIw4ikCLG6V5jKU5NtTzHSSh21XTwmVMX7JODsKaneeJno3K7qLUQjLZLBh7IzYyE
         meqzLOm7JSSyaT2V4RXaIbEBHnN613P+kvI8olRYtySTxmb8TeFIYQg6/hHBAx4ZkaBX
         fV5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVJfc7OWCvYRaGORZ6d67CKOCTkJFeSQZw0Fjbh5lBytBAbG0efDtES4+YIH0PYr3kCt37C6mX6@lists.linux.dev
X-Gm-Message-State: AOJu0Yzq7La7WBl0JgEVt7m4WHFcMKbDKyOLEpnWffJswANck4pHJ8JY
	w4blC7UqNBRLj4nqj4bmydeWTWK+3LljyoRvYymbMKP1k5vvt6buolF5
X-Gm-Gg: ATEYQzwtSWXr2HCr8pSfbZcuRgkMoQo8ZSERUzUfd/Fqf+pm0QEYxX8qfj1ARC+nvPi
	YSZuaqmaFPbDW5cqePHLV5Ka1Mn5Gqtj3QEmEuO9bMwVX3JJFrbi6lQVAVLSZfWziH+UXNy0ETo
	6Y9PntfQ6R2zHxes+ejLFrJIvOXqQOA+5NtdN88JNMXJiDq7ltJxDJCoIfkRkU0ABv69oDt0X79
	LfrDLyUjBUvPUKvKwxdjLVZ3DPWCl765cVrstAE0MJohDv0iQAgrDs1ETvWOLexjfJY7Owxc+99
	K2leVtUXI2/1V8SwGuoMh3VLRKrOmc+CZp8oCJ3Ic/j0bmNGMLXSYf8STczfyVij6i5fwCgOKmb
	XbqrYnMoH+3S75sEENvybppj61HY1eLAlMaORC9Y4Xbtzpx/8ijMRR2e5Yl4aWx6Sgdk+d7jDUD
	RQKxszUtgnnnVscCGPq6dLXcmcOKNOnQ==
X-Received: by 2002:a05:600c:5250:b0:485:3025:162 with SMTP id 5b1f17b1804b1-48530250228mr2832345e9.35.1772853786749;
        Fri, 06 Mar 2026 19:23:06 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4851fae538bsm202029975e9.7.2026.03.06.19.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 19:23:05 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: rob@landley.net
Cc: brauner@kernel.org,
	ddiss@suse.de,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nathan@kernel.org,
	nsc@kernel.org,
	patches@lists.linux.dev,
	rdunlap@infradead.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/2] init: ensure that /dev/console and /dev/null are (nearly) always available in initramfs
Date: Sat,  7 Mar 2026 06:22:58 +0300
Message-ID: <20260307032258.2857157-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <bd45c86c-e1ea-4995-bb00-df83cc873105@landley.net>
References: <bd45c86c-e1ea-4995-bb00-df83cc873105@landley.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rob, I kindly ask you to test this solution to your problems:

https://lore.kernel.org/all/CAPnZJGDDonspVK1WxDac2omkLJVX=_1Tybn4ne+sf3KyaAuofA@mail.gmail.com/

-- 
Askar Safin
