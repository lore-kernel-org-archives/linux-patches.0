Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B251E79E2
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 21:12:30 +0000 (UTC)
Received: by mail-qv1-f50.google.com with SMTP id dw2so9954122qvb.11
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 14:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680729149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9WPVzMu0zYw99iZ/vspmA1+DnRkTHR31Y0rwVrENFY=;
        b=n16loXYrxdB3+h6JhUrNt+qNoh+REsMNIJ6HM48yg+EMIg775iK89wKgNdJPbl9RGd
         3X4ijISD7XGNYLwqfKijB3DOE/Pb9BpPup0/NarlNY61RSNCg6CHf9AMdnxxT7w5gk5Z
         hSnVzV/xl55/7Ph1X2F4vcrGdQ1I6Qjgcv+6678m+kppWhbznqigSJHb3Cklu8VQTXQh
         U9dZFztSaEC1pzSbtwDXl/HwhlpO1XHdbmmtdlIZciw50PgS21jcCDGgDea46smmUh5+
         3gjcEElr9fw19UpVlNEbC4hcyx/24lrF1pSaqFKBBvQsUb6N6HNTw204SMv8QeWROpOX
         inlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680729149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9WPVzMu0zYw99iZ/vspmA1+DnRkTHR31Y0rwVrENFY=;
        b=Xn9wACKsCNJpeolYHLz/VbLe5zGXffpuajYLnWaxdfpGS/D3YhhwSR1GAPCj8Xz/vi
         kFL7sr+itduoi+b8vFNjWdf0n7cjXeQ6LXnC+zLumrC3CpZxpybexjcdB/e+y9F4mSiZ
         EKj81dVEe3ueAkAZnj7ssJIstJHicNE+cudbQNnOd6ChmWwj0yTK4L7qK2REFBGX1T2d
         AN8c3w0R1HP/A38yTRhTMD8zsUvTFNj0uKu71dIwjAoHP57vyntlYQMdD64ToEvBFEvf
         +COmsw/FeBwo/YBQagypnNVi7fZte3HdLWQwHuXNwsydiO22ADTYhwj8HaJpNglLoGle
         xWrg==
X-Gm-Message-State: AAQBX9czL1QdM+4eoADaXaJtHsNUsPjG1wOqHq31dIpex2pa4L5iUskD
	fRJMC2ewpxVa0UREje/aQvQ=
X-Google-Smtp-Source: AKy350Y/7mlmCTZ8boFJPPjVTe3mWec+x17invVCygTahpEG55be+e4yS0pNeodpsujGKNqoXq2vfQ==
X-Received: by 2002:a05:6214:268a:b0:56e:9298:7a1a with SMTP id gm10-20020a056214268a00b0056e92987a1amr1447459qvb.9.1680729149572;
        Wed, 05 Apr 2023 14:12:29 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id nw6-20020a0562143a0600b005dd8b9345basm4507738qvb.82.2023.04.05.14.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 14:12:28 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 84E2827C0054;
	Wed,  5 Apr 2023 17:12:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 05 Apr 2023 17:12:28 -0400
X-ME-Sender: <xms:POQtZErAccJB_-bWsKcVRdb1qUZ2iVWRxzKOrQ_lwU3Xg1PorQRcag>
    <xme:POQtZKp3X7X6b5EU5zcJ7H5io6MI5Izeqvz-_FBHp_nP5xGRL9R_sVJ4MPbW_OPNX
    rFjy6i4PzhKs2MDSQ>
X-ME-Received: <xmr:POQtZJMHQbPBRnWSvzmyDWrZdKpCUzdyssw04tN9ouKGrbik68zCd7qj-r9pDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejuddgudeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:POQtZL635XmkBYulEeQdGwzGx_BheRICXUsS_lP00qbx_CmMztVGcw>
    <xmx:POQtZD60T60iZJV8bsXcamgVuOU-2HbziL189xo8mRECCysw1rhC4Q>
    <xmx:POQtZLgO7tT54tpA6d7Gaghvtg_voQC-Nl7qSupZkWfuzOOkjylUWw>
    <xmx:POQtZAzSIx1PgtDu-rQcaprE2jef5pXlo1U91VmzTcu0mSGpF0raqQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 17:12:27 -0400 (EDT)
Date: Wed, 5 Apr 2023 14:11:26 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v6 00/15] Rust pin-init API for pinned initialization of
 structs
Message-ID: <ZC3j/nB3MaSmaNSs@boqun-archlinux>
References: <20230405193445.745024-1-y86-dev@protonmail.com>
 <ZC3h3q+56gM8pKOX@boqun-archlinux>
 <96b35c6c-6fd1-465d-fb46-aa48c73ae465@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96b35c6c-6fd1-465d-fb46-aa48c73ae465@protonmail.com>

On Wed, Apr 05, 2023 at 09:06:46PM +0000, Benno Lossin wrote:
> On 05.04.23 23:02, Boqun Feng wrote:
> > On Wed, Apr 05, 2023 at 07:35:30PM +0000, Benno Lossin wrote:
> >> Changelog:
> >> v5 -> v6:
> >> - Change `pinned_drop` macro to allow `mut self` in the signature.
> >> - Change statement fragment to tt fragemnt in `pinned_drop` to prevent
> >>    parsing errors.
> >> - Move evaluation of the value in `stack_pin_init!`/`stack_try_pin_init!`
> >>    to the beginning.
> >
> > Could you elaborate why? To make sure the $val evaluation happens
> > unconditionally?
> 
> This is done to allow `stack_pin_init!(let value = value);` i.e. naming
> the variable the same as the expression that is evaluated.
> 

Make sense!

Regards,
Boqun

> --
> Cheers,
> Benno
> 
> >> - Move setting uninitialized flag in front of dropping the value in
> >>    `StackInit::init`.
> >> - Remove `Unpin` requirement on `zeroed()`.
> >> - Add note about `Pointee` to the `Zeroable` impl on raw pointers.
> >>
> >
> > Regards,
> > Boqun
> 
