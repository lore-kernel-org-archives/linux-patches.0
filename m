Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3C14406
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:27:52 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id bq9so20377742wrb.4
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Z5021MP1akYx7neUqLr5qMs7h+HvHIkKeCKcPGSgbhc=;
        b=du7F1/kfLQPUwrpEikl58YETsRkeHLnOy84Lt3VI2oV+evbxoU4zT096EiRdNq38I8
         m+SBWJWQ7ZnHICpYjV2D9Sv6BxLXNqv0cCooIc9/pZQf4vse3bTPMQGR/hcW+BWkjeV5
         BB9/Tska6aP4rx+44jTlNHYGU4etTKA5WsyEKfMAsYxRh0vaaHnEU+4MUR38Aw8abOyh
         1DZzbVqOM1ZfOb+M6areRvl9r47PuGRBfv/O1eragGMvs8C5AJn8R3IAptXBsKhWAdE7
         dVYGwskI5q+tq+pAJMiC/vlMnXJwIr6EbYf1SuaZTeZ09EIJXZ1roQulSfRNDxUeHq+j
         ak0Q==
X-Gm-Message-State: ACrzQf0sN0f7IHaM5muMQ3BjMj0Uy7aBJ797pCGybFoZvzrJPGVM1bKK
	3xmM8tay5s2q/oobfhmCPfo=
X-Google-Smtp-Source: AMsMyM7AzWYKcmC4LtKzfTFeG5/T3mR7Bm6xtkkNpTyXzUEoOHjDeCH+Q5PIuxElD9rilPNBuhn+kg==
X-Received: by 2002:a5d:4741:0:b0:22c:c1a2:812d with SMTP id o1-20020a5d4741000000b0022cc1a2812dmr5779270wrs.220.1664378871204;
        Wed, 28 Sep 2022 08:27:51 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m67-20020a1c2646000000b003a342933727sm2030782wmm.3.2022.09.28.08.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:27:50 -0700 (PDT)
Date: Wed, 28 Sep 2022 15:27:48 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Wei Liu <wei.liu@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Gary Guo <gary@garyguo.net>, Matthew Bakhtiari <dev@mtbk.me>,
	Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
Message-ID: <YzRn9J9S84nj7IFr@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-9-ojeda@kernel.org>
 <YzRj+47LIz2G9omo@liuwe-devbox-debian-v2>
 <CANiq72=qZPdcdPJzD0FMN13A34C9mXoMb18+uKaA7rdEGuZ0TA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=qZPdcdPJzD0FMN13A34C9mXoMb18+uKaA7rdEGuZ0TA@mail.gmail.com>

On Wed, Sep 28, 2022 at 05:25:55PM +0200, Miguel Ojeda wrote:
> On Wed, Sep 28, 2022 at 5:10 PM Wei Liu <wei.liu@kernel.org> wrote:
> >
> > Missing safety comment here?
> 
> The standard library does not provide safety comments for all blocks,
> and these are essentially copies of the infallible variations in the
> library, which I kept as close as possible to the original.
> 

Okay, that's fine then. Feel free to keep the RB tag.
