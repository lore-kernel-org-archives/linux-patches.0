Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF387463
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 21:02:13 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id o2so11500053iof.8
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 14:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=p3kmNNco7c5N9PybUED/NbqPmlZIv5vlXMEqlV8OmdQ=;
        b=C7kohQheIdzIJnlgySCXNEt6bVBDKy83LAC7rreH4sxDFVRECxS6/TsYYeNbWZtesr
         mwXTw/MpURGTNBNibQcNIeJyuD68cTxvE7qcHjxbyLObfmmaeItob6P9/9/FIOVoJQFN
         P4Xmsb/pw8PP7j025oQycBMxP8wqrLAGuBTi7HLJEDFz+RW2Y0c+PGZTH8Wn/t23R+BR
         /PkxN4dHikGFN3Qo5Z5empcUB+7lzxnZuef9EG+LrMZlKRbeXP7RfZohANNfeGc3AUmX
         0uGRcACxIsMT+N01dCQeUkL8driuuyuAngkQpo5sLK8AyzcDQr4IiWAZLqy1k7JCsszg
         E4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=p3kmNNco7c5N9PybUED/NbqPmlZIv5vlXMEqlV8OmdQ=;
        b=c7H7OvaHWjBbTW+exIlDo1R6BC/e7hv31W5ah/M2SbzKYohedC3hNiP6bFdizMrtAf
         +G6OlaYiJYefd7cz8B/0XTfrDUJ6w4+ciNfbGpjaOgtH3svtM/3jd9zxkUiZhQ94S/4z
         Pt84U/irkZ1VOdGhjbHOJ6Z0/9FySnTw2zsXaRtY7QBdr3zNWvF0w3d+Q/0IonyAL2+0
         jtnC8mPvoefAaBghcJSTrB2i194EtH+XdoMpqW+WGafgHFm35Liqin2OOzhsKYJD8PMC
         idoU6pvdoHUcyopELDN7VxAEZC30ZAy0Thr4d1k8bXP1vqODE6D3PdotofhvItxjCkkn
         uPNQ==
X-Gm-Message-State: ACgBeo2S46Qg7dERx21Md6A8ow/sJTAxv5rXHn0d6eH1db+OYxMf5M9R
	/GfnYQfd1D27mLk1uKB8P/YmSSjLYwnlXm8MEG8=
X-Google-Smtp-Source: AA6agR65LjBBgIfnMKzM25ANX/JHE6PHDf9A7mmgpChiz+NhwUHhbZcTvCT1HrVeT3DfvlnuKEXI17eEpsbYn5AqYJA=
X-Received: by 2002:a05:6638:4117:b0:346:b5e1:383a with SMTP id
 ay23-20020a056638411700b00346b5e1383amr33201jab.264.1660770132624; Wed, 17
 Aug 2022 14:02:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-27-ojeda@kernel.org> <Yu5pUp5mfngAU7da@yadro.com>
In-Reply-To: <Yu5pUp5mfngAU7da@yadro.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 17 Aug 2022 23:02:01 +0200
Message-ID: <CANiq72n029==Oc5wbG9pHGrRawRNzYxqZMBK6_S5gMjny5SoQg@mail.gmail.com>
Subject: Re: [PATCH v9 26/27] samples: add first Rust examples
To: Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc: ojeda@kernel.org, alex.gaynor@gmail.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, gregkh@linuxfoundation.org, 
	jarkko@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, me@kloenk.de, milan@mdaverde.com, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	torvalds@linux-foundation.org, wedsonaf@google.com
Content-Type: text/plain; charset="UTF-8"

On Sat, Aug 6, 2022 at 3:15 PM Konstantin Shelekhin
<k.shelekhin@yadro.com> wrote:
>
> I wonder if it would make more sense to implement exit() in
> kernel::Module, just for the sake of uniformity.

Do you mean uniformity with respect to the C side?

Thanks for taking a look!

Cheers,
Miguel
