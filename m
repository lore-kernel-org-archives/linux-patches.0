Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00124187C
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 19:00:15 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id u10so3538535vsu.13
        for <patches@lists.linux.dev>; Wed, 16 Feb 2022 11:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S5BSR6cJxy3OIvfsMR+O/vOvcelF9SA+qkn/HKZco3Y=;
        b=pJZEPf7Kl86YFfMRtKeB4nfuiB3C1EHAHkDlTTaudqjfpSYETB8NiUGs1gpdRJ2BoN
         JDJTGcw8UHBQZxjG+6PAiA1EBsXT63a55qxlKJWNxUpS9qEoBtmC0ttxpCk1ALzpYlww
         1LqxJi8+uVmwy7hChpHr8VsoaqPUwnZajxLgoyrTgP0R6/l46hRBpvKCtD9/DUjHROCp
         4RNnONCunQGzd8kziLrLCoETzTfqzlDrRDEhr5IvI5OxMGb0zrRHSCS32Hf95GkAYXD+
         lIWAkfdrPQ5R3+s5EoOUMANqAljP1BNwsIYbt2hM4sz40rj0xj5+LiguFL7KEYW2dQvx
         SEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S5BSR6cJxy3OIvfsMR+O/vOvcelF9SA+qkn/HKZco3Y=;
        b=0FHEose8hjDzp5fNf/3FfST01goPGwvELgFIo6cl2e0cmNzX2r8boQlfrqyM/a5NI3
         7ZJUS3OtoTkC0A8uQyPFAg3bWw2WrlDTzyQ/d4RNsMZIjrBKaVBnGyg5bboP8NycfCwv
         fTAnZzQt0m8EeZzkaDy+zCg0w924Zanzv9l8uwDMiCqqt87zfM2HRoEeIzjoJMUbYfot
         IIKqXhqpuECATEZPUYrl8gd/+HugMZluEieGWhkGLmIO9a0wOUT5d1jtYXQteGqfMwbI
         0+Dic7JiVQjSd0UUC+iexb81EumHnR6TXksr3hPIOJqQKNap8OGPGYyvBp173VgflMFw
         mlng==
X-Gm-Message-State: AOAM532tv5X25fEVr2HV4sT8JuRQvk55Q4CFZBTpOJN+y4HcAKP6/AEK
	uOIcHeOhk5g+PTjJQmiTevK3RIaEF1rCJ6+J9hqptg==
X-Google-Smtp-Source: ABdhPJwk7yxK99Lm08CHdUF76ZrAthD1mX/3wkVG+nZM+tQ93MpiegxE69ayG2fXpIM8XyQLobOKlFLiSqpNIXgbiPU=
X-Received: by 2002:a05:6102:374e:b0:31b:956a:b0da with SMTP id
 u14-20020a056102374e00b0031b956ab0damr1948636vst.35.1645038011504; Wed, 16
 Feb 2022 11:00:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com> <Ygwka++3eipjQzB2@zn.tnic>
 <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com> <YgzRsfWOmqkNiNI7@zn.tnic>
 <CAPcxDJ4=iknzYbN=b2oQxvJyODkQ_MWEj1wkKEuGwf4HQ3aPZA@mail.gmail.com>
 <Yg08Uhg0fZ9xZuP2@zn.tnic> <9f402331d25c47b69349c8171bbd49c1@intel.com>
 <Yg1ICgHfMYxwHyig@zn.tnic> <7931e48318d64e808a2ccb30ab6f7995@intel.com>
In-Reply-To: <7931e48318d64e808a2ccb30ab6f7995@intel.com>
From: Jue Wang <juew@google.com>
Date: Wed, 16 Feb 2022 10:59:59 -0800
Message-ID: <CAPcxDJ5t47M-+Bn_D+Vj7zbJTxhjrx=HsLX=iQj-EF_h2oVTsg@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine checks
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 16, 2022 at 10:58 AM Luck, Tony <tony.luck@intel.com> wrote:
>
> > You should've lead with that - this is basically one of those "under a
> > complex set of conditions" things.
> >
> > Anything against me adding them to the commit message?
>
> Add the three conditions. Not the "Google has billions and billions" joke.

Thanks for adding this important context.
>
> -Tony
