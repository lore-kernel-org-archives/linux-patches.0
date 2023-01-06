Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793995DE
	for <patches@lists.linux.dev>; Fri,  6 Jan 2023 21:11:04 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id q7so1188814vkn.3
        for <patches@lists.linux.dev>; Fri, 06 Jan 2023 13:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6TxHKlwJQCLSbYZxgdJdZSJ5mNfa7xbEinv+9m+b8dU=;
        b=JkoJF2oW8oodyFdhhEZiE+zCQjJRSe8qbnBn4Ts4FFiwa0sekyPhwMSBKHbEAYUHQ3
         r06xF755O1aHQhg/uNyi+N/5KDBJ+uaAZmpigEg23rzOQ2HcFrMDLG9jJMUNcJHfKiAj
         dE34EO7JXggOKr+Oq4bXZx2m6WRZXthUX8U5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6TxHKlwJQCLSbYZxgdJdZSJ5mNfa7xbEinv+9m+b8dU=;
        b=Cvra6487lVLGyZFLL0FLIQsel1A+zKqo0jBiFYhvl5TwKVb7dVK+afFC1AvCpwqYgy
         MiEx77kxNc1cJFF67KYRS8Zx+q2Ozews9EVOnLzknSU4mGSkDBkAm1Sz2hgPEFsoAf5a
         nH2ceeHIIwmbhujCnb3go49asv9qu2LdTIBes5XD2qfi/kG0KEcPdAo5vh2Z5Ojnzcuv
         hiWL9mrZy/AZQ17yllDWx9zQdOZ/E0zgE1gL5VKrRAYHz/nDyI10ndFHeIUi5sKVTCgg
         jYCJsqwhyp7yumzqMRyQEhPS9zb6PmzOcFVVG8J9Rwm6OaRrvKoNMgA+q+lj9GrAtE57
         E9cQ==
X-Gm-Message-State: AFqh2krpB77K+eXEMlIEwldUDZNuTUgRje2Hfui0rN4ns0qZWsOVZvMr
	hStC1w7Vb+JoYjFn/PjTErwUS7vh1Md6nGnt
X-Google-Smtp-Source: AMrXdXtyUu6QkFWOKQHCw6nOTA4BYcY00RsxGOnhIt1gzwq64Pq/4AgHtO4sUamj3jv2WGF42k21cQ==
X-Received: by 2002:a05:6122:4d:b0:3d5:ec83:511c with SMTP id q13-20020a056122004d00b003d5ec83511cmr9226435vkn.12.1673039463736;
        Fri, 06 Jan 2023 13:11:03 -0800 (PST)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com. [209.85.222.178])
        by smtp.gmail.com with ESMTPSA id d12-20020a05620a240c00b006fcc3858044sm1155496qkn.86.2023.01.06.13.11.01
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 13:11:01 -0800 (PST)
Received: by mail-qk1-f178.google.com with SMTP id c9so1342219qko.6
        for <patches@lists.linux.dev>; Fri, 06 Jan 2023 13:11:01 -0800 (PST)
X-Received: by 2002:a05:620a:4720:b0:6ff:cbda:a128 with SMTP id
 bs32-20020a05620a472000b006ffcbdaa128mr2770302qkb.697.1673039460720; Fri, 06
 Jan 2023 13:11:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230101162910.710293-3-Jason@zx2c4.com> <Y7QIg/hAIk7eZE42@gmail.com>
 <CALCETrWdw5kxrtr4M7AkKYDOJEE1cU1wENWgmgOxn0rEJz4y3w@mail.gmail.com>
 <CAHk-=wg_6Uhkjy12Vq_hN6rQqGRP2nE15rkgiAo6Qay5aOeigg@mail.gmail.com>
 <Y7SDgtXayQCy6xT6@zx2c4.com> <CAHk-=whQdWFw+0eGttxsWBHZg1+uh=0MhxXYtvJGX4t9P1MgNw@mail.gmail.com>
 <Y7SJ+/axonTK0Fir@zx2c4.com> <CAHk-=wi4gshfKjbhEO_xZdVb9ztXf0iuv5kKhxtvAHf2HzTmng@mail.gmail.com>
 <Y7STv9+p248zr+0a@zx2c4.com> <10302240-51ec-0854-2c86-16752d67a9be@opteya.com>
 <Y7dV1lVUYjqs8fh0@zx2c4.com> <CAHk-=wijEC_oDzfUajhmp=ZVnzMTXgjxHEcxAfaHiNQm4iAcqA@mail.gmail.com>
 <CAHk-=wiO4rp8oVmj6i6vvC97gNePLN-SxhSK=UozA88G6nxBGQ@mail.gmail.com> <f36f19ee-5bff-4cd0-b9a9-0fe987cf6d38@app.fastmail.com>
In-Reply-To: <f36f19ee-5bff-4cd0-b9a9-0fe987cf6d38@app.fastmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2023 13:10:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgLWcKq2AdrTmTOxJKn6w4oEpEGdipWAah5Xad5-Yii6Q@mail.gmail.com>
Message-ID: <CAHk-=wgLWcKq2AdrTmTOxJKn6w4oEpEGdipWAah5Xad5-Yii6Q@mail.gmail.com>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: Andy Lutomirski <luto@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Yann Droneaud <ydroneaud@opteya.com>, 
	Ingo Molnar <mingo@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	Thomas Gleixner <tglx@linutronix.de>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 6, 2023 at 12:54 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> I'm going to suggest a very very different approach: fix secret
> storage in memory for real. That is, don't lock "super secret
> sensitive stuff" into memory, and don't wipe it either. *Encrypt* it.

I don't think you're wrong, but people will complain about key
management, and worry about that part instead.

Honestly, this is what SGX and CPU enclaves is _supposed_ to all do
for you, but then nobody uses it for various reasons.

               Linus
