Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285D1FBE
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 08:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668414499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0cKHoFafz+LP1S2CBddADOVNwHT2k+gOLa+MKsB3ptw=;
	b=TGQ68CpZmQ5Df9fPH7bEsnd1Dz3rfzJsON1L54s35mio8qYTQsRQgJzY8utviqmNr+MkgE
	kFll9IoybN2/XEMGGsMCpWaEQ6YzHiawGMaUFAA3EmCERw5XMa8EkCACzQK5FuUk+Lz0Cj
	963a1z2Qx82huv36n/8f6zeZKiMoGfY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-166-FLWVEo_oO3-9D_58QNoHKQ-1; Mon, 14 Nov 2022 03:28:18 -0500
X-MC-Unique: FLWVEo_oO3-9D_58QNoHKQ-1
Received: by mail-ed1-f69.google.com with SMTP id w17-20020a056402269100b00461e28a75ccso7707005edd.8
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 00:28:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0cKHoFafz+LP1S2CBddADOVNwHT2k+gOLa+MKsB3ptw=;
        b=Xig8fquObgWwzPutc3tWzSt37owrZvRWq37aoDUNr5tY6CpYRkqfjX52AVDb+Uq8s3
         T3A6nN3O07vuPX65FzNJCf1Ikf0cBixbFP+6Rvx5oLCMEFxNJ5T+QbdToQFwaY+2f6cA
         A9drPrP5dFDEn63bSgyqsag5D09Ogu1SOPGuttsCsBTAmkR5IBcwmiTjknZy7pQy0rbh
         r/XxoiWV+LSM2FXyPrcLh3nTfJhFPAmShlzn5PREbNP2KDUN/GafQX1GSoyW6ItZuDXu
         rtmyVl9NmErzVS/8pUsNa+dRXH6v88q1v5QdL3swV9vuhMA1WMVb/XXkUl20YaONNVNM
         k8gw==
X-Gm-Message-State: ANoB5pnzpVhXJTJ97/F4FDYnCKq/9d+Czqyh+OoCHARdRjwae0ypZjC9
	QcMGemHmtYi7a7+xbQ5ZwA4y0a7ZJs7AgwY9LEeww1+evVcSMqbkjcqeIo6kgFkqC5HS0ZF5pSX
	tVQyJR8dzZvGVOipy4w==
X-Received: by 2002:a17:906:a148:b0:79e:9d9b:d41f with SMTP id bu8-20020a170906a14800b0079e9d9bd41fmr9465088ejb.404.1668414496895;
        Mon, 14 Nov 2022 00:28:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6llvFfjsia9EdK19bkvVH34sDfeBmnZsD9XX/oHCPsIbjxTUEgWIQrbHxvv3fFbacyGd35kg==
X-Received: by 2002:a17:906:a148:b0:79e:9d9b:d41f with SMTP id bu8-20020a170906a14800b0079e9d9bd41fmr9465074ejb.404.1668414496703;
        Mon, 14 Nov 2022 00:28:16 -0800 (PST)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id sz15-20020a1709078b0f00b0073cf6ec3276sm3840583ejc.207.2022.11.14.00.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 00:28:15 -0800 (PST)
Message-ID: <ab0db3fa-4106-da16-7771-8ab50aa0f3b5@redhat.com>
Date: Mon, 14 Nov 2022 09:28:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs
 entry
To: Borislav Petkov <bp@alien8.de>,
 Thiago Macieira <thiago.macieira@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "Luck, Tony" <tony.luck@intel.com>, "Joseph, Jithu"
 <jithu.joseph@intel.com>, "markgross@kernel.org" <markgross@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "Raj, Ashok" <ashok.raj@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
 "Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
 "Mehta, Sohil" <sohil.mehta@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com> <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <2537334.Lt9SDvczpP@tjmaciei-mobl5> <Y3F4Uq+1qi5tnmeG@zn.tnic>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <Y3F4Uq+1qi5tnmeG@zn.tnic>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 11/14/22 00:05, Borislav Petkov wrote:
> On Sun, Nov 13, 2022 at 01:51:56PM -0800, Thiago Macieira wrote:
>> Anyway, we can update the tool to print "%02x-%02x-%02x-%02x.%s" instead of 
>> "%d". That's trivial to us. I just don't think it's a worthwhile change, 
> 
> As I wrote to Tony, "I guess time will show whether the sequence number
> thing was a good idea."

Just for the record: I've read the entire thread and I'm fine with doing
things either way.

If I understand this last email correctly then the plan is to move
ahead with the patches as-is, with writing only the batch-number and
have the kernel create the filename. This was and still is fine with me.

Regards,

Hans

