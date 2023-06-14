Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713DB6D3F
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:32:20 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bb0cb2e67c5so1263531276.0
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 13:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686774739; x=1689366739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=7qQ2pRRFtJkkGsek6sI8eGIYh2kDVCgIhOHYHltdTmoejySFVhUOI2O+RzdgHUO8St
         DXjUfgph8ErCl0t8k2ZLDkvsaImXoSGboFkpiSNGgCRT6iPw62D0vVVVniU5U9wAzR9H
         zyOpluP2dekBZc94GvHRFyYnDGrmFyTP7mG300SoiX/TsgiH0M59+v3YCw5Na20/LrGs
         YB+9OWXe++0WDbleOpm82V21RhXRmbZYBapRl/mBeNCnlLmEuLlgtZXMp1LVw4jVcVUU
         TqjluAZsA6qWCAlDlayrX3ufyhk1147CBOckGTXvLTg2DrpKExSDZAoeK2t/uOufYl42
         gxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686774739; x=1689366739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=N8LER5OQpFqScjHhK9MtDpV/BDU9rGcDUA1XH3Q/W6w27VFsL0Xj8brR1N3+0xuc+W
         940qtb6r2n5Uz3EGld9vfSyiaFYahiRGW2BdByIVTeUMQXd/xU76DFzSeMx7fIf6QzBF
         g1GUtHlYkM/M9b2Z85YLZFm+k+26sh9F5En9vloN1Lsm4XDRHtcywyBJHssvOMjips3E
         l8fk5cxg9Db1ubP8UeANOt72CyUYsyzCBeJ5saXcFXWL6HriTDOGDsaEtZZsXMLIpSqD
         W2El6rWBuCW3nedsoItAWgA5XtcDT4ZzYoNqtSbK06QXhCCvfdJQLey9Rp/9/WSWHfXX
         9KFA==
X-Gm-Message-State: AC+VfDzHdj0QQlCsR8BucEopjbxwFApTxZVZwvQ0HUWaNXIbkcOf2PVA
	z+mRJVDSRVOLg4kRsCVH+iyJa4jThtwWRzw=
X-Google-Smtp-Source: ACHHUZ7N8NjzbORsY8P9yrlGMhvoX5EEo5wu8Kwz9gBGRafQS4YZfEO18H1Pw0V9rig7JIuYUAUF5fTWR+r6qYs=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:d54:0:b0:ba8:2e79:c193 with SMTP id
 81-20020a250d54000000b00ba82e79c193mr472122ybn.12.1686774739295; Wed, 14 Jun
 2023 13:32:19 -0700 (PDT)
Date: Wed, 14 Jun 2023 20:32:16 +0000
In-Reply-To: <20230614180837.630180-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230614180837.630180-2-ojeda@kernel.org>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230614203216.2908753-1-aliceryhl@google.com>
Subject: Re: [PATCH 1/6] rust: init: make doctests compilable/testable
From: Alice Ryhl <aliceryhl@google.com>
To: ojeda@kernel.org
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, gary@garyguo.net, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	nmi@metaspace.dk, patches@lists.linux.dev, philip.li@intel.com, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Miguel Ojeda <ojeda@kernel.org> writes:
> Rust documentation tests are going to be build/run-tested
> with the KUnit integration added in a future patch, thus
> update them to make them compilable/testable so that we
> may start enforcing it.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

