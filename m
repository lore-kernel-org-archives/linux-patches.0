Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3261ACC0
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 15:15:22 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ba8c3186735so10857459276.3
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 08:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686150921; x=1688742921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=06HbTUXXP7qSeCUQ65JCVHpgC5ctYDDwQ2ntWKZsrTg=;
        b=kJJuPstV/fd36hGGYqYYMfU6SQ6eMQvBPGcCDCMF+3B6XODR3LYU3yrIc7I+D/zsft
         6zsexaV1k8KZe/Dt90YYquozfp1J7tHh3/wNhp+qeyEDPl0mmZpblATGSxPZhOlApQ0J
         nWw+IiChAXdQZlbw05aYZfAf6p+CnxvcX4Rg0PcgCvj/JAKd03rBxFYqFII+6HhbMWUt
         MJQoZjGU5egLSdtfqOZo+gccpnGFlP1/zD4CHa/tfvvLV0hDeaTL4LDVHQqwwF73RlbW
         HwlA/fmcm34oLZjuYUMNBy5GYgzk2i92X9R2abUaebW1TU9zHIQUm01kaKNz/rrBFgAf
         icdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686150921; x=1688742921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=06HbTUXXP7qSeCUQ65JCVHpgC5ctYDDwQ2ntWKZsrTg=;
        b=EBVTHxAsuHSWWKQhjMQPj3fdBc8ostfZ9ZKPGUbK/ptOP3qKloxP3M/wMAaDL6X7VI
         wAmpIU2MF7b5sNn1kGq/UtwaL4VRpKKpch1N9ptxJoe1eA4xTEGaNb0NXncr+vUxWhvw
         gWA34B9jCSPipjMSLIkwOZZZLAEthKLSKf/39vZX6I9wD5Nc4LLSh2U977Iq0Y27lsSS
         4FrgZHKW7+Wa3Miw/RrvZVpz53O2h6AwDS4ePQAqZVsSwBS2E+8sKZQ30+2C6Yvu9gF3
         liCIBiELoYHaUsRojmOt+j6vdLvrRr3Li+CcJabx+qLGjYUQUSgjE2/lsr86Ua1Vh9Ti
         0gmw==
X-Gm-Message-State: AC+VfDyiXNbJIkqDOVzoL//4vrwye2mPnegQteIvGvkIxJd83irb/4qr
	kN40zj4pjbTip0elnfx37cZ+pFc+bC8b34I=
X-Google-Smtp-Source: ACHHUZ5hfgcmjYBr+gjEpgOSocio7Fae1zcX14/mchK1aXcyQDsxI556aUghMJFfiHNwTqEZrwd4bVwBBywPoxs=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a05:6902:722:b0:ba8:8ec4:db50 with SMTP
 id l2-20020a056902072200b00ba88ec4db50mr2207946ybt.1.1686150921659; Wed, 07
 Jun 2023 08:15:21 -0700 (PDT)
Date: Wed,  7 Jun 2023 15:15:18 +0000
In-Reply-To: <875y862lr7.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <875y862lr7.fsf@metaspace.dk>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607151518.1191562-1-aliceryhl@google.com>
Subject: Re: [PATCH v2 2/8] rust: add offset_of! macro
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	walmeida@microsoft.com, wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="UTF-8"

Andreas Hindborg (Samsung) <nmi@metaspace.dk> writes:
> Alice Ryhl <aliceryhl@google.com> writes:
>> +#[macro_export]
>> +macro_rules! offset_of {
>> +    ($type:path, $field:ident) => {{
> 
> Could we add a descriptive comment?
> 
>            // Prevent deref coersion to `$field` by requiring `$type`
>            // has a field named `$field`
> 
> BR Andreas

Sure. It will be in the next version of the patchset.

Alice
