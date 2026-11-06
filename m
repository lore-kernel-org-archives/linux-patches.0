Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961949;
	b=fu/ULjuRZdPL50lFybPAuKWbTR320wd2u1E4D2YlGzseDLhsXIRzchLln0i98w1lGhxq
	 sp2EVx3UfAEh9/NjDlrb/Ml9t/RvmjSViiiiXSRgdjTXXIqoYtdEs6l7YhH9u72nehvPe
	 IAFKbs5VM8eytKwDRHpKER7lzNLiYfeol+OdSReh4MaX3q/VQ2GN+0XyqPg2UGTpdfkmz
	 5L9LnDNpNR0F6livD6ZcKS4TJgacqg1Ty5Nk7mimaBLWS4PB5H9BG+jtSiDRKVBU+FRKr
	 DUVaPmH2ylDjPfCGHmV5pWsXOr4HknWhg8CfYN3vkA47FwvQUSlrqgVUqBFtTUUHRmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961949;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=HN5AaMS/rppxH/Zhw9oaxqCW5S4c47gXtmjruB8wFZg=;
	b=zcy9LGeB4anKSQwyzIvjmq+r+Gmyae7rIqPrLTa1PmDIFyY3NmA3ODWwDEu5oCdE/lXa
	 PvE2LYYk55QJ1XGMBRuyRCQTc1WXWvRXfq50plu89ybk4YqZu+5MR8oW6UMLzmxm9BJa9
	 pvc+uijRSAWmWQDJ3qmAzD2BejR4CjjBo/w1KxB7vksIeQWxY6ZD5q/Ad9M5fGsLBUTA9
	 M4y5JNuO+O/aU7+yp3g1BzGQgMIeHmWGo4AoDD2m0BoXmnIt+gssW8MovLM7kdcpmbPyP
	 lu4oXvn2Xaw1ELTeV4yFsO6culTLGKuPuCzhHf84VXyRI6vJZB2J0g2CqBusJsy56ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TgPzQjtJ;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3907B606A335
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 10:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3907B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TgPzQjtJ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso5046505e9.2
        for <patches@lists.linux.dev>; Fri, 06 Nov 2026 02:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793961948; x=1794566748; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HN5AaMS/rppxH/Zhw9oaxqCW5S4c47gXtmjruB8wFZg=;
        b=TgPzQjtJaWNhbHxS3bH+BjwWu8l+vmhOu/TqGBWqUICRBKiQBY5s1a//CIZhzIvL5s
         JixYiA0wDCQeOm43v8XbSeoao7qgO+Xkt/hxLgRcI2AG8t6klv+UlxT9EkBt3UzrM5Ts
         tjMAfgUdrfi3iBQ1JzTNlw6JsICLajMFmVYCokitpcJupwoEe00Iqc37xBCHnlsNXwP8
         EbWVzgBxPhHOa1wier4gjbZ+9CfgkRRpPgrBud9DCQpo2p/BQGX/SfDJSB7C64/ZFgnx
         oG9XsnSVMP02I2XEKuJzj5+SNEwan/eRnFlCvwUhPbFwo43H8espOBWQWO630CCffZXP
         y52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793961948; x=1794566748;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HN5AaMS/rppxH/Zhw9oaxqCW5S4c47gXtmjruB8wFZg=;
        b=tDV6ljGv+GBM4WH2zpBcPT1fXGqfwKOopy9MJVtg6fIrd0XP+Wyq6TnDFVusi2KjG2
         YpXoQGpp4x1wDou5GTzzKU3qSNIo22lld8PpitCKV0uZzGOzGC6nODmGVXzPYKbfyvMZ
         GZIcoTE/7M5wOWYeuxQzvcFCphWlLjgYmyfKpLPEMP70d8NJhTORTTdK6jBKus1NCf0f
         GhmtC4kYtBqcFs6i4IiVcVz0TEpNy1/6TZ3cjid5SiM6ZvYP0Ik82Djnc0znEUQorVZy
         86wtQmWpRkOaE4DtyA7fSd+wCE4k9shKs8M9eswHkh+qH1Fv+z0COmqJXlRMB0u6cDjG
         jZqg==
X-Forwarded-Encrypted: i=1; AKwUvBxtJosk03In8H4Har+MkWAymMObXCnKzO6QX8nyWF62t8xgqHGb1+MbywemaScjGNp5WNwoErnt@lists.linux.dev
X-Gm-Message-State: APuU4Z/mSTRkDYkmRC/OoqXDn6Ly6To3jrtEI+zg3wK9ojjaoXbTEQ5v
	HqXZONW+/JeUzbb171Hx3xsvGX6yOsLnVEj29+2n1/uthoIY0spCTl0OaMR0pUgzB1o+VnhGD4E
	WtOvNGfx3m9vXuRjSEQ==
X-Received: from wmbe22.prod.google.com ([2002:a05:600c:5916:b0:4a1:f80d:2f25])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d05:b0:4a1:f7f4:7cf1 with SMTP id 5b1f17b1804b1-4b6de4a6221mr32102195e9.11.1793961947324;
 Fri, 06 Nov 2026 02:45:47 -0800 (PST)
Date: Fri,  6 Nov 2026 10:45:46 +0000
In-Reply-To: <20261106070701.89282-1-ojeda@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261104211103.174756107@linuxfoundation.org> <20261106070701.89282-1-ojeda@kernel.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261106104546.2297581-1-aliceryhl@google.com>
Subject: Re: [PATCH 6.18 0699/1005] rust: bitmap: restrict bitmap length to at
 most i32::MAX
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Burak Emir <burak.emir@gmail.com>, Eliot Courtney <ecourtney@nvidia.com>, patches@lists.linux.dev, 
	stable@vger.kernel.org, Yury Norov <ynorov@nvidia.com>, 
	Yury Norov <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 06, 2026 at 08:07:01AM +0100, Miguel Ojeda wrote:
> On Wed, 04 Nov 2026 16:07:12 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > +/// This also matches [`BitmapVec::MAX_LEN`].
> 
> This is a broken intra-doc link -- it can be fixed with a trivial
> one-liner I just sent here:
> 
>   https://lore.kernel.org/stable/20261106063745.87864-1-ojeda@kernel.org/
> 
> But another option (cleaner but a bigger change) is to cherry-pick:
> 
>   f5535d78e126 ("rust: bitmap: add MAX_LEN and MAX_INLINE_LEN constants")

Both options (the one-liner fix or cherry-picking f5535d78e126) look good to
me.

Alice
