Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C124366
	for <patches@lists.linux.dev>; Mon, 28 Mar 2022 14:26:43 +0000 (UTC)
Received: by mail-wr1-f66.google.com with SMTP id j18so20646615wrd.6
        for <patches@lists.linux.dev>; Mon, 28 Mar 2022 07:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFpy1BaNDElGPENkoNelRc37WwyIAqLuxylMjKkOE6M=;
        b=cn5P4zc4OEungJCVM5SAAZwq0z1TyQARhWp2SDJG1+vy2DWU3ZjpkECMZfSihjZlWr
         AbhnJ5g9Vv4SJxMaHeraIvcD17DSP4FuZY3u4fSZZLG074Jd1jeSjy6TAmbcTzRp/h6f
         psfPgYw1vx8MLafej8Vr/zY92VuOEB1ESD7yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFpy1BaNDElGPENkoNelRc37WwyIAqLuxylMjKkOE6M=;
        b=RISmPeZWihgLfkXseIlP9vcK1yyVzuRmS5kbY/2maoSs8Beh5yf6Ck8YgmOOBJBnGe
         17wCSIX7MNYNust93i/aeCz/WZvlbXo7PL6cDF/JkxabV7HpVhxK9sizSI8P29TZVGTi
         I88tnlNbrpTOLGD4SL8QqXUUEk0650BxJMnZ1n06k8C+m0m2sr4xTppxWvFSa/yvG2ag
         fwqSrEu/BnGZz1sWVP0UhiBcmEWMigu9tm/fMwFMeDT4dfX1M3kdylZ6NOztuwJ6+0uO
         nlRk56HfVUWHKHMl4llLbhPULPwPTG0SofpTfYdM9/5f/UtS60/PaB/51otNDPWdb5Fe
         N2mw==
X-Gm-Message-State: AOAM530ncps4OKrx/3JO3amx2JXqniPyEHmwImLnzgq1E7um6x5ArKi/
	LkZOHGQXD35Tb0Q0gl4O4BikkA==
X-Google-Smtp-Source: ABdhPJzKSSaNy6x7oybqj+hN6uR14OHVIoRJjHmrbVsuIunJeuBXFHxJPNjxHK1oe5ti8REaSKJtSw==
X-Received: by 2002:a5d:68ce:0:b0:204:1a8c:749a with SMTP id p14-20020a5d68ce000000b002041a8c749amr23875772wrw.392.1648477601398;
        Mon, 28 Mar 2022 07:26:41 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id i31-20020adf90a2000000b00205ad559c87sm7541587wri.21.2022.03.28.07.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 07:26:40 -0700 (PDT)
Date: Mon, 28 Mar 2022 16:26:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alain Volmat <alain.volmat@foss.st.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
	patches@lists.linux.dev, Aditya Srivastava <yashsri421@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH] drm: sti: don't use kernel-doc markers
Message-ID: <YkHFn0UG9FjGeowF@phenom.ffwll.local>
References: <20220326235132.25192-1-rdunlap@infradead.org>
 <20220328102116.GA2406908@gnbcxd0016.gnb.st.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328102116.GA2406908@gnbcxd0016.gnb.st.com>
X-Operating-System: Linux phenom 5.10.0-8-amd64 

On Mon, Mar 28, 2022 at 12:21:16PM +0200, Alain Volmat wrote:
> Hi Randy,
> 
> thanks for the patch.
> 
> Acked-by: Alain Volmat <alain.volmat@foss.st.com>

Will Philippe apply this one?

Just trying to make sure this wont be lost, just acking isn't enough :-)
-Daniel

> 
> Alain
> 
> On Sat, Mar 26, 2022 at 04:51:32PM -0700, Randy Dunlap wrote:
> > Don't mark static functions as kernel-doc.
> > 
> > Prevents multiple kernel-doc build warnings:
> > 
> > drivers/gpu/drm/sti/sti_hdmi.c:187: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * HDMI interrupt handler threaded
> > drivers/gpu/drm/sti/sti_hdmi.c:219: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * HDMI interrupt handler
> > drivers/gpu/drm/sti/sti_hdmi.c:241: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Set hdmi active area depending on the drm display mode selected
> > drivers/gpu/drm/sti/sti_hdmi.c:262: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Overall hdmi configuration
> > drivers/gpu/drm/sti/sti_hdmi.c:340: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Helper to concatenate infoframe in 32 bits word
> > drivers/gpu/drm/sti/sti_hdmi.c:357: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Helper to write info frame
> > drivers/gpu/drm/sti/sti_hdmi.c:427: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Prepare and configure the AVI infoframe
> > drivers/gpu/drm/sti/sti_hdmi.c:470: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Prepare and configure the AUDIO infoframe
> > drivers/gpu/drm/sti/sti_hdmi.c:555: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
> >  * Software reset of the hdmi subsystem
> > 
> > Fixes: 5402626c83a2 ("drm: sti: add HDMI driver")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Aditya Srivastava <yashsri421@gmail.com>
> > Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> > Cc: Alain Volmat <alain.volmat@foss.st.com>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > ---
> >  drivers/gpu/drm/sti/sti_hdmi.c |   20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > --- linux-next-20220325.orig/drivers/gpu/drm/sti/sti_hdmi.c
> > +++ linux-next-20220325/drivers/gpu/drm/sti/sti_hdmi.c
> > @@ -183,7 +183,7 @@ void hdmi_write(struct sti_hdmi *hdmi, u
> >  	writel(val, hdmi->regs + offset);
> >  }
> >  
> > -/**
> > +/*
> >   * HDMI interrupt handler threaded
> >   *
> >   * @irq: irq number
> > @@ -215,7 +215,7 @@ static irqreturn_t hdmi_irq_thread(int i
> >  	return IRQ_HANDLED;
> >  }
> >  
> > -/**
> > +/*
> >   * HDMI interrupt handler
> >   *
> >   * @irq: irq number
> > @@ -237,7 +237,7 @@ static irqreturn_t hdmi_irq(int irq, voi
> >  	return IRQ_WAKE_THREAD;
> >  }
> >  
> > -/**
> > +/*
> >   * Set hdmi active area depending on the drm display mode selected
> >   *
> >   * @hdmi: pointer on the hdmi internal structure
> > @@ -258,7 +258,7 @@ static void hdmi_active_area(struct sti_
> >  	hdmi_write(hdmi, ymax, HDMI_ACTIVE_VID_YMAX);
> >  }
> >  
> > -/**
> > +/*
> >   * Overall hdmi configuration
> >   *
> >   * @hdmi: pointer on the hdmi internal structure
> > @@ -336,7 +336,7 @@ static void hdmi_infoframe_reset(struct
> >  		hdmi_write(hdmi, 0x0, pack_offset + i);
> >  }
> >  
> > -/**
> > +/*
> >   * Helper to concatenate infoframe in 32 bits word
> >   *
> >   * @ptr: pointer on the hdmi internal structure
> > @@ -353,7 +353,7 @@ static inline unsigned int hdmi_infofram
> >  	return value;
> >  }
> >  
> > -/**
> > +/*
> >   * Helper to write info frame
> >   *
> >   * @hdmi: pointer on the hdmi internal structure
> > @@ -423,7 +423,7 @@ static void hdmi_infoframe_write_infopac
> >  	hdmi_write(hdmi, val, HDMI_SW_DI_CFG);
> >  }
> >  
> > -/**
> > +/*
> >   * Prepare and configure the AVI infoframe
> >   *
> >   * AVI infoframe are transmitted at least once per two video field and
> > @@ -466,7 +466,7 @@ static int hdmi_avi_infoframe_config(str
> >  	return 0;
> >  }
> >  
> > -/**
> > +/*
> >   * Prepare and configure the AUDIO infoframe
> >   *
> >   * AUDIO infoframe are transmitted once per frame and
> > @@ -551,7 +551,7 @@ static int hdmi_vendor_infoframe_config(
> >  
> >  #define HDMI_TIMEOUT_SWRESET  100   /*milliseconds */
> >  
> > -/**
> > +/*
> >   * Software reset of the hdmi subsystem
> >   *
> >   * @hdmi: pointer on the hdmi internal structure
> > @@ -785,7 +785,7 @@ static void sti_hdmi_disable(struct drm_
> >  	cec_notifier_set_phys_addr(hdmi->notifier, CEC_PHYS_ADDR_INVALID);
> >  }
> >  
> > -/**
> > +/*
> >   * sti_hdmi_audio_get_non_coherent_n() - get N parameter for non-coherent
> >   * clocks. None-coherent clocks means that audio and TMDS clocks have not the
> >   * same source (drifts between clocks). In this case assumption is that CTS is

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
