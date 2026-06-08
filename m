Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A33D47D4
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780938786; cv=none; b=NH7k6DcerLJINJTVyQhB+BU9cmEBNk3slKiz+e0TmMIsf9Xyvi/mLIW+P7lI08wQyzUA+Jm08eWfDTU9c879E5aqtIr7KUhZABLbaxzoMxznZLoqDWZT0cJLj2dxtZZ+QH0vW2ovSl7waGbYdLcaHaxZQdbHemA9v6nWrmWc3C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780938786; c=relaxed/simple;
	bh=G2yTdmM+jxM6q4Rp8QMqnUV346H3bZaSNYYTm8fmrQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiYic/r3xZ+shhCjEZr5GckXDIVeGSZt14jtqMT7harZLV5TWV8ATKg4cvc1hQIdemELoKOZTc3p2/hPkvV4ke0LWq9EhXLpXXRgZplcIv5r7AhujOM3N3cYFMWJrRUI9k/W2uwy33OCRIPjRLPXlkrynxeKJz1eK0x73NOXfSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=izDQ1ATI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izDQ1ATI"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso38831245e9.1
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780938783; x=1781543583; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
        b=izDQ1ATIfcNx2JB5jzZwKI3ux/IZLy3eRI5nG2VOI5Gnf+++lRrUAfDN4pMLtiOH6i
         7HOdxTn6ZaGOeDr9ltGCS0UrDyzjNSPwqeK/gPsRqsZBFS7C3y2RqMNA+gwJELAJlMwD
         jwAzg8akFUC+5sc0RaJ+Zpr8BzUtve8An3wYskd5oMhSGnFLNdzuQzu6CBUP2A2H0iWG
         NuX5jVRH6CwohqtE48GDxRMCIgpNFLAGHqemPOy7xSNN+MA3JGICiA9LApT7nntDth+i
         RDymbsAfdYq7LSHEfhbsyTSMSV2dfpdGRPcIxje7HNxKDhGx4yZH4dRMwTdRHlYbtg3w
         gvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780938783; x=1781543583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AUpt/EToVTToJvd7YASG+3OoKZxNxbXoqptfVbb/HeE=;
        b=d4mxI6XVg3wgk3VpUandBcVuYQNk9+hWaYYh+h5NdMVjdnDP2DuCFVVzYgB1iNlPW3
         ZjhB9jbY00kzF3IGskb51nrAOxocdZTX6MmsrGiSJoeyxzEKhR00ike7R9Lm5MTeUPP7
         JTd8SqrVfp5nTdhwEICnTWbeIywc68Gg3gK95wyQmusvj17s9vfsLX8RmbVMK0c+6T4i
         c2nuHbqtsTHdjG20jy1KwPQyuTZxIi0+AW4TVQil4ZjmBMqCVbu+KN+P0R0UNSm+ubbF
         6zD8zbft5kPwjQyN5dmflq4xkZVTpgHMSaVCVFHTtwewpfWqhLjGyoRiQKgSDjWgcYk7
         eDOQ==
X-Forwarded-Encrypted: i=1; AFNElJ8fv+vF3iS63xP8SDHnelc2DJ70//OXvzmw2fCjbOpg+MC4uACAl7HAiq4YurM7NE1do0I4tmGu@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/NQ7Tp1TTGw2pdOCkphRNysbQAtQbOFOXffuig3jn6CImXbA+
	3z7s2c0YzC8Xd+r6s13POo1nLhq6FON3NxIDzAI7OOSLwyvW2VU2K/j/
X-Gm-Gg: Acq92OGSy7F07BogDP+xu9b0UwiVyoX8Vi0wZssfjkxHSlRiGvghQCufHEHKbiztwTV
	UUhh1apnNW4pqBLbpvg2eS6PnqSQAZP49xgegM39BkdtzPKI22NsdK53caLUDOoqSoYpp1EIQEL
	IuGTh7ltFE6GUC4HW/W6/15nMS/3tiYURvnky2KpNeCVtiOoG1Jt/HudSd45KNzaf9ulMbRTvLH
	20k9UMEc63494DkOPaJK3Dt0N/PxKxjLX5DtGRmiI3yHO2jk3tDOt6fkNo+xdSMNBrLHGSq53HZ
	hc5wt61s64fdlF1N8WbXW+oX0KoYJ7CJKnzCSRBxznsb6irKM3XcMfePQnaW5M2r2ahm3FAQXDY
	+vYgoPLTTND+lu/FP66FKcW2e/cnfibQNCFXDYgx0LwQ9wNBoZftIWllqfid18wbrPDsairOtn3
	5wSzQMiaHIG7n+/NzoH0Z/IPKA5ixDRlION2/XaCtJ
X-Received: by 2002:a05:600c:458a:b0:490:389:7644 with SMTP id 5b1f17b1804b1-490c25fbd78mr244360025e9.17.1780938782731;
        Mon, 08 Jun 2026 10:13:02 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f351ac0sm97432933f8f.27.2026.06.08.10.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 10:13:02 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: andrea.cervesato@suse.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	collin.funk1@gmail.com,
	david.laight.linux@gmail.com,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	kernel@infinite-source.de,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ltp@lists.linux.it,
	luto@amacapital.net,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	w@1wt.eu,
	willy@infradead.org
Subject: Re: [LTP] [PATCH 0/5] vmsplice: fix some problems in my previous vmsplice patchset
Date: Mon,  8 Jun 2026 20:12:31 +0300
Message-ID: <20260608171231.1480447-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
References: <6a26aa28.283787d8.1f1282.ba36@mx.google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Andrea Cervesato" <andrea.cervesato@suse.com>:
> Hi Askar,
> 
> the patch-set doesn't apply:

This is patchset for Linux kernel.
(It is expected it will fix some failing LTP tests, among other things.)

-- 
Askar Safin
