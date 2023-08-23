Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37454C8EC
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 16:10:05 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso770147066b.1
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 09:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1692807004; x=1693411804;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=AvCyDnox4fbKDW7rNSjZG6/gL/syisPTe8ALd97uo+Q=;
        b=AMRCA5jQetEgbNYV7zkyPQEYLYr+i8pUdYZUEF4QON89eMWTb4UdIdYtj3uoFKba67
         LZXYSU0+KedMQZ5+JpEvVjTZsFdPlHKtnDeg26ENh2AvkV9sfqbuU+BPxfFxmx/kUdSH
         naknCJY4MAYa0aqSG74R4dvx6iHvj7VSUVgUpO2t/kuCwmxhLdcVLLL6k7xWHIDiI8im
         aqWBaOrsQ1k0QsvOYK7DjYvrkr7j3FS4zjb7rhXjJpVIbxKA+ahm9kgFjUbe8l1etZn4
         DaYsdfX/zC2jJLvApnGKQCAdgIqJ67AbybH9iIdjl8kC0gXT+ZCDJIhHKS8KDlH7uoPL
         mHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692807004; x=1693411804;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvCyDnox4fbKDW7rNSjZG6/gL/syisPTe8ALd97uo+Q=;
        b=KVmGMitQeH0q6ZqDaJ08CGqWVmqZup/6kGdpB1QXtrt1PMq/i4msYR2Rg1PWegx8sq
         QBzGIELFO7SydYL9lePXTbGnCwXKeBtH1f+87lcsmjTaF51ITfMzZqItExpOw2uYs2VM
         59OrBgWfsNFYep9lSILyK7TrRje1cfBuiF3+yEmYzHPoYi8kRC9A8zQQAqgr4TBPucFA
         7IiO0O844+EiBoW+DsDbfwpwuiZKszUbaNhkJC8b4Dz+UQIRE7XMlc3KKmewEt1Vz4GQ
         gFBzyoVM1oJW0fa2Yp5rJVt+FDUTHfgDLedWqwhNek51sn7vowsH9jXw5zjOMp/uajmh
         f4tA==
X-Gm-Message-State: AOJu0YyqKyZDKEfHh0UBeDGxV+rlrs/AZgFUnozQKBIpJs37Q8n/MhZf
	sxEo5duuKmbnzMtotLM9WMxjlg==
X-Google-Smtp-Source: AGHT+IHqKjdbXppHqxgenNeZYES7RnrdB3Ff8k7iiNuK7kgXftXUykFdhh/FJBhTWdlI5gR+XbKyNA==
X-Received: by 2002:a17:906:2d1:b0:991:d5ad:f1b1 with SMTP id 17-20020a17090602d100b00991d5adf1b1mr11989340ejk.47.1692807003799;
        Wed, 23 Aug 2023 09:10:03 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id o5-20020a1709064f8500b0099d45ed589csm9938111eju.125.2023.08.23.09.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 09:10:03 -0700 (PDT)
References: <87msyi406u.fsf@metaspace.dk>
 <20230823103458.243871-1-aliceryhl@google.com>
User-agent: mu4e 1.10.5; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, linux-kernel@vger.kernel.org,
 ojeda@kernel.org, patches@lists.linux.dev, rust-for-linux@vger.kernel.org,
 wedsonaf@gmail.com
Subject: Re: [PATCH v1] rust: add improved version of
 `ForeignOwnable::borrow_mut`
Date: Wed, 23 Aug 2023 18:09:15 +0200
In-reply-to: <20230823103458.243871-1-aliceryhl@google.com>
Message-ID: <87a5uh4u5h.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> Andreas Hindborg <nmi@metaspace.dk> writes:
>>>> I am not sure this makes sense. How about splitting the trait in two,
>>>> immutable and mutable and only implementing the immutable one or Arc?
>>>
>>> I used this design based on what would make sense for a linked list. The
>>> idea is that we can have two different types of cursors for a linked
>>> list: immutable and mutable. The immutable cursor lets you:
>>>
>>>  * move around the linked list
>>>  * access the values using `borrow`
>>>
>>> The mutable cursor lets you:
>>>
>>>  * move around the linked list
>>>  * delete or add items to the list
>>>  * access the values using `borrow_mut`
>>>
>>> The mutable cursor gives you extra abilities beyond the `borrow` vs
>>> `borrow_mut` distinction, so we want to provide both types of cursors
>>> even if the pointer type is Arc. To do that, we need a trait that
>>> defines what it means to have mutable access to an Arc.
>> 
>> I don't see how that prevents this trait from being split in two?
>
> Well, you could split the trait, but if you make the mutable iterator
> require the `borrow_mut` trait, then you have to implement the mutable
> trait for `Arc` too if you want the mutable iterator to work with `Arc`.
>
> And if you're always going to implement both traits, then maybe it
> makes more sense to not split the traits?

Maybe. Do you have a prototype for the list cursor available?

BR Andreas

