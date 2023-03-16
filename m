Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB76A938
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678995521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrsdexTuopIeTtA+lpl9gElJgaVgw+CXQW9dVCSQk58=;
	b=jEA1M216MY7FpDtwGPgUBQ0wlcRYb7ipDeYUo7Go+7M+gbzLn5OzuQkq8G59TuNsjmZZgm
	hMLTEfC9RjFRBdhoc0zGq8d/DCIHuKJcHM2l+eT3BW/vvL1MXy1xsJ/prW8rIlkTwe3mPL
	smRAx+zPhEjXhc5zm4Wr/OM1luECmDY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-jTJE-x0zM8GuE7GeuoJNzw-1; Thu, 16 Mar 2023 15:38:39 -0400
X-MC-Unique: jTJE-x0zM8GuE7GeuoJNzw-1
Received: by mail-ed1-f69.google.com with SMTP id es16-20020a056402381000b004fa3e04c882so4462183edb.10
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 12:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678995518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrsdexTuopIeTtA+lpl9gElJgaVgw+CXQW9dVCSQk58=;
        b=l69Paf6TG/xOwpzXjmw9lL5x7sFm31pDCJYhOXm+RvTK+8G9NZm1n3aLAPwFewNeyG
         OY5vYTS+zuuvR0rlhxtvdcXd7mANtoTep5utWDe255oPY6pfC70qhbz2Ed8dCLzgJ0O6
         jh71TE/VRFAKRSkki/PA9W2Ae25uv3087yWwCMJZ2YFyFSiN34v7iMBRwA5hu7rZhdRZ
         q7j1xveAwuwufsctQCeeKvyfM+SsTBdmNgmfNKVH6vraKnGOGUzQElal55T6FdRLpUd7
         PQjfsy6mCO8AxZI3BRezMzWV6t9Sh2EM/3+keb9zTLmaLknbj8BVwUsjKxh69BzgEvsE
         G5sQ==
X-Gm-Message-State: AO0yUKW3PT1c3bjutqp3UnP2Ge0YkjBDVw9H7yfCeOUQFPJ6LVYZCP6/
	4p2bs6mkCUEf33R4+DA8QeUEupX55EvpNLwz3czg/KatVotBjFtXKgE1kVhEvt5wAxvNaN0+Ea1
	UKL15TIbAXFQyBZ+6NQ==
X-Received: by 2002:aa7:cc8a:0:b0:4af:63a7:7474 with SMTP id p10-20020aa7cc8a000000b004af63a77474mr606984edt.17.1678995518610;
        Thu, 16 Mar 2023 12:38:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set99UEbPnuuTZmnOQukCyTBgTS+9LWWoyV4B/2IRIykoUnefR3TeHe9TGUH2J/cTDbErBabowQ==
X-Received: by 2002:aa7:cc8a:0:b0:4af:63a7:7474 with SMTP id p10-20020aa7cc8a000000b004af63a77474mr606964edt.17.1678995518350;
        Thu, 16 Mar 2023 12:38:38 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id u20-20020a50a414000000b004fd1ee3f723sm166227edb.67.2023.03.16.12.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 12:38:37 -0700 (PDT)
Message-ID: <bafe3301-7a22-7944-ec80-9c64beb13a49@redhat.com>
Date: Thu, 16 Mar 2023 20:38:36 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 6/8] platform/x86/intel/ifs: Implement Array BIST test
To: "Joseph, Jithu" <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230301015942.462799-7-jithu.joseph@intel.com>
 <628e092c-793e-96ce-71f5-80392ad69569@redhat.com>
 <9dde72aa-a28d-2b0e-7b90-6b1996dbf202@intel.com>
 <f45c26ae-865b-b7b6-0f2a-5906d9c0a349@redhat.com>
 <74058e98-2bbc-3f36-7e3d-538fc2323264@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <74058e98-2bbc-3f36-7e3d-538fc2323264@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/16/23 19:11, Joseph, Jithu wrote:
> 
> 
> On 3/16/2023 2:59 AM, Hans de Goede wrote:
> 
>>
>> After taking a closer look I do see one unrelated issue with this patch
>> sysfs.c: run_test_store() does:
>>
>>         if (!ifsd->loaded)
>>                 rc = -EPERM;
>>         else
>>                 rc = do_core_test(cpu, dev);
>>
>> But AFAICT the loaded check really only applies to the first (intel_ifs_0 device) test type and the 
>> Array BIST test should work fine when loaded is false.
>>
>> So I think that the if (!ifsd->loaded) error check should be moved to 
>> ifs_test_core() ?
>>
> 
> It is possible that I misinterpreted your comment in my earlier reply. (Thanks Tony for pointing it out)

No you were right I was looking at the current code, not the code after this patch-set is applied.

> Yes I think moving the load check into ifs_test_core() is better than doing it in run_test_store()

Ack, doing that is still a cleaner way of dealing with this.

Regards,

Hans



