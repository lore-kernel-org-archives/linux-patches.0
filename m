Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931D198E71
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530611; cv=none; b=qXtu0FrOXTIMQHyJ42O23LoFM1zp2s/q/Yiy0RFaqQSQkDF0njfYrYx/6Cq6pUZvjmkQTPcgZKfnRYsY2TsO9NDkICreltKag+PawxgRhGry/23mqdilT35tJ2i15fdyLOS7K5JTm68d/puXA7l5HO+5o+4q1z4fYdl5z+C6z8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530611; c=relaxed/simple;
	bh=0Ky3ry4ktAXzMeSeT0I7OGPp/mgeOZjYi1TiOp84HlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B+CncHapqq0uhq2E+HDqDpiGinEQuX0fOWSgvuC7zqReHNdgM0/cEJbiuO5+NAFIH5VvNXiceMthV56+wPl/BDb+68HwHjdznHutKmdtiTgeLwdQ3CFWiW8gBbpXsYCKOXGdPZa8P+rapMpfYEcL/BtNeZZfUwQu5Jy+uIhguD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L1Lur3Gh; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--surenb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L1Lur3Gh"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3497c8eb0so53428047b3.0
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 10:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729530608; x=1730135408; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hyrIf92icdv4C2H2apolpF3+XQ094SRto0t5Nmu1wWk=;
        b=L1Lur3GhmYGfI0OtIxJpA1mFDn6EwLwFSU980GxKbrwOgOU7ilD+FtBM7ib1cW72OK
         pQFPH1p7gyS45STfg4rhw6xAro9RhpBT0RWxRrHrHtw1gmdkBESWS+dewTE3bg0I19Ma
         26T/7JcVI1IOxVpwy+PwsRVvLQ7YtyFDgQVAGVK8LynsMinBzNFI7fwRFVdwKvimDzhy
         XRopfPXAZtjUknLu54/p4QVDGSb9MVhjPnH8NKm2hV2ZZ/iCdPMQhuHx6FF1tIu94PJ9
         KccsKNevIHI0hrwea1Lsi17WKV+KNAGTZgdBJ8+hm5m7SI5I79MeeXGsjFYMNoPm92ZS
         XJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729530608; x=1730135408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hyrIf92icdv4C2H2apolpF3+XQ094SRto0t5Nmu1wWk=;
        b=vWEuQxgHjmb4gOQihQe/khTDE84U1JLwQ+OLeIADNBE9mi8QAlMoidmP9I+oHVc6E3
         OV7YxU3joCdEGmQGYhDtt24/8RYDuy9ny8TVD6fbpcdDnzonWSLZc05IVFGLpKBF9/zU
         /mmoHTF0ZWrBV4qZZaJ5GfqfhFgAkwQKCtghTY0EYYWbGsYLswUrcxneEQKM6yWjUfVW
         GknpIqUHQuBuiz5cqYOxhq2wDic3KVN5TFZLw57FAo8MtmunC7F3nVwIywCfHNvELrrD
         k6/bT5rb+v8YaPQKF0DABaabE42eiCsLZcCkHB3E6cwDH70PHYcVh2A/yf1p6eXXW87A
         YcOA==
X-Forwarded-Encrypted: i=1; AJvYcCXvpqpN5R2JMue5Qj10Q09KANDfno+j+oZ4P5xXEN3Ji5JzwMQIkoprJBBkceVVU/AGPF96g2mS@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0ocArG3k75HymleUKfTU+sMRSvqrCsbpts7TQIi32YmSvDdha
	LS9WEcW/oneVpVMlZDHKklTlFLYZ1UkWG7ceQqaQ46025Ixz+8tpeqb5l3McB/J9IjYpE261mSy
	w4g==
X-Google-Smtp-Source: AGHT+IH4ff05WX++Qh7Giyaz3E0EwBe0lKlsLONpmg8aOIOXjzTlun11Cl2tFDQ8IAnXNo6FMDRe62BnuSo=
X-Received: from surenb-desktop.mtv.corp.google.com ([2a00:79e0:2e3f:8:cfa8:1167:32cd:5d81])
 (user=surenb job=sendgmr) by 2002:a05:690c:368d:b0:6d9:d865:46c7 with SMTP id
 00721157ae682-6e7d4812d70mr30257b3.2.1729530608363; Mon, 21 Oct 2024 10:10:08
 -0700 (PDT)
Date: Mon, 21 Oct 2024 10:10:03 -0700
In-Reply-To: <20241021171003.2907935-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241021171003.2907935-1-surenb@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241021171003.2907935-2-surenb@google.com>
Subject: [PATCH 6.11.y 2/2] lib: alloc_tag_module_unload must wait for pending
 kfree_rcu calls
From: Suren Baghdasaryan <surenb@google.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com, vbabka@suse.cz, 
	greearb@candelatech.com, kent.overstreet@linux.dev, surenb@google.com, 
	stable@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Florian Westphal <fw@strlen.de>

From: Florian Westphal <fw@strlen.de>

commit dc783ba4b9df3fb3e76e968b2cbeb9960069263c upstream.

Ben Greear reports following splat:
 ------------[ cut here ]------------
 net/netfilter/nf_nat_core.c:1114 module nf_nat func:nf_nat_register_fn has 256 allocated at module unload
 WARNING: CPU: 1 PID: 10421 at lib/alloc_tag.c:168 alloc_tag_module_unload+0x22b/0x3f0
 Modules linked in: nf_nat(-) btrfs ufs qnx4 hfsplus hfs minix vfat msdos fat
...
 Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
 RIP: 0010:alloc_tag_module_unload+0x22b/0x3f0
  codetag_unload_module+0x19b/0x2a0
  ? codetag_load_module+0x80/0x80

nf_nat module exit calls kfree_rcu on those addresses, but the free
operation is likely still pending by the time alloc_tag checks for leaks.

Wait for outstanding kfree_rcu operations to complete before checking
resolves this warning.

Reproducer:
unshare -n iptables-nft -t nat -A PREROUTING -p tcp
grep nf_nat /proc/allocinfo # will list 4 allocations
rmmod nft_chain_nat
rmmod nf_nat                # will WARN.

Link: https://lkml.kernel.org/r/20241007205236.11847-1-fw@strlen.de
Fixes: a473573964e5 ("lib: code tagging module support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Closes: https://lore.kernel.org/netdev/bdaaef9d-4364-4171-b82b-bcfc12e207eb@candelatech.com/
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 lib/codetag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/codetag.c b/lib/codetag.c
index afa8a2d4f317..d1fbbb7c2ec3 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -228,6 +228,9 @@ bool codetag_unload_module(struct module *mod)
 	if (!mod)
 		return true;
 
+	/* await any module's kfree_rcu() operations to complete */
+	kvfree_rcu_barrier();
+
 	mutex_lock(&codetag_lock);
 	list_for_each_entry(cttype, &codetag_types, link) {
 		struct codetag_module *found = NULL;
-- 
2.47.0.105.g07ac214952-goog

