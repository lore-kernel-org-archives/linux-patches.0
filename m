Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803E12DDA2
	for <patches@lists.linux.dev>; Thu,  7 Mar 2024 18:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836404; cv=none; b=jNv01bFUBy5/acWa0fFdD+mx0ARZbl3pFaX7c9NGYJDtG/y7F2nvY76qrkLDuEvTA7yJ+rzw8ppE9CHOrbOIBq6c9TwpOWQ9ZuEugkjp/AaJwikyKTHMmAo8sS4zFbPj4jVn2VeVRwI3ioPEslyIjv6NZkXsSCvkHRDO2cXB86U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836404; c=relaxed/simple;
	bh=KLLXUGdLronzj3ejPe8s3lsBNaclrlbLXPaIQweRWfc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r0GcMSxmgnlUyXKlYDPeS4wnG0zShGcUutliPJ8QzP/Yk1Ui+KAOuyM6gCwGITK/VKboRFXhn+nHqaFFRR/v+wyakFdaYnDqVhsqrBKdw2hSixHMlcPRd0XJq246cw9N9cXYFWbQLauxtUuTRAXK6BhfdvaP+z17xN5PmEvkoc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rnv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bw8Dxo3H; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rnv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bw8Dxo3H"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dc6b99b045so9507075ad.0
        for <patches@lists.linux.dev>; Thu, 07 Mar 2024 10:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836402; x=1710441202; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KLLXUGdLronzj3ejPe8s3lsBNaclrlbLXPaIQweRWfc=;
        b=bw8Dxo3H5mqrnD9+AeNQWzXmrWpyrf7ug3ugBLZfCg9nJ8EezOUfngC66/ttAXRH28
         Db/rZ/PYHj7E4hMFbjDc0lCgdYSW8xQFYv0x7FAWjO+QKLQeY8ZLOgspiz3JFov0XQN4
         ZJvM5RpJ5pojI/aTUer7kYS5x5P3c3uYsLHO3kM8zJ+X7gg+lLYsuP+rRYlzfEsUI9UZ
         6BzQFfrTrHlCjPnIT0xNIZDizgde7Q7MCCau6/btMgvylg5gcfOp3hKtZPci8AyWl0t5
         Fwrf1qjwdTNnqUY20+DlD5xA0Fdk9SwSot7v/jIbl5I2b5tkwNg2J+Zgbi8xVhVMro8c
         SQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836402; x=1710441202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLLXUGdLronzj3ejPe8s3lsBNaclrlbLXPaIQweRWfc=;
        b=H6RESRvHClJOb3H0TiVObf3WrfrSTEGqQvQZhi+4F8aLisXKHfnWL2TAQSWn5vv48L
         Qh+aHwjBHsTT6zv6WJC5vov1RnLV9WA5VMG3Aif3HolEMXc0k5Y2wt16zLPwQQM1xldJ
         0MUBEtfmkszOS9W7kAuRkhMH4ofOJpYEnixc3gN0te+lqaVgdh7frqiQ7Im7WDsHQ2Qi
         HV6Os8Lzu1Bb8jZ5/GCsZ7pdfuv74Rhoe/PH0AWHz/HCSD0WntZHXBArmEVWB0zxYrok
         GmQO/IcrprjmYB3fPlKALlb0MLUW4qd0iZn4qRS/uhf71oeFiK2QgzwiRc6efHqAFg1s
         UyTA==
X-Forwarded-Encrypted: i=1; AJvYcCV9K4roi6jDRjybtLBlhszzZfkZbB7ofs6FpTs5suYNFXJIHBPEfehO5LxPrrVUHOO+icqTxIrom0aZ77NsXxeEzWnqVoFbPg==
X-Gm-Message-State: AOJu0YzZCr297343SCNmVqeU0kvu/ENgbAroxP0iEaaYGzMnA26pAru+
	feEjP25vXlw//y/a85UDYUcPwgRyN7h2pZz6G4FGrO+0qeJIldhl8sysnNU7jjTcxg==
X-Google-Smtp-Source: AGHT+IHi0zsopCbMj/Va6mRCdbqMpzYhdNm/8OUau5xudJeT0+fgAQxWhf40kFU/pU9yCLhbT6ZeUEk=
X-Received: from cos-rnv.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:81d])
 (user=rnv job=sendgmr) by 2002:a17:903:2847:b0:1dd:17ee:c423 with SMTP id
 kq7-20020a170903284700b001dd17eec423mr4597plb.4.1709836401065; Thu, 07 Mar
 2024 10:33:21 -0800 (PST)
Date: Thu,  7 Mar 2024 18:33:19 +0000
In-Reply-To: <2024030457-aware-trusting-9e48@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2024030457-aware-trusting-9e48@gregkh>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183319.3146300-1-rnv@google.com>
Subject: Re: [PATCH 6.1 214/219] mm, kmsan: fix infinite recursion due to RCU
 critical section
From: Arnav Kansal <rnv@google.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	dvyukov@google.com, elver@google.com, glider@google.com, hpa@zytor.com, 
	mingo@redhat.com, patches@lists.linux.dev, quic_charante@quicinc.com, 
	rnv@google.com, stable@vger.kernel.org, 
	syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com, tglx@linutronix.de, 
	ovt@google.com
Content-Type: text/plain; charset="UTF-8"

It does not apply cleanly there. It seems to me that the commit (commit
id: 5ec8e8ea8b77 "mm/sparsemem: fix race in accessing
memory_section->usage") is not a bug for 5.15 or 5.10 due to the absence
of relevant KMSAN bits in those branches.
