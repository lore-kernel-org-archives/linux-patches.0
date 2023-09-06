Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029DC1079A
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 20:23:58 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-500bbe3ef0eso198058e87.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 13:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694031837; x=1694636637; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8vp0InoF118I1Lx55kge76Tlc99H/PzqwsKSdDvIug=;
        b=OqU4/i6SUijJcZG5UvK5AlTYEtPTCGgyA5uWiWvqqQtoTaaD1Xk+IhKKpkS7qiOwdk
         ++54e/yLlp9uZnvZQO21K74ZHNVXHWq/E/lFWOCPJMAazKkzSzMpJ1xq614LcBCtU0BF
         cYoDmfBF9/1b2GeNM22IG+akdcKdZSmLcxA0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694031837; x=1694636637;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8vp0InoF118I1Lx55kge76Tlc99H/PzqwsKSdDvIug=;
        b=a9B936PcCk1+S5PeRXZoCjZ2XZ3UKmqArlFqpMhJtzHneFRVlbw4EPNbPhoSbRDIIT
         SUl4JuR6ljDesexmMMQNcuXOcevhAdNFfaV7b0I7ywU/LQ4VblVb458hnTSNE7jzudcg
         BouheyoUgZXdgLUtSCk0JbEqpldH9hUXOJ+z4LAcQs+i+tMNvFEpTjohI0kVOmPDX7Vj
         v4Vjaqk8AUHzwlyG90BzM7C5bN2tJQsByfA4SLDXMRqwsqZvo9vI+R/D1YXPgCPCt9u7
         isaaU8IKQ4MbvfK2l77s0p994BKvbXrhQ3S1021h4N7KMfReH/ouf064yxe7gvRWlxpA
         XUbw==
X-Gm-Message-State: AOJu0YzVEZhtiyG6rd/mxFau77vz+HUGNHNLQXWoO/w5Y7MzxOZxLoIY
	CbaWlQF2BXRbh3b1L/yyS4j+WAYP+e4Q7aP1n7SfkQ==
X-Google-Smtp-Source: AGHT+IF91IQYI5GqRkLRbE6KJZwPvsZO4fx9EKPszpEGrDsMSaQQVATEVcB2k3W+rGLwzdLsjPLNriROA4FYiIp2JNc=
X-Received: by 2002:a05:6512:158b:b0:500:b102:d1c9 with SMTP id
 bp11-20020a056512158b00b00500b102d1c9mr226970lfb.29.1694031836716; Wed, 06
 Sep 2023 13:23:56 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 6 Sep 2023 15:23:56 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <1248ebb9-ff14-418a-ae01-cfa5c8ca9d68@linux.intel.com>
References: <20230906180944.2197111-1-swboyd@chromium.org> <20230906180944.2197111-2-swboyd@chromium.org>
 <ZPjbZqIQBlIGpoCK@smile.fi.intel.com> <CAE-0n52REGuVrqG8LUdWzjgqAun7uvDFPJeSkjX02OxD=fUhqg@mail.gmail.com>
 <1248ebb9-ff14-418a-ae01-cfa5c8ca9d68@linux.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 6 Sep 2023 15:23:56 -0500
Message-ID: <CAE-0n53Tqcq8KHaYA8+1_kxy2nPmcRp3t1NK_vAZM=9tfCxqjA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after
 timeout in busy_loop()
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, 
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	Prashant Malani <pmalani@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Kuppuswamy Sathyanarayanan (2023-09-06 13:20:49)
> On 9/6/2023 1:14 PM, Stephen Boyd wrote:
> > Quoting Andy Shevchenko (2023-09-06 13:04:54)
> >> On Wed, Sep 06, 2023 at 11:09:41AM -0700, Stephen Boyd wrote:
> >>>               status = ipc_read_status(scu);
> >>>               if (!(status & IPC_STATUS_BUSY))
> >>
> >>> -                     return (status & IPC_STATUS_ERR) ? -EIO : 0;
> >>> +                     goto not_busy;
> >>
> >> Wouldn't simple 'break' suffice here?
> >
> > Yes, at the cost of reading the status again when it isn't busy, or
> > checking the busy bit after the loop breaks out and reading it once
> > again when it is busy. I suppose the compiler would figure that out and
> > optimize so that break would simply goto the return statement.
> >
> > The code could look like this without a goto.
> >
> >       do {
> >               status = ipc_read_status(scu);
> >               if (!(status & IPC_STATUS_BUSY))
> >                       break;
> >       } while (time_before(jiffies, end));
> >
> >       if (status & IPC_STATUS_BUSY)
> >               status = ipc_read_status(scu);
>
> IMO, you can remove the if condition and read again the status in all cases.
> It is more readable. But it is up to you.
>

I don't really care either way. Just let me know what makes the
maintainers happy here.
