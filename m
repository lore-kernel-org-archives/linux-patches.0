Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5487033F6
	for <patches@lists.linux.dev>; Wed, 17 May 2023 22:22:23 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-510d1971474so1178928a12.0
        for <patches@lists.linux.dev>; Wed, 17 May 2023 15:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684362141; x=1686954141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qCQ3NjxZoebSIAtGeHR5p1IA6stp8bUJIlG4AwU4skw=;
        b=4vgsoY+5jg02OmnaPeEWdmac9MQv5QgavqYYTecATI2iI4NboNWkxSh2nzbpk0VLCQ
         1P2DkeGOfUT2Qp1xK7LPXfGpmW0RrVlmiRL59/wUEXcyiBT/N/6NWTeQk+lyuGlbeKoc
         P0Kt5+RNnAgHuUe8PxnnlnmAoSdBMcdFPEywkmBUKz61dRhfUK1efGsDLggM0K2E3sPw
         5egtqGedMvFnjHxzdyzRXcKon5hhGc7ajk4WplTzQvh6KqLqmnPgShi/AU9TqabaWiUE
         5TSBzXNr6sg8rs0q4jDdHXHYfA+lQ6I/aq25oRpOlqjYLO5UQJrgUEIrFSNBxA8nmTkN
         tfzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362141; x=1686954141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCQ3NjxZoebSIAtGeHR5p1IA6stp8bUJIlG4AwU4skw=;
        b=WCbuZFG//Y3Nbs/GU3nniYWQf5vTF+5PEBclgSyWP6So4dsQ60vFhECsLuoKnCppOs
         qzAEdWRBMoLMArJ8BPIM/3yRCcikMkj5bsmE2pcNOpKuwTVwwlcLXqKCGZYx0RRNpbIg
         EghNQmpmG0maRbHB5Jtmm1GBp5SOcRIuv8dYo9HuwLY4hrqQz5laWESE1uxJjhXSarbf
         en/jN24DmSMdZ5fqwdGne0rPmcLRT1jT0wcwG2FalX+I/hcwmoIfMSC6U1SbbHVEsNCK
         bK/emjW110hzVcjGpwGrPIdTTXvRmV3hOEkovs/lyuTnxYJiv4kiI0zFqDkb70IXzNDG
         mKQg==
X-Gm-Message-State: AC+VfDxoQAPTEPus1lnTMdZbioMGitvvJZ6eFrPDEP0n+OvRdclJ9km8
	O9JdmG5StBALfzBagQag6/FqzyKlTPErGLo=
X-Google-Smtp-Source: ACHHUZ4ZH2KINwV3iFH0MzY+AxxyQSTIb3TM0RL+58yOgF2J8k82d22mDFv8B5Y8f2a6F3opNfUG8p8xYlA9gss=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:d09d:0:b0:504:8731:4ef2 with SMTP id
 v29-20020a50d09d000000b0050487314ef2mr1612484edd.7.1684362141496; Wed, 17 May
 2023 15:22:21 -0700 (PDT)
Date: Wed, 17 May 2023 22:22:19 +0000
In-Reply-To: <ZGVLo1V4kjx_lep5@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZGVLo1V4kjx_lep5@slm.duckdns.org>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517222219.3191560-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 0/7] Bindings for the workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: tj@kernel.org
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 May 2023 11:48:19 -1000, Tejun Heo wrote:
> I tried to read the patches but am too dumb to understand much.

The patch is more complicated than I would have liked, unfortunately.
However, as I mentioned in the cover letter, simplifications should be
on their way.

Luckily, using the workqueue bindings is simpler than the bindings
themselves.

> Any chance you can provide some examples so that I can at least
> imagine how workqueue would be used from rust side?

Yes, of course!

The simplest way to use the workqueue is to use the `try_spawn` method
introduced by the last patch in the series. With this function, you just
pass a function pointer to the `try_spawn` method, and it schedules the
function for execution. Unfortunately this allocates memory, making it
a fallible operation.

To avoid allocation memory, we do something else. As an example, we can
look at the Rust binder driver that I am currently working on. Here is
how it will be used in the binder driver: First, the `Process` struct
will be given a `work_struct` field:

#[pin_data]
pub(crate) struct Process {
    // Work node for deferred work item.
    #[pin]
    defer_work: Work<Arc<Process>>,

    // Other fields follow...
}

Here, we use the type `Work<Arc<Process>>` for our field. This type is
the Rust wrapper for `work_struct`. The generic parameter to `Work`
should be the pointer type used to access `Process`, and in this case it
is `Arc<Process>`. The pointer type `Arc` is used for reference
counting, and its a pointer type that owns a ref-count to the inner
value. (So e.g., it decrements the ref-cout when the arc goes out of
scope.) Arc is an abbreviation of "atomic reference count". This means
that while it is enqueued in the workqueue, the workqueue owns a
ref-count to the process.

Next, binder will use the `impl_has_work!` macro to declare that it
wants to use `defer_work` as its `work_struct` field. That looks like
this:

kernel::impl_has_work! {
    impl HasWork<Arc<Process>> for Process { self.defer_work }
}

To define the code that should run when the work item is executed on the
workqueue, binder does the following:

impl workqueue::ArcWorkItem for Process {
    fn run(self: Arc<Process>) {
        // this runs when the work item is executed
    }
}

Finally to schedule it to the system workqueue, it does the following:

let _ = workqueue::system().enqueue(process);

Here, the `enqueue` call is fallible, since it might fail if the process
has already been enqueued to a work queue. However, binder just uses
`let _ =` to ignore the failure, since it doesn't need to do anything
special in that case.

I hope that helps, and let me know if you have any further questions.

Alice
