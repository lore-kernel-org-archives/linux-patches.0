Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8664D14D281
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 23:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544388; cv=none; b=mTxz/Z9bZYO5p0vWnq/eUbYpB3TAJ3oVMnwUYL4mjfFeCvKvTNsYb0mJRffioweAKMX3e367duM0tIQkOvb3MgTcvR/YwBD/QglM6+wfhFyzbA4x0W3oTSbQm16Vlc4tjgGmrb7meBOFLzMTP14X7GAZD3iN1BGaqbPhXZJWOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544388; c=relaxed/simple;
	bh=YYcLqi87Tu6nRUSwa++q+twAQIkfUW4IHMiYr59b/pI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFDy5rFdHLr+DbGmwwke+LOmnItdBi3u5SU3BCagNTNh5nQHjKnIbutM5ZIdYz8qZ5O185vgMNKiPJW0KU7qUdQMrVWVcDDz0leGcklbv7fgYRv08MeNeS/KuNw1imufaXTsHdKORwzaWJqEESbW00wYAKKka+eh0FkYiEywDgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b9lNnzY8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b9lNnzY8"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c1b53b0038so5331533a91.0
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 16:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544387; x=1718149187; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RZ7CpJRXjWVYWPvMtf8v2EmhCGnEDtuJdxARKZJGbA0=;
        b=b9lNnzY8hOKWTNlC4MrmXgF+dND0jiFK9VQOVM0tVhOM1wauP/Rg3wbrcaUKvKVpdn
         t51sca90KTkF/7jO9rasyfSHgi9s4p6Q4pawTvP2v5r/oECZLOAAl+Ke1W5iuIMyRDOj
         wXfZlDDKNJAi7SZCzJn6uF982PLJNsJLZrqfXhcntCaaUeBPqGT/uqIzwphlRi1QcFPT
         Zr4uMFLHySUXGcYtQmIokVvSHD0y3Qb1imhkW3kdS3CZq8djhWNI2ZFnZ4+cIap8sFGh
         JhgPRdKU8+SaGNqUuG+CZKFlSPYx0uai/DW1BCCtQDAkhjCkaZpzq5cd5jZQT5WG5djl
         Nu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544387; x=1718149187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RZ7CpJRXjWVYWPvMtf8v2EmhCGnEDtuJdxARKZJGbA0=;
        b=vgtCyEXQ5tuWtlWKg0vuwPfpzyXWynZnCREhpdgRwtoNbl2UNCb/Tq1JYIoGbcmhmB
         gePHeP2mFv6r8FxCsGus3OV3Fq1hZBBr40BRCEwMNdhREDGR8dGz3iCQXWJqJl+bjFyz
         wWY9xXfVGIAEmJGkGHuxeK0PQ8ID25uYDJRI1sfmUgFPH+lJX4VNNKq7GMUEFsyhX63G
         QeIbypN6ALoo/yyTbtqbY8jdIuSJ4PSTIPBEsDNrDxh/c64GW7LCx/bWnydF3/GKZAsm
         ZRSUU1vZpwA5S3J/jbV6O6yt2AJvI8KAV5A3HlTZpIE+VRQxdH7NRbaBsReri8GOgyqY
         yqaA==
X-Forwarded-Encrypted: i=1; AJvYcCUpEIbVNicjXPn4Ys4I2I3dUDAY3E/Dra7tb4zOM2iUg82XSTRGt7PF8Xao/PZtzQabwpxAG2ZQs3WKhMRJrT5Lc4f4pUhyLA==
X-Gm-Message-State: AOJu0YywCU1UOaf9EOhfoVv0sVL7Csq7gURLdAh1MFztIgnEjcKjojXD
	G49TmzddHL2yNCcuO8y8AW0fQ8u40SNvjNDjXwMEeyyk6HNCx8HdLRdyY1xHl8c4mqwH29EN0WQ
	6CA==
X-Google-Smtp-Source: AGHT+IHR7Nw7yMe8oDKpztMj+13qaYkqZPfJOgL1BiDjmlyXJe+u2yn+W6jv+JrzzTzEQ5o4idZBP5UvXuE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6382:b0:2c1:aa8e:2ec0 with SMTP id
 98e67ed59e1d1-2c27db611ffmr27997a91.6.1717544386839; Tue, 04 Jun 2024
 16:39:46 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:51 -0700
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240520224620.9480-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754355148.2779945.14775698565550979300.b4-ty@google.com>
Subject: Re: [PATCH v6 00/49] New Intel CPUID families
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, 
	Mateusz Guzik <mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, 20 May 2024 15:45:31 -0700, Tony Luck wrote:
> tl;dr
> - Please consider patches 0001 & 0002 as urgent to fix a regression.
> 
> - Middle set (0003..0047) are independent of each other (I think)
>   and can be applied in ant order at a more lesisurely pace.
> 
> - Patches 0048 & 0049 cleanup unused macros *after* all the others
>   have been applied.
> 
> [...]

Applied the KVM changes (08 and 09) to kvm-x86 pmu, thanks!

[08/49] KVM: x86/pmu: Switch to new Intel CPU model defines
        https://github.com/kvm-x86/linux/commit/8387435bebac
[09/49] KVM: VMX: Switch to new Intel CPU model defines
        https://github.com/kvm-x86/linux/commit/0c468a6a020c

--
https://github.com/kvm-x86/linux/tree/next
