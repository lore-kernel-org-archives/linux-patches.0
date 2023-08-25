Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809201803F
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 20:16:06 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-99c1d03e124so167358366b.2
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 13:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692994564; x=1693599364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjJCHGt0k1VwlPR6FmSHmbFrmal68KsL6y3OoKnV8Vg=;
        b=UZ7+BszuI+HA4SWxjR91ezZtiTxHA+UElmuXBNh6shT/nuD663ATY9CDnFKGuqBSC5
         kcOEH4L/nWnBy+j/YrgGzKycZdwYDU13qsgui6DLJnMsf4lY60iYcMmzoUOH9DPUhGPT
         EopC7j2nw8blE5dCNn1utPlJppyp+P3Mu6zlxuFcip+qaeVr6ZpKXVMvZz5JUhag5iVc
         zu13ZN1/0PG6Z4+sT7Le5Z9cdkPTSBpL41SXKouc/ac4/RAB/yU49s/XdZj+iaHR9KhA
         hB6zVhmhhcSehxntStOySs/BhfMJ+PsJEgXG6FsqNQgRujz50k0wxrMkb8p4NgEsjHwW
         kpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692994564; x=1693599364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjJCHGt0k1VwlPR6FmSHmbFrmal68KsL6y3OoKnV8Vg=;
        b=kglD9poHhQXbl4287+jTMG92qeryM3fSzPYklKZCkQyxcXjMacQxx7OGTcMX6/J5VB
         KeX6ASqL7Ba7nYUX3729pFFgURFtcpoyVqTVRvCM/P8/AOiokxlNVirvKariRfXhJuc8
         YTkyOQhiWe92DczaA58sM36BY5orOFNxMoO1Mcjppy1TOvjzchnMy4iJlroJQ4sK0jEO
         1vMZcFUYItY1lLExzTFBSdVZK9SJUtvZbHGyW8BXUNUQMEx05Oq2zkY8OHc29590Wc7Z
         hKMssoI4CBvgAgpQjycLCx4WalG8Z/jNK9RUkEAgbWAw8/EwEf/Pou8aJECaOrg486jB
         gFWA==
X-Gm-Message-State: AOJu0YzJaVwxjYkVaz/fDBcb/bfLCA5rMBoj/tUnaC1PH+LdSYJbmMAG
	mBMVN6VKcUFFcemDCODUBuU=
X-Google-Smtp-Source: AGHT+IHfgnsvA/fcaQsFX768N5I5IbuzJzca9stNFdAHPqeaHuS0RfE3/Tb+CgNr6A4io8f1F4a7Tg==
X-Received: by 2002:a17:906:cc0b:b0:9a3:7148:503c with SMTP id ml11-20020a170906cc0b00b009a37148503cmr2733908ejb.5.1692994564239;
        Fri, 25 Aug 2023 13:16:04 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id a5-20020a17090682c500b0098f33157e7dsm1277736ejy.82.2023.08.25.13.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 13:16:03 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailauth.nyi.internal (Postfix) with ESMTP id 8716F27C005B;
	Fri, 25 Aug 2023 16:16:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 25 Aug 2023 16:16:00 -0400
X-ME-Sender: <xms:_wvpZIearZ1d82KHybSnHx5zol1Px_Shl4JNEIq9YKSReNvoc03TSw>
    <xme:_wvpZKMxKuoYxmJA71dcESzXULjuCV7dlCSJ9iF_CAqGz48IjjunqJPO9ghVCKQpy
    BZrf8dVHp2MpCO9Hw>
X-ME-Received: <xmr:_wvpZJjsM7Do9yl-pHUUKeWS_V9kNfhAXHIPAwxT-OIDbNtnRJ-zuG-K-VM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedruddvkedgudegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:_wvpZN-4r917S81a3e2e1c7eemYg5ViSDPfVK-RHNnF_NJCICMnhbQ>
    <xmx:_wvpZEvVwU-SShEVA8BHccOpv2HGzNmU7U4nNE9c0za_oHGvcbv4iA>
    <xmx:_wvpZEHPM0f_w8c4lO_NqRJpQavSAClakN-e0tdhlPYMhVSquUJQPQ>
    <xmx:AAzpZE0a0LrsZXGJrppD7TZGNgwtV7dSoB-cu2f1wHT7Z1dbkaprYw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Aug 2023 16:15:58 -0400 (EDT)
Date: Fri, 25 Aug 2023 13:15:19 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, patches@lists.linux.dev,
	mikelley@microsoft.com, kys@microsoft.com, wei.liu@kernel.org,
	haiyangz@microsoft.com, decui@microsoft.com,
	apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
	will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v2 15/15] Drivers: hv: Add modules to expose /dev/mshv to
 VMMs running on Hyper-V
Message-ID: <ZOkL12qGLWe_ceCx@boqun-archlinux>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-16-git-send-email-nunodasneves@linux.microsoft.com>
 <ZOeh-4pFgil54iyx@boqun-archlinux>
 <0909fb87-9370-4c59-b7ea-9ca673d456b3@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0909fb87-9370-4c59-b7ea-9ca673d456b3@linux.microsoft.com>

On Fri, Aug 25, 2023 at 11:41:35AM -0700, Nuno Das Neves wrote:
> On 8/24/2023 11:31 AM, Boqun Feng wrote:
> > On Thu, Aug 17, 2023 at 03:01:51PM -0700, Nuno Das Neves wrote:
> > [...]
> >> +static long
> >> +mshv_dev_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> >> +{
> >> +	switch (ioctl) {
> >> +	case MSHV_CHECK_EXTENSION:
> >> +		return mshv_ioctl_check_extension((void __user *)arg);
> >> +	case MSHV_CREATE_PARTITION:
> >> +		return mshv.create_partition((void __user *)arg);
> >> +	case MSHV_CREATE_VTL:
> >> +		return mshv.create_vtl((void __user *)arg);
> >> +	}
> >> +
> > 
> > Shouldn't we also have a MSHV_GET_API_VERSION ioctl similar as KVM? So
> > that in the future when we change these ioctl interfaces or semantics,
> > we can bump up the API version to avoid breaking userspace?
> > 
> 
> Note that we contribute and maintain support for this driver in
> Cloud Hypervisor, so we control both sides of this API - if we break
> userspace we can fix it ourselves.
> 

This actually doesn't always work, e.g. old Clould Hypervisor + new
kernel, but..

> For now the MSHV_CHECK_EXTENSION ioctl is sufficient - we can pass it
> MSHV_CAP_CORE_API_STABLE, and it will return 0 to indicate that the API
> is not yet stable.
> 

.. I missed that we are using this to report API is not stable, so I
agree, the API version is not needed for now.

> A version check may be useful in the future, but is not needed right now.
> 

Thanks for the explanation.

Regards,
Boqun

> Thanks
> Nuno Das Neves
