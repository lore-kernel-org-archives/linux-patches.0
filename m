Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB04C137
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:32:22 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bb2202e0108so1156608276.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 13:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686774742; x=1689366742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=G7nM3HJOnTFO/r9nAs3VZ8ncUNpyRX/dBLh4cUcJcmbenazk6RT3d0BY4kl05VgC7M
         hNG3l1eFIHZy0gEKps3DT5vySPcxIostlF906zTm9a6QCda+Q5I9tcCdRY8YWvhUYCUW
         lsOxSdJQJNcHDnkCz4F10A5UyoXfstoJTMP4CDGufudVQ0bYtp3EOIDQWs1ea1W8e2lO
         QIxDHcHSEKPBkMjJd96eewXi0JWcq53nWPUQ5+57RZZSBUkQyIVjvR1yEgLxFtsud9z1
         bS9oAGiiTJRrGkQXaK5TaTs/QZsSEcsG9PMfGSVuk52YwGs5GnAvb4usttTNRyYt2s4Y
         0hdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686774742; x=1689366742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=NS80HiF95D3oP7wmLUSBPJijn6YZ1ApGXDVXsYEi3RR1ZlMaz5P5GsCOEmLyZKsixU
         6HxTtzHP/F9Yjb5yfyH8mNsZgADedNj+ZuYnv8FjvPR22LTTNbK0PXPYexKbLEe2CSmX
         JXg/Ou8tIGyMvfb1WhdKOBz30JhcJRLmul/h57HJaHhN87qRngmsxBV36bFYSbEd6DLQ
         lI0XwqAUuTXzROEx6c8gVn0eNnKnYpWxF5FLJZ80PfEplWq3TsnPjiIwkh/OzInQM47V
         A+bzwaNDfkpcjQcaTEyaw8JITjdr1lqu/aq+PM5hHEQh6o1xlNvx1cL2JdWXSed792Ul
         kooA==
X-Gm-Message-State: AC+VfDyFEC1SgFT9Qn5WmdRjsG3c8VXqu2/ZnDGdBqO7gpdFsZv6KGEU
	A4yaCxGgIVKX0kpP+e+bDRspQN/Fcvj/+q4=
X-Google-Smtp-Source: ACHHUZ7nhMzTUUAXeFrCWZk+JOE1hhfH3uptvV1wMpqo0Q8CgtIthBnY4QgsVNVwEM46C0usmP5m88ATIWqIRW0=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a5b:d42:0:b0:ba1:d0:7f7c with SMTP id
 f2-20020a5b0d42000000b00ba100d07f7cmr460247ybr.2.1686774741924; Wed, 14 Jun
 2023 13:32:21 -0700 (PDT)
Date: Wed, 14 Jun 2023 20:32:19 +0000
In-Reply-To: <20230614180837.630180-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230614180837.630180-3-ojeda@kernel.org>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230614203219.2909087-1-aliceryhl@google.com>
Subject: Re: [PATCH 2/6] rust: str: make doctests compilable/testable
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

