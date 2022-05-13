Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058F07A;
	Fri, 13 May 2022 19:07:31 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id x8so4902480pgr.4;
        Fri, 13 May 2022 12:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G3htLal0R9JQlgB8aBD9qwg4j1ycq7FYDSReJvI/Ejs=;
        b=dfoLW4YM0AL0o2UMe/CAZsp0ISgrY14Zpen78cfYOkTh8uiK+/vttAkAdjMkk/14xy
         SkHEqwzygwbVdVYpB555V9s9B6LdrIpute6MioCLvnm4zn/4aCE4V34hLSOJKiPZEH+R
         DFOjPcVRQFQnqsrdSXpx5st7CfN3wgRoeo66SCZ2MsAPcKVK09+EUZwdQ1TVd5XyEBMC
         SfrmwLrwsouxzDDbrSsOz7sCUraI2aloN27/WaQAnF+PV6AHKAsXlLwW6VniVR3wJm4M
         EKV7KGQjAAewxj/+rPb1dBJrHkfcD601mRjyL0gdY5uh88LU338L/CUBP39wKlPeUH5a
         T8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G3htLal0R9JQlgB8aBD9qwg4j1ycq7FYDSReJvI/Ejs=;
        b=0mVWeWAgSGUV3X7hk9D1pPnp+KrL73OC1cqclR3HqpsraqskcoH9eV4uCeuE0gvlzx
         Dc7hH5Rd/pwqzkqywrvkY5nm2nopsypvBEcJy7IQOAQzqZ30HtKSmLUA6A4U35wANwHF
         VXr5CVT/TNfNbHztubgMX/cdA26YPD3jkSzoRUCtL3OceLDSIgCOSzuau4XHGo6Rk236
         uHtn99enXBOvgXzo/EozgaqTrLQGfkOQvjtYyyU5ckFBF54v8SQtqXMVp9uflkqJ//Y/
         +6tAODDobAsTqSnWMISuRW7d18hMduxybsY6/5L1VFXmE83eO7o+ppMwR9te/uuWhEP2
         O9TQ==
X-Gm-Message-State: AOAM533HmHdYtMo3/Pn6osZt4xI1kh7AsTwlz6u9Z2L4xAQWpbKkciKk
	jnxgiC6a6kvl5llREi2+sHM=
X-Google-Smtp-Source: ABdhPJzfFpaq1WOaqP10V9tGZ0QOROH6rY7aqAt6vYrrlF/byY/Hs88Xuipqk5G/jy3te8LF32mFpA==
X-Received: by 2002:a63:6989:0:b0:3c2:3c19:d661 with SMTP id e131-20020a636989000000b003c23c19d661mr5119901pgc.352.1652468851245;
        Fri, 13 May 2022 12:07:31 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:8d3c:fa63:aaf0:6c4e])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090a428700b001dcc0cb262asm1948027pjg.17.2022.05.13.12.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:07:29 -0700 (PDT)
Date: Fri, 13 May 2022 12:07:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>,
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
Message-ID: <Yn6sb1mzXuGyPZeR@google.com>
References: <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
 <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
 <Ynzf5jEIECLmELK7@google.com>
 <CAE-0n50+obQ5qgPNPtUY=OmTgU9bZQ3hNw+MaG9Wi3SQSc-i4A@mail.gmail.com>
 <CAE-0n52WVNru5fnyaB_7wcBOk4twL0Q92YpRbd40-o6ZBmbXWQ@mail.gmail.com>
 <Yn2YvIFNhaz5GmfI@google.com>
 <CAE-0n52ofANUWOY5h=Jjy5SYv=bnxO3xyN4cm3qGVRYmDtkNBQ@mail.gmail.com>
 <CAE-0n53VqYBP1Pq14ju5GWZ6VcKNS-DwLnM-1J_4Z3HExpMU1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53VqYBP1Pq14ju5GWZ6VcKNS-DwLnM-1J_4Z3HExpMU1g@mail.gmail.com>

On Thu, May 12, 2022 at 04:53:13PM -0700, Stephen Boyd wrote:
> Quoting Stephen Boyd (2022-05-12 16:46:22)
> >
> > I think I covered that in v3 of this series[1].
> 
> Even better, see v4
> 
> https://lore.kernel.org/all/20220503204212.3907925-1-swboyd@chromium.org/

I guess I was looking for the explicit verbage for when a particular
compatible has or can be used, and I do not believe I see it in either
the 3rd or the 4th version posted. I see some comments in the example
section, but I do not think it is enough.

Thanks.

-- 
Dmitry
