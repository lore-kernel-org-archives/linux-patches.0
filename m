Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826FD6108
	for <patches@lists.linux.dev>; Fri, 19 May 2023 09:40:46 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-94a35b0d4ceso337807466b.3
        for <patches@lists.linux.dev>; Fri, 19 May 2023 02:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684489244; x=1687081244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qWpQ3Z9uo5d0lko+yuj7LVhbX1lJ1BOQYyhbdzAiJWo=;
        b=dyt7NwVO2a1gKgywYFDD8VjInLnFEg9pkbesUJ5JP62K+efVqGabn2ejkuN+LA0w+3
         7skaMDSCg4NECg+cB+RSOxApwoffaQAtr+X/Aadf95/LadOlW2OybzUpZM2hLDUDP/Rj
         j23AANItbXkHlUHz5AemgqeZt/ql4Uws1OqRWWb50SWAR3QIBqOYgpm4ZZYPVRzLg+Dm
         p4BMj2purjRFRRLB1LFM8so/mUBz31z3Fimh19+TyWPUPdzALTMS5bsDjUIRFj7AVmBT
         sjluU/ZYj/ZOLN7F6l2bDDVzSOj5BVThpWdNmyUAKBVHGZn2ygORwCveYpBHY39Y/io9
         Xfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684489244; x=1687081244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWpQ3Z9uo5d0lko+yuj7LVhbX1lJ1BOQYyhbdzAiJWo=;
        b=J4iU2z/2ZlOyOb0MMNyh2fdNkJIT1gN3yztaqcyAu6fFzTI34V/Q7UF/Ccv3FGlU4A
         e95fK8trHU9TKIfs7mBoNocKbGE/VoDLCNI3/rKT5pbQK7ZQ59d9Cxo9xJFDaVZa6lef
         OPgkpG+Y/y0CbAJMkxn5tJA232k7eV/YDyIq2khdC3a/jeKxBdc7s/vrOe2/QLejgQ/b
         J4HfN0uHWQ8O+6bJJzr9ZYU2AsZ5FDrOypgdpAndOs4FTJc4HFn72nTv2KHshLhGrWnj
         8XOsY8oWHkVzOdXke1BP7A8drQ2uf8fDYDzKx0SCTeQ3Ogj7yeKkD56tH1RRaWixTQ/0
         DGrA==
X-Gm-Message-State: AC+VfDyCNH8Ogtv2a9CKuyPaac6l3tdmDmlLxNnQhyTu52PooqaDCfL9
	3CBQOLVsR/AREwuKGS57QjTJmqJFqfncxbY=
X-Google-Smtp-Source: ACHHUZ5n/GWQx8DIeNB1oencH1Ize+8S1lQNiMrR+ccKmOwSjb/TZ7lXLIx1yetd0ozoxs/LbXo6AOMtrxnl+is=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:a067:b0:94a:8224:dbbc with SMTP
 id ia7-20020a170907a06700b0094a8224dbbcmr440656ejc.5.1684489244727; Fri, 19
 May 2023 02:40:44 -0700 (PDT)
Date: Fri, 19 May 2023 09:40:42 +0000
In-Reply-To: <8e42aad3-d94e-3cb4-ee59-90ded31cea9e@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <8e42aad3-d94e-3cb4-ee59-90ded31cea9e@gmail.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519094042.3432952-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 1/7] rust: workqueue: add low-level workqueue bindings
From: Alice Ryhl <aliceryhl@google.com>
To: yakoyoku@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

On 5/18/23 16:51, Martin Rodriguez Reboredo wrote:
> On 5/17/23 17:31, Alice Ryhl wrote:
>> +    /// Enqueues a work item.
>> +    ///
>> +    /// This may fail if the work item is already enqueued in a workqueue.
>
> Wouldn't be worth to mention that, if not implied, the item it's going
> to be worked on an unbound CPU?

I'm not really sure what you mean. Can you elaborate?

Alice
