Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94281591E8
	for <patches@lists.linux.dev>; Wed, 15 May 2024 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715802685; cv=none; b=MMP43Sh8oc0SmXdQKIawtTBESEiDQgVgttV1NpQCY9Ei6xTN/1lt1b68JZnYTsp7cT6k1Bbe5HvcArzsC55VigMI/jUlYGJJ6xYMQZMP0ES+UW0v4kMfqQcncjBc9KwLbPyDSuIRVa9IyA+eNdBl5C+C0iyp3Mf52tbl2BOXO4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715802685; c=relaxed/simple;
	bh=xUdwyyc9DDJMLZ61thjjioNQXbXlTBzS5tFbsMz+eiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jl87f+gcTjDEoKhZk5qwMkH33dXhwgquCgWRiMINbu1qEWBnFN83QJXy/bQ5ZUSTqiG53eTSXo8VfZzKQIZiHPjM5tO+/767ntyl+0Uyzma/4u5xnAnxSsCvf1vXDdquVbZS6ONr7RBfGBmd6PYpkCq5hagAD8xD58OvhA3XZGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FnfVMIHh; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnfVMIHh"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-574bf7ab218so2517009a12.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 12:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715802682; x=1716407482; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bv6Y52OPQ45b8PiWsJQ93RfatvvEmIVGeOXnyCxO5FU=;
        b=FnfVMIHhzXsEOIzmngt/y3pCZ3XDzMtbyv4vlVgV68BhFudsLOYvAoA1n9rPhtAwvm
         6ifZ4qXScvPkiLNS8oLmByv2q95XSC41lt2qfUTUeGMwVeH54BMBqEuvp90CpK1Md0O4
         IalYfLpxQchMfocFo/xqZmt+Xdtiitcyrz0pdy8gFdrpJOBgv33jPUB4ShcLULUdr4Rc
         HkrUFI65GmBiDlqrJu8b3IgyceyfdWCjojCvwEW700ByJIUuitaIRkTtcIqbD7RF+dpS
         Lbvv5yUPApnE0NMUvL6KD9iYEOv1yROPeiY7a9UtKxn7JBxs3vrhTtCmeg6ystmR2ySF
         RAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715802682; x=1716407482;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bv6Y52OPQ45b8PiWsJQ93RfatvvEmIVGeOXnyCxO5FU=;
        b=aSanarGwrIwgELMv6hA0waEGoFs6P4JAxnwgniVZEBCmj/IZl8AV0/qvdwdwx97z41
         xA7uGJK30e9t0ArlijsamAYxF3NE+ja279goOsm5zZcl+E4AWldMn1v4nY5dy8TSWK3P
         YPGdWPNbWGwOJLUSnxURMFH39ZoU1f8WV3Ndck5IfWcNnAcS5rRe36ug6v4SuCZVEYg6
         w4PV7Tqjdv1sHhmHG0/QQKQ+5H0WVfCBaWofSSNWKiRc15vG0EECG2YdsaX/Woz/4UCy
         gmPaQPoeyegp1BeGIg05qlzMio//7Z+U0+zzQ/FZRHEMw/ghqb9AohM6q5QBF1ptQuU+
         lHQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPn+742J+BFWGybhZsyTKGhhJiKj+4Q6YRETUUxv8LSFXwZaX1pqU31fpl3B9m4zHpCrQxg33sdvn5KQPDaCNiGQG5OsVYBg==
X-Gm-Message-State: AOJu0YyIfkfMaU9ylso1xRWBDeJrOLKuU7MyYCvDsbRBZayP9tCQeZn2
	LL1CHtHOVdRs7n6h5sNEZx6yzHPKaRyzEkt6dz2/5vp2EPu65jxtuGWfE5V3z1js4kyz1WYFyRg
	JgRy4k7FvdJVxxFUaCTF4wQpDqrphPoGI
X-Google-Smtp-Source: AGHT+IFnG3YKmbtnr5G5j/7XAJy6uS82VIYWqDP7F7G6aYqhTJgctHd1HPS5diLdOftxXl/0W/6S3/bEGt8kjGdUNH4=
X-Received: by 2002:a17:906:9815:b0:a5a:c194:b53d with SMTP id
 a640c23a62f3a-a5ac194b61fmr261965866b.20.1715802682025; Wed, 15 May 2024
 12:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082517.910544858@linuxfoundation.org>
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 May 2024 12:51:09 -0700
Message-ID: <CAOMdWSLtpXkvXTckfsD6BWPg4V-qAFX2NhJsR0nm3F9DBm6F8A@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
