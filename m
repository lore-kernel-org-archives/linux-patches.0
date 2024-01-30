Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C188381B6
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 06:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706594441; cv=none; b=MTVDssgO/H40Ztu/sUlR+bYt5rxLONAeervZ9D4u6PUTKsLGCZSda9geROtZCWTO2DgebIlt6S/r0owVXY3AeRMFlSP1ReCcTjvRAn6vwxmUGztv9jfqb3QKNaZeSFHQV/Y4IPYePitHUuWv09hCl2GFD8JKlD3ndGCKixVpqOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706594441; c=relaxed/simple;
	bh=R/NUso3ZEXjZ2CXWXjsDnjvrYhNhAOzkDkVelIq0JdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWh/GkXTAmFFpFEv/BoFMoxfpg9aCKv/NF4mMnuBA7v4NKsQVVN62Cqv//3o0Y5CsFsq/xAPkFGyWz1UUKv99et1gxjdi02hYTEZHeSkuwkbakV+HIp+IQ/LD4qr6c5pmLLvxfFZfABiA0Hl3TWNZV6Y5lHmdHWht7slal6S4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40f033c2dfbso1617655e9.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 22:00:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706594438; x=1707199238;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTQy4CJ+SNb3OxmfVWZjTqNKmHu1DKSY5gt1OZXHfuc=;
        b=mevzQ3SV/EPMRxL1YSpZ91ZNG46dmkS1lhpPG2+4xVqXV1aBE0ihjsJjJGSnNYNN/S
         JQpue/s1214ecPOb9UU/8nvh0LI0CR2rcu2qKqv6cfCUVtW0OcMW5MjwLvle03OMOobY
         zcKWu/1jIw8Vk4vP7E25tUvrALFUdbCHUuvrOtAHJWYMZ3jJ9FGCRV5lGWpgtogLg3kt
         2PqMPhbn6aFCkY+TjG353Q1EnGJCiBivGPeMGEPLCgChdbK/iSWcsANVKQ88EC8djB8e
         w5OjVlW01LC5521YELf/88MlIoU3nEDIoSG/fa7qY16/ojh1hj2dsdIqGdpiZknYrscs
         e97g==
X-Gm-Message-State: AOJu0YyzxYVobvwO/BCPMh8P+4vYPxOuhiwxt2RP2BZwFlZ+IFXB46zY
	i0exuZICzd+7R61ogtRDZw1risDIzUKia+yIruAnBU0eOCvMhsmV
X-Google-Smtp-Source: AGHT+IFZ6hPbT32UQR2lgpMNvE/g7jRs+U4Ug+HdIvz4WT9Mg/G6Gky6utBnNUO6eqGBltDosbZCGA==
X-Received: by 2002:a5d:6081:0:b0:339:47f0:7dda with SMTP id w1-20020a5d6081000000b0033947f07ddamr6601428wrt.54.1706594438016;
        Mon, 29 Jan 2024 22:00:38 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id p14-20020a05600c358e00b0040efc83d1basm1934532wmq.8.2024.01.29.22.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 22:00:37 -0800 (PST)
Message-ID: <81752462-c6c7-4a65-b9f2-371573e15499@kernel.org>
Date: Tue, 30 Jan 2024 07:00:36 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 125/346] mm/sparsemem: fix race in accessing
 memory_section->usage
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Charan Teja Kalla <quic_charante@quicinc.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Dan Williams <dan.j.williams@intel.com>, David Hildenbrand
 <david@redhat.com>, Mel Gorman <mgorman@techsingularity.net>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
 <20240129170020.057681007@linuxfoundation.org>
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20240129170020.057681007@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29. 01. 24, 18:02, Greg Kroah-Hartman wrote:
> 6.7-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Charan Teja Kalla <quic_charante@quicinc.com>
> 
> commit 5ec8e8ea8b7783fab150cf86404fc38cb4db8800 upstream.

Hi,

our machinery (git-fixes) says, this is needed as a fix:
commit f6564fce256a3944aa1bc76cb3c40e792d97c1eb
Author: Marco Elver <elver@google.com>
Date:   Thu Jan 18 11:59:14 2024 +0100

     mm, kmsan: fix infinite recursion due to RCU critical section


Leaving up to the recipients to decide, as I have no idea…

> The below race is observed on a PFN which falls into the device memory
> region with the system memory configuration where PFN's are such that
> [ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL].  Since normal zone start and end
> pfn contains the device memory PFN's as well, the compaction triggered
> will try on the device memory PFN's too though they end up in NOP(because
> pfn_to_online_page() returns NULL for ZONE_DEVICE memory sections).  When
> from other core, the section mappings are being removed for the
> ZONE_DEVICE region, that the PFN in question belongs to, on which
> compaction is currently being operated is resulting into the kernel crash
> with CONFIG_SPASEMEM_VMEMAP enabled.  The crash logs can be seen at [1].
> 
> compact_zone()			memunmap_pages
> -------------			---------------
> __pageblock_pfn_to_page
>     ......
>   (a)pfn_valid():
>       valid_section()//return true
> 			      (b)__remove_pages()->
> 				  sparse_remove_section()->
> 				    section_deactivate():
> 				    [Free the array ms->usage and set
> 				     ms->usage = NULL]
>       pfn_section_valid()
>       [Access ms->usage which
>       is NULL]
> 
> NOTE: From the above it can be said that the race is reduced to between
> the pfn_valid()/pfn_section_valid() and the section deactivate with
> SPASEMEM_VMEMAP enabled.
> 
> The commit b943f045a9af("mm/sparse: fix kernel crash with
> pfn_section_valid check") tried to address the same problem by clearing
> the SECTION_HAS_MEM_MAP with the expectation of valid_section() returns
> false thus ms->usage is not accessed.
> 
> Fix this issue by the below steps:
> 
> a) Clear SECTION_HAS_MEM_MAP before freeing the ->usage.
> 
> b) RCU protected read side critical section will either return NULL
>     when SECTION_HAS_MEM_MAP is cleared or can successfully access ->usage.
> 
> c) Free the ->usage with kfree_rcu() and set ms->usage = NULL.  No
>     attempt will be made to access ->usage after this as the
>     SECTION_HAS_MEM_MAP is cleared thus valid_section() return false.
> 
> Thanks to David/Pavan for their inputs on this patch.
> 
> [1] https://lore.kernel.org/linux-mm/994410bb-89aa-d987-1f50-f514903c55aa@quicinc.com/
> 
> On Snapdragon SoC, with the mentioned memory configuration of PFN's as
> [ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL], we are able to see bunch of
> issues daily while testing on a device farm.
> 
> For this particular issue below is the log.  Though the below log is
> not directly pointing to the pfn_section_valid(){ ms->usage;}, when we
> loaded this dump on T32 lauterbach tool, it is pointing.
...

thanks,
-- 
js
suse labs

