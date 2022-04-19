Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110981374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 18:15:16 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id i63so753732pge.11
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 11:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zpBv9Q1tNkPDBxpwPbLdjbsmA3r5cT/nw1H2p8//7VQ=;
        b=nZvZCFCBv0zvPnol4PONdYJwznuBCN/AxhcMZT3PpAg7N/VnQFuPRmc59dVJmZhUZX
         ECMv/hjCGO+Yo9hPm0IPGeKJ0B6ktiAJyHTxXvVuF2aVbAVF8CuAQHgIJP1LNJMXn9tW
         pewlp4W+kHkNI1zg56QFlr1V7Y7IC03EodUwq8bmU0cnToRJRtLyABVPCFbP3syCDchx
         LDjvNXMhS7Xh2ngpvwPQ2GqpF+opYdpOjCsLq6UgJBnYaZhcq7SIJ1v5a7aSd1NogVh6
         VSjMR54pFEhQe1/PiG/gXQU8g8fXg+WNaoH+BrDQzIaYm/mRG5gcSrOvz7wSwTEhHzhn
         RLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zpBv9Q1tNkPDBxpwPbLdjbsmA3r5cT/nw1H2p8//7VQ=;
        b=ssf5JLshMpYrGOuBLCfIb/+ku1V0z4TwCqoyMAQFX1svGAav/3cXLyOC3W0LP0rXnH
         2cOrjT2YlCNB6FkTUcgubnfFGNh1SKun1vnHvHi69CBM+5JF8cqYURP1ZvMKinVoGzU2
         cCNUFaOiwo8Zv8UKuN2MDbATlOz/GZWKbX58OPu2+PKYI4n1f2hbEHnOgY+3Fgi4WFCO
         DxBRmpmQs5P+ZOxlYamE9LDijklrj5Dw5smuitf3C51FAar+/m0/1qEYxaXv/K5/Jt+C
         94dosFRGrQGc6npLFdXBhQxJxxxUdtrXdhxck6j8bazFdjdDsGFShDVBK1z4mKB3tPTW
         otvA==
X-Gm-Message-State: AOAM530N0XoojAoig6sKQoLU2ADBJJh8nAnP/Kdsm4QpGIXshwi9qTmq
	ZFZhPzHWFH42HPjk2OKVZC/nh5hlvjhOeZ3dd9Gawg==
X-Google-Smtp-Source: ABdhPJw4oSURnCuFS/ZVGc9BlKI9iSwFoHzN3zK1GLk085q5yQt4OdaNxeK86wgd3BiiLXrJ0hkQRIeqzlpHZRTTfTo=
X-Received: by 2002:a65:6e0e:0:b0:399:26d7:a224 with SMTP id
 bd14-20020a656e0e000000b0039926d7a224mr15704175pgb.437.1650392116287; Tue, 19
 Apr 2022 11:15:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220407191347.9681-1-jithu.joseph@intel.com> <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-10-tony.luck@intel.com> <Yl7vdpJgKYRL1jeW@kroah.com>
 <Yl7y1YDaNVxyDnKI@agluck-desk3.sc.intel.com> <Yl74MYW1+NgH4tOX@kroah.com>
In-Reply-To: <Yl74MYW1+NgH4tOX@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Apr 2022 11:15:05 -0700
Message-ID: <CAPcyv4haH561eC_+oPj8PMdf2510BDq7==orHNLoHPm0d16k2w@mail.gmail.com>
Subject: Re: [PATCH v3 09/11] platform/x86/intel/ifs: Add IFS sysfs interface
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, 
	Steven Rostedt <rostedt@goodmis.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
	patches@lists.linux.dev, Ravi V Shankar <ravi.v.shankar@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 11:01 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 19, 2022 at 10:35:17AM -0700, Luck, Tony wrote:
> > On Tue, Apr 19, 2022 at 07:20:54PM +0200, Greg KH wrote:
> > > > +/*
> > > > + * Note there is no need for a ->remove() call back. There isn't an
> > > > + * "unload" operation to remove the scan binary from the BIOS reserved
> > > > + * area. Also ".dev_groups" removal order will guarantee that any in
> > > > + * flight tests have completed.
> > > > + */
> > >
> > > So you are ok with the warning the kernel gives you when you unload the
> > > driver?  That feels wrong :(
> >
> > What warning?
> >
> > # dmesg | tail -5
> > [   38.084165] virbr0: port 1(virbr0-nic) entered listening state
> > [   38.149621] virbr0: port 1(virbr0-nic) entered disabled state
> > [   38.582054] broken atomic modeset userspace detected, disabling atomic
> > [   43.703321] igc 0000:01:00.0 enp1s0: NIC Link is Up 2500 Mbps Full Duplex, Flow Control: RX
> > [   43.703470] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
> > # modprobe intel_ifs
> > # ls /sys/devices/platform/intel_ifs.0/
> > details  driver_override  modalias  reload    status     uevent
> > driver   image_version    power     run_test  subsystem
> > # rmmod intel_ifs
> > # dmesg | tail -5
> > [   38.084165] virbr0: port 1(virbr0-nic) entered listening state
> > [   38.149621] virbr0: port 1(virbr0-nic) entered disabled state
> > [   38.582054] broken atomic modeset userspace detected, disabling atomic
> > [   43.703321] igc 0000:01:00.0 enp1s0: NIC Link is Up 2500 Mbps Full Duplex, Flow Control: RX
> > [   43.703470] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
> > #
>
> If there's no warning when the device goes away, why the crazy comment
> trying to justify the lack of a remove callback?

The comment clarifies the nuance that driver.dev_groups coordinates
flushing access sysfs ops users before ->remove() is called. It can
certainly be dropped.
