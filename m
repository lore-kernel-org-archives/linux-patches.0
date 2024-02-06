Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318861CD1E
	for <patches@lists.linux.dev>; Tue,  6 Feb 2024 23:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707261582; cv=none; b=mMDC0Aq5dNYp5tOnzGkzX26uZ6vI+w5OVecbUdZFBVAZYAVh9pZwpClA+aCa8dBT7GySAJi1wVgWTLTX1DyNj1rB9zDipVD3fBloTxzVorEFmflhJo77l7WYR2K4VPAsaStYvo5CMFzTKIDZ7EmMwvIogNm4GqocJsRj//p+eCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707261582; c=relaxed/simple;
	bh=mSp1+JYDb7NdH17RZ+qMLPdVmrJ42e3fPvlEjXiGpZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ou+DBM4KhntyAnBArlOydmJ4tSzTLstlIrX+j64SZvK4ORCcHG9tw6QGqtnsVgA7qW6bcjw9NUZD9WZ/UF3gKIKevoXZ6QFjucnrGYyQ7wWWRPReL44sudFHaRV84W/nn/+qeDk85yFogyxmXovsaCNpPDK6GJ51ZFMdtnhBEJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XPNLdvn5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XPNLdvn5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707261579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9lQWrs1kWLDUb9rNRJMZocZRASv82NRrn4c/SQZik0=;
	b=XPNLdvn5V6bTVv/AXIx/40HLOU3SbTPJ8u609S6aAjQFMJ4I+PVOmI75YZRMH/X0Ne5/xU
	lkEe57jZ+0cWUv9vlW/EhTMuGTurTeZpmFPwHXFsuQMzDSg6CTxnVPBNXO3C1wbGp0sLVg
	kaeK+n2JdexH1DNU/4eXgiWGw/St1PE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-YDck_N1wP6yQZyLFaklzWQ-1; Tue, 06 Feb 2024 18:19:37 -0500
X-MC-Unique: YDck_N1wP6yQZyLFaklzWQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7bfd755ae39so4013039f.1
        for <patches@lists.linux.dev>; Tue, 06 Feb 2024 15:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707261577; x=1707866377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9lQWrs1kWLDUb9rNRJMZocZRASv82NRrn4c/SQZik0=;
        b=n3xmJfLlq1jhFNTx9hRAtbuy1x4ZutvsbN8jKr8psHDVWvRi8yZQ1brVemzDVpnLLH
         zEzqERTZAXq7TTHXSiL4v6oy6BDiuwJ9EhY3p31LB7RE83Jopz14+9gvkSdMoXgRA7N9
         wj7nxYdtmYTwE5zaOgm0CPuIUkcEpiRPfBEvFgYIwjKygI9+Wqb7v449tb44itmAfwq+
         /q6cra4V4LeIRctD3Vy/zRzESzG5joyhXl5S6k1HJj0GUaPPRexxCkGvs7k9YkRqsC5e
         tKDNCIFRH1VHa5ysMw0ocVuZby7KXiKfh/ehBA0xoyTRGuVBrpO/+iLPpTfLsKrlDP1A
         WeYw==
X-Forwarded-Encrypted: i=1; AJvYcCUawuQhxttpI50PSc815c5a9ZPgsrj4g/lDzMj2AZhOEIJycCJLD8u0cwnQ/62SE958KzOGRQJjcEokfVmOt6/435tpLTaAAw==
X-Gm-Message-State: AOJu0YwmZhN3Gk2n1KhdGbMk64so4XovqgIj3Lv4sAAN8vhaESE/sFLD
	BZQxokr0HOc5DLS/GvKi089ggpOhJ53zC4I1nvKYp2D3n1rz0WLM7j41WNaqJ1DZ0L+HKAE3CNG
	u52zUpdpEFng6bBM/ouzjrEmKxf7jN6xiQQKlkFkkNW6ifUFSs5unKKk=
X-Received: by 2002:a6b:d90c:0:b0:7c3:eda4:ea11 with SMTP id r12-20020a6bd90c000000b007c3eda4ea11mr3842362ioc.16.1707261577001;
        Tue, 06 Feb 2024 15:19:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXK/MFQbXmN+Uf8XVzJe4tvZZl/EZvTIdNvNxAoxSmujnNBpZGeCU0PDhYylr2/KYfzAQzoA==
X-Received: by 2002:a6b:d90c:0:b0:7c3:eda4:ea11 with SMTP id r12-20020a6bd90c000000b007c3eda4ea11mr3842343ioc.16.1707261576688;
        Tue, 06 Feb 2024 15:19:36 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVxQNy7WM81D1KyTsj5b6dysZmQ7irl+mHz/wXIJCehZJzT0rzy+38bzv2vK3ShDIBzaGnFianyWRV+Hdsia6yEsRrKo2XUlAzSu2R7lPibY72NFRgkL6J1H4gguFl0tSVtOPFdoSDj6gOxqFGFXrShMogteJqdI2GP0UhDD2LGRyM9B5Wc+7HDrTXKN44RMTBUNTuq7aMfFxLTXCzPdV4FZ1UgM7UOCYN7m5m0EnQ23l/aEj0OzE8fhqLrcF+Mya/rFzyaRajzcLY69xrxYnzGhpt+N80pc4GtLcrRAz51m/QHUQtyk020l/znzMSPys9qDlGZ3Q==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id s24-20020a6bdc18000000b007c3f616986csm369762ioc.40.2024.02.06.15.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 15:19:36 -0800 (PST)
Date: Tue, 6 Feb 2024 16:19:34 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt
 types use same signature
Message-ID: <20240206161934.684237d3.alex.williamson@redhat.com>
In-Reply-To: <ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
	<20240205153542.0883e2ff.alex.williamson@redhat.com>
	<5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
	<20240206150341.798bb9fe.alex.williamson@redhat.com>
	<ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Feb 2024 14:22:04 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 2/6/2024 2:03 PM, Alex Williamson wrote:
> > On Tue, 6 Feb 2024 13:46:37 -0800
> > Reinette Chatre <reinette.chatre@intel.com> wrote:
> >   
> >> Hi Alex,
> >>
> >> On 2/5/2024 2:35 PM, Alex Williamson wrote:  
> >>> On Thu,  1 Feb 2024 20:57:09 -0800
> >>> Reinette Chatre <reinette.chatre@intel.com> wrote:    
> >>
> >> ..
> >>  
> >>>> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
> >>>>  		if (is_intx(vdev))
> >>>>  			return vfio_irq_set_block(vdev, start, count, fds, index);
> >>>>  
> >>>> -		ret = vfio_intx_enable(vdev);
> >>>> +		ret = vfio_intx_enable(vdev, start, count, index);    
> >>>
> >>> Please trace what happens when a user calls SET_IRQS to setup a trigger
> >>> eventfd with start = 0, count = 1, followed by any other combination of
> >>> start and count values once is_intx() is true.  vfio_intx_enable()
> >>> cannot be the only place we bounds check the user, all of the INTx
> >>> callbacks should be an error or nop if vector != 0.  Thanks,
> >>>     
> >>
> >> Thank you very much for catching this. I plan to add the vector
> >> check to the device_name() and request_interrupt() callbacks. I do
> >> not think it is necessary to add the vector check to disable() since
> >> it does not operate on a range and from what I can tell it depends on
> >> a successful enable() that already contains the vector check. Similar,
> >> free_interrupt() requires a successful request_interrupt() (that will
> >> have vector check in next version).
> >> send_eventfd() requires a valid interrupt context that is only
> >> possible if enable() or request_interrupt() succeeded.  
> > 
> > Sounds reasonable.
> >   
> >> If user space creates an eventfd with start = 0 and count = 1
> >> and then attempts to trigger the eventfd using another combination then
> >> the changes in this series will result in a nop while the current
> >> implementation will result in -EINVAL. Is this acceptable?  
> > 
> > I think by nop, you mean the ioctl returns success.  Was the call a
> > success?  Thanks,  
> 
> Yes, I mean the ioctl returns success without taking any
> action (nop).
> 
> It is not obvious to me how to interpret "success" because from what I
> understand current INTx and MSI/MSI-x are behaving differently when
> considering this flow. If I understand correctly, INTx will return
> an error if user space attempts to trigger an eventfd that has not
> been set up while MSI and MSI-x will return 0.
> 
> I can restore existing INTx behavior by adding more logic and a return
> code to the send_eventfd() callback so that the different interrupt types
> can maintain their existing behavior.

Ah yes, I see the dilemma now.  INTx always checked start/count were
valid but MSI/X plowed through regardless, and with this series we've
standardized the loop around the MSI/X flow.

Tricky, but probably doesn't really matter.  Unless we break someone.

I can ignore that INTx can be masked and signaling a masked vector
doesn't do anything, but signaling an unconfigured vector feels like an
error condition and trying to create verbiage in the uAPI header to
weasel out of that error and unconditionally return success makes me
cringe.

What if we did this:

        uint8_t *bools = data;
	...
        for (i = start; i < start + count; i++) {
                if ((flags & VFIO_IRQ_SET_DATA_NONE) ||
                    ((flags & VFIO_IRQ_SET_DATA_BOOL) && bools[i - start])) {
                        ctx = vfio_irq_ctx_get(vdev, i);
                        if (!ctx || !ctx->trigger)
                                return -EINVAL;
                        intr_ops[index].send_eventfd(vdev, ctx);
                }
        }

And we note the behavior change for MSI/X in the commit log and if
someone shouts that we broke them, we can make that an -errno or
continue based on is_intx().  Sound ok?  Thanks,

Alex

