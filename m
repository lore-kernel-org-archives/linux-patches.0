Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28436135
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 23:05:01 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id j17so9755360qtp.12
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 16:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=lGIdeZM1S9hN/ejZ6gUGJwd3xauHVCbCEipm4Vgi8qU=;
        b=dlbf6/F/P4SrgvdTS2+FiE5hANx0T0WOLMIcQSg9PEuqXhJz2+xSo5B9WwxZIUFQQx
         hIKvzmjjmhGf5tzZUJSxB90z3XIIMGNHnbyBSYXudVhDVtzMBcZjWSKlMZ0ENUqHuRPU
         JpbtQrkx3v+o+101M4mqAd20O3M31s7gU8rkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lGIdeZM1S9hN/ejZ6gUGJwd3xauHVCbCEipm4Vgi8qU=;
        b=KWoKU6v1tRF14SpYHcH+cZquoy5rTN703FviGebdX0ttH/UsWP9TwdA6UjaqBX4MsU
         Lt04Xx7Cd+bvbt0noIG0Un+7DHTedDyUxM9KSgWf/N7hbhyqlp6Yfvb1lSYg2iLYR+2u
         U9USblZMaHRq4qLgUATy8xhuYNvXFlkLWMrWIy1MboGelbbShSFbKLcemVJxK4ptzRyF
         Kc3lHq9SH53NXY9gXt3knIYtA5iNrT639+UXXUFmbGK+WRx7hiyEGmO45lmQ7y+4a7SE
         BDkjYiGxjBXiX66ZOrLrH8vE5XfHo6ceB0OCv+DOQYbmcXO0pYrqdO7GFbW6Rjf0v9l5
         Oo8A==
X-Gm-Message-State: ACgBeo1FcRPhcQNdo/nX4DC5mRo9/lhWC0vRzemn2L9PtzFYWiBOrIsY
	U4lScUU3VCNlOOy4zcQsQkHJMAbIngdtuOtz9fOt4A==
X-Google-Smtp-Source: AA6agR5c0XeQFvIoD/9i1d+eD97rvNFHI5OWnMRuWRK0UMO/zTCiwEeveR9tSFaGf6Y1iLwckZrNLl9LVLaZKLB1Eyg=
X-Received: by 2002:ac8:5ad2:0:b0:344:90e7:410f with SMTP id
 d18-20020ac85ad2000000b0034490e7410fmr17446555qtd.625.1661900700697; Tue, 30
 Aug 2022 16:05:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220830225831.2362403-1-swboyd@chromium.org> <20220830225831.2362403-2-swboyd@chromium.org>
In-Reply-To: <20220830225831.2362403-2-swboyd@chromium.org>
From: Prashant Malani <pmalani@chromium.org>
Date: Tue, 30 Aug 2022 16:04:48 -0700
Message-ID: <CACeCKacwLMTdaURq2F5uiE2KcJG0pcMUBR8UZy5ftGZpWZRL=A@mail.gmail.com>
Subject: Re: [PATCH 1/4] platform/chrome: cros_typec_switch: Add missing
 newline on printk
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Tzung-Bi Shih <tzungbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 30, 2022 at 3:58 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> We need a newline here to ensure the next printk starts fresh.
>
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Fixes: affc804c44c8 ("platform/chrome: cros_typec_switch: Add switch driver")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
