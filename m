Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8953F2DC339
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753894751; cv=none; b=aOnRrs04kvAU2oJ7KDkfL7UTgck8lxSpgg024BEWazpmgjR1byKKEDpVtZoIQ0UJt86d/a7v62HYXNdqn1dZ/d9msMVy2F31XbLaj2O6774OCGi8c+NvKTMOu2cfW1FcNJEZ26vZ5NWX8riK/6HMeW5EV+O5FTjzZtKvPhwlx9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753894751; c=relaxed/simple;
	bh=hsfldSqyZtkGuHCXurYFqBQI2ocyjzcqOynFnNS3wzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G75/jYVsW+f0pR+gPQcS4Gu9sG8Q5C9zUnmGg+MVdjgFd2b9zIraHY64WZ7s7w1N+/MBtNqfKBynMyi/V9q7FonsNIpdmzOAQi+xNsoo9ZfPpwnC+OsjgiWmzAjEZMohuzNeE9g+uDaHbN3+3Zj/FeEIvcRIAxvFXlSGn7oUois=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jeG67mqj; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jeG67mqj"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76bc5e68e26so59949b3a.0
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 09:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753894749; x=1754499549; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EH5JD90Tl1qo9n7g3lAqoBlVtBBqqC64veRIJI/XJDo=;
        b=jeG67mqjnVBgGcEPfJF0P3IzWeyyXa1SMlId3YdBctAOuMmP39Vu/m0NXUlFirqCd6
         PQ+vrf2fhWio9KQfSwGDuA7fX78f+HxfhknurJy66g7kHlneKIpifrqX9036+tzMserX
         8wf3uIZbM8hfPytIR7MAhxl/FiU31Gar4rT3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753894749; x=1754499549;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EH5JD90Tl1qo9n7g3lAqoBlVtBBqqC64veRIJI/XJDo=;
        b=dlOOtNI6tjQUuppNBobqr+oC3Ih3jOGtiUgZIQdkFRhLvwR0RHxHr2Ih4slRocBWGn
         JNI+RX+iE70ritbz21OEphMP60w/dIOALVRLwGDBDUeP4moq0hTj8+huCatzXwXoH9bo
         W7j4cdnocPxotV1tFN/a/th6/dJ+v3LpobSXZLfXf0ljbgRSbbCb5fMzWDBswjprmWJA
         iEFC/IxfTSCofo8AnmB6e6UuSDiEL1b9dCG+2h2YgT86WPmCh1hD0/mip+V7oIoMS8Nk
         NBejJgVGgAe53RAzxMq6oZLB87+durE9ZnHoUDqRVL+1crz7AvBrYJF2G0ZE1cjizKGf
         1VCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc4U9lE+ecx16JOMjiMktbwF8+iAUPqfNrWjGVTA4zn78X5RAZsUWx8IWbRfVBbhfCXbRSe2gc@lists.linux.dev
X-Gm-Message-State: AOJu0YwzKsWiq9wfXZdvoEi9tA4d8S6rY1F198hOmqg2fRICLlwjhvoV
	YuKHabh7iU42B8C1rfL10aOaOcCZrfq865eeoxdatUDHFP0BWVniisk153KhrZeAeQ==
X-Gm-Gg: ASbGncsnqMkAySqsEyxInE6qkbfJ2n5lebkcPWjeh1UqzJdJ58hIXtcuE1dXInfv8w0
	fWrZAC0giJ95fjcPf33KXb/8sh2FBw/W35Pg7cSfmGXAgcQNH8+PZ6aFub39qaUd3xzjdDgQLWM
	mlc7NpZUO49t/2upIXbIYidl3lZ4eut957qEihRVMZssKjv6VFvzj2MvnG4B+b8TgJ4s0Mno3R2
	XsE/ApsjIaqsnpF9h/aTUi5yAMqi1YG+5jTULttk1yd46UN5UfwcBX+ND6ZSAdPMcUZRsgEjRLU
	INcMH3vrWYem65ZaIB0nPFBja5KpPtNuyMN0MhHkYLnp8Bw2pEFYbx0m4MUznziUfvh1YXAh7Z/
	iRuhGjuFq5phSOP7kol41wDLfBPhXq2pMK+rhjKQsGA6Nf1AaMMYuq0uTzK/k
X-Google-Smtp-Source: AGHT+IH/DTINiXieBBCB6fXZn+swcx1FlwUGHkVf5c1lHKa2RVoj/xxnUF7G+HQ0O61TY1fWCWlm0w==
X-Received: by 2002:a05:6a00:2d15:b0:742:3fb4:f992 with SMTP id d2e1a72fcca58-76ab121fc50mr5625376b3a.10.1753894748872;
        Wed, 30 Jul 2025 09:59:08 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e14:7:9b65:b0d6:4d11:d33b])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-76a00902a50sm4485424b3a.79.2025.07.30.09.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 09:59:07 -0700 (PDT)
Date: Wed, 30 Jul 2025 09:59:05 -0700
From: Brian Norris <briannorris@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jian-Hong Pan <jhp@endlessos.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 6.13 445/623] PCI/ASPM: Save parent L1SS config in
 pci_save_aspm_l1ss_state()
Message-ID: <aIpPWZ5eS1gEeAwm@google.com>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250205134513.241757556@linuxfoundation.org>
 <7a41907d-14d0-a1a4-47d6-90ff572d5af9@linux.intel.com>
 <2025020621-remindful-occultist-b433@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025020621-remindful-occultist-b433@gregkh>

Hello,

On Thu, Feb 06, 2025 at 03:29:35PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Feb 06, 2025 at 11:00:18AM +0200, Ilpo Järvinen wrote:
> > On Wed, 5 Feb 2025, Greg Kroah-Hartman wrote:
> > 
> > > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Jian-Hong Pan <jhp@endlessos.org>
> > > 
> > > [ Upstream commit 1db806ec06b7c6e08e8af57088da067963ddf117 ]
> > > 
> > > After 17423360a27a ("PCI/ASPM: Save L1 PM Substates Capability for
> > > suspend/resume"), pci_save_aspm_l1ss_state(dev) saves the L1SS state for
> > > "dev", and pci_restore_aspm_l1ss_state(dev) restores the state for both
> > > "dev" and its parent.
[...]
> > Please withhold this commit from stable until its fix ("PCI/ASPM: Fix L1SS 
> > saving") can be pushed at the same as having this commit alone can causes 
> > PCIe devices to becomes unavailable and hang the system during PM 
> > transitions.
> > 
> > The fix is currently in pci/for-linus as the commit c312f005dedc, but 
> > Bjorn might add more reported-by/tested-by tags if more people hit it 
> > before the commit makes into Linus' tree so don't expect that commit id to 
> > be stable just yet.
> 
> Ok, now dropped from all stable queues, thanks for letting us know.

Any chance these can be re-included? That's:

1db806ec06b7 ("PCI/ASPM: Save parent L1SS config in pci_save_aspm_l1ss_state()")
7507eb3e7bfa ("PCI/ASPM: Fix L1SS saving")

We've independently backported them into kernels we're using, but it
seems wise to get 6.12.y, etc., back up to date.

Brian
