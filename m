Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03340E554
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:17:33 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-965ab8ed1c0so2201577666b.2
        for <patches@lists.linux.dev>; Mon, 15 May 2023 11:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684174652; x=1686766652;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=6/nxqu6qJWqfBLblCuT6TWexFdaNEzmO1+L6cVrLZqU=;
        b=bhLCsPmABWiM8vruD3TVtItT0sfR4SUIuL9qLKUOj1woP+qL06EEQLgNNTc9AisnS7
         FRhm3jAg3pRhNnAPsR0paOD+v2MJtpR/anrJmj/6xul6xqa/BaWKHb8Yi1s5Di7Agewa
         sYMThGN7q9E0PS2xUZNmWDXTteYasUljNENjTTo/ZjoDurl27DZJUV4Ez2JHT18yBWkV
         dioum9PGBrXuijzxwQoiReJP/HKTOJ9cH+T8msYb6a8PmpTqJARS/zaAk6FuStRLXmI1
         PR3u0+bFj2PfkcFKNTETzTwg0jHmhAAYXlNKFWxXPp31gYUszpnA8w/HkjlN1NUrdhJB
         HJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684174652; x=1686766652;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/nxqu6qJWqfBLblCuT6TWexFdaNEzmO1+L6cVrLZqU=;
        b=HoQiZP2UIVww62vPAvbrogEz3LvbJHZbeTot9qlC65Cgdus4Oyo0kps/V2Wb1b90tx
         gKm+Ib6RSmHRbI208nZQxPASjN0y6wNkta+fyqvrYMQDjA69xt9wjtsu0iz+qtAvVK27
         CJnbybbJ5UCUkRD4iQmDxjPza5sqP1czhvBkx/+eqNaulVCYWtAOa3nYGIpQobs2wDlR
         men1sshMjGH+zvUKEDr8sut0PW32QfjmX1GoRHkxOJthjh7z988FVWk+XUrFMrl4SqJZ
         glDHuGXGkXL14D+78V13DaACadcIuQlq02EhgyJQme52cwTn4GpPEIn9gln4df+caSIU
         WtSQ==
X-Gm-Message-State: AC+VfDzIczb5puX1+jgXoDVeUhEGPg7gqqOX14lTJxCIw6k5SeRCCiaN
	6KFodG30AjExU9k40oaAuolJCw==
X-Google-Smtp-Source: ACHHUZ6mvBgvPodUdE7nvAliZU7yYsJPsfUsfq9CvzMl9RmUzRf3NYGfERotBPkU5xormssom4WaOA==
X-Received: by 2002:a17:907:25c8:b0:94a:ac4b:e11b with SMTP id ae8-20020a17090725c800b0094aac4be11bmr26777061ejc.39.1684174652125;
        Mon, 15 May 2023 11:17:32 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id jx26-20020a170907761a00b0096629607bb2sm9823804ejc.98.2023.05.15.11.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 11:17:31 -0700 (PDT)
References: <20230503141016.683634-1-aliceryhl@google.com>
 <20230508124127.77a97c54.gary@garyguo.net>
 <bb3bfbfb-0761-23b2-24e9-e5b4cb3ffac6@ryhl.io>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <alice@ryhl.io>
Cc: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, Wedson
 Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Martin
 Rodriguez Reboredo <yakoyoku@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] rust: str: add conversion from `CStr` to `CString`
Date: Mon, 15 May 2023 20:12:57 +0200
In-reply-to: <bb3bfbfb-0761-23b2-24e9-e5b4cb3ffac6@ryhl.io>
Message-ID: <871qjhe9xh.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <alice@ryhl.io> writes:

> On 5/8/23 13:41, Gary Guo wrote:
>> On Wed,  3 May 2023 14:10:16 +0000
>> Alice Ryhl <aliceryhl@google.com> wrote:
>> 
>>> These methods can be used to copy the data in a temporary c string into
>>> a separate allocation, so that it can be accessed later even if the
>>> original is deallocated.
>>>
>>> The API in this change mirrors the standard library API for the `&str`
>>> and `String` types. The `ToOwned` trait is not implemented because it
>>> assumes that allocations are infallible.
>> How about add a `TryToOwned` trait to the kernel crate and implement
>> that trait for `CStr` instead?
>
> Eh, I don't think it's worth it. It doesn't give anything new to the CStr api,
> and I think it's rather unlikely that someone will actually need to be generic
> over such a trait any time soon.

It is just as valid as having `From<&str>` and `ToOwned<&str>`. While it
does not add anything in terms of function, it carries intention. I
think we should consider adding it at some point.

BR Andreas
