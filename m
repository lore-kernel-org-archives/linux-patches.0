Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651D01ACB5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 15:18:41 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-514b05895f7so1053322a12.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 08:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686151119; x=1688743119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=deVQh+qbleFKFMBXvnJT6n7IHyrSJm7waz9PF08hDFU=;
        b=DNXQlO+kgvXwz6qTJX0etAVSfGVzhFmEBenY1HHqPAA3uAG+PnXCUE7jvbEGWQvs2j
         CHWEuYhIOyskMTlKZZBQbahX0jfdn2xYBiYf3V5MfSVfB8XWxVFHENd1V7ARhwY4OvFd
         pReca3JGKzbul6Xb48vcaWW8e/HczwXy5I8sXDtBOiCG+UgFFu72hBmjn+4FAq3ed4Kx
         7QVrQn+ie8L4PDdPcypfIoPQlUVl5Q4qvvpnTG8ifuRtJHgCFVYWU7eUuPMPvv8VAnVU
         l+lXs7A6C23rOGvrP0ssUOs6FaauJbJr61DcGg7m/hHRTx5Z7XluO9VPZ1GjbQOBt1+u
         7zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151119; x=1688743119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=deVQh+qbleFKFMBXvnJT6n7IHyrSJm7waz9PF08hDFU=;
        b=G9eR1EEkZWnCwEexZSvhN/xTZ/k0nBo9G36dAxOg38D79GLV16mDoyqhkVyhJpYhwf
         xc/Eja8XXCNOjc0DOKXuSvqQe2BfEarGpH0v+NXbmSJcGW3xMHhjlwFxacHRJRgliHyy
         Vehx3buRBhGtBwwYzcrJFPdk1ENnj3ynDUlwU0DluUY0aGXkBhrYEg3y8/SWOEroJGtx
         xcxBEU7WZQVBkrUf0H1Kz2J1EMhMsJf0YmbHrkEh7HRvlftl4+YAVpxr/3AmMWl0iKjV
         GNmvNWR3hkrvYgoD+Ej10a513jyvOsI+rZzN/+aJv+5MgkhX8/DIWZVM1Jw7wc+I+JQO
         Fd3Q==
X-Gm-Message-State: AC+VfDxgI2quxLwhP3Jd8zwahxMArviGa7dM1MXAvenuD1WOJRvJ/G0y
	0gDv4cjj3D3TQ3Jrvq6XEX1J/r+84YlBo7w=
X-Google-Smtp-Source: ACHHUZ5+zXTXF5D3mZ/9fHkAjNG/eNG0QStWdbxlxoduzPgPX6YpKC8RCoeMj1HG0n0ESy8+IfPs3bCbvb/mmtU=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:99cd:0:b0:50b:c4b5:bb77 with SMTP id
 n13-20020a5099cd000000b0050bc4b5bb77mr2220409edb.1.1686151119485; Wed, 07 Jun
 2023 08:18:39 -0700 (PDT)
Date: Wed,  7 Jun 2023 15:18:37 +0000
In-Reply-To: <ZH/C/lKeYxM7tbYA@boqun-archlinux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZH/C/lKeYxM7tbYA@boqun-archlinux>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607151837.1193399-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 1/8] rust: workqueue: add low-level workqueue bindings
From: Alice Ryhl <aliceryhl@google.com>
To: boqun.feng@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Boqun Feng <boqun.feng@gmail.com> writes:
> On Thu, Jun 01, 2023 at 01:49:39PM +0000, Alice Ryhl wrote:
> [...]
>> +/// A raw work item.
>> +///
>> +/// This is the low-level trait that is designed for being as general as possible.
>> +///
>> +/// The `ID` parameter to this trait exists so that a single type can provide multiple
>> +/// implementations of this trait. For example, if a struct has multiple `work_struct` fields, then
>> +/// you will implement this trait once for each field, using a different id for each field. The
>> +/// actual value of the id is not important as long as you use different ids for different fields
>> +/// of the same struct. (Fields of different structs need not use different ids.)
>> +///
>> +/// Note that the id is used only to select the right method to call during compilation. It wont be
>> +/// part of the final executable.
>> +///
>> +/// # Safety
>> +///
>> +/// Implementers must ensure that any pointers passed to a `queue_work_on` closure by `__enqueue`
>> +/// remain valid for the duration specified in the documentation for `__enqueue`.
> 
> ^ better to say "the #Guarantees section in the documentation for
> `__enqueue`"?
> 
> Regards,
> Boqun

Sure, I will clarify that this refers to the guarantees section in the
next version of the patchset.

Alice
