Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B227322C
	for <patches@lists.linux.dev>; Mon,  2 May 2022 23:49:41 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id 12so16713816oix.12
        for <patches@lists.linux.dev>; Mon, 02 May 2022 16:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=f/8wAhfndevj/J1N3yBWJIasHRz86NCxkLOraqJEZ3I=;
        b=U+eozlJiuwXweZAZwZgwKg8AbtEWzgT787jSunJqgNYKFAYU2sk9jF/tussaSBzEj6
         zPONEEClbARzCV70uc7Eac8vMXYjko7CvW18CXSdgRFD6hiK9T7gZqDzUjmqV/b3PHmk
         OWScniXMFIN7XUInNcGUHP0cy2DepwEIxBsrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=f/8wAhfndevj/J1N3yBWJIasHRz86NCxkLOraqJEZ3I=;
        b=0EEeG1Fh/a/CBEdjnJU8lbJY/hG4YJ3YROKy3oCCWdJ4CmJFQOCt7+LEz0ZmTU3M+d
         h7lgHfo2Mo9B4c26kS+nNbes9+AnCpzdFvKAeunM2/plzcOuWbKER9gKwyhtcMxq67hJ
         ObJEEPWfKKS5FuU7rTFUNNiMBWSMzGcirnFUz6HMSQyoV7+qWjoySMX13L5cYkpgny/y
         vIahgfBhQhDG76uoqBLiAVYgf/MP1IUAwZihAnhgWxNtFi7tOyi0mI3D5yoRfRYHgp8W
         4XW/CkX3Aql/WPo+al8l6ztSraqrnPw+kNuBcbzz/YCQPwWEyKxqieTuE3C/SIA9H6Y4
         1BuA==
X-Gm-Message-State: AOAM5337McC84q7CNqq+nHjZBJC1Ug4WY+wHF1I8FA4MpPZtcYSBvwhf
	w46fd9J1eXS2MKqqBb3qopiZiy8hVAvzugT1Kk4epQ==
X-Google-Smtp-Source: ABdhPJxXlou3d6XzjcL/neLV6qpKQUgvnmAFgJDuMOTACWhPnak8bHhRAo8T3khmrzYlbcN9YD2WnbIjkQoANiagm8E=
X-Received: by 2002:a05:6808:18a5:b0:326:31ff:4232 with SMTP id
 bi37-20020a05680818a500b0032631ff4232mr249354oib.193.1651535380105; Mon, 02
 May 2022 16:49:40 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 2 May 2022 16:49:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com> <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 2 May 2022 16:49:39 -0700
Message-ID: <CAE-0n51hke4j6ChZ0am53FEojXF96X3K+ptOMOhdN7T7W1550g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Doug Anderson <dianders@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	chrome-platform@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>, 
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2022-05-02 13:41:33)
> Quoting Dmitry Torokhov (2022-05-02 10:43:06)
>
> > We have
> > implemented the notion that without rows/columns properties we will
> > not be creating input device for the matrix portion, all older devices
> > should have it defined, so the newer driver is compatible with them...
> >
>
> Agreed, that solves half the problem. This new compatible eases
> integration so that devicetrees can say they're compatible with the old
> binding that _requires_ the rows/column properties. By making the driver
> change we loosened that requirement, but the binding should have been
> making the properties required at the start because it fails to bind
> otherwise.
>
> My interpretation of what Doug is saying is that we should maintain that
> requirement that rows/columns exists if the original compatible
> google,cros-ec-keyb is present and use the new compatible to indicate
> that there are switches. Combining the two compatibles means there's
> switches and a matrix keyboard, having only the switches compatible
> means only switches, and having only the keyboard compatible means only
> matrix keyboard.
>
> It sounds OK to me.

There's one more thing to mention. The switches are discovered by
querying the EC. Reverting commit 4352e23a7ff2 ("Input: cros-ec-keyb -
only register keyboard if rows/columns exist") makes it so that in the
case you have a keyboard and switches you'll be tempted to define both
compatibles because you have some switches, but for all practical
purposes you don't need to change anything. The EC will still be queried
for the switches. Maybe "google,cros-ec-keyb-switches" is a bad name. It
should really be "google,cros-ec-keyb-v2" or
"google,cros-ec-keyb-optional" where we clarify that matrix keyboard
properties are optional now and are used to indicate if there's a matrix
keyboard or not.
