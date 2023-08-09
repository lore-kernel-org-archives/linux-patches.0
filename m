Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A230224528
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 20:15:35 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6bca3588edbso195070a34.0
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 13:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691612134; x=1692216934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mD3lZ+cedaC3uh75ynu2ZL3JyVWBLEXJVSbA+C3K0LU=;
        b=eu8uD+QFcUZ38jGEmySOr/1VMtkfXYu9r93sNp/ePwPq83li5VR93dBVyNgY9L7Cfc
         WgNqkoL2GSmDl/o/6yYY5DTr9hxcezCRzpgSytKFBXwe0lQMnp1kwkQc8p+YxAuz9z1Y
         hxU8EDW8bvGyNjEY3YfY5B3FXr8r/SEmwN49H4G3Kp9VduX3saJOq4wPFF4qBiujEJ2g
         Qh9y2oIUFP/RdFF7M6bQusB5GMBvU1wh0tppVi1KD+Nz5b6/9jq5TM1L1cGsexin5fW+
         tvTXov1jyvcbGi6L7uLvxc9oT7wAnHxa4w1CRCCvU8x+oMNeHHbYfVDO/4gUdiHRuwoG
         wLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612134; x=1692216934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mD3lZ+cedaC3uh75ynu2ZL3JyVWBLEXJVSbA+C3K0LU=;
        b=bEXdE+j0lHP1CXdIUILoRep7yPRI4m6ZG4FQBoFcDZn68IOrMK7Kp1jOGifxljZaLH
         z84xgmWte/xZhgVPiIC+tW8gTaJ3nNH7HoRFVAsWJfrU6x5b/A/PKxN8F7r4stlSILy0
         r8o5d39CaM28lBwtqoaRRNy1A3PD1RmHMNJumJQ30ARIZ56vErr3AL7jF3iqRusqllog
         9O08IXXhEw0/0G00iup0YX/hSxYqW7LzpXFZmzH+IMWImVmXy+Mmo9v953C3vgln5DaK
         IkuVSQhjR7q4lazRQnoLrlzFpVLQ9Eb98r/JjNvMrltu0Ed4zAuK98z3cmaiF+ceMcOI
         fLwQ==
X-Gm-Message-State: AOJu0Yw/3oXa030727Yx1YrCXpNlrbC3AaAo3WeeY7O9BERLG5GLDED9
	j5sMRNSKRAI4vME9r8llcCM=
X-Google-Smtp-Source: AGHT+IGmy/YEk0/6tf7GbIdqdSbviX+FQ1mwJv6DoHjtUIF0cXpMUJL6SRyWRhjyQR8256ApJQZ9WQ==
X-Received: by 2002:a9d:798b:0:b0:6bd:bcd:43f8 with SMTP id h11-20020a9d798b000000b006bd0bcd43f8mr118188otm.21.1691612134452;
        Wed, 09 Aug 2023 13:15:34 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id z21-20020a9d7a55000000b006b8ad42654csm14147otm.0.2023.08.09.13.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 13:15:34 -0700 (PDT)
Message-ID: <8313fb24-5fbb-4408-825d-974da33a4353@gmail.com>
Date: Wed, 9 Aug 2023 17:15:29 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 5/5] rust: file: add `DeferredFdCloser`
Content-Language: en-US
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230720152820.3566078-1-aliceryhl@google.com>
 <20230720152820.3566078-6-aliceryhl@google.com>
 <bee24ff5-444c-44f9-81c8-88ff310b401a@gmail.com>
 <CANiq72mHU7n2jTPFsO=tjfqucrbe2ABSUYPUG6ctEerh4J+U_g@mail.gmail.com>
 <CANiq72m5tbj2_N_s371d5N_4H1xpE2ahTHOUvFtUd+N0Y=0tsA@mail.gmail.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <CANiq72m5tbj2_N_s371d5N_4H1xpE2ahTHOUvFtUd+N0Y=0tsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/9/23 06:09, Miguel Ojeda wrote:
> On Wed, Aug 9, 2023 at 11:00 AM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>>
>> If you mean for the commit, then we should follow the kernel
>> convention instead. Please see my reply to Alice above.
> 
> One extra note: if it is a external repository, then yes, I would
> definitely recommend adding a `Link` because readers may not be able
> to easily `git show` the hash. But if it is the kernel tree, then it
> is not needed.
> 
> Cheers,
> Miguel

Gotcha

-> Martin
