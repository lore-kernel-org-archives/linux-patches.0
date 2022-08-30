Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5759B6131
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 23:05:37 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id c9so9631666qkk.6
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 16:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3q+RTaRoDJ/mS6E2OdJGUZUv/ANh5AS0o0Ziht8MEyk=;
        b=PgxTnvTE29KCKVSMRimB72WadJkatYaN9T3nsES8Z9oojD1WTJQEamPUKdaq1Ym4ZD
         NyUTCKpvvAcet2PSsMpf3O1BtqIkpFuG7nrMyIFlreo8CgAOl2oCb6Y9I2vjdcdMk/JR
         662tf3ZT0yOm21sB0rvyCZCLS1g/C93AZJlkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3q+RTaRoDJ/mS6E2OdJGUZUv/ANh5AS0o0Ziht8MEyk=;
        b=gfuB79yPh6YG2gkWf7/aGlnPaLgRk/hbcxxEk+Sb1yrFvXrebeFwm9rAZ4D2t75RH6
         zG+PaHHB1HnYerFD3pClFAHPrtgBIXjP+qk9LGKLdYByF360jXn4IK57Ubzo+PUvRudB
         tX0TZ+WqNEUGWl2wvcDzDwL1H5873j4se0Hm5ymVuXHcPGTDKX50muxESAAsvpWcz0J/
         KqrtGCJ2lx8tNko0bcNDlr9bTDgIogJETZxkgCAxZ71pB/Ym/IHLCLlAFoXlA7qpPJ74
         /b7kHRHBU+47u9b3BsZPV4SOvzJ88UFb8LLb8loz2Uu5x9Z4fpS90nAah5EOxPFAkqze
         kjWA==
X-Gm-Message-State: ACgBeo3CW3M5d07FYCK4dgpzliLIsw+e4U03CmhS5Fx4tOMIGgLic4K+
	O3ihzCa072hkRaAUT9uoTMknOZTx1LJDq8kVvcCWtA==
X-Google-Smtp-Source: AA6agR5Cdy05jCjyZers7UuBLDnUBYOzZ0flmb/NVCrmjXIpevYhyeQiLMi8DfapiijfzKnTxqRo7TCVyUg03BwkPsA=
X-Received: by 2002:a37:bd6:0:b0:6ba:f6d1:9619 with SMTP id
 205-20020a370bd6000000b006baf6d19619mr13070687qkl.366.1661900736963; Tue, 30
 Aug 2022 16:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220830225831.2362403-1-swboyd@chromium.org> <20220830225831.2362403-4-swboyd@chromium.org>
In-Reply-To: <20220830225831.2362403-4-swboyd@chromium.org>
From: Prashant Malani <pmalani@chromium.org>
Date: Tue, 30 Aug 2022 16:05:25 -0700
Message-ID: <CACeCKad+aXZbSmkd6puSrw7XVUvy1pnta4-2-4dhoJo44dzSYQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] platform/chrome: cros_typec_switch: Use
 PTR_ERR_OR_ZERO() to simplify
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Tzung-Bi Shih <tzungbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 30, 2022 at 3:58 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Use the standard error pointer macro to shorten the code and simplify.
>
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
