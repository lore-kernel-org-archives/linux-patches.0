Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F83EA23
	for <patches@lists.linux.dev>; Thu,  1 Sep 2022 03:16:36 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id a36so17002643edf.5
        for <patches@lists.linux.dev>; Wed, 31 Aug 2022 20:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=G7ttsCuJ+J4/i3YBhKPz49AMBmOxDd9nfW8xTxQ4h0M=;
        b=YK/HTOaFeidBrISWkJxAv0RRcjxbKPsrvYdSRlC5iYmTFRM94m8seXKolYNCyWAfry
         PlRsUbcA6etASqDUHjas214kmY09uDBASTQYG9XmYDEvk6DVFlOUd1Yxa3/Hkii2xeyr
         TT7zDAdOUTUBmgFXR+oZqizpPkotwljSby1qM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=G7ttsCuJ+J4/i3YBhKPz49AMBmOxDd9nfW8xTxQ4h0M=;
        b=N1rEjuOY2vyyBx/pXWTkDwNuSci1FnjfG9iKndQaVH3cmplkU5tVkFPPCIcPDgyN+B
         xSx2+7b+LzQZLhLgb47vs2ZMactK9kB0kWD6NICGyakb0Y9fvPgvbdEsu31sEyd6rXEN
         7FBpa24Urr+Re5OhaJb76vRmejsCkhJbrj45tqqzbVFi99Utax/esCwSZYH52xJb1Ei6
         sVcaGdAWD88vTbqYsbuxTy55lN4VCaybeWevqF8Hv4MdbrrDC4igT5EKuLMIt+FQFRoq
         lSmARSa89d5iEYwktg139Gg+Fmn31gMEC6Hn0pzsX1GgTQ8fGTSC8rZWIKus4T5Xs0S0
         yk5A==
X-Gm-Message-State: ACgBeo1SAWJjR62UIIYLv4eV/FhaESd0QjCBC7GMftbxXDieiL6idZEz
	5n1coKpRvBC0LBYoVeQdsj9tk5KUv731umLSIajwUg==
X-Google-Smtp-Source: AA6agR7vJeE5BNhhen2MLdU5JdOhlrGzZODJxL0PCi4/ZVfXO6wKdzyhUgjU0FnX+CRblsDSypW2pprW7PvKD2IsvwA=
X-Received: by 2002:a05:6402:292f:b0:448:6241:25de with SMTP id
 ee47-20020a056402292f00b00448624125demr15550195edb.248.1662002194496; Wed, 31
 Aug 2022 20:16:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220831175326.2523912-1-sboyd@kernel.org>
In-Reply-To: <20220831175326.2523912-1-sboyd@kernel.org>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 1 Sep 2022 11:16:23 +0800
Message-ID: <CAGXv+5G1cAdT8S7Ksr=SiHn8-ugMvRXEZkVXd9vru_nuQvVW0Q@mail.gmail.com>
Subject: Re: [PATCH] Revert "clk: core: Honor CLK_OPS_PARENT_ENABLE for clk
 gate ops"
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	Alexander Stein <alexander.stein@ew.tq-group.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 1, 2022 at 1:53 AM Stephen Boyd <sboyd@kernel.org> wrote:
>
> This reverts commit 35b0fac808b95eea1212f8860baf6ad25b88b087. Alexander
> reports that it causes boot failures on i.MX8M Plus based boards
> (specifically imx8mp-tqma8mpql-mba8mpxl.dts).
>
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Cc: Chen-Yu Tsai <wenst@chromium.org>
> Fixes: 35b0fac808b9 ("clk: core: Honor CLK_OPS_PARENT_ENABLE for clk gate ops")
> Link: https://lore.kernel.org/r/12115951.O9o76ZdvQC@steina-w
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Acked-by: Chen-Yu Tsai <wenst@chromium.org>
