Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE12166F06
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 16:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727453975; cv=none; b=Z18efsiA7jArWb4PLEE8cWT5Mba5/NX+eNHT0QCeQF+rSbkcgcq2MjcuBqheGkdAfgDFYRNhYN8JMc6mcUFq6HSADAZ0L26rpxuiT09PqNagkFTcrQ6yy4PjElXTDSjSn5ZY0+E4kBNXpL6MxdOkmH5hubJtlioTvCmZeE4sAw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727453975; c=relaxed/simple;
	bh=pAzoEG02XkyNylD/xCeTTggYxDtr6Z4lPRJGRWG8dn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6uD9NbH70lxmzflYYXmgnxxOxDyGd+AtUyyYPFgtscF3FIklke/h+p1XF6fx6rdacsGoX7lu/BxwQMpybRHnASvSJcV/MvETX1AlrCZ0bpAumkdHgTJ1yFNyhTk0RrwLOyY7Y0QXTtsEWcKW4uYNjvHV+3PYCof8Eh1DHWRn4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQyE8KeW; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQyE8KeW"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20afdad26f5so30025265ad.1
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 09:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727453973; x=1728058773; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZ4WJkOwGqqQgF3m1LaEUK/eck934Y5jldk45Shajf8=;
        b=XQyE8KeWdrza916kW+/q0TU00Y4KCxQmsm7sDhgHmPBej2aW7Arh60MwS71kTrDMef
         pYgIiPMWb6xgHEXCeOT3c2hE6u3XT1JKYrhfxXBiBDDpapod/pQEKvOcVOndJnFmZ9Bm
         Z+RBit2iTCIp54Pf7M8Nnzybj10MdhsqyLVbWOr/Qh4Nvy3zcuh30UoKwk6Wh8zex6kM
         ZVm8rhNx35487t1s/63LBqnfyPo4BU9LuBrD/1Xx8anL2GjPHDMgyR4W2w8F4VSMYLvv
         vZBJetdTFUWt9YdEXoPzX/AOJqdTx1TPIwZJRGtqnCGX0A6V3v8jQHTeNzIQ3X7STQSh
         EL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727453973; x=1728058773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZ4WJkOwGqqQgF3m1LaEUK/eck934Y5jldk45Shajf8=;
        b=D4u0704HFUDUx9bn4y5ISOk5Fju2FCZxr9q+tNp7r0PETd7eBjL4vXRQWSe6PXC/S1
         /6X2eZuFMWR2gaoOCY/ecGmr2fv2kVllromT6rWYlldPfFcC7O0gdChVLdVEryG8l0Rp
         MgZBuW+Pyaz+ETmhMbe2j7+xVoIuB6OD38kgwyHsDVxKm8gHE0gbix8PA0Kg1yrmqCrW
         GOyfWYuJv4sg7CVGg1LM7gXFuBKKaB8CYxup3d4XTk9/Yquu+1DY1oQ1wtLTyhUWLEeh
         eetmhLZpHpc/bfXeapXlPVgNq3qwJv6wlUU7t97K9CsN6tVkKSRJ09DZQ4PYymAySxkw
         pwQw==
X-Forwarded-Encrypted: i=1; AJvYcCXtgSzfloKIVBencKb+Hul2BDHQ6Tf91vS2MQK1flUXlAq9Pdula1v832437VBgwjMnF3LJNH72@lists.linux.dev
X-Gm-Message-State: AOJu0Ywbpb7QuhWFtsJiIaR3tynoBAW+W5xHUchUQO6jo/6zF0QPHpgb
	nYXhQ+YYxibIP9B0CTBQzc9OS4xo5a3VzCuMLCEIN5xOkH4quGZk
X-Google-Smtp-Source: AGHT+IGgguNQ+PmgQVEgHdCC2FdrNHTusB4SH0YUBq4fzrALOkcJ5A6OlLQACGre8/CZZhcMd7mBvA==
X-Received: by 2002:a17:902:d506:b0:205:7863:2dec with SMTP id d9443c01a7336-20b3729c7b2mr58096525ad.27.1727453972895;
        Fri, 27 Sep 2024 09:19:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e35ce7sm15258055ad.209.2024.09.27.09.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 09:19:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 27 Sep 2024 09:19:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev, kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Daniel Latypov <dlatypov@google.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Maxime Ripard <maxime@cerno.tech>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH v8 8/8] clk: Add KUnit tests for clks registered with
 struct clk_parent_data
Message-ID: <dcd8894f-1eb6-4b5c-9e6f-f6e584c601d2@roeck-us.net>
References: <20240718210513.3801024-1-sboyd@kernel.org>
 <20240718210513.3801024-9-sboyd@kernel.org>
 <6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net>
 <a339ec8c-38f6-425a-94d1-ad69b5ddbd88@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a339ec8c-38f6-425a-94d1-ad69b5ddbd88@roeck-us.net>

Copying devicetree maintainers.

On Thu, Sep 26, 2024 at 09:39:38PM -0700, Guenter Roeck wrote:
> On Thu, Sep 26, 2024 at 09:14:11PM -0700, Guenter Roeck wrote:
> > Hi Stephen,
> > 
> > On Thu, Jul 18, 2024 at 02:05:07PM -0700, Stephen Boyd wrote:
> > > Test that clks registered with 'struct clk_parent_data' work as
> > > intended and can find their parents.
> > > 
> > 
> > When testing this on arm64, I see the error below. The error is only
> > seen if I boot through efi, i.e., with "-bios QEMU_EFI-aarch64.fd"
> > qemu parameter.
> > 
> > Any idea what might cause the problem ?
> > 
> I noticed that the new overlay tests fail as well, also with "path '/' not
> found".
> 
> [Maybe] answering my own question: I think the problem may be that there
> is no devicetree file and thus no devicetree root when booting through
> efi (in other words, of_root is NULL). Would it make sense to skip the
> tests in that case ?
> 

The problem is that of_root is not initialized in arm64 boots if ACPI
is enabled.

From arch/arm64/kernel/setup.c:setup_arch():

	if (acpi_disabled)
		unflatten_device_tree();		// initializes of_root

ACPI is enabled if the system boots from EFI. This also affects
CONFIG_OF_KUNIT_TEST, which explicitly checks if of_root exists and
fails the test if it doesn't. 

I think those tests need to add a check for this condition, or affected
machines won't be able to run those unit tests. The obvious solution would
be to check if of_root is set, but then the associated test case in
CONFIG_OF_KUNIT_TEST would not make sense.

Any suggestions ?

Thanks,
Guenter
