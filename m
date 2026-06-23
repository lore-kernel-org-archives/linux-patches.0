Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03003CCFC2
	for <patches@lists.linux.dev>; Tue, 23 Jun 2026 09:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782207766; cv=none; b=JS124Ll1uLiL8DaFNOT+gQox0swaBFfp7uT5u6V6h9RSzY/ReH3YVogS6wjZRs4/t40XhO6esRkyUzRnGqmaLqhGmVZF/FhZTP1Hy9e4c8puYdegl9FIOxyJNRb80hnIRxn85bKnA0fmQMHaV8YiXoNXRii0lp2SBkwRJkc94ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782207766; c=relaxed/simple;
	bh=B8aiSRXgNzNgIcTsqvlM+jiX5YYMrahhBOPApOswCwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUdWYfNaGBLL0/SIr0DOlh40/GrGbCD60d3PSmAS61DdzyJRPqkwf0kUWlI0Q3M8g3Ts32vZfSLuttuLu3Q4gUehugpuTZCp7cKmAP5OsfkDTtMsMv9g3+ncI2uJtNZ7Jws/rlJ7EApC5ptK3gWzvLj9D2qtVH+DM5eMfu5D7T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NX4mgLsS; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NX4mgLsS"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490b9318997so37043155e9.2
        for <patches@lists.linux.dev>; Tue, 23 Jun 2026 02:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782207763; x=1782812563; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SJWx7Zgz0Pyhs4JZwrYmJyYWWMlxydwzpM41quzKVA=;
        b=NX4mgLsS1blr6SjAbfyjGpXr79UvPCUmXtumz5FGzwHIJ2Gt+OlNQ9P2udxAYlChKM
         P+qrL9ub1294UZc3bBiKXZu5hNyb4BNVHgx+mWbwbx6aKiwbv7h6B8QlUs+D8R6TjwGb
         rFmVux4i9kaApoSg+1Xf3diCdOaEYIwh2EQGArlPRy5d9IcMeQTjn0JnDEoDsG6S6dWr
         fAETAVXCoQRmOi4WNqqHFJe9CAI3acrCf2NeGNGUx56RxvGfLjZq1Ai5CdGrJcVMbrOZ
         MG84agdqsFrB49x3TPvTHvhoP89HAE9HvCiQoqxa6golN/suSdG/lwjhIgyx7DkCS7ZS
         7pgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782207763; x=1782812563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3SJWx7Zgz0Pyhs4JZwrYmJyYWWMlxydwzpM41quzKVA=;
        b=SH84lQq7ZRnv+7MX5GDFpWufsVVjeQKTd4OMsrlpIm1BvmvidbOXwnM2JUgv6ylu10
         vywWACllpweqrHdxPbNt6dscnHxVJNUTtbZzdFa5VO66AvTx1/NvF+L3DP2ilPAZsXYh
         hm58JtIpo2an4aPR2fMRhK2dkpQjcv9Tgqx1nrVu1HltY+n8hGWsjwSsZMI6NpLCRWnP
         QLlyzcPOTlyUyMDGxiWAaLoKNwJIiRGbW0tl0o21zjHqu9iMryvbLbd80xB7kaS2SXly
         IhIzp1pCPFcIXhBYD6ndKq3b4QzhRhYcJvKMledqMQfOgPjjRuzJjuMIUsRzguYEk3kU
         jVCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4Yfwoc/ZzOJrJyCBKYC/AL0sSnMo1q/19zcuCBpbDc1E/P7UvGNYDVSqUpVCXKu5nQVPgCfgw@lists.linux.dev
X-Gm-Message-State: AOJu0YyW6Qkcj+2qkdjkzD2jjnrp3e2DeaXGKx3HrRhJjGwhicLLKKEE
	Wh9N5q3m7wSC3IphJculjgZ+RvuNDB6JCq65VNInh8U7qmf3xGQu+OAU
X-Gm-Gg: AfdE7cnE3gifda9vxjJadFeryQYZpr96kIc/ngJJSTEgZCetsHZusz4UcfbuFsqRhB0
	fNBSG137qOOE8kDzfMPNddxJsv6xeT3e6ECgXUg+IshQDqVkw5dDTF+nrDOq1PphlyKzVoHDaGI
	v+BYmzTz5vqycIW4SPnklm9QbFf0hkEilyGD+f8cnAI7rDyf9GKkmQmRBdj+yr1iUeCvrDoT/fW
	233hGXzfCRvGovl/xcWEH8Iv48SPFJZB0kQMB6rfSnSZaH/CxH5H/8jZG7F0v90gDmDX7/FWIe8
	MXb3poP7CJaV5+qIi/Yhyp4gSHD2zwF8tyHc4+dts7YPXXWKRmEivOeWWI0rZCNZE/fUsw7lfxT
	7XSWelzaVN2pK46MluSADGaWMPn4cNP5IwTr32Up7vo7tpgcNFQmQQ3I2ka5CpbKnBesJvC1phg
	cGJyT8Vr/j
X-Received: by 2002:a05:600c:8b8a:b0:492:2e48:81e6 with SMTP id 5b1f17b1804b1-4925b389b83mr30093645e9.4.1782207762970;
        Tue, 23 Jun 2026 02:42:42 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49249455302sm280248525e9.15.2026.06.23.02.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 02:42:42 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: avagin@gmail.com
Cc: akpm@linux-foundation.org,
	alexander@mihalicyn.com,
	axboe@kernel.dk,
	bernd@bsbernd.com,
	brauner@kernel.org,
	criu@lists.linux.dev,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Tue, 23 Jun 2026 12:42:11 +0300
Message-ID: <20260623094211.1080873-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
References: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Andrei Vagin <avagin@gmail.com>:
> Actually, this change introduces a performance and functional
> regression for CRIU.
> 
> Here is a brief overview of how CRIU currently dumps memory pages:
> 
> CRIU injects a parasite code blob into the target process's address
> space. The parasite invokes vmsplice() with the SPLICE_F_GIFT flag to
> pin physical pages directly inside a pipe without copying them. The main
> CRIU process then takes over from outside the target context, calling
> splice() on the other end of the pipe to stream the data directly into
> checkpoint image files or a remote network socket.
> 
> I ran a simple test that creates an anonymous mapping and touches every
> page within it:
> Without this patch, CRIU takes 9 seconds to dump the test process.
> With this patch, It takes 18 seconds...
> 
> Plus, it obviously introduces some memory overhead.
> 
> If these changes are merged, we will need to completely rework the
> memory dumping mechanism in CRIU. Using vmsplice() in this proposed form
> no longer makes any sense for our architecture...

I just have read some docs for CRIU. I found this statement:

> #### Why `splice` is Better:
> *   **Consistency via COW**: The `SPLICE_F_GIFT` flag ensures that if the process modifies a "gifted" page after resuming, the kernel performs a **Copy-on-Write (COW)**. The pipe buffer > continues to hold the *original* version of the page as it existed at the moment of the `vmsplice()` call, ensuring a perfectly consistent snapshot of that page.

This is wrong (with released kernels). I confirmed this by testing this on my current kernel (6.12.90).

See the code in the end of this message.

If you actually rely on mentioned consistency, then, it seems, CRIU is broken.

So, in fact, my patch actually brings consistency to CRIU. :)

-- 
Askar Safin




#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/uio.h>
#include <sys/wait.h>
#include <errno.h>

int
main (void)
{
    int p[2];
    if (pipe (p) != 0)
        abort ();
    char buf[1] = {'a'};
    struct iovec iov[] = {
        {
            .iov_base = buf,
            .iov_len = 1,
        }
    };
    // I pass "SPLICE_F_NONBLOCK | SPLICE_F_GIFT" here, because this is what criu passes
    if (vmsplice (p[1], iov, 1, SPLICE_F_NONBLOCK | SPLICE_F_GIFT) != 1)
        abort ();
    if (close (p[1]) != 0)
        abort ();
    buf[0] = 'b';
    char buf2[1];
    if (read (p[0], buf2, 1) != 1)
        abort ();
    printf ("[%c]\n", buf2[0]); // Prints "b" as opposed to "a" on Linux 6.12.90
    return 0;
}
