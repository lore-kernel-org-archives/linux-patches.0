Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB4F33FE
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 16:02:07 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id e205so8118456iof.1
        for <patches@lists.linux.dev>; Tue, 27 Sep 2022 09:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ct18v3QfbaOt7CsF6ErcYqFs3nH5VotKpLqZ78HARmQ=;
        b=no1GeN48oclNXpvXOcJ3XM42s7G74QAfuxJUP2w9C5cuLEt1LA2InXaLu4/g7vE3Ah
         S/Mc2c6zxeOHl3MQFolYrdx35TehZqB+m2XkqpnZHNqrwi5umGImsOgRLLDhEMmJ6ix5
         qeuIUdoylQJ7AptS4+1rEN42XUXKncRc/qyo1TFhi6Q0KDwdAtuC5XFm02IRz9f+iAcx
         sEw/LaTx83SSMgttZk7rB8ivAe4XALo445n5UqTrJu3tSHxpkqdJOl5W6Zc+DO1pRwIo
         j2fZEMqxdCfiMO3AUliNZDWlSVzAxmAB9lJ4s9GqYvY0EH8pYHJ1JJ0Idmtjb+MQEjmv
         /mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ct18v3QfbaOt7CsF6ErcYqFs3nH5VotKpLqZ78HARmQ=;
        b=sVUqrtZYBfQsBHphiOIoJeBd1MjJWcQqeugOO+DwJROG0dCPk/3TsEpiq2hDfpOlhi
         1AZFgQXm4EFcv9seeaoeQnCKQxnojovFgO0cqkjaSBUFQm0hUHgy77KW3PKbA+YBtOuv
         Bt6uwYLG3mTDzZkaDfpaX+A271bGuPo7DnX/0iKy66ERF4VqCc9Too7qt1829fWN8eh0
         MHL4nmkO2bplZDiMpBedirHXL34ZwiPAsBdB7lkc4DtWRUjv5ZUVeXGzWNoAt+S06JlC
         MvaDQfzcsHvw66Le58bY1cGjcoitZPF5M6ByPetJUubyYZrgjwvwQI0YoAFYrNFDRAES
         kReQ==
X-Gm-Message-State: ACrzQf0wsFNb+qApYDu+OqzIZc6POJGWqcOIfp10a7dd/Rj5k9dAlFv5
	br3BtDScm4PSyQaD+SqIiKcMC6QehWPH+4OwBww=
X-Google-Smtp-Source: AMsMyM5odjm/1/sK9Q4u52UeI71zmJgkTDOy0C5e+aZtCOyOTsfGQ3g+oQ5ZaDNDjzLaBsPSyP2gSi2I+7blmm5gF9c=
X-Received: by 2002:a05:6638:218f:b0:35a:7f20:6a57 with SMTP id
 s15-20020a056638218f00b0035a7f206a57mr14587401jaj.186.1664294526531; Tue, 27
 Sep 2022 09:02:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-9-ojeda@kernel.org>
 <YzL/9mlOHemaey2n@yadro.com> <CANiq72kDPMKd0qLAMVrd2A3n9aAWhh2ps5DvKos58L=_V2-XwQ@mail.gmail.com>
 <YzMTH1v9yZQcujLa@yadro.com>
In-Reply-To: <YzMTH1v9yZQcujLa@yadro.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 27 Sep 2022 18:01:55 +0200
Message-ID: <CANiq72nkiOsAkr4oeBi-ohf12-JjvkQmb67s-G1L87pBS+FEWA@mail.gmail.com>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Gary Guo <gary@garyguo.net>, 
	Matthew Bakhtiari <dev@mtbk.me>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 27, 2022 at 5:13 PM Konstantin Shelekhin
<k.shelekhin@yadro.com> wrote:
>
> Sorry, my bad.

No apologies needed! Thanks for taking a look like in v8 and v9 :)

Cheers,
Miguel
