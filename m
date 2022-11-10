Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0611A629
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 19:16:14 +0000 (UTC)
Received: by mail-qk1-f171.google.com with SMTP id z17so1733260qki.11
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 11:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qnf+7Iz/AC6v/1QCMpsQVXmtrt+7PcPrgj9ldvBanC4=;
        b=CwQfgbI4DuFardVNcz0uqADSJZuog7DfOLMB0DlZyNtKNN+/AAvh2LRxwZmgilOF+X
         I3JtdfoWwEbKsnfFl1ndsT7C54El7cEafRsjlAtAXO38NZfW3+qb142sIyialkF1EuJX
         UD9EcBweatojlCkpb5Xr8x1O8QBTlj04tsUOUolfhW4n1y8HfrWjaYPTIuvl3/009lpJ
         8VD2xtqbopwqA/5hMaE58taNq6ZXzAjlMiPwf3GB8QeNFLLnX62bkRAPOXaqF+xn+i1a
         ef2xc9uWHo3hD/OChu60GI34be8uAb879KS9rVYmyuW06KnyaqoyjtPix72a54DCvkkP
         PDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qnf+7Iz/AC6v/1QCMpsQVXmtrt+7PcPrgj9ldvBanC4=;
        b=M8rG8m5ePoRPYwbiUsIPZIX7PCwiXgoo1qj57TML6MbzOrw/HqF0/Fi1SYhbwGwgMt
         mF73mKXIwXVFj1/75n8Ny4dt32uw60pWsvMGMX8XJ44axTDRWQ11xaBoMVouSuWqXwg+
         QI2zTa/JNOVlqIJlI77k88WEa0FE6oc1VjwFfqz0QuveyiDrKC3oq6WUmqIP7j2rSWrZ
         JirVYnAAVMul4rgs2u4PTLFyK1CTUzpYwbrmzadOy8wRbRi+tCQNI6NYWGL4cURKW3rY
         Wrig9nu1NDINsiiZFfJ1jSmk9tBYTwFDGFwjsSAnJYSFMHZBeVwh5hc3CrB+6zmvJcT+
         I5ow==
X-Gm-Message-State: ANoB5pkhN/gO/1GHhstnRLgkZSK2s7/GCLkvKNW73pMa/7/NnN1c6Sx3
	hyfLBXYdUWwr+e3YcjBRXLU=
X-Google-Smtp-Source: AA0mqf7OmccX74WLnA2RzCh82dTb3yr7TSHjjf0XJGJIW0Rg2zenvqckfbOPuy5mu6rqRnqBVu3XGA==
X-Received: by 2002:a05:620a:1184:b0:6fb:176e:1dbe with SMTP id b4-20020a05620a118400b006fb176e1dbemr5159880qkk.249.1668107773309;
        Thu, 10 Nov 2022 11:16:13 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id c8-20020a05620a268800b006eecc4a0de9sm76608qkp.62.2022.11.10.11.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 11:16:11 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailauth.nyi.internal (Postfix) with ESMTP id 0D82A27C0054;
	Thu, 10 Nov 2022 14:16:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 10 Nov 2022 14:16:11 -0500
X-ME-Sender: <xms:-k1tY1fkq_lUw8WWo0FO3vORGR060uvU_plUv0Q2gAIa_hHqkWbrAQ>
    <xme:-k1tYzN_gPfyVlhC0FPrzsFfKamUsIYQGqcWDiRFMeSuKt_rtS560FOp1WahpLrzB
    vI9vBwZEJTiw48neg>
X-ME-Received: <xmr:-k1tY-hSYkjdj3_09XZqbuNlAQ1XOi0gS0nBWbkibMlZ_ZXP15fEosPJ6GYL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeeggdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:-k1tY-8oHQtArzBVlmDg3PSp1VhU3-Tq9tE36EFd2u7sezkLFKd_pQ>
    <xmx:-k1tYxvsyCjMkE-Ux7x1_Az9Nd5wkymXhkGQPzQuFc168Tj8sJII5A>
    <xmx:-k1tY9Fld3VaVygwcT5qo2PTXo56DJMYZuFri-RuMo861WRbCeZXVQ>
    <xmx:-k1tY3JjGlZ5BYdUkcDQgrSXsY5uDhGSYCZ5LIHiFkooMle3k_qsIQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Nov 2022 14:16:09 -0500 (EST)
Date: Thu, 10 Nov 2022 11:16:08 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Niklas Mohrin <dev@niklasmohrin.de>
Subject: Re: [PATCH v1 23/28] rust: std_vendor: add `dbg!` macro based on
 `std`'s one
Message-ID: <Y21N+GtGsqzaPSFp@Boquns-Mac-mini.local>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-24-ojeda@kernel.org>
 <Y208lVCN3VweD5iI@Boquns-Mac-mini.local>
 <CANiq72kR3YZv65NYPx+H57XO7T85kioMWMZajRnk7f+ru-3x+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72kR3YZv65NYPx+H57XO7T85kioMWMZajRnk7f+ru-3x+w@mail.gmail.com>

On Thu, Nov 10, 2022 at 08:14:17PM +0100, Miguel Ojeda wrote:
> On Thu, Nov 10, 2022 at 7:02 PM Boqun Feng <boqun.feng@gmail.com> wrote:
> >
> > and I'm almost convinced ;-) Better add the gist of discussion into
> > comment/document/commit log? Users need to know when to use `dbg!` and
> > when to use `pr_debug!`, right?
> 
> The docs talk about it a bit:
> 
>     +/// Note that the macro is intended as a debugging tool and therefore you
>     +/// should avoid having uses of it in version control for long periods
>     +/// (other than in tests and similar).
> 
> That is the original wording from the standard library, but we can
> definitely make the rules more concrete on our end with something

Yeah, having some kernel contexts is better ;-)

> like:
> 
>     `dbg!` is intended as a temporary debugging tool to be used during
>     development. Therefore, avoid committing `dbg!` macro invocations
>     into the kernel tree.
> 
>     For debug output that is intended to be kept, use `pr_debug!` and
>     similar facilities instead.
> 

Look good to me, thank you!

Regards,
Boqun

> Cheers,
> Miguel
