Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99271B266
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 15:53:05 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso433275466b.1
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 08:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20230601.gappssmtp.com; s=20230601; t=1696434784; x=1697039584; darn=lists.linux.dev;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=hZDNFZC6WiTT02ULBJ6jIt5/1FUgLgt3WVljz4aDHFY=;
        b=fvtnk2pCdvKIGnkJq9i7dUQu4btl6IJZ7T557uIjRIq9h82XhvRiee9lpnyhqPgKUX
         VsyK/Ho1WC13U5RQQLpq7cLuP+Hj39NDAYjjo+Slujk3xWyg5u8v23pZD5hKrS5oFbFx
         1+2AYX8Rgt3kVEnUVxRrzs876azpBdceIYgn4JI4jhjIvXp8wjIAT3s62acdiSOvaymJ
         yCKwqzX4nKuGjdjScnI34ZMKAh19Nh1I3ovQlu0xivLpVbC2+00w8h1QHJfPdJ+0BrkN
         E2KeVlPb4FjxEzmZWYgu1fnWCDLjb8OJSz4DY6HR5zdBAR+6xTwo/KYZR68h80cD2vSp
         fzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696434784; x=1697039584;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZDNFZC6WiTT02ULBJ6jIt5/1FUgLgt3WVljz4aDHFY=;
        b=AulYL8Ze504hkf2KIe/ImO5jx7hiiHB5Bt81vAYON+bksVWW+d4hu/jo9EY+ukZ7Gx
         DJpZEE/eM1U1vn3tH1n+Kb03JnNFALrR2LyH6Je+QP1ijFu3/6lHnaqYmfpB+aGiZ1Yk
         MuGyK8fAIp7F31iVamibwqySeQiXySdHJ3+ri3G4nLe1GFq/bGAOxukVh5d32sMOMkwD
         z7ttckexKxwuokpXWXxwM/h2F+bWvrfI640CeM7vMdLsxiXa+8/DYXV+1cWuFT4uWhGq
         C6E9+uxCthO7btMO4hVfAGDMHYfGroSF7YOwePXXLs7Zytx+VHCHsuvH2WPsZsIq8lSK
         ZT+g==
X-Gm-Message-State: AOJu0YzK8wceSgiSakhkuc7cLRrTEVqJbAuJlqUTOs9LCgISqxohNYcF
	HAXRz/urUYwcr32zVTeApCtUcQ==
X-Google-Smtp-Source: AGHT+IHyhGmibidLlX+i+h3CeE+RkyvRJ1BmsD82yqONASQWydT4Q9HuIszDXGT+fFfHOEohePFpdQ==
X-Received: by 2002:a17:906:538f:b0:9a2:1ce5:1243 with SMTP id g15-20020a170906538f00b009a21ce51243mr2663645ejo.60.1696434783543;
        Wed, 04 Oct 2023 08:53:03 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id gh18-20020a170906e09200b009b27d4153cfsm3034424ejb.176.2023.10.04.08.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 08:53:03 -0700 (PDT)
References: <CVZ2KU4KK5YH.2HVL1F6X93YLL@pogg>
 <20231003222947.374039-1-aliceryhl@google.com>
 <CVZLU74VWMKA.GQXYH7WUNPS4@pogg> <ZR144pugIJQRAFjj@boqun-archlinux>
 <CVZQQCDA444R.KWA6OPEZRIBG@ftml.net>
User-agent: mu4e 1.10.7; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Konstantin Shelekhin <k.shelekhin@ftml.net>
Cc: Boqun Feng <boqun.feng@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
 alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 gary@garyguo.net, jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
 ojeda@kernel.org, patches@lists.linux.dev, rust-for-linux@vger.kernel.org,
 tj@kernel.org, wedsonaf@gmail.com, yakoyoku@gmail.com
Subject: Re: [PATCH v4 7/7] rust: workqueue: add examples
Date: Wed, 04 Oct 2023 17:49:30 +0200
In-reply-to: <CVZQQCDA444R.KWA6OPEZRIBG@ftml.net>
Message-ID: <87v8bm5qqp.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi,

"Konstantin Shelekhin" <k.shelekhin@ftml.net> writes:

>> This is not a problem until nvmet actually uses/switches to Rust, right?
>> ;-) We can certainly improve the API when a real user needs something.
>> Or you know someone is already working on this?
>
> Nope, not at this moment. I have an itch to experiment with Rust and
> iSCSI, but that's my personal toy without any plans to at least propose
> it to the subsystem maintainers yet.

If you are so inclined, I would suggest you take a look at the blk-mq
bindings and the nvme (pci) [1] and null_blk [2] Rust drivers. I am
available if you have any questions!

BR Andreas

[1] https://github.com/metaspace/linux/tree/nvme-next-for-6.6
[2] https://github.com/metaspace/linux/tree/null_blk-next-for-6.6
