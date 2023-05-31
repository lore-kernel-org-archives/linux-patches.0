Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EFA14AA8
	for <patches@lists.linux.dev>; Wed, 31 May 2023 14:03:49 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bb0d11a56abso3058051276.2
        for <patches@lists.linux.dev>; Wed, 31 May 2023 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685541828; x=1688133828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zgZNa9EtHrAIwO3wPspMKG7VOPoKw+bLM8tIqIzljU4=;
        b=73dq1vBSAi729Lilf8hsEKhqFYXzhRCBI6uMLZyuvErH5WN8nLHGymQsclfH1xkkds
         +6qlOW1V0G/D72xBKfuy805DJKiqGU7jlVl9I4OHIcm2kJXPH0nINc3ZYotFu4YITGC8
         2xTH5sY9WC25b/N2LfFTeCJAZSMhYGlOgQI1yfrwpRfCnNIqb+JBCt1Mx2N4U8vorlD0
         FDY1w0Neh0xfk1ErY/wQC70kl5CmojKosloDEqjNLa6zSAPbiY5V63vnIPxsoCHGBSIt
         rP66wSjY08cx2dXI60q6pBlD0u1cD4rKvT2s0DnC/vcelPtgnbW6H/dzVyqzMEPCrI1k
         Qfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685541828; x=1688133828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zgZNa9EtHrAIwO3wPspMKG7VOPoKw+bLM8tIqIzljU4=;
        b=eshkjrsxN4octetejdcirXTJqiNRfNZiGCylRBIniOmlf3tQDnssBNWurYt+MBrrHb
         ASZ5ibUYFroinq16+34l8MBkMeBEHH6Pug1q7ZRTsaYP2vK9gPVAdzrHa9MkrMJJvxhh
         PN7nnPZVxlDbksQWti2+yXZsPoLL7iAR+oBtMrmQYbAkegq8wilGXdb0OvF0/5AZLIYd
         jKqaUTHL6BkgqsCh5FbN/HrtEL4hefjTgWY41gxnXK6bnDKZBVAdLx5TAIMVucCO9el/
         Jrw3bycsLUp0a2aJyZSxzaG+vr0lxwM49J0KTXdTVmuushq9lHHSVDtRRpTha2lcqhdx
         djEA==
X-Gm-Message-State: AC+VfDxIBDMKhA7EDbfpyrNt44etqpNzPLxM6p0rc8C59qALYGws6t61
	SGm5X+D35XLs0gBLWhk/ZmsdMigcSl0Ca+Y=
X-Google-Smtp-Source: ACHHUZ6DEtgX4K6pdimvH3NmwoYvDCaDL753Abz2f/W5Qjy+z7CORXWoLXb2LvEYZj0nfLJnZLh7+T0qXaxZI94=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:3444:0:b0:ba8:37f6:a586 with SMTP id
 b65-20020a253444000000b00ba837f6a586mr3364248yba.3.1685541828239; Wed, 31 May
 2023 07:03:48 -0700 (PDT)
Date: Wed, 31 May 2023 14:03:46 +0000
In-Reply-To: <xAv635eVJdklAFBXcwxhVWRvgkMs37YDjANEArFkcOdoyH27NSHwbBGgJ6b9Q1EvX8gACiNqkaDYNvwdMWy6YHbeGM4qz1xW54-02UjzzZA=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <xAv635eVJdklAFBXcwxhVWRvgkMs37YDjANEArFkcOdoyH27NSHwbBGgJ6b9Q1EvX8gACiNqkaDYNvwdMWy6YHbeGM4qz1xW54-02UjzzZA=@proton.me>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531140346.3707802-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 7/7] rust: workqueue: add `try_spawn` helper method
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
>> +    /// Tries to spawn the given function or closure as a work item.
>> +    ///
>> +    /// This method can fail because it allocates memory to store the work item.
>> +    pub fn try_spawn<T: 'static + Send + Fn()>(&self, func: T) -> Result {
> 
> Why is this `Fn()` instead of `FnOnce()`?

That's a mistake. Good catch. It will be fixed in the next version.

Alice
