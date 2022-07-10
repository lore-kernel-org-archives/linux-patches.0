Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047457B
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657469388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5JEb/uVG3DX+vJnFG63dtA/86MruuqcGl4hcFXTDLsU=;
	b=VEL5kDwdedu5wvpBiHSuWqbnKkgESFwBSMoS7goW6u/SFFeqd1MPjamd/sfBp12JbcqdJF
	RQ+gitMl16XllNakrZnbb03Bj+M/CVnaa61JEmbFR5xpDLCZz4Dp1wtiFCxnH9LwxMTEKk
	P6auBVsLIPG7T69V2/AjRFYQo0di2g0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-5tCMb1BqO_-hE-h6nEuIbg-1; Sun, 10 Jul 2022 12:09:47 -0400
X-MC-Unique: 5tCMb1BqO_-hE-h6nEuIbg-1
Received: by mail-ed1-f71.google.com with SMTP id t5-20020a056402524500b0043a923324b2so2744094edd.22
        for <patches@lists.linux.dev>; Sun, 10 Jul 2022 09:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5JEb/uVG3DX+vJnFG63dtA/86MruuqcGl4hcFXTDLsU=;
        b=JJXLFBUZSoVpOrDjpWtK5TAD4WdUhtvzrexOin09pS9+oGsVglk0kU895/qU98QkMD
         2Glh/UqPWhnwr/IY+DH9Uj4spI5PEBtmrhxqvP+kH+gFimCBT3BfQwAKlQdTBCySL9Vz
         Kro5bgzu1aHrRIb3kQrX+uojjbK6PbvwxfV2KpaZwIOZuTEZXJ81HZ3KJ/ojNu0b87P7
         Q36s5/8/9YejtXxypOxi8gpOPGvmYQJ/1bacF8wiwEg+BtyiiPeyHY4hn8RuS/xL7NUV
         sMpHpdjkySF2LjHrIBsLWowgdaWcFBVSml4yOJyxEcYxyjlR4yk1a1uWDzOCsVgbx/+p
         c+Zg==
X-Gm-Message-State: AJIora9C/bJ3MJbqWdmfnZyuLopzwX7iQndGDSwzP5iWxJcO22g/vP1e
	LnP2jIbK0eRq+KIH2WuTAKg/AqLvANj49FqVYO/K2xecv0glG5+YKyKsSgDNKtDdEwsSCQqC/De
	7wMEsduNe6LHonXm5Wg==
X-Received: by 2002:a05:6402:241e:b0:437:d732:20d2 with SMTP id t30-20020a056402241e00b00437d73220d2mr19246731eda.39.1657469386713;
        Sun, 10 Jul 2022 09:09:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tAEO7VsUhPfsSyPmdDqBi85AM9kac/m49JwWXrH0pYNbMO9JLrifA/AA3CovwAufvSHKZErA==
X-Received: by 2002:a05:6402:241e:b0:437:d732:20d2 with SMTP id t30-20020a056402241e00b00437d73220d2mr19246700eda.39.1657469386519;
        Sun, 10 Jul 2022 09:09:46 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id gs5-20020a170906f18500b0072aa0d9ba93sm1686888ejb.134.2022.07.10.09.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 09:09:45 -0700 (PDT)
Message-ID: <745efcbc-4b9f-df25-d587-4b4409b82518@redhat.com>
Date: Sun, 10 Jul 2022 18:09:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] platform/x86/intel/ifs: Allow non-default names for IFS
 image
To: "Joseph, Jithu" <jithu.joseph@intel.com>,
 Greg KH <gregkh@linuxfoundation.org>
Cc: markgross@kernel.org, ashok.raj@intel.com, tony.luck@intel.com,
 ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev
References: <20220708151938.986530-1-jithu.joseph@intel.com>
 <YshNAh6awfPFmxzU@kroah.com> <33a6193e-1084-ae5f-1f80-232274f71bd0@intel.com>
 <Ysqm1BRbCTtWfAcW@kroah.com>
 <79eae42f-50ca-c23c-9fd0-8c356b2d3783@redhat.com>
 <YsrZwc9P34lICS99@kroah.com>
 <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
 <4483d1fe-417f-4279-3460-dca351ee42e2@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <4483d1fe-417f-4279-3460-dca351ee42e2@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 7/10/22 18:04, Joseph, Jithu wrote:
> 
> 
> On 7/10/2022 7:08 AM, Hans de Goede wrote:
>> Hi Greg,
>>
>> On 7/10/22 15:53, Greg KH wrote:
>>> On Sun, Jul 10, 2022 at 03:42:29PM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 7/10/22 12:15, Greg KH wrote:
>>>>> On Fri, Jul 08, 2022 at 11:34:40AM -0700, Joseph, Jithu wrote:
>>>>>>
>>>>>>
>>>>>> On 7/8/2022 8:28 AM, Greg KH wrote:
>>>>>>> On Fri, Jul 08, 2022 at 08:19:38AM -0700, Jithu Joseph wrote:
>>>>>>>> Existing implementation limits IFS image to be loaded only from
> 
>>>>>
>>>>> Ick, you are overloading an existing sysfs file to do different things
>>>>> based on random stuff.  This is a brand-new api that you are already
>>>>> messing with in crazy ways.  Why not just revert the whole thing and
>>>>> start over as obviously this was not tested well with real devices.
>>>>>
>>>>> And what is wrong with a firmware file called '1'?  :)
>>>>
>>>> Actually the Intel IFS stuff has landed in 5.19-rc# so it is
>>>> a bit late(ish) for dropping it now.
>>>
>>> We can mark it BROKEN right now before -final happens as it seems that
>>> the api in 5.19-rc is not correct for its users.
>>>
>>> Perhaps we should do that now to give people the chance to get it right?
>>
>> That is a good idea. I've just send out a patch doing that.
>>
>> I plan to submit one last pdx86 fixes pull-req to Linus once rc6 is out
>> (prepping it now and want to give the builders some time to build test it).
>>
>> I'll include this in this fixes pull-req.
>>
> 
> I did send a v2 just now, which removes treating 1 specially. Not sure
> if it is too late, but just wanted to give it a shot

The v2 patch does look better to me, thanks.

But IMHO it is not good idea to fix userspace API issues during or
after rc6. So lets keep this marked as broken in Kconfig for 5.19 final
and then we can get something like v2 merged into 5.20-rc1 in a couple
of weeks and then also remove the broken marking.

For enterprise distros to be able to backport this what matters is it
being in Torvald's master branch, so from that pov this just delays
things a couple of weeks. Which is well worth it IMHO to give us some more
time to get the userspace API right.

Regards,

Hans

