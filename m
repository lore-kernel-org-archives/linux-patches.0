Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD4A217F26
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 22:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.74.137.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548934; cv=none; b=i+mgmyEL6F/+kUPCYxo1JTFP52wQ4+5IZx4GqMmw3C9WgJznSl8gf2rTj0OHLKWtN6ly17uZpwhkTg5QD0ud1k8jWKVmGy9A5DEp030iYzcv6nSAucelQeaG6wKy9ntvHLlx+fFguyviRamwkbuOCyX6ArJ4mopXZYLBX2yxO3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548934; c=relaxed/simple;
	bh=eK6+jIZVoWfg5kTomRU8zhTFqBhjiK9fMT3OGkn2BCE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=skFru04IyybSIgmW2vg0RtOsBv/IX+649NXFWifM9luMGrZ3T2fIaHxIPXOrR6lLoCDBFbvM/pFuoR01uhiLHJV5eiffsxvlJg5lTor7hZg/XcuCb40TlP3ySSpUrFVeLeqO/Si5waFfoHR3aiIJkjAarBWjB7jfnHkZSp1WggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com; spf=pass smtp.mailfrom=atmark-techno.com; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=OWxJWhC9; dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b=RORVfJXM; arc=none smtp.client-ip=35.74.137.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atmark-techno.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="OWxJWhC9";
	dkim=pass (2048-bit key) header.d=atmark-techno.com header.i=@atmark-techno.com header.b="RORVfJXM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=atmark-techno.com;
	s=gw2_bookworm; t=1736548932;
	bh=eK6+jIZVoWfg5kTomRU8zhTFqBhjiK9fMT3OGkn2BCE=;
	h=From:To:Cc:Subject:Date:From;
	b=OWxJWhC9GW1TJaMaNO3Hua814oRuNZraaMEMd3xNgUt9gob4fTgWUL2vc9/sa4CkD
	 2dgU5Sj+bQkRYdhrNlviehq0PFnC/BQ7FNYfjY2jpMaaOIibycRbC6PiPyCDtkeABG
	 qkVEcoxRwmrxZ5RQfrw7PxhTBRg07Ql/yaq13NmCk5Jp9n4L/k5IT8YUTUlQGdwPZH
	 HrqGpiU5AmxmnbREoCIUqH7rGPfbGbcZwcIoNAZMLcA7egHTvrQjpXXauj6vyUfXSR
	 F+RUGoklqV/2F8irH8m9z1iQjFYJxdU7ANeIulqGEMbJsacZhOXUgmp6oXKYefCzDL
	 2MoUFfxNu1Dvw==
Received: from gw2.atmark-techno.com (localhost [127.0.0.1])
	by gw2.atmark-techno.com (Postfix) with ESMTP id 096B831A
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:42:12 +0900 (JST)
Authentication-Results: gw2.atmark-techno.com;
	dkim=pass (2048-bit key; unprotected) header.d=atmark-techno.com header.i=@atmark-techno.com header.a=rsa-sha256 header.s=google header.b=RORVfJXM;
	dkim-atps=neutral
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by gw2.atmark-techno.com (Postfix) with ESMTPS id E082631A
	for <patches@lists.linux.dev>; Sat, 11 Jan 2025 07:42:11 +0900 (JST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6df9ac8dcbeso80099156d6.3
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 14:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atmark-techno.com; s=google; t=1736548930; x=1737153730; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KR9Jb7+M96a7m3wyj0Qq3Ui7G5w6rg2/MtJ+sETTqwU=;
        b=RORVfJXMhu3R8E/S7SiP2RmatT3zG0GdMzTHwvPNUBJHeXO1ZbEA9YyiEHRHJZiFIx
         iw1oimQvEF1KQvD3cPsslOHcfm6atnyvQxrIkCA/2hA588Y3uOaxC3oNt0Aqech2ug0O
         O7HQoB4A7k3K9knGJmkctgsf+A76o33A9XS9lHGdysNECXni2Ryj0uasObS6GVbc1vFU
         VaQ8oFY/JyxfNy+5LehzESHrDrq8XVVOMYOA/Lh9uebvZZMwcFpKstRXQYRJNkMQYKqp
         jWNGuxTHp1QnmW9IGwRupzlAvineq+qREGsUOR+V04JNWCe7eTvJ5gHK/rltE5BCSJp5
         jiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548930; x=1737153730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KR9Jb7+M96a7m3wyj0Qq3Ui7G5w6rg2/MtJ+sETTqwU=;
        b=OlOxvMWbPyIhgXZBrismPZPxkP6nAbmdCIs2xAjtUCMUmpKczjrWtq1+ipD1o0u+K7
         /9S4hHXfuVBS6v3BfJijpf+qzlQe+lbhvZXwgYZtv0L4XFOv19fcOmeq8GRUWZVPGvCl
         s2+Txp0sVEPED59j2FQvxt7/rz0GXOZi36n5fe6+jleRGbXAbO/oFl7yGiQ1BmQFGw2T
         IsyEERtB6phgcdauc08OMuxbET6Ai/XYWhnw/ndfnSfeA4tRJWLEMvQTtK/dYd7drzdX
         ssGBU/RP9o+OVtQRzEfK15sbT9mH+7tb7qWIEmkzSltvcRaAbQ6HjPsxOqus4eqq10zm
         IFbA==
X-Forwarded-Encrypted: i=1; AJvYcCWC7EZNiyuL8XBoMcsQV4xw4BaImVIP5ZckEpfVXIrHK+MST925TbdXolJMlnBFnpFDv52VwRqz@lists.linux.dev
X-Gm-Message-State: AOJu0YzzjzTGjaBUXHH5CFvD6CDnkajETgQ8SNfc55bqO/TupV5w8E5h
	Iwj1YA1V0JUzRqo5SPdIsdPevPOzChI4YWIKvIz9yBwzUdFyPT1WxulRY6IR+va0APl2QTigX5C
	yhsaN8hBlIuTppdZ5Rgwdep/Jn+pY4wtVHW5/+IJqM5seaMElC4UOoHJP
X-Gm-Gg: ASbGncvuIYNNb43+TpksJfiXLRe/yBNElYgWPYFFcQlmoTE7urix3+hr2c67U/HCm0o
	P87N0NSMDCCeye8DoVeXgGBmrPfLn6n4IHFyk/suy7IeL++V6V7M7JrLgSwVx7coKSfIcUrGW4p
	ze/94KPdAiYGn0dpb7JsEYqW5Gs8Xh0Ui/Ben9VY5CD26pfwD8L9/btu07Z7UX+dU8IgOl3zXDw
	IDwBUuEtlO9WhRGa1Nt5yiXBmmDovCor3Z+EAbsTdmxi7qVJ4kE0qQjR9iINWfTLerwwdA9zzCA
	RfJTlPxxib201BNh2UIRalN0w3uaMqPBBtvDEDym
X-Received: by 2002:a17:902:f693:b0:215:a179:14d2 with SMTP id d9443c01a7336-21a84009d06mr128912825ad.50.1736495930210;
        Thu, 09 Jan 2025 23:58:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFzHWwgLPaOeVSM+1jbeshjC7R1SjDFRzk2NVokl2pNGuifQbicAyr4dgasHpvI3I4p+9/enA==
X-Received: by 2002:a17:902:f693:b0:215:a179:14d2 with SMTP id d9443c01a7336-21a84009d06mr128912565ad.50.1736495929872;
        Thu, 09 Jan 2025 23:58:49 -0800 (PST)
Received: from localhost (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f12fbf1sm8992735ad.77.2025.01.09.23.58.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2025 23:58:49 -0800 (PST)
From: Dominique Martinet <dominique.martinet@atmark-techno.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 0/3] ZRAM not releasing backing device backport
Date: Fri, 10 Jan 2025 16:58:41 +0900
Message-Id: <20250110075844.1173719-1-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a resend of the patchset discussed here[1] for the 5.15 tree.

[1] https://lore.kernel.org/r/2025011052-backpedal-coat-2fec@gregkh

I've picked the "do not keep dangling zcomp pointer" patch from the
linux-rc tree at the time, so kept Sasha's SOB and added mine on top
-- please let me know if it wasn't appropriate.

I've also prepared the 5.10 patches, but I hadn't realized there were so
many stable deps (8 patchs total!); I'm honestly not sure the problem is
worth the churn but since it's done and tested I'll send the patches if
there is no problem with this 5.15 version.

Thanks!

Dominique Martinet (1):
  zram: check comp is non-NULL before calling comp_destroy

Kairui Song (1):
  zram: fix uninitialized ZRAM not releasing backing device

Sergey Senozhatsky (1):
  drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer
    after zram reset

 drivers/block/zram/zram_drv.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

-- 
2.39.5


