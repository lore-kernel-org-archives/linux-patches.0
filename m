Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8917D4963CF
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 21:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780521470; cv=none; b=qp15UcYsayp6q7kO8quPqZRfg1DpYKPsZFjPZ2xDRpKO9gNEksPB/YFNMfRhPWrGBBiJC0EgxXgGfKKKoVx9Zt6giZfm+xuYgmVB0qD+laeqaPTF1zKVlQncgIAcalqJfXAA2iHf5neCTwNyq24kV19xFKqhiLSN4CBBWI75HkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780521470; c=relaxed/simple;
	bh=cC2THtMvsKyfTnqSrCUcXu0Wb3XRjrvrr6iNqn0oj+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SivOGEYUks4S3lYtR2/BNL88Fu+SsfYJxgYS6Pb/yx7iURkPsNIvmBTI73mm+l99qOsvdSi7+DjKV1f/Qqo5PQ06H81Xxtm1lB/PHI8g8nHkoH0LkatPxLUNWMGGsOM+qrOYhqF7G/gfZslPREymNKX9IDfkxlb9CGU7S5ntoCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtF+szdC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtF+szdC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490ac357c55so195135e9.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 14:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780521463; x=1781126263; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6B/50xn270YOFb+RgL3nLDaMTNlbmRRwqq6mUIoXECM=;
        b=BtF+szdCE9zIKoql2v69YFcxT/cocpyEtuUoWrWSsUNuY03hNb6lK1UmNrK3PcK2Hn
         y5yrIUNQkzf7dJWSUv4+00NnZpLVigkhoDEuiRCXQ5tXc9LexLv5VZdLUwxHkP3wJgB4
         OPela8T5kKqF3jHG13oj+rhB7NtmclUf81uktj/YsvL9XOKn28CM28PCnR57TWxcfJjQ
         1X5diUcn4Hqa8PeFO6y+DChxC28irJkBG28K9YLAm6ILFK/gqOxcytZEgcp04USiYeb8
         S6u8UUb6PY7yJO+eT88/oBOBkts/1Tl9wuQOZbyzSbNanjLoYtOT/AmTCBPz8p7EXBxO
         stHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780521463; x=1781126263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6B/50xn270YOFb+RgL3nLDaMTNlbmRRwqq6mUIoXECM=;
        b=We628cFaQozWAd9A9EqLVWZWELKvRD49LPYl2S2fzoG+YDnnEQrAurnZIMIzorwP0w
         ck4KdX1CKrtCxTXi4JwBZiN63FtJqY15PDVuX4XXNCsZ0NQnAFO199CYmS2r+GDMxzqC
         j+FZuWnCF34/bvVNElwM/ETjUphanZRf9bsy22DL15yr+vjR3ibqtgQpsUXuXeGdH8mn
         FMtweQV9eyZk0yGpMnbrHRrXMpfOUVg5Mut5y8uZbA2ep8ZZ1/rGFJNSXwCA7tMlZnBO
         IHS7Gcq9OJEj/VSkBSuBVxF6kb1EMyzN+58adZs+PQVclVjC/gRRFITh1v//WWNx/TZw
         nNAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Y8qdblSZeshvzHuW13V9g2otlyrECW03WJR1KbDIY8y6gbdMIletnS21Kvs2Mn0hYIirlx9v9@lists.linux.dev
X-Gm-Message-State: AOJu0YyYHZNOcO+oGSPnWpQDRNwVi+RnWyXGy4YOpcPNXAYLpAGWKMDt
	jBFbN02kvM6gjhqU6Z6lxcoDKBxDCV8Cq75j1+dXCWJysQ4OzQlCExzpHoHW1A==
X-Gm-Gg: Acq92OGBKo03gbZx7U5H3jhkh1zhhRhc8bsmhs/Fif7OXWGTqmf8vmVRfgD5gAV6TGl
	86yuFrYg71S4/OOrQ37ot8TxuIWPot5E/wgT/EkFMz0HUDaFMMBfDp181rnGvaoGvLWHpqjPRTC
	okMxQWljEsIXjCZwLXPKB/1RkbLwGlFn3JsRkwhbDl5iKITLAmtpy3wGafEeaKdJbd86oIZ+/Z4
	DaLgerOxmAHtULW3Bx0OkeDACW8I8DFN0An3BIfwbqYhfB9SNWjZB9JjGKThteUawL8gObQaGz4
	zeEepdTIo65P+5mFy7cTNQvx4mOJYahvorN2lEZ/QTEyuGhP04fEJKeGYf0JbldkxoUEnKohmBE
	xYnQUT5Ws/ual90DxvnqcstcvN2uGBAsvjUjoz6gcvkeDXt7b1li70gbeNgIoqZREn93oFiLjQk
	yFUDZ5vGEUvws7RE2TkyCxFP3wKISKUQ==
X-Received: by 2002:a05:600c:19d2:b0:490:7136:ad02 with SMTP id 5b1f17b1804b1-490b5e94d63mr81490465e9.7.1780521462549;
        Wed, 03 Jun 2026 14:17:42 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7a273e3sm59171155e9.0.2026.06.03.14.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 14:17:41 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: metze@samba.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 00:17:36 +0300
Message-ID: <20260603211736.755139-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stefan Metzmacher <metze@samba.org>:
> Why is 'int fd' changed to 'unsigned long fd'?

Because preadv2 and pwritev2 take "unsigned long". I want vmsplice
to be as similar as possible to preadv2 and pwritev2.

> Should that be its own commit if the change is desired?

Yes, possibly. But this patchset already got to next.

-- 
Askar Safin
