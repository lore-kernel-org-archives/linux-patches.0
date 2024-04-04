Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A07112B163
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252512; cv=none; b=Ipr+NMb6j28w4pIhhYa4W4K4xPFlnl+pn2tiwwM4E0PZJDOKyAi47rIvR22Qy80ThBtVdLe/A29kkRV7T4EYMf17cz+knK3hmVgmWWtzwUqHPMizLtIrBr7AO0wV3A3gBBmfgB3g4A+oT1G/A3o+rsp71i2Qf+5fcrtG4QKt3gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252512; c=relaxed/simple;
	bh=QJcrvaUqNeLSD3sP8oKrhHn1V+DtHQD2tokKy7lm46k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A5fX0KSac4prIaO6FgNjnVGPE3PYa+JfmoWkclkfNa/+qGbPA8JzLhJL5lXnHMkCvO186mld0MGd54Ur/3LUPmojJ+hi6Vv84gLJfVFmxvmLKwCfmiARbtEdzidHrlc7plg5H4KERHZlxDSScml4ays9PpG4c8pS+5x7oW3dlk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PG9o1Zof; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PG9o1Zof"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a44665605f3so150702766b.2
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 10:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1712252508; x=1712857308; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VN0b2tawtHaPUNX4wk3tslHJG7emspSlRs8ITmny6iU=;
        b=PG9o1ZofaH5xW7a4GubngEgqIzb4QO8BEtQkh48ZCTCxHNso7V/WZK8UV/Sjs+2BM9
         pxEyMNTzxD9aeF4Y0siBjbsKkLNuXqE+roH0twd+CyRaPOCMtQky/biczXM1yiGRElXN
         Lg4/wUJSoR12tJvOcssRGE3K29qflwyvszuY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712252508; x=1712857308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VN0b2tawtHaPUNX4wk3tslHJG7emspSlRs8ITmny6iU=;
        b=F9rvFf7JR0ql6wBO/k5/ZIgI2fT/2Zw/4K9IP4jRnh6ZpA4f3MvYZZgHquMOfPD9j8
         Vcz7Qs+nCmXWG1gn0EVSw5jql+ZfyefgOVz4hSfMAm232KQrl8KkMFKBcSLiOrvheMb5
         qH00awO4+5h2nO7munj8VNrGiHlNuho6cgPxfd7OE0PKWNTtEV/S32Ge7fZLZQctH53x
         yCnOpJtIPBJR6NkmcIpx+51+EcDApIwrmexUj7GeJg0l3WwGywH8MjBTXBuBJ/o8SZ2B
         DBpnGrWnaGDTmlXAa4JbCWEb4Ja0XJ8IrNviPt8XXn7cJFFP25BSUpJnVyw20TqZlZhY
         esbA==
X-Forwarded-Encrypted: i=1; AJvYcCWcOVC/JDNXOPPPY8EtJ3tK0dVh4R2wHVwOOgdMj5wQt1kzjyBgA6gdM1+5isQx50/gTEkvIj7WVoftfAfUHq3wb4bGwUOR5w==
X-Gm-Message-State: AOJu0YygrWftaPwjSrdsvgccPiTAew9j1Kj6vPoRU5MMoFOdZmmpqqM/
	5zpXsjhmKHkMwDa4taBfsyQjeL/GXzuDSHuW4mVN19j/eIw9splTYcd1xYBALAV4TQqT99B/jLx
	4kWg=
X-Google-Smtp-Source: AGHT+IF5iawKtJec5jVZygc7gVMFhs1qxu/qZ4MgT7T77MhNuymfmKA5qWfEDupkFbBxFjnjymGC8A==
X-Received: by 2002:a17:907:2d21:b0:a46:6623:6938 with SMTP id gs33-20020a1709072d2100b00a4666236938mr2649666ejc.50.1712252508350;
        Thu, 04 Apr 2024 10:41:48 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id xc1-20020a170907074100b00a4e5a784843sm6148039ejb.168.2024.04.04.10.41.47
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 10:41:47 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a4644bde1d4so182548666b.3
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 10:41:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWycRy8ruk1onc6uhgHQhZSNGUjw6Y6385TdR4erK2OCj7bWL5d1z5WkgJ81Z/a0i74kqwn8qF15/tnR8qTa4Wpnv2TrfBDg==
X-Received: by 2002:a17:906:710e:b0:a4d:f5e6:2e34 with SMTP id
 x14-20020a170906710e00b00a4df5e62e34mr1762782ejj.19.1712252507413; Thu, 04
 Apr 2024 10:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152549.131030308@linuxfoundation.org> <20240401152600.724360931@linuxfoundation.org>
 <87v84xjw5c.fsf@turtle.gmx.de> <20240404095547.GBZg55I3pwv8pttxHX@fat_crate.local>
In-Reply-To: <20240404095547.GBZg55I3pwv8pttxHX@fat_crate.local>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Apr 2024 10:41:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiiK8qEZ+PkOzeEpguxB18XrfcHGcSMyHzFtA30PvZP2A@mail.gmail.com>
Message-ID: <CAHk-=wiiK8qEZ+PkOzeEpguxB18XrfcHGcSMyHzFtA30PvZP2A@mail.gmail.com>
Subject: Re: [PATCH 6.8 387/399] x86/bugs: Fix the SRSO mitigation on Zen3/4
To: Borislav Petkov <bp@alien8.de>
Cc: Sven Joachim <svenjoac@gmx.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Ingo Molnar <mingo@kernel.org>, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Apr 2024 at 02:56, Borislav Petkov <bp@alien8.de> wrote:
>
> https://lore.kernel.org/r/20240403170534.GHZg2MXmwFRv-x8usY@fat_crate.local
>
> Once Linus commits it, I'll backport it.

This?

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0e110732473e14d6520e49d75d2c88ef7d46fe67

already committed.

           Linus
