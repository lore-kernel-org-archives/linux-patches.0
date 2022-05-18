Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598E469A;
	Wed, 18 May 2022 05:06:15 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so939559pjq.2;
        Tue, 17 May 2022 22:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XRlsgT/DhPOQs8SJOPJpABXkZ441U4eTkofnVJR9/V0=;
        b=gw/mDhni92fmwnaUg618f+wzz9908yL+rd0nTfay+zsDORoQHW22NvfLKAWGLdocYI
         ommPn3F8OsYjdazmSfOyHjrf3LwEgRY4Y2rnLKwYYcs5CK0HGeUPuEZh9S20VkfMTW1B
         B3T421gBglYuMNX4n9TnJ/30ew4Pbwfn7bncxPSQ7RQDLmS9oIvY8Ti5xT91S9cg7BvO
         K84zAVxzTu6AlF5YLNRYW28XRhBoVmQs5L1SFBh1VNx6qvQEwW3FfxIuDNFSC9p7f3js
         0dIjldDLL4uc8Je7UgD370y0I0TH69ZdarTkKj61y/VVvsc3IDEmwtxZvpGCuCbDHeXy
         2x/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XRlsgT/DhPOQs8SJOPJpABXkZ441U4eTkofnVJR9/V0=;
        b=1gGC7M7yXSgOgwqJldxCx1LcmyYjg1gg7WfUn/+MwZ2UsNqcggm4K6qncoZ0MYUElH
         g1S1L0ZB5HzUCS9N8IR9t+iafBVUhZHycRVHPtXXI8fzcL9U3MP+GtJY80P7rxxEJs8B
         dKAmZxeJPR+iztbwj205PaKpxh6DJgbEn1WallCisrFLyT9EZtKHn2x3RvJw1H1BsNxA
         N/oYo2k7QppJ8Rz/wk6Zz2a+Lrr6woCTzT5FjCwCMcv+z92ICPa34/CEZ/fKzzt4ZoAm
         MHwz6vu1fXSuMVNkRPhPkrdpL9lrlxJslAxuKCQhgpsic5V+7ydElLk+LTHc36F1nVCR
         t4aw==
X-Gm-Message-State: AOAM531/iKozZbOJc2/yq/8L/ikHY8Nz/ZItNCOswKeYkF4cY14xT9Pz
	5aDJ/QUggRODZEWJww6EDME=
X-Google-Smtp-Source: ABdhPJz/Ts716RSWDtwDnqjE6nbvnA/HhsrFs7hdFknU2JjN18U3m/JtJ62iHxHnqxMXAPX8m5gm2A==
X-Received: by 2002:a17:902:ccc2:b0:15f:4acc:f202 with SMTP id z2-20020a170902ccc200b0015f4accf202mr25153827ple.3.1652850374886;
        Tue, 17 May 2022 22:06:14 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:556b:348:b181:320f])
        by smtp.gmail.com with ESMTPSA id l17-20020a629111000000b005180cf8f8c2sm651052pfe.169.2022.05.17.22.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 22:06:14 -0700 (PDT)
Date: Tue, 17 May 2022 22:06:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: Re: [PATCH v5 0/2] Input: cros-ec-keyb: Better matrixless support
Message-ID: <YoR+w7CSqN0aAE5b@google.com>
References: <20220516183452.942008-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516183452.942008-1-swboyd@chromium.org>

Hi Stephen,

On Mon, May 16, 2022 at 11:34:50AM -0700, Stephen Boyd wrote:
> This is a followup to my previous patch[1] that skips keyboard registration
> when the matrix properties aren't present. This adds a compatible string
> for this scenario so we can ease existing DTBs over to the new design.

As discussed offlist I massaged the binding and the driver code a bit
and applied it to an immutable branch off v5.17:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git ib/5.17-cros-ec-keyb

that you can share with DTS maintainer(s) to accelerate DTS conversions.

I also dropped the original patch as it did not make it to Linus' tree
yet.

Thanks.

-- 
Dmitry
