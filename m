Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F77463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:45:43 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id q16so1011890ile.1
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=d1Vgpq9X5YO+PwL5y7QUHDAwAkqiaQQAgkfJbYzVVq0=;
        b=LaPYTV2/D8VkQyeRMlMejudbf5K/nTvqXy0MUDHuYszw4tWxAx21CDJ6f27ZEuLcpU
         KctBy0EHSB6NTBFzDJh0uoQ27QWNKdXoVKlW7BVQA3kvPSR81Oft6NDBecQxNLtOCnaF
         af9Kg49qpyroatKZXd5KQjuporz6n+m2gLgJN3WTt7pU8Spumrbr/YyvrGRqqREcssJ0
         UQDLJ3CDdbKj5RrFzl57SKBcnbhHjquSPFbeD95ebsNLbcfWWc62N0y/htc+YCFjAcqt
         2ze4PiBVbkPUmLzduZcFcC9LCsFac8cHEKs8Za5PI5Q1ZIWnEq/TqsAegcyu8/PUfs4Y
         fqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=d1Vgpq9X5YO+PwL5y7QUHDAwAkqiaQQAgkfJbYzVVq0=;
        b=3oxsx9RAZDng3XQwh/2A81qMrgLiCR1bjZfwRKW3TAc9uJdnojNMXcV2eCIfQy2D3f
         aBZ+6WJWmTqP0O1BZBSTVUB+T52BPO9G0wbh/+V5XwmS9cdzdMCRwnEd745zPrVGXirg
         LnAfpMgMekE3l1MXMjR4qc1gEO1NdvDlfL8/7+uK+ozXgGmNPfyKgbXZhf5YlUojZaKe
         eNpwlXkfRYRE+RYmbq6MBlBHRWWRbCgNvPoTdsVCu3WmJreQjsRzIBLCGhWp0I7JaOZ+
         EzO+og6S1PkoLzNsIaNv4vTCzEAwHikpFKdFiysvsRnFYD2s1ZVm8xCBZWZ0ymTtN9Ly
         s7ew==
X-Gm-Message-State: ACgBeo2eMBx3p8kPh/GVGKlxeg84+3PfV1ptxcb0nVRINdaNQd5GFgfV
	HoiY2W8j3KTOFVG6FLt3/adr2pdL3kex1cWwfn0=
X-Google-Smtp-Source: AA6agR6Nm7MWXy0TYAOYscqNUAIzeSuDdU7CjMymOwFGtEGx7D3WFG7qttZC1lk/1OE+k4Q06t3mvA6TpFhhxMku80o=
X-Received: by 2002:a05:6e02:1c26:b0:2e0:d8eb:22d6 with SMTP id
 m6-20020a056e021c2600b002e0d8eb22d6mr12711912ilh.151.1660769142550; Wed, 17
 Aug 2022 13:45:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-4-ojeda@kernel.org>
 <202208171238.80053F8C@keescook> <Yv1GmvZlpMopwZTi@boqun-archlinux> <202208171330.BB5B081D1@keescook>
In-Reply-To: <202208171330.BB5B081D1@keescook>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 22:45:31 +0200
Message-ID: <CANiq72=S4ACw1mJk4MynmUu46Hdh3bm3w-S7eGPGacw+CJda+g@mail.gmail.com>
Subject: Re: [PATCH v9 03/27] kallsyms: add static relationship between `KSYM_NAME_LEN{,_BUFFER}`
To: Kees Cook <keescook@chromium.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 17, 2022 at 10:31 PM Kees Cook <keescook@chromium.org> wrote:
>
> Yeah, please add a source comment for that. :)

I agree, I think this sort of explanation should be in the source vs.
the commit message, since it explains something about the code, not
the change itself.

Cheers,
Miguel
