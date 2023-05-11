Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE650363
	for <patches@lists.linux.dev>; Thu, 11 May 2023 00:25:06 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-64115eef620so54107900b3a.1
        for <patches@lists.linux.dev>; Wed, 10 May 2023 17:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683764706; x=1686356706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NiIAKS0VeNTa0Mpe7u/4NIaUrufb6wO/HHXswmRGRIQ=;
        b=D6ZVr8L5gm2c6Qrq+kA00eiTsg5rBpmsfXi9fenQ0gNlZZ8pjMcDY5F0LcGwVe5m1c
         ZlNY1pTqDOh/Sdf3JJHuwU2SqXmTUiXD4tznuUwPnzXOq+wlmAJTMX/s+ETnP39OKyPA
         MW1R4sgwYXh4euC0Qy4GDOcS2yIPoXJDSIxSqJh0YglohoKveKeZLF/qYDesMD/cJ/WO
         iEQU1gfl3UM8uA6u0Wv2sawFK/cw0P5kunYnDN1IuuwJZPUQv2SSmModvt329ibayPth
         pcLChR3avq77eEklPDgP7Sk7KLIodNJWal96Kf6qohTgQZ28DMvwL3+NypmWANhL4j3D
         Q+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683764706; x=1686356706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiIAKS0VeNTa0Mpe7u/4NIaUrufb6wO/HHXswmRGRIQ=;
        b=H7+MkDYJEETnGumk2bK/W9WoQJcl/NvOEKblZtZPMlAyw02neLQTDieQQzM0ZtRErb
         4kgUYZOVdCPYJIIGWtsMp2nUEyfL7nfQmYH4WJYN3lgBQ6lP0Bb4bLVql1iEMb/32sbo
         ZixWJvkxCBG0eRNe24bvu5Tg1n3Y1aP7N/ANiJCN94xNb6bNNBSvTK9ulEzydxoCnc52
         we3Koac0ha3Xvm1T/duOZE8hYfvwZxEH+fCg/XhZs/2PGYqO326EN4/WDwMdhKfB9BXV
         IxwMpxe8YaGCEEFZurD6KV+GtTRtCWPw2QZM0R0wXE009AKzjcy7iOT0jko17FlAzBom
         xMIQ==
X-Gm-Message-State: AC+VfDwt9chfYslEtzE65s6XjnAxRK6hy1HwXSUXhdraeP+jGBpbZjsC
	E70V4UyDNBsNrgm1Z1OiY1w=
X-Google-Smtp-Source: ACHHUZ4xdFMjnxzjvjJ1Fd7ldfzzLJIyyYXtJr+gghVAO38rUN0DBRdC8d6E6cSW+9qzfZpLdHvkeA==
X-Received: by 2002:a17:902:ea0e:b0:1ac:7d8a:35a with SMTP id s14-20020a170902ea0e00b001ac7d8a035amr14529498plg.12.1683764705845;
        Wed, 10 May 2023 17:25:05 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:84a:ed9c:4024:c347])
        by smtp.gmail.com with ESMTPSA id jn22-20020a170903051600b001a80ad9c599sm4386641plb.294.2023.05.10.17.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 17:25:05 -0700 (PDT)
Date: Wed, 10 May 2023 17:25:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: google: Don't use devm for hid_hw_stop()
Message-ID: <ZFw13uv7/q5jsLWE@google.com>
References: <20230505232417.1377393-1-swboyd@chromium.org>
 <ZFWZ785FRHDii/+5@google.com>
 <CAE-0n521MhmdWjEb0-xwnPLQz07bMCGyXokZ3L87azYcw6_C_Q@mail.gmail.com>
 <ZFv9aKZlZbfK1cVr@google.com>
 <CAE-0n52bv1-VaQikOV6hdFmuRyPBX6YV7MT=2+xrpReJecrgbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n52bv1-VaQikOV6hdFmuRyPBX6YV7MT=2+xrpReJecrgbQ@mail.gmail.com>

On Wed, May 10, 2023 at 01:50:01PM -0700, Stephen Boyd wrote:
> Quoting Dmitry Torokhov (2023-05-10 13:24:08)
> > On Wed, May 10, 2023 at 11:51:31AM -0700, Stephen Boyd wrote:
> > > Quoting Dmitry Torokhov (2023-05-05 17:06:07)
> > > > On Fri, May 05, 2023 at 04:24:16PM -0700, Stephen Boyd wrote:
> > > > >
> > > > ...
> > > > > Unfortunately, the hid google hammer driver hand rolls a devm function
> > > > > to call hid_hw_stop() when the driver is unbound and implements an
> > > > > hid_driver::remove() function. The driver core doesn't call the devm
> > > > > release functions until _after_ the bus unbinds the driver, so the order
> > > > > of operations is like this:
> > > >
> > > > Excellent analysis, but the problem is not limited to the hammer driver
> > > > (potentially) and shalt be dealt with appropriately, at the HID bus
> > > > level.
> > >
> > > Thanks. I thought of the bus level approach as well, but I was trying to
> > > keep the fix isolated to the driver that had the problem. I'd like to
> > > get the fix into the stable kernel, as this fixes a regression
> > > introduced by commit d950db3f80a8 ("HID: google: switch to devm when
> > > registering keyboard backlight LED") in v5.18.
> > >
> > > Is the bus level approach going to be acceptable as a stable backport?
> >
> > Sure, why not given the kind of stuff flowing into stable kernels. At
> > least this would be fixing real issue that can be triggered with a real
> > device.
> 
> Hmm, ok. I was worried it would be too much "new code" vs. fixing
> something.
> 
> > >
> > > This got me thinking that maybe both of these approaches are wrong.
> > > Maybe the call to hid_close_report() should be removed from
> > > hid_device_remove() instead.
> > >
> > > The device is being removed from the bus when hid_device_remove() is
> > > called, but it hasn't been released yet. Other devices like the hidinput
> > > device are referencing the hdev device because they set the hdev as
> > > their parent. Basically, child devices are still bound to some sort of
> > > driver or subsystem when the parent hdev is unbound from its driver,
> > > leading to a state where the child drivers could still access the hdev
> > > while it is being destroyed. If we remove the hid_close_report() call
> > > from this function it will eventually be called by hid_device_release()
> > > when the last reference to the device is dropped, i.e. when the child
> > > devices all get destroyed. In the case of hid-google-hammer, that would
> > > be when hid_hw_stop() is called from the devm release function by driver
> > > core.
> > >
> > > The benefit of this approach is that we don't allocate a devres group
> > > for all the hid devices when only two drivers need it. The possible
> > > downside is that we keep the report around while the device exists but
> > > has no driver bound to it.
> > >
> > > Here's a totally untested patch for that.
> > >
> > > ---8<----
> > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > index 22623eb4f72f..93905e200cae 100644
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -1211,8 +1211,8 @@ int hid_open_report(struct hid_device *device)
> > >               hid_parser_reserved
> > >       };
> > >
> > > -     if (WARN_ON(device->status & HID_STAT_PARSED))
> > > -             return -EBUSY;
> > > +     if (device->status & HID_STAT_PARSED)
> > > +             hid_close_report(device);
> > >
> > >       start = device->dev_rdesc;
> > >       if (WARN_ON(!start))
> > > @@ -2662,7 +2662,6 @@ static void hid_device_remove(struct device *dev)
> > >                       hdrv->remove(hdev);
> > >               else /* default remove */
> > >                       hid_hw_stop(hdev);
> > > -             hid_close_report(hdev);
> > >               hdev->driver = NULL;
> > >       }
> >
> > This will probably work, but it I consider this still being fragile as
> > at some point we might want to add some more unwinding, and we'll run
> > into this issue again. I would feel much safer if the order of release
> > followed (inversely) order of allocations more closely.
> >
> 
> Sorry, I'm not following here. How is it fragile? Are you saying that if
> we want to add devm calls into the bus layer itself the order of release
> won't be inverse of allocation/creation?

What I was trying to say is that later someone else might be tempted to
add more traditional-style resources and non-devm-unwinding for them.
Having an explicit devres groups gives exact point when driver-allocated resources
are released, and makes patch authors take it into consideration.

If everything is devm-controlled then we do not need a separate devres
group.

Thanks.

-- 
Dmitry
