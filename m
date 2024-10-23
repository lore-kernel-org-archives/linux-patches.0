Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3308152517;
	Wed, 23 Oct 2024 09:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729677031; cv=none; b=ZhAz+TOf6QKHloio1R/AOrmHRNOS93V8YuRthh9iXkcZr7GAGIlZEMfoku5t9/SyFGlAWATNyZTHsQiL89FtmH/2FsmdcJXfl/Y5iRWwZOWN78O7zxXuS8eEwvjuWbHeGH5z6TfZLJo7C6ioM+4EJLUzDeERT1m+qiE2665esh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729677031; c=relaxed/simple;
	bh=nALBb1S+YRbc8EW/CONgUpvGQ1smNeFejUFFKudXFE0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=pcQjGX3nmh8ZEMiYZ1ACRWQClUMNhSZKRtaPNVMXgDVdzq0tF0UvUs09DK+NFyUQ2HDEOXE032lr2a5+7AmOxsBmPPWEFiYKMCMRYmRaSOWprZ2AlHXZFbUxrfk9LftGo4cApOP6BzKct8k0lN5ZtR/m13JdV+SqxIAHDpLSxYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/3pLDOC; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/3pLDOC"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2fb5a9c7420so66727761fa.3;
        Wed, 23 Oct 2024 02:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729677028; x=1730281828; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nALBb1S+YRbc8EW/CONgUpvGQ1smNeFejUFFKudXFE0=;
        b=j/3pLDOCfaUb3vIGkT1YDflB0ohEdAwv7XhampgruhGvKzwJ35Nlp8Ad38R1K5XW6A
         NE0r9KVERQa/5kTgIP+rGSP9s5XfaNahJNOu8ICWWR5VG1TYdS9xurrmxArdnqqd+LeF
         R8MyPIdP4MPKrrBCFCdPyHC1kRbAgF+cExhUEJqFumJ6sLTiNBa6G8oZ3K3ss1e0oUOw
         FZTRYKV/65mGdlZydPOa05szovRQNKoqz4MVFp7vLhnRsybbBchQh8pbCoj19rjZQefE
         hcaChkKtU758RTVck7nLEgO7WLv8p19BWxqOmR77kxVUq9sHm9TQSrots6V6pk+PLDdu
         h9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729677028; x=1730281828;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nALBb1S+YRbc8EW/CONgUpvGQ1smNeFejUFFKudXFE0=;
        b=YLs1jIufMjpm8OnP1SW9A2O7RvV0PPpK+qtZec/FjTwl2/yFWkC83LZN0IVbddgnWc
         x2CXjFz2wTZ0tA7PRKQpseZGUauICywNnSWk4kLX7oatf3ww/GarfO4srFVteXcuB9dg
         hOSAqUIURgT+XozBJVklDhmnS1usM0f1kVDU1nGmkyQNe4KXBA5BoLIg+K0itMttOSQk
         eWHJydnwzR2Vj0E+HnLFO0PjUnwqveShD2q/dW503qXhQOCydKl08cmHIGZi7VWqMMQr
         Y/4NWiXa35DGKIPwLii2Yw/QeQhh4BNzqhCnmfkQvuoomAOINihlntt0P63NDPKEzyFz
         SKcg==
X-Forwarded-Encrypted: i=1; AJvYcCUdGqFsuLSkRPUahTUqf6g9CY3BVue0W/haAJxBcaSyBfzFKca1McJH5N8S2erKwBIvjyhVafR0LQ==@lists.linux.dev, AJvYcCV7bQTyDpI+1qAeYxrC5IzNk4DULlCoPi2scb2PXa+lW3yTldxWg2O43jWoqDruKp3tSfw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1chqoXZLLadxXa5CtKXb657gC4/D22inCpo3BnWFGvtf8HS6n
	/QV+sLrqTxpG44S99FzI8gkiK9BPHXxer6FA1n3wDlUCnspO4v+AXL05SXi8g0NFl6yBLyCgA+Q
	m/MWqIcPsXTtvn7NZQU7VXibjaEE=
X-Google-Smtp-Source: AGHT+IHNhDNmIBEoWNfMDJkh8nwS8VXu0N87NYNLSWFW58MV9yZik6opYGCLTnx0VgKlf8IbL1v8MSDrZvR16S8jqgo=
X-Received: by 2002:a2e:9010:0:b0:2fb:3e01:b2bd with SMTP id
 38308e7fff4ca-2fc9d35a589mr7818271fa.21.1729677027463; Wed, 23 Oct 2024
 02:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Anna Antonenko <portasynthinca3@gmail.com>
Date: Wed, 23 Oct 2024 12:50:16 +0300
Message-ID: <CAG72VMfSwMitWSyBYHF7a3DCJtc_awO4fw=rJkuvcxh-qeqqNQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
To: jeffbai@aosc.io
Cc: aospan@netup.ru, conor.dooley@microchip.com, ddrokosov@sberdevices.ru, 
	dmaengine@vger.kernel.org, dushistov@mail.ru, fancer.lancer@gmail.com, 
	geert@linux-m68k.org, gregkh@linuxfoundation.org, hoan@os.amperecomputing.com, 
	ink@jurassic.park.msu.ru, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-fpga@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-iio@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-spi@vger.kernel.org, 
	manivannan.sadhasivam@linaro.org, Matt Turner <mattst88@gmail.com>, 
	netdev@vger.kernel.org, nikita@trvn.ru, ntb@lists.linux.dev, 
	patches@lists.linux.dev, richard.henderson@linaro.org, s.shtylyov@omp.ru, 
	serjk@netup.ru, shc_work@mail.ru, tsbogend@alpha.franken.de, 
	v.georgiev@metrotek.ru, wangyuli@uniontech.com, 
	wsa+renesas@sang-engineering.com, xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"

> > Although this commit has been merged, it's still important to know the
> > specific reason (or even an example) that triggered this change for
> > everyone here, right?
> >
> > And those maintainers who have been removed should be notified.
>
> Seconded
>
> <...omitted...>
>
> So I repeat - call the decision-makers out and ask for their
> explanation.

Seconded. I'm no Linux kernel developer, but as a user, I would still like
to know the reason behind a bunch of maintainers getting erased. I wouldn't
go as far as to claim that I sense malice, but there's definitely something
fishy. I would like a proper, public statement about what happened and why.
