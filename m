Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E5B15481
	for <patches@lists.linux.dev>; Wed, 31 May 2023 14:02:37 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-556011695d1so103174877b3.1
        for <patches@lists.linux.dev>; Wed, 31 May 2023 07:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685541756; x=1688133756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LkdmJU7MS1CA/Dj/0Gr76+y/wuVU2Ut+UYAk4XMq1Lg=;
        b=Ul62Teod+ZCunAd2EaQQxKG83SZcds9E9ARf6Guo7N40whc2dZSgIbAE/efE5+07k3
         6J8STcdoUa+bUIB5012q2gLmDiwH85tW8sZnC4zKBkPsfswcvG55+lsK8NU7nhTwjESI
         y+XhYHIYN8tNQHohIYV427qwc0uyQXSz+F/vrpiroQ+0WX2t1IYKHoTOGDsmJpMdDtKl
         M2XO1w/dieA+wC7EV+O7Pb1QnNcZPegV/y1rhq/zDznyxUsQPTRXAn2IOrEB9axqM6b3
         osENZfZYT9q6lZTWEFOfHmGlHjB81v0DYFQQr2RzPVDB68XIFPbNjZnKTb9+icmY9Suk
         lvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685541756; x=1688133756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LkdmJU7MS1CA/Dj/0Gr76+y/wuVU2Ut+UYAk4XMq1Lg=;
        b=ROjq1Hb8Mwa/r2/hszcpLs+OMeKLRxs9S/+PcJkK6+rQhqRj8cbfs3ncHnK4ecIyqo
         SeuRdvPdRmnQJ65a59FwZPMgrDaSd1+mo+doYSl6fjikuiwH5ODMorumQQ+7sMbVRAkh
         XdwTix1IR/2VyFlBHua+Cf+8MxTeR1Zk6J44uCFrVh659Cer5p3P5+bX6bBQdpcOo4WY
         AyVBFNPEIgQrhf73pyatozNhzc3dEkeQUgMF9RbpPpD9K3zfzCFta0aSJ+CVQ+49OJxJ
         u2tEw2olWPFkYcSE8SbQwVYVKm4uDa3ctmXG4tdVBXlgd7jlNlGENF6zXWbttfv6Ebz9
         9yvg==
X-Gm-Message-State: AC+VfDy6S1ApW9I2nG9fxNUvPmnN3pzFGKNbnB/DkienCXzA2TDFl/FO
	XoirxJ/cap5X5jrMgkOAO1hliRTjWjjziUQ=
X-Google-Smtp-Source: ACHHUZ50A+8qlR08pz8bSpq1xdjUBTlxwXtgKuxqeCBhz/sJHN7MEZ8M5JmPDryHbJli2rjh2e3mkYiU0zWrKlQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:af15:0:b0:568:ee6d:3364 with SMTP id
 n21-20020a81af15000000b00568ee6d3364mr1151085ywh.4.1685541756307; Wed, 31 May
 2023 07:02:36 -0700 (PDT)
Date: Wed, 31 May 2023 14:02:33 +0000
In-Reply-To: <875y8geiye.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <875y8geiye.fsf@metaspace.dk>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531140233.3707302-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 4/7] rust: workqueue: define built-in queues
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
> Alice Ryhl <aliceryhl@google.com> writes:
>> +/// Returns the system freezable work queue (`system_freezable_wq`).
>> +///
>> +/// It is equivalent to the one returned by [`system`] except that it's freezable.
> 
> Can we add a short definition of what "freezable" means?

I don't know what it means, but I would be happy to add an explanation
if you have one.

Alice
