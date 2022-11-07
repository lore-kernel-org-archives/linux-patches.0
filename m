Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329B428E8
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 09:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667813052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zudUvGHItJCXzYsNesQp/1KXLKVzgoLhNyUkkrXfU2g=;
	b=itvCLEnojPhrd8pxNyatB/83vI3nWixx0hdlBiCMW3OqicFTTXWQaW7RHyYL3GBv++lbFP
	TDyzpw3dsAq1qGnIagBUMRCY2Ws+v7xZkALmks21BUOca+xzq2sgw/8/4ddwyW5RYe8Grx
	zfxORMz/0zY7/34hwwbGMNW/pdanhjM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-277-zg7L4FJEP_ylBzXNyIOiow-1; Mon, 07 Nov 2022 04:24:11 -0500
X-MC-Unique: zg7L4FJEP_ylBzXNyIOiow-1
Received: by mail-ed1-f72.google.com with SMTP id l18-20020a056402255200b004633509768bso7816720edb.12
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 01:24:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zudUvGHItJCXzYsNesQp/1KXLKVzgoLhNyUkkrXfU2g=;
        b=NYAu1mEPD4K1r8R1k8IaZmB/mE5Icg05D+t3z/66+hwLWNjt8oDPhOMDIbc66bz4Ax
         /Vl3AOJYIoO3OuHOn/NkCcnJ4FXK4gDGlQiyVu7eGV09lD45hvFCogbEe4sm1TX6+E4m
         PNXu6ta8Nzft6r69O+SQNPboLzvDS6K/5V7OKa/gNm/xe/2AWDTPAxXuR2eqPjktOP6i
         e9sR4/8BEpc1y/1ukHnFNWO353H51mlyIk6RjjvdY42KTuG3FLD7kwB3bXMGUarBgtdU
         loKSEHQI+jFMrkBeEd1P0PfjVzLVN4N8hVooOci2IGkV3axQnyyOwueG2k1jbOr/HVMJ
         F07Q==
X-Gm-Message-State: ACrzQf2MoCfXiX17a4pSMtsgYYjOfQ2Swv4nCqt4eydZs8aG1KuTCE3d
	OqedrGEuPXXAaFJoprxvA+b6+FnEPJ5ngm63J/JM3aSC8uTSD+ACAd8Hi8Qfnho5iLAd2dhNeX8
	Yj+TzaxZ2+P0Rri1DYg==
X-Received: by 2002:aa7:d80a:0:b0:462:2c1c:8716 with SMTP id v10-20020aa7d80a000000b004622c1c8716mr50284542edq.185.1667813050606;
        Mon, 07 Nov 2022 01:24:10 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4S4Q/hBP1vxV5dzFKqqTCIw//NzGSBJYV52hQFwokS603v6ovdGyaOynySBQ+vHfE+4fwKxg==
X-Received: by 2002:aa7:d80a:0:b0:462:2c1c:8716 with SMTP id v10-20020aa7d80a000000b004622c1c8716mr50284526edq.185.1667813050439;
        Mon, 07 Nov 2022 01:24:10 -0800 (PST)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id kx5-20020a170907774500b00738795e7d9bsm3105053ejc.2.2022.11.07.01.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 01:24:09 -0800 (PST)
Message-ID: <ef0df3da-c8b1-b996-edfc-d14956f953f4@redhat.com>
Date: Mon, 7 Nov 2022 10:24:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 00/14] IFS multi test image support and misc changes
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, ashok.raj@intel.com, tony.luck@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com,
 thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 10/21/22 22:33, Jithu Joseph wrote:
> Initial implementation of IFS driver assumed a single IFS test image
> file with a fixed name.
> 
> Subsequently, it became evident that supporting more than one
> test image file is needed to provide more comprehensive
> test coverage. (Test coverage in this scenario refers to testing
> more transistors in the core to identify faults).
> 
> This series makes the driver aware of multiple scan test image files,
> modifies IFS test image file headers to make it fully compatible
> with microcode headers and adds a few other bug fixes and changes.
> 
> Patch organization:
> Patches 1, 2, and 3: bug fixes
> Patch 4: Removes image loading during init path 
> Patch 5, 6 and 7: exports a couple of microcode/intel.c functions
>                   for use by driver
> Patch 8: Adds Meta-data support in microcode file
> 
> Rest of them are IFS driver changes
> Patches 9 and 10: IFS header format changes to make it fully compatible
>  to intel microcode header format
> Patches 11, 12 and 13: native support for multiple scan test image files
> Patch 14: reverts the broken flag

Thank you for your work on this. Due to personal circumstances I have
been unable to do any pdx86 patch review for the last 2 weeks.

I see that there have been lots of comments on this series already please
send a new version 2 addressing all the existing comments. Then I will
review version 2 once posted.

Regards,

Hans





> 
> Ashok Raj (1):
>   x86/microcode/intel: Meta-data support in microcode file
> 
> Jithu Joseph (13):
>   platform/x86/intel/ifs: Remove unused selection
>   platform/x86/intel/ifs: Propagate load failure error code
>   platform/x86/intel/ifs: return a more appropriate Error code
>   platform/x86/intel/ifs: Remove image loading during init
>   x86/microcode/intel: Expose find_matching_signature() for IFS
>   x86/microcode/intel: Use appropriate type in microcode_sanity_check()
>   x86/microcode/intel: Expose microcode_sanity_check()
>   platform/x86/intel/ifs: Use generic microcode headers and functions
>   platform/x86/intel/ifs: Add metadata validation
>   platform/x86/intel/ifs: Remove reload sysfs entry
>   platform/x86/intel/ifs: Add current_batch sysfs entry
>   Documentation/ABI: Update IFS ABI doc
>   Revert "platform/x86/intel/ifs: Mark as BROKEN"
> 
>  arch/x86/include/asm/microcode_intel.h        |  25 ++-
>  drivers/platform/x86/intel/ifs/ifs.h          |  27 ++-
>  arch/x86/kernel/cpu/microcode/intel.c         |  81 ++++++--
>  drivers/platform/x86/intel/ifs/core.c         |   7 +-
>  drivers/platform/x86/intel/ifs/load.c         | 174 +++++++++---------
>  drivers/platform/x86/intel/ifs/runtest.c      |  10 +-
>  drivers/platform/x86/intel/ifs/sysfs.c        |  41 +++--
>  .../ABI/testing/sysfs-platform-intel-ifs      |  30 +--
>  drivers/platform/x86/intel/ifs/Kconfig        |   4 -
>  9 files changed, 243 insertions(+), 156 deletions(-)
> 
> 
> base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff

