Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57401CDA35
	for <patches@lists.linux.dev>; Fri,  1 Nov 2024 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730484465; cv=none; b=WcjT6IdsuWPx2UdKgaRo2BJqcg8R3YtdkWHNC8h1pc9Y6PlvZ8tv3S6t2S1RVvRNwrAq9NXklQzJOQdG6pVdqWCdRmIDtB19UKhL8bU2tSde6u9TWZakOw4Or1pdCovYbPkdjbvZssNyN5B42jCVpcOqCY0qzRo38gGPPh57dRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730484465; c=relaxed/simple;
	bh=4ht9G50SlYlr7BPTCuy+KjNotHQlLEXbSKghIYlF3TI=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:Cc:To; b=f4u33muNSuOUb3YTcPh2CCT1M+OVB8xdHT59LrIh/Xw1yjZNT3qWXqFkurxHM0+LDTUYKPdNXY2Y6RFEUO5DgxVVCCezDhqxf+vUzzCPGf7I/ZijOziV+ubIWKXuvnLM9/ar3J0YKEWj1hhyJBWkaA/jSl6xdzQqHqJIZDU3F7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IeTjMRf3; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IeTjMRf3"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9a156513a1so365254166b.0
        for <patches@lists.linux.dev>; Fri, 01 Nov 2024 11:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730484462; x=1731089262; darn=lists.linux.dev;
        h=to:cc:message-id:date:subject:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ht9G50SlYlr7BPTCuy+KjNotHQlLEXbSKghIYlF3TI=;
        b=IeTjMRf33wk4JCSqSxouJvi52RDC6er2jHUO6PO/zwNF6zMq5v/AwtpJc9bL6mdqZB
         YkWZ5BAAPtls104nIN0R5CYg80Dbo1kc4gMy49Hn1kZQZcEFoTk01SuMRPQK5I7WRlZ5
         eF3LuGSpVSyUjpFh2uvR4b2FdvGkZeZkOPQq3zau6FLnZZZJULUT9NUnjnnByhFWuJWs
         F4M1AZev/9kN0UzNNgXgs/zi/owhEP5SIOCl6J9Vx44bpgOBt3Ck6JsbOdDqx+s5h5Xn
         9gPYLkyNBjtVTo1P1DgTf2IRMETV8HgwCLukLEb5kopjVhNHFJ+oYorECNF3yJWTpMrP
         jcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730484462; x=1731089262;
        h=to:cc:message-id:date:subject:mime-version:from
         :content-transfer-encoding:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ht9G50SlYlr7BPTCuy+KjNotHQlLEXbSKghIYlF3TI=;
        b=xBQSruqwTT/+21sgRrsR0YYC51neb9C0yjh5GhrZOYzZG10Ybd1G8Kb4lWuSrGOc5a
         /9V1NBY3b94b08YPnfKtdaOieGA5EhVHZtlRaqYDOH71sJ91jdlT+IcKFlZlFGPDViWv
         6+uhbpFrtvjn3PU9J6uGH8oNogoNByK5bqcGjo9Ab3h6s0fdH1qKYbrXwqE4q9fIzBd8
         32BYM1EYeK4B2w1mExwg4gWbUFSCn+QZ34aSPWFDfuM4tCsDBKmJPD7547Iuzof/iMMh
         pMzqqUEbQacsmEiuqLXJ3fPXbSAvU7GleZBlrh06QEQhE/RzexUUO3HB5l/VgU4fgkhX
         sUtg==
X-Forwarded-Encrypted: i=1; AJvYcCVjZN0SqbDnnC/gnrZ6NwfNmxL5uVlkqDoDFA2Sa27ny4OPWzeVYqbzeTtKSQKB/axRLAXih/ix@lists.linux.dev
X-Gm-Message-State: AOJu0YxkmrkKGVO/1U4ZG7Cq1sYJbwdrt/LJk+m7OZfTQ0qD/jEh9125
	nKDgfXsW1foWytEjzrz/k9FoVcQYQ4LkOdUAyK57rrY2oaI1yeKA
X-Google-Smtp-Source: AGHT+IGIND0a2w6FiSMiKhuFQgaTuS9zBQtQXZDnUefy8qn1grI0b0CwYI+KoEZhLJXD0lzwYEpKAQ==
X-Received: by 2002:a17:907:8686:b0:a99:4615:f58c with SMTP id a640c23a62f3a-a9de5d6eb9emr2496049866b.2.1730484461854;
        Fri, 01 Nov 2024 11:07:41 -0700 (PDT)
Received: from smtpclient.apple ([102.209.109.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e56494052sm211690766b.29.2024.11.01.11.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 11:07:41 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Ivan Fay <ivanfay99@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 6.6 000/213] 6.6.57-rc1 review
Date: Fri, 1 Nov 2024 21:07:39 +0300
Message-Id: <D1C54175-3397-4EB5-9130-8D4889D4818D@gmail.com>
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
 linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
To: gregkh@linuxfoundation.org
X-Mailer: iPhone Mail (20H350)



Sent from my iPhone
