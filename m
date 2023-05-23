Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756C61E501
	for <patches@lists.linux.dev>; Tue, 23 May 2023 10:03:34 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba8337ade1cso16592509276.2
        for <patches@lists.linux.dev>; Tue, 23 May 2023 03:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684836213; x=1687428213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lhbu9xWkX3wLR4lq6dHzqQfPPOyNOfH06YqwJA9yG9w=;
        b=4dGLh+H8/haGhmxxd255Mz98LoY9lbqlzhvIM0z5TVaS8s7iiloqpEQFQ2qP1Jt9PE
         zKpqTTulmUI/MWJQvFQXhUCnpdIaOpFNGdGvsPNhSJwihz3YaSDyHUCqKHELkhMuL8Hu
         +nSXeD+NZLAvNBHsHokuZd+gTNoQggLV7wIWR3U68CYwaFDMTli0094VK1HT++cFNryg
         zaBKyFBiBb7yJR1v0cAXkCSSTWoKOYUs8N6tfJ7RbJ2vk6ypbgOgDiANKcjZkoN2coRA
         p+JGDbr97LlwKRbllnPDz4+36UKAESyhAXUJpaFwHvg62hN6Ea4uP0p2RkC8LvTnIsVw
         m/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684836213; x=1687428213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lhbu9xWkX3wLR4lq6dHzqQfPPOyNOfH06YqwJA9yG9w=;
        b=EqVmtbD9gP1CSz8gs3zjSV+HvZQkd6n3CHE6UgmiDT6lp3yvh86HrhEvqXVXxDjY6Y
         K3VfMGUxMaEQVxhv9/cqChi8kym6RI0oxR8OsEdmfhGp009uBxeT4fLyMEMzPs9/hBCw
         ye+HlO/qclQHp1LzF5l7F+iPVZKVq3+G5KdKQqhSdCyni9liZ2FbZ37aHNk0RNMg7fEl
         +Y9Hv5jJZvzP1WsSs0qTPm29QUTO8RF6zXGncQWrXlZ+3tXIdPye2IBlJvcwhf8Hev/A
         aMmZj0P1KZfSpPPTlVDcHYqv7G651QblshqkzWRhB939YaNNwhREM9se7BPlb/DRjgfs
         ATtA==
X-Gm-Message-State: AC+VfDwq7EZ0S9d3Q7qSl+rez78b7XxlR8dFxsGorZ7JP62Mli4mfE9+
	pjheSV1/sYM8EwXafF7aDsi0oPRUcBY7FGA=
X-Google-Smtp-Source: ACHHUZ4NyfEHvy9cwuuqUdgnYfvSx3Y0xS9fHqMoUQEZs42xAAW/AgpB44Yzdmz7fLNz6YiTYLzDdVorZ13CiOU=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:d6c1:0:b0:ba8:17de:552f with SMTP id
 n184-20020a25d6c1000000b00ba817de552fmr5502594ybg.3.1684836213484; Tue, 23
 May 2023 03:03:33 -0700 (PDT)
Date: Tue, 23 May 2023 10:03:30 +0000
In-Reply-To: <beb2932e-7f16-e368-9cb5-edbe115fcb67@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <beb2932e-7f16-e368-9cb5-edbe115fcb67@gmail.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523100331.4070035-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 1/7] rust: workqueue: add low-level workqueue bindings
From: Alice Ryhl <aliceryhl@google.com>
To: yakoyoku@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

On 5/19/23 09:04, Martin Rodriguez Reboredo wrote:
> On 5/19/23 06:40, Alice Ryhl wrote:
>> On 5/18/23 16:51, Martin Rodriguez Reboredo wrote:
>>> On 5/17/23 17:31, Alice Ryhl wrote:
>>>> +    /// Enqueues a work item.
>>>> +    ///
>>>> +    /// This may fail if the work item is already enqueued in a workqueue.
>>>
>>> Wouldn't be worth to mention that, if not implied, the item it's going
>>> to be worked on an unbound CPU?
>> 
>> I'm not really sure what you mean. Can you elaborate?
> 
> I've meant that if it's good to mention that `queue_work_on` is going
> to be called with `WORK_CPU_UNBOUND` so that API users know about it.

Ah, I misunderstood at first. I thought you were commenting on the "This
may fail if ..." sentence. I'll go ahead and add that to the
documentation. I will include it in the next patch set once I have
looked at your other reviews.

This part of the next version will look like this:

+    /// Enqueues a work item.
+    ///
+    /// This may fail if the work item is already enqueued in a workqueue.
+    ///
+    /// The work item will be submitted using `WORK_CPU_UNBOUND`.
+    pub fn enqueue<T: WorkItem + Send + 'static>(&self, w: T) -> T::EnqueueOutput {

Alice
