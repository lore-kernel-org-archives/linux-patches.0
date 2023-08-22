Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2A8BFD
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 09:31:53 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-94a355c9028so294130566b.3
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 02:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692696712; x=1693301512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vf+urCuo+i/PGdGVpq57Y5tRY0x9kDJ3rrqszJUUwro=;
        b=NX33VQFT1swrupwKm7gCk0QP/aKbrrRVR6vV8NelDdC7bkFRVvmsbaL75lSpQ+ba0S
         BBvoYWXA4c6DekkcFQQvwpGKHtR37hVcpPF859hxDRelIRj9gn68mg9NnOWM3+Ofui/u
         hcmhLCUbbHEYY9vsy/S0nDfrnleUNd0Y6YDW88cQcKX2r7puHl/DLbIJcJq5liPMArQx
         B9UXZVbrtTKJ+Elvp8lRhIa3fKWhySQxI8d0mhcL5A88vw54lnskKLBQWgnqj4B/S4GX
         aDUQ1KiLsthK7YA5BIxjvpEVVpQC4uy1ZgFpgOnpnh/nvkRzq8FPxhwpNqDy/BdpZzZP
         LEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692696712; x=1693301512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vf+urCuo+i/PGdGVpq57Y5tRY0x9kDJ3rrqszJUUwro=;
        b=WxW/SciNr60egWBxLwCE59jdNKNRZP0p2DrVXv2w38jpFMGeJDeP10BaMyd+tSHJby
         mGQzYKdNWEB8FpRIhEi9xvQLdJqHHqjjM0MBSrUZyGvOhstAau5d0rwG9m9dI7t/r1n1
         enXLNGWF5fcYNoMhoVMMXBeg+xf8JAMovNpSk6W1FAr6ja/tJyLnhTDHzQWeYvhTnmj5
         TGZrK34ndQPLuXSA8Gst+A3qhWfhF+ziQHKtJoGOo1R2KlNU/bNTdLlKhhI2R86nlQMG
         omVJepdVMBekgBber2N/ezWIPG74rrachaSAgBdA8xlM/IczwEl/QleZOjlZ72Vaa4m0
         RXpQ==
X-Gm-Message-State: AOJu0YwMRiO7CI873YGg5Yga0P7a18+zUkqr9xqhXkttNQ3uSbGajJI3
	j5wUZ6/Y856NPq+iZg5xbUBrqO3+VvdtE2I=
X-Google-Smtp-Source: AGHT+IH7jfczo1ag7cPwrHC5eR3B4Cg6Z+4gTxcX+oGFl3qww4kgIT0tUDCiQT3rTAsmf3QNu+i9aP8coHB96vA=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:a1a3:b0:9a1:bce1:e8f7 with SMTP
 id om35-20020a170907a1a300b009a1bce1e8f7mr3999ejc.5.1692696711766; Tue, 22
 Aug 2023 02:31:51 -0700 (PDT)
Date: Tue, 22 Aug 2023 09:31:48 +0000
In-Reply-To: <87r0octho8.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <87r0octho8.fsf@metaspace.dk>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230822093148.3478340-1-aliceryhl@google.com>
Subject: Re: [PATCH v1] rust: add improved version of `ForeignOwnable::borrow_mut`
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="utf-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
>> +    /// Borrows a foreign-owned object mutably.
>> +    ///
>> +    /// This method provides a way to access a foreign-owned value from Rust mutably. It provides
>> +    /// you with exactly the same abilities as an `&mut Self` when the value is Rust-owned, except
>> +    /// that this method does not let you swap the foreign-owned object for another. (That is, it
>> +    /// does not let you change the address of the void pointer that the foreign code is storing.)
> 
> How about this:
> 
> "For a smart pointer P<T> this method provides mutable access to T if
> &mut P<T> would allow mutable access to T. Otherwise it provides
> immutable access to T."
> 
> The point is that the method provides access to the pointee, not the
> smart pointer itself. In fact it is perfectly fine to do a mem::swawp()
> for the pointee in the case of Box and depending on interpretation the
> sentence "does not let you swap the foreign-owned object for another" is
> confusing.

Yeah, I agree that the phrasing is somewhat confusing.

How about this:

/// This method provides a way to access a foreign-owned value from Rust mutably. It provides
/// you with exactly the same abilities as an `&mut Self` when the value is Rust-owned, except
/// that the address of the object must not be changed.
///
/// Note that for types like [`Arc`], an `&mut Arc<T>` only gives you immutable access to the
/// inner value, so this method also only provides immutable access in that case.
///
/// In the case of `Box<T>`, this method gives you the ability to modify the inner `T`, but it
/// does not let you change the box itself. That is, you cannot change which allocation the box
/// points at.

Alice
