Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19172561AB
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 20:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759524691; cv=none; b=OdCOndg4IaNKNxUjy5YxdFufT0/H3+Jz4hGgH9wLX1NcKD5zu06bwN2OIgTB+OpFg8NqLklh7n67hbXKo7ZbuVr2Z8zoCsSPvWAwi2uU3XPrb9zFIMGBwpgmZWVbMcnMIAAU0X6gblLMuSdhEx2AzUFAUytWgk49mTnI26M8rcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759524691; c=relaxed/simple;
	bh=bGf/fVMq7D81Q5YNB5Z+ahF/or+jbs9kwSx5EKrooY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ta9t58kUe4Mj/8m2wV5B3SiVLjbiVJQPylZ6hl99SuSg/I7JVit2lOOd6gpJpdHN7jkmYvpDJtRjNlPSXImM0GU75ImuGklZ1HhWWZYs5ESVnV/Fw4RZ8NyVlu4S8OX3WKCoZqY4sHSEOqOZ3wYwEHIFxYjHbOf72sNYMl+yrGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=e4RE9KL7; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="e4RE9KL7"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b109c6b9fcso28087481cf.3
        for <patches@lists.linux.dev>; Fri, 03 Oct 2025 13:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1759524687; x=1760129487; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Z9OJHsg9AnDgBWFYYVznso9JgY1ikRBT350Nr1kqdA=;
        b=e4RE9KL7IX+EQTpQn/pmdq5Vfina7DazQscTWRxJycZgplj+Ee3IXTBUegwonDEWbF
         UQtxKi+hkDCkBtoIV/WTlnme736/3+2oP40ME/c9eDcB7lcmZSbHlaZ6MD+Y6MnmC6Jt
         Nq++ry6voJpSyq6tQFQHvq45m7IcpeVqMdZiJ40Im6jItWbkg2k25ulr3BxnwLAGNOBk
         whUn8skSGeQ1LdZiiT3aL9WRLZGKPgstR3fbXrqJq17IBOkhvrRDeP3pndTX2NlGa7ob
         Aed0V3trt7DeDYPWbGRNLKMSfLqDVzxA2DB7uaqUTnmh1Gso/sLccxqI4cT/MuNoEOyt
         xPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759524687; x=1760129487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Z9OJHsg9AnDgBWFYYVznso9JgY1ikRBT350Nr1kqdA=;
        b=jvQfzVjkTWqhlOsKpIZeTOP8a1Muq1jZmS5ryrHSjyftd3kBnAn+AOo91SyrKApK7z
         nMxNgCE4HJzNZOYYgvcJtRlVcDvS3UHzhu4VMjuqPCct3In8C1JycBVaqL4jgKjyc4Z5
         0HuUakmrL5mdvgJYFCVso+ZjwIEEN/tXwi09M7LTn6e+oc0jzAf9cAsnNnLkZDWkKg5z
         sxD+CahCBRGU2oqyU70km+vnAbVaSeZtYN+uNTghKEL7Bpr7Mi5ZuvUg046YpFFoNXLU
         KpzQ3uZP5WYwIVL8SGOXVzJxJzUcdMLjfoZnfd2xEAak4QGf6Txl6+j7hpc3BCObAGlw
         VV7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUf0OI6/LgY5Wyu/jBzX9uK8piKvGvgIoEEUqrqSwUEXRSSzgjneZwcHAgvncKc0Mf4VzCaQMGZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv9zpT77htHTDJuXTcvK8T3JsouGxMsjIbZABH+Dg2RkVckbQw
	wM3MSl3oecNPOm5uT5wuHcvUR2vd5JUkLilkx+ndvCzDNnkXlp1ZDT+HhyjaY2v/Rz+0YY2cbz2
	PTN5QcrZBmdjdb1x1Xi4uLNiyigvYss1BJAy+VmLvNg==
X-Gm-Gg: ASbGncuqbFUQENtKvxx24BMfGDYWOIIN72COIvMZPjKUz1lzUErx5jWUxu5FqfU44zR
	5ML6T13+7I/JitaFTxR5F0UDd92niEGLxpHO3SqDwZJSc3+fMcyhtgEclyFfUIZQyLfburTbJ6P
	EC6OEtS9H5pYKqdf9iczG303zFRVPQAyQu2M1y0jzkQR2CPAhcssfGm5B7AQjPDn/Q84mYWsmzv
	zxsVMpGkiOjJXfoTK/PjjL3/wNTcBuq9pOdVHwRcTs=
X-Google-Smtp-Source: AGHT+IGOFuK5QKXUa0EoyQNwTfrrar3OCp+dKAGP3fEaEJ9VnSeYg1Yk+ezWQ9N6bxp2R87Mtx6d9Bh25m/9JjggpuQ=
X-Received: by 2002:a05:622a:303:b0:4b7:9add:76cd with SMTP id
 d75a77b69052e-4e576ae6ba4mr64596521cf.42.1759524687516; Fri, 03 Oct 2025
 13:51:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003160338.463688162@linuxfoundation.org>
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 3 Oct 2025 16:51:16 -0400
X-Gm-Features: AS18NWCwKeFKfMLlMvvr2cSuujlh1BUpd9drr1fldSku7mQZdxTUWOKjj9ta5Is
Message-ID: <CAOBMUvjBZLErkgx=VK06QHFBJZ3rLiJ+NdXitrT7PUnd452Jmg@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/10] 6.12.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 12:08=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.51-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
