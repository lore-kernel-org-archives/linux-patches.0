Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166461C6AB
	for <patches@lists.linux.dev>; Mon,  4 Mar 2024 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709590815; cv=none; b=LwR7fEUJi8S5Dvb/kfVjwpE/AgMtTxqxYkCr/sI1GldHVaxqvsdRlvVz61bMzhrjPQSQEGg14vUG6zniscfdN962ULmKS2aDp/CruVF3eJDnc6YuzXSVJzIt6DAaWznOf9109uSXDLKhW4mEYjnwea4W5RG43iBOFlrSCBNY7H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709590815; c=relaxed/simple;
	bh=daJJ+O48/rxQfVLn4qSUO5TBMPB93fpJojNV87v3Jho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bOgAAI51snkT9IUg8v6j2zcs6QlWt+pFMs1XOZiWnr6ZWKl6rYRqbZAJ/t/kMV3LD32M+s9P2m9Z/wo8ruIQK+y2F2ULc3PkAUL+m3O3aO8rK8rgV941Cx+izPgkAhH9jQ01vuhlrbwHoGCvTdS41e/wovpOHoDONxif30O8V60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rnv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yaGvHSmV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rnv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yaGvHSmV"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bff2b792so4168470a12.1
        for <patches@lists.linux.dev>; Mon, 04 Mar 2024 14:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709590813; x=1710195613; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=daJJ+O48/rxQfVLn4qSUO5TBMPB93fpJojNV87v3Jho=;
        b=yaGvHSmVxJ0J0p0BMSUkTCjBRz+N6NTItquub9cupyOnJW1VxxBI7tg0n2+PpDCCFh
         pEut7p+J0Ditrj7wLjFLI4V0VLc1p3YQW/+QwpIHowEkNnotiWPcYX4y39NrmrHeUgaE
         aQAUUmTD7w87yFj2o0+p4Z0x2cEwCtwv4ENMFzbU6UT5X3LzBn5f/jt4qdqy3GvLZjqd
         dvxdRuySx+pxrYdAGwI9+mXorgZIJ4UDtUWKF5ATnXECm5ML199KfRx14T2NU56gSYuw
         hoSEquOmNXEzQn8apbdBAI2fljYZFkItx7vF4/WyEoFmQ6GlLPBk15HVlWO7/UiUa8Ne
         NXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709590813; x=1710195613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=daJJ+O48/rxQfVLn4qSUO5TBMPB93fpJojNV87v3Jho=;
        b=AzDldI/hIyLndSvW57kkLVvsxYO7Gc13mLS77grsWmVBwcRaHYBq5V64zgwsFI292/
         /ERx/p1F9m7Y5Jt+5B2kIUR7T9PLozz3rkzpcJyQXH781EsV9HaikQfvyZ0xj+lmJagH
         J7iAbFwEk/oqJCiVKMSxYh2TbkPGBBUW4RljTeN5ou+Btrf3DFyTVJG1DEXG3r3t/wkq
         h11NSOiqvFme+Lrzw8RX4ZRUg1d98gDgf6LC/LSaefh7CRg0mMmHLCX9HiA/8B7QPRNP
         MuaWijuo0X0E2WeY3qCHg9u7u08JwzZgv9C2OZ7MCFlxH8yAozhMMnUiFjVbd2NFlL2J
         ebXg==
X-Forwarded-Encrypted: i=1; AJvYcCVfKzFY63isJtVkFtCuzw5O2t/mrMTzqb7VvR76oHmgLBYkrlp0F4PCv3UzZABvNarTgeGmzoLP4TCVxY+qmaVb1rBXJCNgzg==
X-Gm-Message-State: AOJu0YwuURKC6tmc9eQPVFK5z+j98+OyXhsQTBlEqJMtRp5cVDDqMWPK
	kPUG7BqVpUEkY1oFHvlF5K7YNDs7MjOQaXaKiUp+3M3bVBphUKbR13TbhH3Roqj9/Q==
X-Google-Smtp-Source: AGHT+IH6n8nD/pd+GpoBbvd5C2DsH5JzWW5H+GIS5zXoOxKlXMSHiTDp7/imzsPzBowYnQHpwLonIuE=
X-Received: from cos-rnv.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:81d])
 (user=rnv job=sendgmr) by 2002:a05:6a02:f87:b0:5e4:292b:d0eb with SMTP id
 dq7-20020a056a020f8700b005e4292bd0ebmr25591pgb.2.1709590813310; Mon, 04 Mar
 2024 14:20:13 -0800 (PST)
Date: Mon,  4 Mar 2024 22:20:11 +0000
In-Reply-To: <20240203035346.771599322@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203035346.771599322@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240304222011.2221862-1-rnv@google.com>
Subject: [PATCH 6.1 214/219] mm, kmsan: fix infinite recursion due to RCU
 critical section
From: Arnav Kansal <rnv@google.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	dvyukov@google.com, elver@google.com, glider@google.com, hpa@zytor.com, 
	mingo@redhat.com, patches@lists.linux.dev, quic_charante@quicinc.com, 
	stable@vger.kernel.org, syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com, 
	tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Are there any plans to backport this to 5.15, or 5.10?

The buggy commit (commit id: 5ec8e8ea8b77 "mm/sparsemem: fix race in
accessing memory_section->usage") this commit fixes was backported to
5.10 and 5.15 and wondering if there are any plans of backporting the
fix to 5.10, or 5.15?
