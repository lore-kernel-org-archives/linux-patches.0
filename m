Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94092C9D
	for <patches@lists.linux.dev>; Tue, 26 Apr 2022 22:41:48 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id c12so63723plr.6
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 15:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FbBWmvHmK3IQ/p4Z2WqxkrztSbZlWCp1DoYs6E39RsA=;
        b=ldES1I0qz9ByqPHhRHx7eCQ9ZkGKEBzw2T8tUCIFu7om2d4dlipMaoVyMIb5MUTW7w
         cZXRYqvSWU6i+TdOnxmOds+hBFesRmcRjIBOMWVXjOnFkhG8IBH5NcrnhzpEk0b4Qado
         a6ttqGdmb7NhEaYS3CShe6rXJfQ/LFrCQJTVp0Am9eeSYdUAChPWdFvDr/rFiRa40vli
         NqyoT5pt6PmNlqqnW+7GfkvfbVSk/7cSyT6Bp6FuwutIQub473pt5PsGQ+2hdACZUrDB
         C36H9WTqyhgGPlAEEPMIcEHx4hV/dEwYnvHW779nxyD1F36ihqXZ8FKkefg7nApimUkL
         Pdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FbBWmvHmK3IQ/p4Z2WqxkrztSbZlWCp1DoYs6E39RsA=;
        b=DFamMYoU5Tsh3qkwu7Ns5H62ia3SMRo/SZm2sGXEP+LYtGYTRmrLKErVHIFXXO/0nD
         oZLqgb4im4QTXdub3LzcZdqCAEmBHVDpwUNZRJf4myZD8kT6gFSdcfk2iBMJ63FDQ2C4
         MmghmGMvmUhHGuKFjSf30SbNLIrt+2/CCTjYS56iclAO/K+N/HtUMgAuwlELevyXodlv
         rEj+FGYH6N1DFpPQENtiVtWxgbmEudyAxEi11dLW0vc1GUlji7tB20vfpoQsboBlqbvi
         sOsVtxDvv83M5RDIVA0/ubuQ4Ynr8EKeds31gQ+9nKeBNSAaFeVAUFadEX5BWQTP6s2h
         AMSg==
X-Gm-Message-State: AOAM533JVY0Nbe9oF/e7/KPUsgyNf53IgdyWNDfwQKu/PbQA6kfQnQwu
	cbtQKXPuUnbiSMhBceVXJTg=
X-Google-Smtp-Source: ABdhPJz3jG9OVaP0/gv/wHQABjs99n3lLKtgL9rMzQINE+y7Qjnz2IFJYpt1IeZOpTykC04gYm+j7w==
X-Received: by 2002:a17:902:8f94:b0:14f:d9b3:52c2 with SMTP id z20-20020a1709028f9400b0014fd9b352c2mr25183279plo.103.1651012907805;
        Tue, 26 Apr 2022 15:41:47 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:d35:5028:5db5:38ea])
        by smtp.gmail.com with ESMTPSA id g6-20020a056a001a0600b004f7bd56cc08sm16437172pfv.123.2022.04.26.15.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 15:41:46 -0700 (PDT)
Date: Tue, 26 Apr 2022 15:41:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>
Subject: Re: [PATCH v2] Input: cros-ec-keyb: Only register keyboard if
 rows/columns exist
Message-ID: <Ymh1J9zQ+5EyQadE@google.com>
References: <20220425210726.3813477-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425210726.3813477-1-swboyd@chromium.org>

On Mon, Apr 25, 2022 at 02:07:26PM -0700, Stephen Boyd wrote:
> If the device is a detachable, we may still probe this device because
> there are some button switches, e.g. volume buttons and power buttons,
> registered by this driver. Let's allow the device node to be missing row
> and column device properties to indicate that the keyboard matrix
> shouldn't be registered. This removes an input device on Trogdor devices
> such as Wormdingler that don't have a matrix keyboard, but still have
> power and volume buttons. That helps userspace understand there isn't
> a keyboard present when the detachable keyboard is disconnected.
> 
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Applied, thank you.

-- 
Dmitry
