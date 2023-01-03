Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618AA7E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 10:32:20 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id b88so35917879edf.6
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 02:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v68bOoCkR5Tf7INS4xaBH/vNbNABqgbVmisl8n1c8os=;
        b=APp/boIlEzVSZyYU1Gyb8hYMdMSDN7Vy2kh43Ip09ilk29PnlWASTAQCVFadgXSV7a
         Dx1d0tk/DrrwR9Fk8ccyzI48+1raEPU/heOf24L7Sq00C662Vp9BXdNWgdyDKNAEZQ4h
         1AtpgN5lWLAxkPTaps3rxH7goKyE9orSf6DHYEfxesR101lsGLf9NPOr4SBUJ00kJKYH
         EfK3xAwbP0SgBYgBZluMpJ2+tlMPLpurCTHruBA3UwEsXeQ0LQJjPNxHuSv9LjGfpHqW
         sVrqJ9fyI/2BpC117/KVGgooZFMFT15xytKbe7utLTgI4BXCo5dI950ReI6pcTe3Rt/j
         2fGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v68bOoCkR5Tf7INS4xaBH/vNbNABqgbVmisl8n1c8os=;
        b=QZgnw2fgiCX18SJvi/5NwycwzODuFTrco2cgmu4ioSQCHgpr2klRxGmJrmiJ0HiUPk
         36/0I24dVE5fLuoEiYlNMx0ePYtOtmAqJBlx2iLciQv5YpbBjhow/FmvIr1RURbLi5kz
         Emegit9YZes2q+6AnpQjSbhhK3G8U2wmq62QKuucrRZFNbP52PYpZyt9gPW//SxLrrPK
         y9r2J++mZUVYYHlrRU/VYN8rFLNLk4oCNB70GlLe2OhWCo8s/NnDiIuACDOVsd7KA8/2
         DKhm+Xu3t4gycpItdKCMExnWrkwkuOFkihjIG52ipevLYfNhljvF62m6u5JMeyObeVd/
         qZlA==
X-Gm-Message-State: AFqh2kqxP2aD92wf8EoVrsjEPRH0KNHREZJGMWnr73ISfsA8VTjSwGUl
	UStOMU9BZKe1iu7DxLTF04A=
X-Google-Smtp-Source: AMrXdXu28DjVmzTZWJ65IPFE5UzkCMj3obws/ToJ6HzK7ruWFBn/tXvuDNKK93bFiOhX1lvTVmMaLw==
X-Received: by 2002:a05:6402:12d4:b0:45c:835c:c6d3 with SMTP id k20-20020a05640212d400b0045c835cc6d3mr36173805edx.4.1672741938632;
        Tue, 03 Jan 2023 02:32:18 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id n20-20020aa7db54000000b0047e6fdbf81csm13616526edt.82.2023.01.03.02.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:32:17 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 3 Jan 2023 11:32:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v14 1/7] x86: lib: Separate instruction decoder MMIO type
 from MMIO trace
Message-ID: <Y7QELo9etPM8Tpx5@gmail.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-2-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230101162910.710293-2-Jason@zx2c4.com>


* Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> Both mmiotrace.h and insn-eval.h define various MMIO_ enum constants.
> Rename the insn ones to have a INSN_ prefix, so that the headers can be
> used from the same source file.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/x86/coco/tdx/tdx.c          | 26 +++++++++++++-------------
>  arch/x86/include/asm/insn-eval.h | 18 +++++++++---------
>  arch/x86/kernel/sev.c            | 18 +++++++++---------
>  arch/x86/lib/insn-eval.c         | 20 ++++++++++----------
>  4 files changed, 41 insertions(+), 41 deletions(-)

FYI, I've applied this fix to tip:x86/asm, as the fix for the namespace 
clash makes sense independently of the vDSO getrandom feature.

Thanks,

	Ingo
