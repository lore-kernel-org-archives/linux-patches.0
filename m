Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5319B1848
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657462125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZ+Ir5UHkWJnKPJDN3wCsOO/4a0jZwNAsijgMvisGzE=;
	b=NpeSj/Xx6hTbt5n8Hdlha7mxUHVZPj95r1OIzbTm9XQGEKMJzItSP12wQA+NBRCi7J+x2M
	jza7ElOWNpc5dvqYde3LuAjLtWFlBbhckmFByj304WTAYjaInytSmTJ6GXWtclSUZXQypA
	ZZ7vH2V2Ta+5gkVENVNkMLywv5PNyHw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-pmITd1TuPWCaoiQPZ4-b1Q-1; Sun, 10 Jul 2022 10:08:41 -0400
X-MC-Unique: pmITd1TuPWCaoiQPZ4-b1Q-1
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a056402268f00b0043ac600a6bcso1661680edd.6
        for <patches@lists.linux.dev>; Sun, 10 Jul 2022 07:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sZ+Ir5UHkWJnKPJDN3wCsOO/4a0jZwNAsijgMvisGzE=;
        b=6Zv6P92GTOdnIWX/4LOAs3IkzZj3Yi0ydXWYTJRRRP3V3CQTK+yQEAVtrNUaP5ZGhu
         13+x3Rg8IUTh3Mhy5Emd5BfQJd1rHvFCQBpPQRr6ZZMh3kmQTWsf+n1ewVVeyQ4s6qUp
         Ljm1/6HWMJyxVm03WjJRpeATCKvZODeoRdHiBzzrLt2DHqSd+CPv9bj/uA54OrD2qQHA
         Np/68MJemCCa1i570O/cfHvqz4QVPpK61YyMotYeBAKkHEAOni3A2DFXQPUYB91mFLIQ
         GnNSVyFrpjZXLQ1Adr5PBB++1wPtqp5wyottPzaxGeKzkY0AtQsh+D9zBku2+clNbkM8
         1bWQ==
X-Gm-Message-State: AJIora9eDSWK653HJ7mo5/whTuXC0aGiO6Fh8xLnRe7UIujc56CbxnYU
	ew3GHQsFsnnL1LH2p9VEGndVEGZ4HLTpHQp3j3Iq601P4VvZB8qOdoHGs+1FAX9PrHcFZgHi2U8
	cVkx8HlxBGNyu/uss7Q==
X-Received: by 2002:a17:907:9693:b0:726:372c:2c02 with SMTP id hd19-20020a170907969300b00726372c2c02mr13804642ejc.483.1657462120456;
        Sun, 10 Jul 2022 07:08:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tvZYcSZLE5z95IwwNnidfUvhPzTEicgyUuf8VshR8QlLUySMai4yVrsn7nMBFpW59UEsA4Dw==
X-Received: by 2002:a17:907:9693:b0:726:372c:2c02 with SMTP id hd19-20020a170907969300b00726372c2c02mr13804623ejc.483.1657462120277;
        Sun, 10 Jul 2022 07:08:40 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id f10-20020a1709064dca00b006fef557bb7asm1615582ejw.80.2022.07.10.07.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 07:08:39 -0700 (PDT)
Message-ID: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
Date: Sun, 10 Jul 2022 16:08:39 +0200
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
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Joseph, Jithu" <jithu.joseph@intel.com>, markgross@kernel.org,
 ashok.raj@intel.com, tony.luck@intel.com, ravi.v.shankar@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev
References: <20220708151938.986530-1-jithu.joseph@intel.com>
 <YshNAh6awfPFmxzU@kroah.com> <33a6193e-1084-ae5f-1f80-232274f71bd0@intel.com>
 <Ysqm1BRbCTtWfAcW@kroah.com>
 <79eae42f-50ca-c23c-9fd0-8c356b2d3783@redhat.com>
 <YsrZwc9P34lICS99@kroah.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YsrZwc9P34lICS99@kroah.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg,

On 7/10/22 15:53, Greg KH wrote:
> On Sun, Jul 10, 2022 at 03:42:29PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 7/10/22 12:15, Greg KH wrote:
>>> On Fri, Jul 08, 2022 at 11:34:40AM -0700, Joseph, Jithu wrote:
>>>>
>>>>
>>>> On 7/8/2022 8:28 AM, Greg KH wrote:
>>>>> On Fri, Jul 08, 2022 at 08:19:38AM -0700, Jithu Joseph wrote:
>>>>>> Existing implementation limits IFS image to be loaded only from
>>>>>> a default file-name (ff-mm-ss.scan).
>>>>>>
>>>>
>>>>>
>>>>> Ick, but now what namespace are you saying that path is in?  If you need
>>>>> debugging stuff, then put the api/interface in debugfs and use it there,
>>>>> don't overload the existing sysfs api to do something different here.
>>>>
>>>> The namespace related confusion could be because, the original commit message
>>>> was not using full path-names. The below write-up tries to be more clear on this
>>>>
>>>> Existing implementation limits IFS images to be loaded only from
>>>> a default file-name /lib/firmware/intel/ifs/ff-mm-ss.scan.
>>>>
>>>> But there are situations where there may be multiple scan files
>>>> that can be run on a particular system stored in /lib/firmware/intel/ifs
>>>>
>>>> E.g.
>>>> 1. Because test contents are larger than the memory reserved for IFS by BIOS
>>>> 2. To provide increased test coverage
>>>> 3. Custom test files to debug certain specific issues in the field
>>>>
>>>> Renaming each of these to ff-mm-ss.scan and then loading might be
>>>> possible in some environments. But on systems where /lib is read-only
>>>> this is not a practical solution.
>>>>
>>>> Extend the semantics of the driver /sys/devices/virtual/misc/intel_ifs_0/reload
>>>> file:
>>>>
>>>>   Writing "1" remains the legacy behavior to load from the default
>>>>   ff-mm-ss.scan file.
>>>>
>>>>   Writing some other string is interpreted as a filename in
>>>>   /lib/firmware/intel/ifs to be loaded instead of the default file.
>>>
>>> Ick, you are overloading an existing sysfs file to do different things
>>> based on random stuff.  This is a brand-new api that you are already
>>> messing with in crazy ways.  Why not just revert the whole thing and
>>> start over as obviously this was not tested well with real devices.
>>>
>>> And what is wrong with a firmware file called '1'?  :)
>>
>> Actually the Intel IFS stuff has landed in 5.19-rc# so it is
>> a bit late(ish) for dropping it now.
> 
> We can mark it BROKEN right now before -final happens as it seems that
> the api in 5.19-rc is not correct for its users.
> 
> Perhaps we should do that now to give people the chance to get it right?

That is a good idea. I've just send out a patch doing that.

I plan to submit one last pdx86 fixes pull-req to Linus once rc6 is out
(prepping it now and want to give the builders some time to build test it).

I'll include this in this fixes pull-req.

Regards,

Hans

