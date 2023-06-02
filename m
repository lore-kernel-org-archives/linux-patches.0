Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE55E17FFE
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 10:24:30 +0000 (UTC)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-4f4f8b94c06so2516564e87.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 03:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685701468; x=1688293468;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Q536vrpXoLbpW1C6zFSYlWNTwScKe+fs0vNmAKc7wXU=;
        b=jT7/+uAamD3DLHz7oiaOZg0sQP1OAIuAhTDoJLae+Jt4QEkTX7WREA3ZPBcYtnFzHz
         h+o+tpdqA+JYtbSGDmUBqfDCS+zBpdeQvfGShi1mQQMXe2gcZG645CUBr7vgijDWvlcF
         ESyjD0nzAnO8LFCnOw9rudoGR7BOwJzDujFzBmMX/ssOTjFcCRt3k6ZhnW2Uq3Xj4VNi
         r8EL9XD6s7VP2KRfDTlIqNb42UgIaY/NvkearDZuBnIaUEVJIjWt7KFRqHRfhLAr0y1j
         hrK49NsIel0xZjvaHn01rtSQlfyICGZcjdlPncya7DgY8Uhu6B7qnH9pNXcUFEz8m4O0
         lpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685701468; x=1688293468;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q536vrpXoLbpW1C6zFSYlWNTwScKe+fs0vNmAKc7wXU=;
        b=mCNV6oLu+azrPYcb4e0RWifrZT3Y9eLcPgQL6xda7HItMnsKdwUoGpN+p4wESUpoEM
         IyhILgM57oDBi4oXjndIWRAFhrz7Tv8ceiDF/UcNPHYkltMTq9f6KC0IB9TJlhfyPAAb
         M7gUleVIY7gGmN1yGX2jFrjmfSkPIv0xZKktQ7JY+x86ycsNwRDMzNMZULWJCL6AAMic
         yD1ggBDqG8PFlE+4pTc0mg3OLDCNYe9nsFuYI6spLrMI9zoqE/r67c3kr31ueOSFe9/D
         V89exl7LwsvZXA0bMQnxw+jWNBk/sfzP/VrCsDOQUWsE3nce1ImUzwLyionMDfkIpyHx
         d9OA==
X-Gm-Message-State: AC+VfDwrjJm9TQGZhuxAn2/HFsFMysxxhrnqMcRTDT8DMCcfVdnjUSak
	jkXRJoUyQWNe73k91VZWdzmQRQ==
X-Google-Smtp-Source: ACHHUZ5uOxWjuD+Th59XeUlTguQfW9Gr2KdRw3X8oPchY9B/eGOj8lCOVC6x4lt8OsrILhj5hOOuEQ==
X-Received: by 2002:ac2:51b1:0:b0:4f3:9f9b:ad09 with SMTP id f17-20020ac251b1000000b004f39f9bad09mr1377240lfk.38.1685701468351;
        Fri, 02 Jun 2023 03:24:28 -0700 (PDT)
Received: from localhost ([147.161.155.99])
        by smtp.gmail.com with ESMTPSA id g26-20020a7bc4da000000b003f50e88ffc1sm5150674wmk.0.2023.06.02.03.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 03:24:27 -0700 (PDT)
References: <875y8geiye.fsf@metaspace.dk>
 <20230531140233.3707302-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev,
 rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Subject: Re: [PATCH v1 4/7] rust: workqueue: define built-in queues
Date: Fri, 02 Jun 2023 12:23:21 +0200
In-reply-to: <20230531140233.3707302-1-aliceryhl@google.com>
Message-ID: <87a5xi2mcl.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> Andreas Hindborg <nmi@metaspace.dk> writes:
>> Alice Ryhl <aliceryhl@google.com> writes:
>>> +/// Returns the system freezable work queue (`system_freezable_wq`).
>>> +///
>>> +/// It is equivalent to the one returned by [`system`] except that it's freezable.
>> 
>> Can we add a short definition of what "freezable" means?
>
> I don't know what it means, but I would be happy to add an explanation
> if you have one.

From https://docs.kernel.org/core-api/workqueue.html:

"A freezable wq participates in the freeze phase of the system suspend
operations. Work items on the wq are drained and no new work item starts
execution until thawed."

BR Andreas
