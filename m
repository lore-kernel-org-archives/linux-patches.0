Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E300E233935
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 00:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781570256; cv=none; b=FdURZ/o1SM7ogm52D2+ECV0sWSgepFhTxobRQeAQTB8UXlxIQY9QTJzb9xL7QylgJhUJIPYtLaVBrTivKRsnfVMuexTefMHykmx71FwRKL6YsKouiVOJZdFfXKmQhsTyC7X3tXYGG+KYkqZAUS99knjtZ6TbufdjaiuL/b86tg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781570256; c=relaxed/simple;
	bh=p91yC0380ci6RVyhXJ1kuAXKj9VL+EWnmfNds5Mm5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRgmpETIOqu2jQX6vKjF9Ttx/OEAXQcFTzTj/KtI+imZ1wA3Nano1TOfFJgT1P/AU7cDcLcHK+S+5xY1JB37GyprN+VN7+gD6vcXdQ4ueev1TLArNsxDCjUDKMPcV8Z/aEn0hPaGYlXUW3LO3t/kGTcuM5byQpVC5uzglsM5nW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yzf/5+y0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yzf/5+y0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b613a17bso35820565e9.3
        for <patches@lists.linux.dev>; Mon, 15 Jun 2026 17:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781570253; x=1782175053; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFPF4sC2peklNMGORgGTd/4IxXXegAkw7S2lBmPrG1Y=;
        b=Yzf/5+y0SqkAnaGuBdCHIGOssJZM9iyCAp5rkuUkZEOlCFQzJx9OuowCUav6zhT7qD
         kKZrBSgIC8AE26X/1QTj6xZFG7xKWE2KSKJcwdHwEY1QCDfYb+49K6D++FKM64acDQDM
         sC36BvmMpv2MQaUv5AopXjv59fSl8Z+PII9SCO0gY+UuJk8mAOzUlSbtEigFxq+G1bit
         ZrWZPGsHIvkWuTIlOhv5OtPQ4K9zvNoMDxhEZ4lCJ/aXoQ8xbz5nF2S5uUGJpRUThhq0
         9WPu0CbKDJHwhDbpF+6BeMYY2kKP6QBZt7xhDVIVZrI5BJONe66qQlay4zbB0TzMnDKR
         uD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781570253; x=1782175053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iFPF4sC2peklNMGORgGTd/4IxXXegAkw7S2lBmPrG1Y=;
        b=kKuT+xdwpQI11wOEO/5D9YDvkLKYyjHjY2MRIFs4PI6b3qoy2zP/S5wpH3SHqsZtMk
         iFwpVuL6cX/tQdY0/d81MfwvpgluTQfJkaqoAIXrlO644zPHZgFwBxRgIpRVCgdbp4k9
         H1Lla76N5gi/V6Z6wGGEPZieGkomfQhvpog2B0X41rSv7SusvYp3q8qXwPTOUzfqNK2n
         Snhv7TEyYDXcp4z9Ii0UPQohQBCLL2OkDoZmdtqDQxNshv5CojfLS/+Yg8Cf2yU8sipO
         Xs6SIadKA6QI6M4DG8WdDV4nV6uMd03z0DbGNp48PIAkwXdH1cWNt6XbN4KXnaxlUYol
         guag==
X-Forwarded-Encrypted: i=1; AFNElJ+PMuoFGZoNkUReqF8wSUOf87AVA13v05xK9UGwceXBR0Q3iziw6mSbuBHHbGyggQ72eqKscQ/c@lists.linux.dev
X-Gm-Message-State: AOJu0YzS1m9g9IVmyFgXiKRQ+oZ1S0EOO5e3kLEVtimAsiChf6ouE+oY
	SbJEUQ/c3Dk7Vx0/gjzVeEAtJUixxW0jeg+y1fZgd49pfBIUU+UA33/p
X-Gm-Gg: Acq92OEwq7qpaZXfCvlRDk98PedDAM91iZHWO78WqpXs/8WCRwbgSYs1RjdQOmVsuzv
	81uxt0Hu3YGBauGuZw+kZVAYf4raR+nF31GL9Ks0khXhsAUzQWH/Vn9BxBClx3jRsjrrYM/a2yo
	xxrMHqfNf5CwVAItOq7zedCj8PbcrZYF1I4QuyaqXlY4K7DvbWUQB9uEX/pKSs4eEp60/ZgB1Aq
	5Flc80WC+BBvcovLieFXaliErzgCKUBOSmKy0DApDOroUa+gMiHaZcQ2NQp2eZ2O0enMQIZFCRB
	KaalMBP+t4FiZHoPl6Eyq3SJqN6t2pwW80WaM6M/bSFrYE33No2HEHnYKQNXl/Xs4OQ+8SuDJhn
	qQTfvZMr7E46QwuBmLcbiCACCuVQXbXWG6woi7yEx2mqiH+KWbLxRRdT/VPFWJ3MUBWlzEPcG9P
	aTWoJAFBcvtYwZDtp/L9M=
X-Received: by 2002:a05:600c:698c:b0:490:b025:f324 with SMTP id 5b1f17b1804b1-4922ffbdad4mr19600415e9.32.1781570253120;
        Mon, 15 Jun 2026 17:37:33 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490ea4b39e9sm238270495e9.0.2026.06.15.17.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 17:37:32 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: agordeev@linux.ibm.com
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
	linux-next@vger.kernel.org,
	linux-s390@vger.kernel.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Tue, 16 Jun 2026 03:36:59 +0300
Message-ID: <20260616003659.4002764-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260608171917.3195488Afc-agordeev@linux.ibm.com>
References: <20260608171917.3195488Afc-agordeev@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alexander Gordeev <agordeev@linux.ibm.com>:
> Hi All,
> 
> This patch as commit e2c0b2368081b ("vmsplice: make vmsplice a trivial
> wrapper for preadv2/pwritev2") in linux-next on s390 causes the selftest
> tools/testing/selftests/mm/cow.c to hang:
> 
> # [RUN] vmsplice() + unmap in child ... with PTE-mapped THP (128 kB)
> 
> Recently there has been changes in THP area, so the problem is not
> necessary linked to this patch per se.
> 
> Please, let me know if you need any additional information.
> 
> Thanks!

As well as I understand, this test uses vmsplice to pin pages.
I. e. if my patch lands, then this test should be rewriten to use
some other mechanism.

-- 
Askar Safin
