Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA84B2599
	for <patches@lists.linux.dev>; Mon, 12 Aug 2024 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723491390; cv=none; b=tdtdvSrZUy84wz+m3EokAvDzZZYM69bNh5w+ODINQ7CjAkEfM+xPrDTl/uS2NOH1knTM7vQ8odn9JzVZteXlxufAK1CjlY7VsQfDhUgiqP4x/0YEK9TWdGd6F9lAn++rXwEfM+fXGnx6RPl0vWiG1AoR63I+b0pluCVGN+/bwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723491390; c=relaxed/simple;
	bh=eWcy7xE8ttgz+wR9ps6hBW/kivFgprsNTb9KV8BPMVE=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=VFRsYcqMtBrh/dhpQeVg/88SCKl0PDEkrXtw4YUp65UtrBvnzFrex2HI28u62Zc5EGJOlIa13VJz/OqllOXwm0uv/wXz1jhDSJyEW3ZxR6ELgRi6f43AhJyI2e2TPacUBqxh8t6OUsnVotc19lYifOcZTY4ENp58YaHk0KDoA5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lpAx4oIM; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lpAx4oIM"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-70eb4de4eb9so4629327b3a.2
        for <patches@lists.linux.dev>; Mon, 12 Aug 2024 12:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723491388; x=1724096188; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eWcy7xE8ttgz+wR9ps6hBW/kivFgprsNTb9KV8BPMVE=;
        b=lpAx4oIM8YDWQppNjTH77rGq9GJykPbD9oCYsObHuGsoYPjI198u1m3k/s5/Rcu67C
         v0XTqOushB4J8gmV2Nki3H0RGVHftg/nlVSKiRxjl5Cq6HdCtn37Y+lINg1eC24ApQnh
         oVeLJyxeSKe3urfK49MRP40fzhS65Ztr3ZeeCzEFsElvZhehL/V1mNxxr3c9P0iLOTx1
         oPvTQNvMwPov2NtrQYSWA3a4E3N9al6JwLRHoBfP1GZ+4qp/FW4q4dntuPxNmSvb458o
         wHPhcvlaC5XZJNI/6fhuqyu57959gqPgRIGqK8r9rIG5B/zLUvGMknjuxAvePOG/XUqT
         ixFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723491388; x=1724096188;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eWcy7xE8ttgz+wR9ps6hBW/kivFgprsNTb9KV8BPMVE=;
        b=OJS4BmnSEzWKoq1slIqYoCKwIaYiyGQL2SywkFe4NNOve/d336Qq03iMsPkfi/BfFL
         2dLhF8hPYfktMXmw123UIKZ0pUo/+XLQpxZEZhs9m8lVewPbWpji7+aK2iK72EX9xmu+
         NaAeD53BHHQS+3dksKqzy/P74pIz7TPJgVPMXIDi+cBjZXK5kOfPsvVSqQB7o2dCs+QC
         m32owLS88AuhCmEa61fY+jyiK5M/e/gMlULR7PXGV+l0rzjZpdHxeJ0fZnA58J5LKHc+
         i6C3Q7dd+qrEkOrWz0vNcAaShyREBOxRHK6BIZ5CxCOXOBKyDqf1EeCdFjaRo8dysg+W
         d3eg==
X-Forwarded-Encrypted: i=1; AJvYcCUR78E7/s4tDESfGiT+jBIDayx7JlbVVsBSryaOawt1wkxbZ1F1OhuZMKGyCEaH8Zut0/+QVu7p06CdBD1uhURR+wlW4sOQrQ==
X-Gm-Message-State: AOJu0YzkmnUWehcN96erpJmTq6YCCZ0cXypoTdYSHjvA+fCV337OaaVb
	FQ9C9ns+/JwIuT8ywLJFmivgWdvkpG/mQJhDIBdKiKS5m5RzvWtB5Mroxt9G+zRvPP+4LfBbkiZ
	uxx5VETWgJSxnh66o1micjRMYct6p4m1prMBbb0OyXJmLydZ+dud97tGgbJyX9zkHLP1BZ/xrE8
	wZUBq2AXHasteyYhBBQbuKDBI/vS8c
X-Google-Smtp-Source: AGHT+IEVOtkezygPLG/8V800714fG83za699IBYKlnGcaD5g/17+ZBdQeSicqhpSx53FJIgBJTwRDy8V8CezUKsU3p3ZKqE1jt1HGYgKhkhwqiB+JA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6a00:b18:b0:70e:98e2:fdae with SMTP id
 d2e1a72fcca58-71254f60803mr8875b3a.0.1723491388040; Mon, 12 Aug 2024 12:36:28
 -0700 (PDT)
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
Message-ID: <000000000000f57a13061f819b1b@google.com>
Date: Mon, 12 Aug 2024 19:36:28 +0000
Subject: Re: [PATCH 6.1 000/150] 6.1.105-rc1 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, chromeos-kernel-stable-merge@google.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

This rc kernel passed ChromeOS CQ tests:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5782314/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
