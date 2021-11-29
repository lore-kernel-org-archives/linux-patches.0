Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FE42C99
	for <patches@lists.linux.dev>; Mon, 29 Nov 2021 18:07:54 +0000 (UTC)
Received: by mail-qk1-f182.google.com with SMTP id m186so23854230qkb.4
        for <patches@lists.linux.dev>; Mon, 29 Nov 2021 10:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=deISSAFAJ1nMzgDcbCGf9bw6DHRyersoiS7211hhSTs=;
        b=ZeD0KrAwdNNuyo63GjpRcPpBlf2ymarlAo1aA9vvs33GpKrteszRvs0R9N3pNqjnYy
         L7T2dspYcPqmof15C3ayuCKd2jjzT1JXgfX2sRrn80LRhW+lrdGC4Bc06v5tAvnnTL0q
         b1KezBapExjxgpkZLj9YuGpp2SoaRuT1oyUUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=deISSAFAJ1nMzgDcbCGf9bw6DHRyersoiS7211hhSTs=;
        b=bquDKofC5l8S1tgZkyVnpJcccYRWGANetTK2kMf+EGfzuAkGKOMAjDIrohlteJKnUi
         L7rqopYWv6Z0NerQEwZbX3Nli8B/6n9CjMvb0/vfO6Xe8Lep2PR3iMz0PJOI90Ixn90w
         da5PjbzjjEMPCQCLy8HkO+hiLjPmgUiTPMNFjBI+K9xIo8HCoopjA3DJ8ogMHJcZmcdR
         23AnWEhMj6hw5tLDYiZoVXuor5lWYJ2G7nACnvfmwUuZ2JFpp3yrnpgC3F8A0ixT6zQN
         62fGnYbzsw1M3Er3jtFf4hFEplRNQvobq5MGurPy1AlHfEO3aVKYIn+LyjFDuTi6pBfw
         cYdA==
X-Gm-Message-State: AOAM533jfWkD3dHm/O8zpJqtbEA2p7lytVuMygKo7Zg4AhCbHdtNRCYI
	Ti/YwjH3enZkcACEl9n+kzmwFsaN2zs2eQ==
X-Google-Smtp-Source: ABdhPJxhfOy84LwZ7bybNkJL5axsrohuw7DnyTno6ZiMzoHC1YykTu1/RpmLM6fXvlzTfdcVU95Zpg==
X-Received: by 2002:a05:620a:404e:: with SMTP id i14mr9426835qko.111.1638209273141;
        Mon, 29 Nov 2021 10:07:53 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id h13sm9356951qtk.25.2021.11.29.10.07.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:07:52 -0800 (PST)
Date: Mon, 29 Nov 2021 13:07:51 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: patches@lists.linux.dev
Subject: Test delivery
Message-ID: <20211129180751.uzns75mrdq6zadjt@meerkat.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Initial message to start the archive.

-K
