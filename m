Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6613C23;
	Tue, 25 Jul 2023 16:54:38 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-666e5f0d60bso3311422b3a.3;
        Tue, 25 Jul 2023 09:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690304078; x=1690908878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8UuEkDJW730mNtROAXjbaQr214jAPvsqozqw3XotTgk=;
        b=QC9cRbmKk12UP1Rm2hCntC5ZqLpEe+PJFe7ItKJb0mXd/yGSzmDLYbzM6o9dtNwmj2
         7x/JTTKbylWsjekJxMEI7xz4F9sSZ5dwSOk5IYm/SMwSn3cDVg7QtbNo0jADygtWSdlC
         pnKrMkgL5EMSuVcY/Xf52d9YnH/kCOI+Mf27z433oJ7ZfafIev1QRMXZPS9YIj6BIZnr
         LBSpTZrKMa0yRIw9t3UJ66Pq1WXGX92LAi6+gxsLV5/JPGpekD5iZLu0W2jLMzDWItVm
         dtMsrXpkOd2NJnqOCU1seazn3lczzKAGVTowUd7CIJ11k/rGC4FB/ZPb0HyC5gjZ93R9
         +hkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690304078; x=1690908878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UuEkDJW730mNtROAXjbaQr214jAPvsqozqw3XotTgk=;
        b=M4sJRJhKSym0sG59hBIWfZ7xLP//WrH6SbvIV7J4I8yYubuRb0+EYBxn77hHtPyjsL
         +3sn7BHWn8WL33pQVaRBu5YOkO0k8lttqIwk53WkOHDctC39o4Ga44c5otM7VxNnDuf5
         PHYgms+q98E7u3dZpqGE9/H/IR2bQCimeNoVi9/78etE4h7oR5KLm7b/aVCbcb41UAzC
         bDqZWOGOj+8ZfM5Oy1txJLYnzHkah22ZAS/xkkCDi/HvIVf/EJixT9l6bT1NTMnVVAha
         tMQR39PiZEP/KfAmJ6HyU5b1o9e2swfP9LEb5x6IPYBobyaWRjGrFJv2bpufhoDHe7ZZ
         jnpQ==
X-Gm-Message-State: ABy/qLYloyLvO0ZcZQPkbpYALfaqgkKvxvX3Ol6d1C3jNxzrAeV1q1cf
	/vUiRtOs0TU/Lo6FtuXdDxM=
X-Google-Smtp-Source: APBJJlEsM5uOpRgfOeSskRtjwNdhQd49G6XxsgoE/raWfRa8Cb8yblk5KkgTkru8+yrIvwGWQEhLLA==
X-Received: by 2002:a05:6a20:258a:b0:135:62b8:2a35 with SMTP id k10-20020a056a20258a00b0013562b82a35mr11708687pzd.32.1690304077724;
        Tue, 25 Jul 2023 09:54:37 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:9d8f:da31:e274:eeb5])
        by smtp.gmail.com with ESMTPSA id g8-20020aa78188000000b00682a908949bsm10100429pfi.92.2023.07.25.09.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 09:54:37 -0700 (PDT)
Date: Tue, 25 Jul 2023 09:54:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com, trix@redhat.com, frank.li@vivo.com,
	linux-input@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] Input: mcs-touchkey - Fix uninitialized use of error in
 mcs_touchkey_probe()
Message-ID: <ZL/+SuXswTMjXDUv@google.com>
References: <20230725-mcs_touchkey-fix-wuninitialized-v1-1-615db39af51c@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725-mcs_touchkey-fix-wuninitialized-v1-1-615db39af51c@kernel.org>

On Tue, Jul 25, 2023 at 08:37:56AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/input/keyboard/mcs_touchkey.c:149:49: error: variable 'error' is uninitialized when used here [-Werror,-Wuninitialized]
>     149 |                 dev_err(&client->dev, "i2c read error[%d]\n", error);
>         |                                                               ^~~~~
>   include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
>     144 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
>         |                                                                        ^~~~~~~~~~~
>   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
>     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
>         |                                     ^~~~~~~~~~~
>   drivers/input/keyboard/mcs_touchkey.c:110:11: note: initialize the variable 'error' to silence this warning
>     110 |         int error;
>         |                  ^
>         |                   = 0
>   1 error generated.
> 
> A refactoring updated the error handling in this block but did not
> update the dev_err() call to use fw_ver instead of error. Do so now to
> fix the warning and avoid printing uninitialized memory.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1893
> Fixes: e175eae16c1b ("Input: mcs-touchkey - convert to use devm_* api")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied, thank you.

-- 
Dmitry
