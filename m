Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66E3F6C26
	for <patches@lists.linux.dev>; Fri, 29 May 2026 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780073720; cv=none; b=DxV/avmUt33xYmKsgU9ooQKU5ZntyShi0cui5yhD1kfi6iD8QlL72GlmjJTDhP9mX11ErmXMnfApe286k7+6oKUPFW4j33ohHFne9xk+XwWKuzjzXnxu8Sq/UCsfo1SoxvyGkdiqIe+qO8YaXKIfu2sfmb74jnaCXX9+V99FadE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780073720; c=relaxed/simple;
	bh=llW4OxFvtKWFyEC9eRxy9VUDdqj1IBqiGVZmNBrPlP8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+zE4mnRGN4MUTceEVgv28WzPHEGanx+4n1dNumUngi6ytsXicK58+r3fFIUi6AvPCKslB/1aMPwOdkkYlwOqqgPFsdqZt+EIZfHvT19EYs3tdahcUQKgdxpj5f9GlSlUDSu0CZRH27SlIod4H2rQmdRUuf/D1Eyn1H3+N1tS+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKcKTyBn; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKcKTyBn"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49039a8851fso85224885e9.2
        for <patches@lists.linux.dev>; Fri, 29 May 2026 09:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073718; x=1780678518; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kg88DDtH/8BXfFFdiCpH0Ax+iqDzN9Cpw3OqPjVLSd0=;
        b=MKcKTyBnsYrrPYCiumtTQtXeSon22Fxwi1dG1IyRebPkfDFe6Mi7dEAy1JwLmRZuM0
         uvD/FPXdltf9I8qqaWd8bdcvpUIO/wkLIqvgU0BGSP8pMOnzoacbAHdoYcXeUd/Z1CYr
         m3jQtymM9nvyeYY1mZXPqt3O+LQHGAM7hp7bOLBpU8xjzsrfEGTCAY+5DMrrdSEKHnn5
         7mch4EVEfEA1c7ydtPeXyhcjkSgFkULXrk9jkGqm2sQypjSGxLwQAFsWoAOZiCyflRpY
         z0RxFNWYMcTcMUmOGONS/iCQcM5ldSnT/S9jmL8m/O2n+pbKsjbUvYXzC+Oxyj9u3wjY
         4zuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073718; x=1780678518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kg88DDtH/8BXfFFdiCpH0Ax+iqDzN9Cpw3OqPjVLSd0=;
        b=RC14UmYSo69fr20DuwRjvqLOKjI3drIKQ2LOKnVWRyPtuFiTDak1afLxykfFeEVZy8
         yHda/7H5kI753Ap+/gd1uJYMyBR0ZnssYv+/HwJCPhYN2P08Ro/IGXIHCn4Gf9EyRTp7
         ZEMs63I9jqtNcXuVB0U3GFTOIP02CXYUlIJ09H1SqRbGeR2B89lHAnDWC4OSGUNAxeFL
         jLknhjbwOIlOI38Vkr9Bn77eBInqq089ahlSa56MD+8lxmyn/G/LVQAR6NlubGx7k8UP
         dSNCEmGMGyM3zlKa2owqYwxmfKkNLrUpVmy5yFFFxGD0GPSCXC8fCdlsmVtHs4n+7jA8
         saZg==
X-Forwarded-Encrypted: i=1; AFNElJ8RtgsBvRpk3VHLSd1Aea9EnVPKePNjRi4yyPjiBEMVwjVVmxNaR2KPGW5M1pCkkh6t8YY49uaF@lists.linux.dev
X-Gm-Message-State: AOJu0YxmP7NRDFQDdZULC5ybhC8iSgf/olRnwYiFfnWK1s/BeB0Y3u3H
	esw76BrxxrXoRBazIHVtO+gtZDcO5RO3+us3W8kgovG0mwFX8UPfaeX4
X-Gm-Gg: Acq92OEA+LrgRhE6qHLlQP9trlkhrte3kBNs+JUxUFrDLJBxSTetM7Gahs3jEoVpbJn
	wooxtR+eIrJQIZcYfsvqYVcvTduh7OiwEDf0EB6j4dAnuRNAOjtJGXn6rqTAnDcOfCDwf6j9R6s
	hz+pqAhtWeVSOGtGVXiuOFadD4zXCFVYYQIvGMeFqpf2imBUl62+ptaeH5w1TD2ePC3HR+UwmSH
	rNlc7VyWHwSM3/0AlWTqWmg3f5W3FKIer+AvRQbkt96guMPg+PYbXd+kDUMRHi7vIrXU3vbvC5v
	Qy12yQi2gaMUpObYYSNXRTdd3uOFJiuyea8nX8uR0E0yJNixb/T0FFnbFvZnJeaSQqISvtvGzMP
	UBn+q0nNd3O5qCuRoqYnOySaMativACeo6PGMMPFd5yfSLf3x49aJ2lPMqaFkbVo1XrCWgky9B7
	2Ol84kePhioGY0gQaa0NZwz63E4vjE6fWDo2fQeAYyUGEKUwSV/LmTO3YhH6pSEMmK31W4bFs=
X-Received: by 2002:a7b:c3c3:0:b0:490:5191:6e26 with SMTP id 5b1f17b1804b1-490a2941d7emr4738915e9.18.1780073717867;
        Fri, 29 May 2026 09:55:17 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6a0a89sm68444645e9.7.2026.05.29.09.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:55:17 -0700 (PDT)
Date: Fri, 29 May 2026 17:55:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org, Mark Bloch
 <mbloch@nvidia.com>, netdev@vger.kernel.org, Saeed Mahameed
 <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan
 <tariqt@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 06/11] selftests: Fix arm64 IO barriers to match
 kernel
Message-ID: <20260529175516.06d5788f@pumpkin>
In-Reply-To: <20260529134947.GA128816@nvidia.com>
References: <0-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
	<6-v2-72e9640932fd+2c64-mlx5st_jgg@nvidia.com>
	<ahiFxtmspbETiqWw@google.com>
	<20260529134947.GA128816@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 May 2026 10:49:47 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, May 28, 2026 at 06:13:26PM +0000, David Matlack wrote:
> 
> > Let's put these in tools/arch/arm64/include/asm/io.h so that the tools
> > headers are more aligned with the kernel headers, and so that the arm64
> > io.h overrides are done in the same way as the x86 overrides in
> > tools/arch/x86/include/asm/io.h.
> > 
> > Something like this (untested):  
> 
> Okay, the disassembly says it works:
> 
>     1db8:       ca080108        eor     x8, x8, x8
>     1dbc:       b5000008        cbnz    x8, 1dbc <readl+0x58>
>     1dc0:       f9000fe8        str     x8, [sp, #24]

That looks strange, I suspect the C didn't match any usual pattern.
Normally 'tmp' would get thrown away and 'v' would get kept.
But you seem to have discarded 'v' and written 'tmp' to stack.

I'm probably being stupid again, but how does that work?
The cpu can speculate straight through the control dependency into
the following instructions.
An 'eor x1, x8, x8' may not even have a data-dependency on x8.
(Most x86 cpus just generate a zero for the equivalent instruction.)

-- David

> 
> Jason
> 

