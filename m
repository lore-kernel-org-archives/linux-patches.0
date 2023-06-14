Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54B72EC25
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:32:25 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bd7f0e5df8eso1250106276.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 13:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686774744; x=1689366744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=rqUNnuSZmxyZA+3FLRLmQGXXAuPP+K6OhcSMkEMWjmz/+X0E9WWAWceF6qaPJbCEf/
         +LcOMoxwadWXOKYaeGEP5rRGpXeZIo2Ksngu9HPwa+EZT5o3QpyOEXoCV4P6jyxRyf4z
         yWVmZv74htbg2qR4hiKLnGjDsjcl3vWgVEkG1DzdRTsfbNLSgOcTuO26AXNwqwdXtcOA
         UeAJLb8lLD0tGurvvkXdA0mc9wvIPjhd6tj4jtVcOfnRz2vdzx++nU84LteJJPgzAW96
         UR/fgVmwczusNfVrjQz9DGIvzbZpSABZQs7RTDWi/j6hWmRIFZ6+FWkU5QfTKYLLs45R
         1Wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686774744; x=1689366744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=czEjt+NjAyuH0cAt6yqFee89woVRFsyvQrYC+0eGV9Y=;
        b=b0dN71hiMFmb3hzHMpoznU+mTsLOkQKRdoQZm5CbDyuYwFHmiwAGg1aqf185nC3SdO
         3L2CfRdUgYoslq3MylkQ2ecqsr1gJGb+BooNXMeRG7q37LsSj3pELuQWmfgsfA7RJNaE
         XqJ408goa7vNDIP9susNZV0hrid8tKml1ZH3IPobYpEbNRZXgzfk+LlOnVCaDyIjv8ds
         DYjBRnco5mbtMe4A/Ej1L/q6dk94zEkKxC5qQKoMnGnvGZzyA0vXYZn00hlIZ0I19S3P
         V2CGEoPUj8iKpkgboz5EdOc/Vb7kKV9tE1qEamUWllpZhwLDhZoiXLxuGfW6CUMeq3zX
         ObLA==
X-Gm-Message-State: AC+VfDy+TmHjQz2g2cEsQ/6BF7TvIL811bpwuGwSu94f71Fx7KN3o/ql
	TpGOmp3SluSSHaUE46zKpaji0D2BQlhrvXI=
X-Google-Smtp-Source: ACHHUZ4lKrCgpFpHSKe1jrlgkrwHsdQtUzGMLfno8/6282W4EFvNEysptvz1ncztZ8ndlqxGsU2He2vAPn/OwjA=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:5087:0:b0:bc5:9faa:24d4 with SMTP id
 e129-20020a255087000000b00bc59faa24d4mr482042ybb.11.1686774744749; Wed, 14
 Jun 2023 13:32:24 -0700 (PDT)
Date: Wed, 14 Jun 2023 20:32:22 +0000
In-Reply-To: <20230614180837.630180-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230614180837.630180-4-ojeda@kernel.org>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230614203222.2909418-1-aliceryhl@google.com>
Subject: Re: [PATCH 3/6] rust: sync: make doctests compilable/testable
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

