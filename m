Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721AB4A3B
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 11:30:37 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-99bcb13d8ddso221955866b.0
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 04:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692617435; x=1693222235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HA8dqby1nZ1fwOUv1l3IML+MlLZiMB2vRjvmhbRkLTM=;
        b=xFql09yay+vpn1dg3gZEY3KE44Qe4Q/3kWxh7GyZ/ReG01cKaillbXT0sDqGyG0kXC
         eyj8ynoiBP9qwGdEitsJ+fVFgEfscB9Z05kNn2bShiy+CpGo2cjGJ4lZ2sKVLFbUrn5O
         YnQuYOxIPiAKxKM0kVvRJIXoWli7+a5uVDTOJI9uTIlFtXa1fsanqMsd/pKjFHICV9zo
         Im6uhpT9jdqjId+YclvpI/Mae1olkLxA/Ec+3g8Kax5tnNvllRdPAU+tHIUihQ3Em2df
         Q2q8kFimywGW3EJFpRuM9SSlfmXEZtIgQmQkVypXhoasIbjtRUE9u5WlkayIcKwOou4u
         R4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692617435; x=1693222235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HA8dqby1nZ1fwOUv1l3IML+MlLZiMB2vRjvmhbRkLTM=;
        b=UIxUlzjgWq/qoEzSLZiDYwTMeChXMCwSx0BRhEBSIJR4ESwwSLI/vtUyRS8UcN9ypu
         DXRpU0TakY26fJkpxJ08ibu3S0ln5RTHjI+7QsQN62h6BOq7nhoBRtqDXMh/3riiZn4c
         hbiyGtSRqLTA3KwxrFTekX9bVp0MEaP9tY/uWHNLilL/CXx3dE02yvy/86cWwEHD1kyZ
         WLQjIxfdm1Wce4yjy2hF1WlQBqOQFHluYa4oJZNMxxI/Nxn6QMo9p/gQYol6MgydsPsU
         oWA2nW2DXNiobSCIVmk2P2lKjBT/FQOCYWP6gyoOpC4UcUhyheaEj7iaXDGVXdawswkH
         XDhA==
X-Gm-Message-State: AOJu0Yy3zzgoj01jPppZXxzn22J++5Q12F7AjMkxxLPiHUws9aDPt29d
	Yk/JfDMQepnzYr6s3R0Z2qfweLk1JlFDgNI=
X-Google-Smtp-Source: AGHT+IE1swuyoYJXn3wCV2WuJ+6CizH2g2W/p4ht1wxk7+OSszBp/ZO7oL5XOH70/Fs+Eala1K+zuoPWBDu5YRs=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:cb2a:b0:991:c35f:ad54 with SMTP
 id um42-20020a170907cb2a00b00991c35fad54mr20902ejc.7.1692617435468; Mon, 21
 Aug 2023 04:30:35 -0700 (PDT)
Date: Mon, 21 Aug 2023 11:30:31 +0000
In-Reply-To: <20230814084602.25699-14-benno.lossin@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230814084602.25699-14-benno.lossin@proton.me>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230821113031.1498685-1-aliceryhl@google.com>
Subject: [PATCH v4 13/13] rust: init: update expanded macro explanation
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, linux-kernel@vger.kernel.org, 
	nmi@metaspace.dk, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="utf-8"

Benno Lossin <benno.lossin@proton.me> writes:
> The previous patches changed the internals of the macros resulting in
> the example expanded code being outdated. This patch updates the example
> and only changes documentation.
> 
> Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
