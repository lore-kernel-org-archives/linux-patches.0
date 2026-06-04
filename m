Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879F3F7894
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 09:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780563974; cv=none; b=nSqkh3OWjAP09GHH/R2TLy3KuiDJxjatK4wwoIWu6s2aRWd+A4IedtWnjgUqZwXONDFk4gnFDdlLrpzqitbBGoHDqRk9R+lWkJBZb2oz1950LaXsL5br18+0f1jaKyUkRrnjPk6Vu9uYRUqqzdJ3hKaKqNgebh32LwQad4NDKnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780563974; c=relaxed/simple;
	bh=6nC4qMmpp4fUyVsAFDYujq7+sxNujf5CGEPAWJHIlFA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKEniNDDVFmEv4xpjSUt2r7Z3MwPXdFpcPbXmg935mGsTjApdJcKqYt3/0nuyG3SK5VuOq5DQO8AXCpnwQOm+o2kpUJSIJjKeMvKI6EYI5DsGd/oIoFp/Oppp29yMIVUTQdn35pwho1Mw9+J1P22Oa5U8ty0+HfT27CASrM3+3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+o2WL53; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+o2WL53"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490ac357c55so5396275e9.1
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 02:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780563972; x=1781168772; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdFuwsES54dFvGT6zPCTaZ+yF4K8AlHGY+rBuqBIdh4=;
        b=h+o2WL53QEmXLZj757jVUYUdmZHjyQZhdVdQ6v9e7qhFibHZ8tjVGpZUv8DWb7Fsa0
         o9tJibN+6QzgxJYLktICVPT+OrXdjfWrfA3dlw9UsQ7uErDKaDtzM2HH6EPWwyOUoWzC
         eVKU+Z7YswOw/jjXKR7agZl/3OvxK7KovCU6dzkRlhYgaL+xwpHKnwVOzhM5b9sbum3x
         H6avaqrpK//X4udctyR8/FWfhjmBsrQma0lL7kRXwdPadf0uo7uCqI9OwIeAC98JIYRT
         Unw7lplifd4u+xfp3VrxHh9AwgC70yCi7+oe4/g/OB0I56zIOFoAztHTwnU6R3pmpU6D
         g0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780563972; x=1781168772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EdFuwsES54dFvGT6zPCTaZ+yF4K8AlHGY+rBuqBIdh4=;
        b=TvDjzSxYlvyt7k9pd7S3OqY4KHIMBqCj6FpkjJEx3dl07zp0w6b3nO6USs1kew6XXB
         RtFmSX5pcs38lcxW0LLMzx0KS9IBjrhfJubuwbIdXDmix7HXKGuHNoVvraX5LbymiGtY
         VPZQ8Cm4PmTZthU3yQdyo4nnSjteheCOg1dgiZeKyhDEPfamvz/oXVLcakbpG93GAB1D
         i5psLzykX6NzI8ErbmnGjp9uXJYLdr6mERpujNYvp8j5Gj6zImUC6zWeinq1MS7de9FW
         F/Xog0wtB8cRs2Uo59hmmL6YJa2k1NKIIx5uPEAcHzWw9Bh30CYCSCmvbfJU4OhzAzyp
         jIcw==
X-Forwarded-Encrypted: i=1; AFNElJ/usZ37aeFhdjWzdugBGzk7qjWt9kklSXR8PnBdknk6oArOD986jnLi+2lYZuIlgPXB0v2BADj6@lists.linux.dev
X-Gm-Message-State: AOJu0YxTQ/jwMOhRNA46m0/IL8ew0nL4W+sHW0oHLGIzEO7s2wWWH+am
	bdKvKRTKGe6wysVwx1+mzIGyPlHFWZxU/cW4LSJZMER0ZvNwI0tcczQA
X-Gm-Gg: Acq92OFr/rEprRV806nsh4uT7o6DkvVeMXvXkQUYFA+8tag42PIXSOi9Xrq6U6Pvqg2
	FA5k8a/LW3Zf5Vn0eINLxkeahGi57JBkcAjpm/YFzaJ3o+VZ83x+3kaLDxgkkrd9hfF5ZOvseaw
	X+8YHuoyxMPSjQUfp0ynmI5nwFbwGT934GZBNvFqRjwQPEpn9uG/W/Uxlp0y8gx4TQs2g5rj+G/
	IuIf1slyIq5LtPmV0/yI99B9gXez4vt5SwlLGgBrqD+3JhDYqdSemz4kvmveqR29OlICTaa8rau
	qgsITv1QaecnxrqWUmgz0j5L/ASCjGio8S+iAhPfPLOJ6D6Mg14PCVGoxcGuiCIguBlft5Ioe6s
	C8U/VIPnbvTIrWGc8+FX1LSNoHZ4aGhpv/jWt83W5dEEiaIiL2xHE1H9ON7gdstCdcZGz+o3Fe+
	3d9XJlGa+cIajBc3IRW/j3mhWCKcUvDy7ius77UuBwrJPe912DgXl7cta1MxfnqzJ+zQGd+S1rN
	0I6M1P33A==
X-Received: by 2002:a05:600c:8184:b0:490:5cd8:d213 with SMTP id 5b1f17b1804b1-490b5eb44f8mr113527135e9.15.1780563971711;
        Thu, 04 Jun 2026 02:06:11 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b7e6c774sm70203515e9.1.2026.06.04.02.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 02:06:11 -0700 (PDT)
Date: Thu, 4 Jun 2026 10:06:09 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Askar Safin <safinaskar@gmail.com>
Cc: metze@samba.org, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604100609.6b37f500@pumpkin>
In-Reply-To: <20260603211736.755139-1-safinaskar@gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  4 Jun 2026 00:17:36 +0300
Askar Safin <safinaskar@gmail.com> wrote:

> Stefan Metzmacher <metze@samba.org>:
> > Why is 'int fd' changed to 'unsigned long fd'?  
> 
> Because preadv2 and pwritev2 take "unsigned long". I want vmsplice
> to be as similar as possible to preadv2 and pwritev2.

Something needs to ensure that the high 32bits of the fd get masked off
on 64bit systems.
They can be non-zero in the register that comes from userspace.

-- David

> 
> > Should that be its own commit if the change is desired?  
> 
> Yes, possibly. But this patchset already got to next.
> 

