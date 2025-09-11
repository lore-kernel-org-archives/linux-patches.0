Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D53C268C73
	for <patches@lists.linux.dev>; Thu, 11 Sep 2025 19:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757620265; cv=none; b=rEuSFgHg4XScbXsIudIRS+DOFNDBfMOXD7Pc3y3KfO4ULp1xCmbjEEEssq5wveJUcrT8PaKyd2fbDDOLqpAZ9ee2AC09PfzXZYTrvlYIxrxU4NSugYFfEJkkSDPtf8hNBxLPTBpvTiT/6OVV26eKdLtdir+h0OHaukN1pplOgIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757620265; c=relaxed/simple;
	bh=hLur9OXrLJVNhi3C1WvtgxiOwyKSS2/BRYUd6nt2+lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttXflnHpPrpd50083pB1Wmk4g7Exk9fI9tIKNbHRJfoB2K5L+78B8xUyxibSuoDQ9+pmoWXQecYV4Mi9Fi8XjMwJ69utc16QuuTB9nV2ai2D3xVi8Kj9IYVb4FUYcf97ztdnT399S8krJfso2eY9+oeyMDumMGLjrlGd48SEVkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1TGNSXo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1TGNSXo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757620262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09h8euVLQFnhNfq+GfL1OKCW/f8r8xXjiDas370lAT0=;
	b=e1TGNSXoRBJfKbS/TR4Dc85kP+hA/3SaeCtosKAOgUsQ7l0k3mmsXaeClKmVZ6gj+KLU9f
	sJzpfaeKK8Gk8IJXkXlB3cwYf309qdbwB2h8kKKNsqrzbqXL2qTdypo9phrZ9qlrsj9A9+
	wHDG+tr7hSGy13rsH3m3tvH7kI+Q6Ko=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-IABEycG7MlqruqvPMdxXYg-1; Thu, 11 Sep 2025 15:51:00 -0400
X-MC-Unique: IABEycG7MlqruqvPMdxXYg-1
X-Mimecast-MFC-AGG-ID: IABEycG7MlqruqvPMdxXYg_1757620260
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-7296c012ec9so14062936d6.2
        for <patches@lists.linux.dev>; Thu, 11 Sep 2025 12:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757620260; x=1758225060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=09h8euVLQFnhNfq+GfL1OKCW/f8r8xXjiDas370lAT0=;
        b=r6X0KHAQXxuAivF1Y2vZogzCoqrvFHLh/VYalYCOFRn9ihci8yi3lM/uo57YQuRPnH
         IAFO6CWf7Syp7zqck4at/lUSnbpK8MUYgszTK6GyTL2r7gFjR3WBM5+0f4ofck/1YvBd
         //K7zkaSZu6Q6YhBHFhCQxHJWE7Ass16+AXfxdm1hBhhsP/kOW+y8BwQ3TeKsvANQFU3
         GkQckj6FVFIspNLkJ1Axcc5BWWN86AAOWB9FR212JuMJK0nuGV4Fxs4GNUp9nJTSr8MO
         9CBELa5N3/E89f+x/qy7mvPa770Ya791gW3Xp4TCV5RqS5bYn7ZgTLVaE9qJpBzU5etC
         69bw==
X-Forwarded-Encrypted: i=1; AJvYcCXcOZBlI7PTfB+j6XJrADYaFPeQNlFk+VCli+Fy/f4OKhr/oLYE1/bioYYmghdPBbdCu0JYCEq1@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy6Ogn/+ijhFFJNy3hXz9aU8SXk3KsBfUds6H0kNiW91ktVGM0
	rlD1eN4G+w2f0v6iH9j6cLiOJ9+ViPzkL/cbMKjeFAJBD4lKF2y9cchSdq4+YL+kYbG6XOBG9xx
	cP79wDQh4EZnIWmCerUy1bGXVBn7pSmNqsmtiL5S6wUU75JKNeZewS9RG60A=
X-Gm-Gg: ASbGncvBGAwbetv28IdmA/qiw7dR9qSceEZJS8rUb9pnCrzG0xBLBaJfqAFzF05YrqT
	Kle5SPGJWgVhWgE5GhRGdp/kWw2W12Q6grdMdqhFc0WpzJhLpJZQkrS9Eo9ecFsKB+6UQibpWYP
	dxCO/g0eLiEq8YFPohoQldJVK7rTa+Ti+0GJ8Lj54r19xF+Tf9rhqWu0dYVblR3jeT+FGGGWi+1
	OVQ8Eez5bD0wxKQk+o4fKPO1wx4Pfl0CJiJyLx1+FhSwELEETZc6kiqsFRUH785XVRf9dtqJdQX
	tWuFRkCTbdMcXALGOrwj5Tq1LAwkqsoVfmNx0AgS
X-Received: by 2002:a05:6214:2689:b0:70f:a2a7:ce72 with SMTP id 6a1803df08f44-767be2edcacmr5704856d6.29.1757620260148;
        Thu, 11 Sep 2025 12:51:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE25013zy+jxapmo75m2lXYdO9DhsJ09FzmF01ZPRWsNQN6+IV+NPQ6QZ2wA+tvyoAPi0B6ag==
X-Received: by 2002:a05:6214:2689:b0:70f:a2a7:ce72 with SMTP id 6a1803df08f44-767be2edcacmr5704456d6.29.1757620259688;
        Thu, 11 Sep 2025 12:50:59 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-763b54a1f41sm15832166d6.20.2025.09.11.12.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 12:50:59 -0700 (PDT)
Message-ID: <827cc327-0d07-4b87-89e2-e45acede32ac@redhat.com>
Date: Thu, 11 Sep 2025 15:50:57 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/11] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250909214350.GA1509037@bhelgaas> <20250910173405.GC922134@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250910173405.GC922134@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZPbXNOTRA7NqcRuJwdI5_kWf1C6ituHihV-skWghzTw_1757620260
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/10/25 1:34 PM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 04:43:50PM -0500, Bjorn Helgaas wrote:
>>> +/*
>>> + * The spec is not clear what it means if the capability bit is 0. One view is
>>> + * that the device acts as though the ctrl bit is zero, another view is the
>>> + * device behavior is undefined.
>>> + *
>>> + * Historically Linux has taken the position that the capability bit as 0 means
>>> + * the device supports the most favorable interpretation of the spec - ie that
>>> + * things like P2P RR are always on. As this is security sensitive we expect
>>> + * devices that do not follow this rule to be quirked.
>>
>> Interpreting a 0 Capability bit, i.e., per spec "the component does
>> not implement the feature", as "the component behaves as though the
>> feature is always enabled" sounds like a stretch to me.
> 
> I generally agree, but this is how it is implemented today.
> 
> I've revised this text, I think it is actually OK and supported by the
> spec, but it is subtle:
> 
> /*
>   * The spec has specific language about what bits must be supported in an ACS
>   * capability. In some cases if the capability does not support the bit then it
>   * really acts as though the bit is enabled. e.g.:
>   *
>   *    ACS P2P Request Redirect: must be implemented by Root Ports that support
>   *     peer-to-peer traffic with other Root Ports
>   *
>   * Meaning if RR is not supported then P2P is definately not supported and the
>   * device is effectively behaving as if RR is set.
>   *
>   * Summarizing the spec requirements:
>   *      DSP   Root Port   MFD
>   * SV    M        M        M
>   * RR    M        E        E
>   * CR    M        E        E
>   * UF    M        E        N/A
>   * TB    M        M        N/A
>   * DT    M        E        E
>   *   - M=Must Be Implemented
>   *   - E=If not implemented the behavior is effecitvely as though it is enabled.
>   *
>   * Therefore take the simple approach and assume the above flags are enabled
>   * if the cap is 0.
>   *
>   * ACS Enhanced eliminated undefined areas of the spec around MMIO in root ports
>   * and switch ports. If those ports have no MMIO then it is not relevant.
>   * PCI_ACS_UNCLAIMED_RR eliminates the undefined area around an upstream switch
>   * window that is not fully decoded by the downstream windows.
>   *
>   * Though the spec is written on the assumption that existing devices without
>   * ACS Enhanced can do whatever they want, Linux has historically assumed what
>   * is now codified as PCI_ACS_DSP_MT_RB | PCI_ACS_DSP_MT_RR | PCI_ACS_USP_MT_RB
>   * | PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAIMED_RR.
>   *
>   * Changing how Linux understands existing ACS prior to ACS Enhanced would break
>   * alot of systems.
>   *
>   * Thus continue as historical Linux has always done if ACS Enhanced is not
>   * supported, while if ACS Enhanced is supported follow it.
>   *
>   * Due to ACS Enhanced bits being force set to 0 by older Linux kernels, and
>   * those values would break old kernels on the edge cases they cover, the only
>   * compatible thing for a new device to implement is ACS Enhanced supported with
>   * the control bits (except PCI_ACS_IORB) wired to follow ACS_RR.
>   */
> 
>> Sounds like a mess and might be worth an ECR to clarify the spec.
> 
> IMHO alot of this is badly designed for an OS. PCI SIG favours not
> rendering existing HW incompatible with new revs of the spec, which
> generally means the OS has no idea WTF is going on anymore.
> 
> For ACS it means the OS cannot accurately predict what the fabric
> routing will be..
> 
> Jason
> 
Exec summary: the spec is clear as mud wrt RP/RCs. ;-p

The above summary captures the proposed update conclusions to the spec,
and enables a good reference if a future conclusion is made that should require
another change in this area.  Thanks for the added verbage for future reference.

- Don


