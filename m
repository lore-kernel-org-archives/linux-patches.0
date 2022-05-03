Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9E67F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:54:57 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id z15-20020a9d65cf000000b00605f064482cso7990744oth.6
        for <patches@lists.linux.dev>; Mon, 02 May 2022 17:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=PqPv3sukjDPfWFVVv2QmzL0BRFz4buvp3OmCyU+0818=;
        b=RAtI906hs/kp540GhWQ0A94Gkyla/8HnZVa1xTJKQ7MsrVFNPtwGGP8COs35R2rDzz
         WfMC+zIhqWmbvdC8q0RYd2/TUl/cYQ3WXAKtwqH9hzVha7UYJ9EE7y6rAZSK3ykOEX/n
         KxQKyP5GPlyNsVzOsEqacG/f4paG5MVhovcM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=PqPv3sukjDPfWFVVv2QmzL0BRFz4buvp3OmCyU+0818=;
        b=QQLmVpe16LHqEkLxd53xPJVovICVAgbtRO/nbs8Lr4EirXWLzW90RxtQuoaPge+TJ+
         fWA1pr0MNPYHI7BdjtbQ8cuQCE7w+3n86dZNGVRv5g8nvo3W00pDBf/7Z5HyXDiu7Lm/
         HkEgppZZ4s3AMI0VESk399NJ4x+07z1lyzBptZk9qfZq7I4gAI2caItsjfySC9p8Gy4S
         sYYortHpLTfp6H1bX3pbl/DbP0K+sRjkfDpu1ot9Nzh909Qn0tSCPhrftXuVi/+TnCUv
         2sWdCR/6jGj+8XyEI7eA+q5nhuqSgoTwDtJQazR64h4P25ARO+gn3/pT1wwFKOLUIQNg
         D5MQ==
X-Gm-Message-State: AOAM533/U19BqOx4LxwDDVtEmcOt/llts4KukQZ4Q1ELY0DYa2pzj/54
	bUldBkz/FbdDuS2+TO3hIsD1MCvZmNS4EAsinhXb3A==
X-Google-Smtp-Source: ABdhPJwXC5LAmqwYvlZ/jur0av0/iVWc1WDfRVb3EUDIbC0lUKd0OVNWqhmTPQVo95mtyDwJY6OcGX5l/l1kozM+bo4=
X-Received: by 2002:a9d:20a1:0:b0:5e8:d2b6:f63f with SMTP id
 x30-20020a9d20a1000000b005e8d2b6f63fmr4960898ota.159.1651539297094; Mon, 02
 May 2022 17:54:57 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 2 May 2022 17:54:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPUE2usLO-sJLP64ZgBrzYBwuZf2tSvKvr9GxcVEiQk7d==OiQ@mail.gmail.com>
References: <20220503004156.3559940-1-swboyd@chromium.org> <20220503004156.3559940-2-swboyd@chromium.org>
 <CAPUE2usLO-sJLP64ZgBrzYBwuZf2tSvKvr9GxcVEiQk7d==OiQ@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 2 May 2022 17:54:56 -0700
Message-ID: <CAE-0n50neMUBqPbmne-AUT-K2KJZCV4GxQHQoShxveFj9kon6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
To: Gwendal Grignou <gwendal@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, linux-iio@vger.kernel.org, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Gwendal Grignou (2022-05-02 17:50:02)
> Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
>
> Nit: you may want to add an example.

Good point. I can add to the example and resend. I'll do it tomorrow.
