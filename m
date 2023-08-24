Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C2111726
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 18:32:15 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-99bcc0adab4so7300266b.2
        for <patches@lists.linux.dev>; Thu, 24 Aug 2023 11:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692901934; x=1693506734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPlwIuXS4UKNdwnv7dloCDkuc6cLmXeTG3uvRrx0mcc=;
        b=AMrfHRJyOccu2U1+VViw/W5kSSakls1k6XEM2l+XA2ikpvbNc5CjPHOKd+S8cAgmxB
         ifln8PRBXTTy667HLc2M0J9OBpMGT4SY7YR3yGWE4RPiVbS8xgwg+iyIw9DnjOY0Bu12
         seKj6LhzYfkqiihsE+M9TuazFlSD8dWijS9Or1ipmamiKhW6c6v+1ExtJmeNqrxHAcri
         +Xnt+j+8YxZLjpw4n1RONcQ4m0bs/79N7fv6iAjV8YS8moWOB0wQttJ0FcjvkQtf+KEN
         IVtT0tGbaPM21Z8O7s7qYGj9kcaTar4Aja2e6R/11LDP0jpZr9mM04PIxpYCqod8ELkB
         xXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692901934; x=1693506734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPlwIuXS4UKNdwnv7dloCDkuc6cLmXeTG3uvRrx0mcc=;
        b=h3yf1BAnAwugnQnAMrqcmBZhawsV+LDyvAj184pjoMQhE+9fj4g6IUuovzm502ya+v
         L2VtTgTpAmZeRXTICIb+wgXuRNuKmmKCHV2NBOARjhnSp7pcB9CC+DqghtMNYBRTx1p9
         f10H0urMX3CAy5AKf1AlG/BznYunRsk5Cfxd6o/Bc+E8NHG1L6xlfkiMiL3ytIlMoxyX
         +CW/e0C95Hme+ltx8Hfw9GZ/xGSZinZ2nTGLGFNxtUwVIEAInWyXURs1pRDJUCQJ0E/p
         9zgVwShlm+GbErWoiPivtFBQCOFCT6zLTvPgAFGhKpsdzMydavMeokNdKHxtIcAxeZ2L
         4cNA==
X-Gm-Message-State: AOJu0YwzZ5gZYL3HEvSw2/tKdzNmPDoKhjuG0vRcGK34D/feIqZwI1rm
	+dBZHi8YFerGWYuroDMwSGQ=
X-Google-Smtp-Source: AGHT+IHbCZyG5/7et0uig8UAuRPjyBzz20Gw3VrhhgrsbCSWXKLDR7YVo8khW5+Ne6maGO7ViU80UA==
X-Received: by 2002:a17:906:5385:b0:99c:55c0:ad15 with SMTP id g5-20020a170906538500b0099c55c0ad15mr12900344ejo.38.1692901933771;
        Thu, 24 Aug 2023 11:32:13 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id fy3-20020a170906b7c300b009894b476310sm11087708ejb.163.2023.08.24.11.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 11:32:13 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 737EF27C0054;
	Thu, 24 Aug 2023 14:32:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 24 Aug 2023 14:32:01 -0400
X-ME-Sender: <xms:H6LnZE4l_cegzfNRp0EP6DxR7UzaH60yDcm9Pt-Dfj8GKn1ODIUhlQ>
    <xme:H6LnZF4SK-YsUlMmogV1t3aAODNaiCZJfXsjftj4-kaZI_KQ2ZxBRIltAW7IhkAw0
    B3r0J2Kg2Nds1C8Ew>
X-ME-Received: <xmr:H6LnZDee3xyQL6gWQJSQ1KmTMHmrV7von6PKyEfVSOYtXpJxQi16PVMFwu1FvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedruddviedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:IKLnZJIz8wSlenA3l3Qv-0P0nBbFiMqJFQUHr7aIxk4wN1u8g5t4Nw>
    <xmx:IKLnZILlvf4NrWmIsGxRmeg6Ng83iNEpHsG0WMrspAvKwVvlhnpQag>
    <xmx:IKLnZKwgzOMhQDC1_-OuyZ4DpUGBSfg2L_B_RgNDJV9DcnnAIMbZeg>
    <xmx:IaLnZIDqHZ_Iq7nXhNGsrr_JyIQXxcRxq99kQSgEl7DdxQVbCcST8g>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Aug 2023 14:31:59 -0400 (EDT)
Date: Thu, 24 Aug 2023 11:31:23 -0700
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
Message-ID: <ZOeh-4pFgil54iyx@boqun-archlinux>
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-16-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692309711-5573-16-git-send-email-nunodasneves@linux.microsoft.com>

On Thu, Aug 17, 2023 at 03:01:51PM -0700, Nuno Das Neves wrote:
[...]
> +static long
> +mshv_dev_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> +{
> +	switch (ioctl) {
> +	case MSHV_CHECK_EXTENSION:
> +		return mshv_ioctl_check_extension((void __user *)arg);
> +	case MSHV_CREATE_PARTITION:
> +		return mshv.create_partition((void __user *)arg);
> +	case MSHV_CREATE_VTL:
> +		return mshv.create_vtl((void __user *)arg);
> +	}
> +

Shouldn't we also have a MSHV_GET_API_VERSION ioctl similar as KVM? So
that in the future when we change these ioctl interfaces or semantics,
we can bump up the API version to avoid breaking userspace?

Regards,
Boqun
