Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853525DB0A
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 02:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758594397; cv=none; b=k3mOQdoxGQU0DKspAdPSmxyfBiW70SnYu3UF8mqDwZjVjxQhAnPcLUsgpBqhYr31ikuhHCJgrrIofqkgFzhPysaqrcaRxOZ07jmGeq0UTyzTBpG3qAMf3NvzUQljsl0zWVqjKaoVTaqwd7kzua/Czy93b/a3p+vyOkR4eydnqUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758594397; c=relaxed/simple;
	bh=g9MBrqKRxZdbNaQ2i02BY1V65gw6a+Y7SeILJk5mGz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sWEFRUW9hurkdmTWgXqTlDp9xQ2q09Wno5xYJJaRvAZyrIEFCgrIhBfik4WthxHM4OHNaa3KQHKQ97QfPvK66TKLoeAxWdKBSqPYlio9YS0CkBeBinf+gOlys+WrBqcEKcqCyXs0pgtaqlAeQM2AL91FXqDqRBXlF09p7F1xV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DU7F5i89; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DU7F5i89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758594395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4PCUD8Djs42q6wF1aYGU4dHZzCceidwhyTYH/cv8Ps8=;
	b=DU7F5i89yKziEQ9oDgcYU054q5Kz6ebbITVztZeWF/HbBkPyCRR/vA96sEiS3v7jEGdW7Q
	LJmMIBRvj5hiHbTsRNB1j6g4LjU0MBUjtuYkjU4SYWGEQunbFLZksb3ttHxFw4kGF2otAY
	K54RaXJCLAXxlS/b/oc5ZMTIWgpQCzE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-lXsm8bxOPfaDPuIOLp3INg-1; Mon, 22 Sep 2025 22:26:31 -0400
X-MC-Unique: lXsm8bxOPfaDPuIOLp3INg-1
X-Mimecast-MFC-AGG-ID: lXsm8bxOPfaDPuIOLp3INg_1758594391
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b345aff439so103808261cf.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 19:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758594391; x=1759199191;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4PCUD8Djs42q6wF1aYGU4dHZzCceidwhyTYH/cv8Ps8=;
        b=thTco9eJqX0eZBx275MyM4mNN+f4N34nHKftOQe/q2i9qvUOs8T8Lv2rxM/QYtwQyQ
         V9udNXgirydjUigymLaCyWs51QfmKG7a/JRubbAk6aX74F3QX608k1mP1ForiAbnvXQM
         bG04/zH+3nkusnnZr860nvx5kHY6BHswsbsy80gml+ZUtpXS/HgjsXdxzTuPGge5jvRo
         DZ/9s0Aoo2I9IU+FeN4W/SdHM3UPZdyMtSRBNHa7ynKlnss8Fr/loE2YnfkIipUkt66X
         Iq8eXDt+ZXrLE08nGF6V/HOY7kqXVPJqMl/6QbxeK5PPZQZ13OnyF+/9XJTgPV3sRcap
         8cWA==
X-Forwarded-Encrypted: i=1; AJvYcCWHgZif5gMcVfUThf154CNgDvdy4YdP0ZmTEYTcMPAUeoSKIIkfncDjDqryR1KoHI4GS35n7vLZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yzyn0eUWM6MSVxNzFRkEhzLWNcKqcetr6C9JIveUprKb9px1pKP
	aeD33UmI9FfdmvEaFV+B6gVkD2Yin0VLQlaN6SgJi160hGC1iO3M7TS7hzLnDVKxfpu9gT4feH/
	SUMr861L2ZNNfr5dk5weqN7F4kkYG5MSO4/Vaf5alCggO+tY7OH+6jTUdTsg=
X-Gm-Gg: ASbGnctNkDrkf4JBTrvsp7yM5zgGwjqbLP7R47FGXGlJEpr8ax87IC1OEFPisy3iKg3
	wzag++Ha3amXA66UuZaG8rumYntdDOEIxGBQ8lzT1/IqPKetjCs8IGLeCclhQtbY0hRm6i8lxSj
	c0YiwLbDaVDLuWrheKkofAvh+fHWmWOPrwyQM3kYo8TO4Myw73Sd0hl+6LWgzMQ213U9poPJZmf
	Q+akIP9PtUWd3YJRqmJvB/ArKXTezB3hGfFgtiBU5eadhdEypL+l6sfIdgVIfbRburH2gksUp2j
	mXmY8ZMrjnuXxvivCv7uXJW2t6PjgCA7A77PLTc1
X-Received: by 2002:a05:622a:22a0:b0:4b7:9abe:e1d0 with SMTP id d75a77b69052e-4d3736be686mr10224521cf.83.1758594391147;
        Mon, 22 Sep 2025 19:26:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh1sa0UCiSmZuNAaBvHrwWnpQZ66gjDzkXkZDaP2M4kQe89ePy6njY8SwRBtPjwxnoKyKQGQ==
X-Received: by 2002:a05:622a:22a0:b0:4b7:9abe:e1d0 with SMTP id d75a77b69052e-4d3736be686mr10224311cf.83.1758594390717;
        Mon, 22 Sep 2025 19:26:30 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4bd9b0c128bsm81896451cf.0.2025.09.22.19.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 19:26:30 -0700 (PDT)
Message-ID: <066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
Date: Mon, 22 Sep 2025 22:26:26 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
To: Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701132905.67d29191.alex.williamson@redhat.com>
 <20250702010407.GB1051729@nvidia.com>
 <c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
 <20250717202744.GA2250220@nvidia.com>
 <2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
 <20250718133259.GD2250220@nvidia.com>
 <20250922163200.14025a41.alex.williamson@redhat.com>
 <20250922231541.GF1391379@nvidia.com>
 <20250922191029.7a000d64.alex.williamson@redhat.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250922191029.7a000d64.alex.williamson@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Njj9tBPsEHX7jR5aRle3UCyuLVYCfb0Nsbas1dtDs6w_1758594391
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/22/25 9:10 PM, Alex Williamson wrote:
> On Mon, 22 Sep 2025 20:15:41 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
>>> The ACS capability was only introduced in PCIe 2.0 and vendors have
>>> only become more diligent about implementing it as it's become
>>> important for device isolation and assignment.
>>
>> IDK about this, I have very new systems and they still not have ACS
>> flags according to this interpretation.
> 
> But how can we assume that lack of a non-required capability means
> anything at all??
>   
ok, I'll bite on the the dumb answer...
lots of non-support is represented by lack of a control structure.
... should we assume there are hidden VFs b/c there is a lack of a vf cap structure?
... <insert your favorite dumb answer here> :-)

I can certainly see why a hw vendor would -not- put a control structure
into a piece of hw that is not needed, as the spec states.
For every piece of hw one creates, one has to invest resources to verify
it is working correctly, and if verification is done correctly, verify it
doesn't cause unexpected errors.  I've seen this resource req back in
my HDL days (developers design w/HDL; hw verification engineers are the
QE equivalent to sw, verifying the hw does and does not do what it is spec'd).

Penalizing a hw vendor for following the spec, and saving resources,
seems wrong to me, to require them to quirk their spec-correct device.

I suspect section 6.12.1.2 was written by hw vendors, looking to reduce
their hw design & verification efforts.  If written by sw vendors, it
would have likely required 'empty ACS' structs as you have mentioned in other thread(s).

>>> IMO, we can't assume anything at all about a multifunction device
>>> that does not implement ACS.
>>
>> Yeah this is all true.
>>
>> But we are already assuming. Today we assume MFDs without caps must
>> have internal loopback in some cases, and then in other cases we
>> assume they don't.
> 
> Where?  Is this in reference to our handling of multi-function
> endpoints vs whether downstream switch ports are represented as
> multi-function vs multi-slot?
> 
> I believe we consider multifunction endpoints and root ports to lack
> isolation if they do not expose an ACS capability and an "empty" ACS
> capability on a multifunction endpoint is sufficient to declare that
> the device does not support internal p2p.  Everything else is quirks.
> 
>> I've sent and people have tested various different rules - please tell
>> me what you can live with.
> 
> I think this interpretation that lack of an ACS capability implies
> anything is wrong.  Lack of a specific p2p capability within an ACS
> capability does imply lack of p2p support.
> 
>> Assuming the MFD does not have internal loopback, while not entirely
>> satisfactory, is the one that gives the least practical breakage.
> 
> Seems like it's fixing one gap and opening another.  I don't see that we
> can implement ingress and egress isolation without breakage.  We may
> need an opt-in to continue egress only isolation.
> 
>> I think it most accurately reflects the majority of real hardware out
>> there.
>>
>> We can quirk to fix the remainder.
>>
>> This is the best plan I've got..
> 
> And hardware vendors are going to volunteer that they lack p2p
> isolation and we need to add a quirk to reduce the isolation... the
> dynamics are not in our favor.  Hardware vendors have no incentive to
> do the right thing.  Thanks,
> 
I gave an example above why hw vendors have every incentive not to add an ACS structure if they don't need it.
Not doing so, when they can do p2p, is a clear PCIe spec violation.  Punishing the correct implementations for the
incorrect ones is not appropriate, and is further incentive to continue to be incorrect.

Don't we have the hooks with kernel cmdline disable_acs_redir & config_acs params to solve the insecure cases
that may (would) be found, so breaking the isolation is relatively easy to fix vs adding quirks as is done today for proper spec interpretation?

- Don

> Alex
> 

