Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1DF3C13
	for <patches@lists.linux.dev>; Fri, 14 Oct 2022 17:25:10 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id mx8so3650664qvb.8
        for <patches@lists.linux.dev>; Fri, 14 Oct 2022 10:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5mETzZW4qi8h2MOU+Aq/FDewrEbvdbUnDP9+oZX3LE=;
        b=M+MFRjOZBw7pP9qNfSxH6RYLByFi4618Vx1xmCU6DBOxbp0CGuwThPJ/QHDXvQieNx
         py3vjfkAFEc8lgp57SpggVmQxwmAXn/EtBAeF2DkPCxBwoRmO35mDh2jCWip8DZAlada
         cIDCTt7cg93QAIu2NZeVUChSmqbHzja9DhjI3J4k9AoSmp2y+MEWYSjn3avRd+FhFeC1
         zIM/zQywKourHIbAVcKSEHZuDruO98eXf03xtpjnwh95QhhjXtCv8IsElHBHn7D6KSkw
         /c60IiP8/5bmcNqeL/08WEa8xWxh8cum/mvL6j8/4GBr1nzn6oyY58Etap2fV5sm+ReX
         neDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5mETzZW4qi8h2MOU+Aq/FDewrEbvdbUnDP9+oZX3LE=;
        b=BMCzJTseYbbTSVjqjIrHPpHnvHRLOXYVHsDaosNpd6LlFwI/b6ZVWH8AjFq1cMt9cB
         JWGNsXHhBKsttFJ61CnjdSJSQavs7k62cSx355PSocU5yT65n3qohMivFPJejmYR0hyA
         ebDxBrtwlpknX5pmYDGtwWF68t5PoaotH0zqpzLwG8iGBPtoMmlaYjp7+nW96174Ud25
         tUbRVEfRu0cQU3iFNGBxEJiTk0OO2Ywr66fCOhwKALno4Ofm/ulj/8f72Zl2aVoMReBw
         kNLgLByMmsMPUT//3dudhV9G5WoMhnVRsr8QtnZdN95OVGT0S8z5j45PXkxH69EMgY5p
         5x3g==
X-Gm-Message-State: ACrzQf0hwg8UZJxEiFFNBZFEfA7VBAm89cFY0D3l0nxVarvw2yMHnn4V
	kjzWzLLZ6naUjW/cejIMXvM=
X-Google-Smtp-Source: AMsMyM6vzOmjscSaz+0L/oK2o1egx03i7La+iIFeSPzVcerbkw24bbYrplGqrTn0ZWVxPBl1DiUXgg==
X-Received: by 2002:a05:6214:224b:b0:4af:b412:2269 with SMTP id c11-20020a056214224b00b004afb4122269mr5051092qvc.54.1665768309175;
        Fri, 14 Oct 2022 10:25:09 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id i9-20020a05620a404900b006bc192d277csm3032331qko.10.2022.10.14.10.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 10:25:08 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailauth.nyi.internal (Postfix) with ESMTP id 1A05127C0054;
	Fri, 14 Oct 2022 13:25:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 14 Oct 2022 13:25:07 -0400
X-ME-Sender: <xms:cZtJY6NbMUovjM3p7x_Bia7ochkxR7z3F0iFbzK1oQTOlcTarRgNUw>
    <xme:cZtJY4-SkgtC3i3jozNDZ70AA-s6CAnZ0li2p4YIPXyS8_n4KCDMoMx_h9EYmiKUz
    IYWYwlhpzqyVxM6Gw>
X-ME-Received: <xmr:cZtJYxQ5SbI_JyLMkdi-8MOOty45xlx-XEvrz4c6300zXpshbsSH8JR_icM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekvddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:cZtJY6uxyO2N3MM019RcwoFiN7kGclBCv6ZBsQrmGdpHsluYHOTixw>
    <xmx:cZtJYycM-91rGo4cuDNkFF0lT4Q2szO-QrUFJK-8MmwkYhZktxuzQA>
    <xmx:cZtJY-3SqZeaFppzAhZdlGX9tSD9pWP9FURoWZulryWd-nM1nR8gVQ>
    <xmx:cptJYzs1xnaT3qN1tlkewsEN9sa43RdcbG3Ws43FHOqLVm-cuwMsxw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Oct 2022 13:25:05 -0400 (EDT)
Date: Fri, 14 Oct 2022 10:25:04 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	David Gow <davidgow@google.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
Message-ID: <Y0mbcEuR7GhJncSE@Boquns-Mac-mini.local>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net>
 <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <Y0Ujm6a6bV3+FWM3@hirez.programming.kicks-ass.net>
 <CANiq72nggG_z28Pne7wD=CQfKX3bTUah9vMhvJoWB8Y=uA4j+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72nggG_z28Pne7wD=CQfKX3bTUah9vMhvJoWB8Y=uA4j+w@mail.gmail.com>

On Fri, Oct 14, 2022 at 07:23:18PM +0200, Miguel Ojeda wrote:
> On Tue, Oct 11, 2022 at 10:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Right; so where does that leave us? Are we going to force disable rust
> > when kCFI is selected ?
> 
> Constraining it via `depends on !...` or similar as needed for the
> moment is fine, we have a few others too.
> 

Right, and Peter, we actually need your help to figure out which configs
are related ;-)

Regards,
Boqun

> Cheers,
> Miguel
