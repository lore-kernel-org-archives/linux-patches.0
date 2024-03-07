Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950071386CA
	for <patches@lists.linux.dev>; Thu,  7 Mar 2024 20:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843120; cv=none; b=msCcYbr7ER9xtSf1pevxfljRx43bGtuv5mgjS4thV8u1+d5M9L2WMM61Y+MU5nBVOCq+N0td8yLjCs5KVHwEGB/AaGYSitG2o6nv9AK1EXvgNv6SWOh+pQsf0DTnA/RoFNpkp6snIy1LHnsF9kqJaiaYDoHMnq/kkgOA+QR/Nlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843120; c=relaxed/simple;
	bh=wcksxAH5d0LJpyAK9834DF91YZ/vlDby1Av24OrRNTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hwU50kmh0DZEeJ434irEBaCRN2a52kfWxNhtIZYsHnfvw4FrROci0DtWIRa9NIvMbh4Fq/H5lDWU146Ob6SUprC1Z4tFsxJF5AtJdrkzych76pRpl5Ve8GX9g9N/BgcbB2nYvcejSl5yohNyk0/9TW+kfGzlxXtq9e5qLXApZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rnv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y6bZzn9r; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rnv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y6bZzn9r"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29b4867fc07so106437a91.2
        for <patches@lists.linux.dev>; Thu, 07 Mar 2024 12:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709843118; x=1710447918; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wcksxAH5d0LJpyAK9834DF91YZ/vlDby1Av24OrRNTo=;
        b=y6bZzn9rATizSmUNmIv9UZ8yrf9yQG9hhLj0qtshf04kJix6GApWbltEQJ+C0+Dhck
         u2a876lY0bi+gCnqauqMrUBux6HdoaFBae6ysOQ2GHizrJrZzb2hGjf//Fekl2ztZgGa
         A7rF5eterN7G1DIJPaPlg1meY3CJFQSOf21fwb6e6PnZBv2G8lqqyZMWNERTkR73mGMJ
         BJfh121dhixI0XiXi2g4sUUhlRORb/JPKwPGIUfDqbMDWwBOLL59BJXFFjPg6L6VTJir
         LN9nLbPuP+7eCleBRdrgRb/fs/TkawKBdnmLl1UWTPV4F9KQVl4Akjj15lEEgHTLN/ku
         HGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709843118; x=1710447918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcksxAH5d0LJpyAK9834DF91YZ/vlDby1Av24OrRNTo=;
        b=ReUWvrTaCPC92xm947syOhBjz6vadzpMdTbaoIEl1Abiuyl941Py55hJLUfLgoyUtH
         d+Hb2e4bEkCiUJelmEpDLC9+eAv+eRQ/bT1vA3L5lfYiy1fozZbWQ/NCCnhCyyp5PoyR
         Q3m/PoYnzC5HV05t3K9AWbsG06uIXYdeHLqX9qiYOfYWDNymdrh9n++lGw+q0d0Uxfgr
         APXTYCGPoxLmrXWLKnbbMo9h+lukOO1AhcHHXcmuaRc4pZYMBSL0WTkgwwMO/kFFSi7J
         7gGYuWFkjMZ4hfUTLvUOXB/6xiqLb1NLe1fjfxG+yUcsuWKk2haBFK4GC/NaNkKRaNAA
         jwwg==
X-Forwarded-Encrypted: i=1; AJvYcCUzUAdYly5boZ5lfLEXlrMVnFznCiAwzv4GJJtFN8O3tWzqdwDD1khZHAT6znheT1OM9a45ErQ9DHPiuCSKTSxHNOr8sqbfbw==
X-Gm-Message-State: AOJu0YwdiW9pQva7s1kPiv5s8DrSv89fH2QUvtNULlp0qWEuWoHcaC6U
	O15fe2GS2iP9OoM5mQ+oZq9Bj6zKTuZ4LFexUm7SOpw+PSUkOmyGUozZtreAB1215w==
X-Google-Smtp-Source: AGHT+IG5rhxQfiUQ3FbNS7mxcQgFCmb8lQ87KoIdi96NuNNVpEPDAise+9SzpwE/tXgKxUgupveBRao=
X-Received: from cos-rnv.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:81d])
 (user=rnv job=sendgmr) by 2002:a17:90b:4d8d:b0:29a:c853:6a20 with SMTP id
 oj13-20020a17090b4d8d00b0029ac8536a20mr51731pjb.0.1709843117685; Thu, 07 Mar
 2024 12:25:17 -0800 (PST)
Date: Thu,  7 Mar 2024 20:25:15 +0000
In-Reply-To: <2024030739-untidy-progress-3db2@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2024030739-untidy-progress-3db2@gregkh>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307202516.3162736-1-rnv@google.com>
Subject: Re: [PATCH 6.1 214/219] mm, kmsan: fix infinite recursion due to RCU
 critical section
From: Arnav Kansal <rnv@google.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	dvyukov@google.com, elver@google.com, glider@google.com, hpa@zytor.com, 
	mingo@redhat.com, ovt@google.com, patches@lists.linux.dev, 
	quic_charante@quicinc.com, rnv@google.com, stable@vger.kernel.org, 
	syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

I was initially interested in backporting the commit dc904345e3 ("mm,
kmsan: fix infinite recursion due to RCU critical section") to 5.10 and
5.15. However, this commit does not apply cleanly to those versions.
Additionally, it seems this commit was intended to fix a bug introduced
by commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") in 6.1, but that buggy commit may not be
problematic in 5.10 or 5.15.

Thanks,
Arnav

