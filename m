Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2072D2E1
	for <patches@lists.linux.dev>; Thu, 23 Mar 2023 20:49:57 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so3309488pjt.5
        for <patches@lists.linux.dev>; Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1679604597;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M1Uul858JFOc4slgtlzEor7kzW5IkLa0my4yRuVlvyQ=;
        b=ZCCwxjIDJyAzWKJ4Dm7q8drS9iIvM0hjIlFZuu891sZNYdObjxpAQMuckoUN5NAbod
         YfsEbbaDONhPM7Gqjse5lp2T7AWHg/UwjE0efOKZ4M7QsxrkVdTLfGl+nkQQ24U00u7b
         AhurTzPzIu3NZmfHmSWY4/Lmk6XJR0rEqc1iG0IwRBBoYzIIv0bSfHVeo9kRvaHE2r35
         WwHqt2/1RqKrwGMlkg1jn2UTCxtk2tgjsliotC+l2fhl9KYskZlkSf4gmIvuROsrdi+6
         XJGvqHr0+DRJST5E/4OLo1B3GMd6YPsqe31xigKppOA4tAqZcwQo6K5v34F/DmvscknR
         zJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679604597;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1Uul858JFOc4slgtlzEor7kzW5IkLa0my4yRuVlvyQ=;
        b=krlDO/a88QAiP25KwB1bJwL/bduV/jhEqF5uvrLMqKhm8a+sLKLfa7jwlw/d+id1DS
         szSfboPMHgFka75aEvHXAIEZ7bQOAAKk+r7dQsemNH1ENSSAi0nJ7L2cMnkiBZI/EC1D
         6ckFLew66xUAUn3d/6NPyWPQ/nMl8ofv08OMGFm/ZGYNwAykbh4adWcyovK+LiOjIQbE
         NJjG9FWWsThqtxneEEDFtzean29QI1D2eVi8rfYDs5dSXXNETfhq/Xa1aZ5o/k5hcmA1
         ccTK0UyK4zxC083oN2Yj7LfDISophHXSy/tJ69JXdDVjckL9uGmZBi4KoTDcH62ZUOj5
         sEGg==
X-Gm-Message-State: AAQBX9f24u1aWa6GtSMA1WfZ/PE86/bxx7QYfm3WX9MFdeXuFBcEVODK
	SOIBmP+fzpG/WOvBf0jcMuDG+J0OIPqhyATTxhM=
X-Google-Smtp-Source: AKy350Zr1GRzGFoiPnXthakhzlVrWQ27tcYR20J9buwGWiDH1AccoQsn0StymwoAZeIzzNdJrKdc9w==
X-Received: by 2002:a17:90b:4d81:b0:23b:3422:e78a with SMTP id oj1-20020a17090b4d8100b0023b3422e78amr372422pjb.6.1679604597027;
        Thu, 23 Mar 2023 13:49:57 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902789200b00185402cfedesm12757133pll.246.2023.03.23.13.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 13:49:56 -0700 (PDT)
In-Reply-To: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
References: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
Subject: Re: [PATCH] riscv: Handle zicsr/zifencei issues between clang and
 binutils
Message-Id: <167960451913.18089.10045388605224266027.b4-ty@rivosinc.com>
Date: Thu, 23 Mar 2023 13:48:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-901c5
Cc: ndesaulniers@google.com, trix@redhat.com, linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
From: Palmer Dabbelt <palmer@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
  aou@eecs.berkeley.edu, Conor Dooley <conor.dooley@microchip.com>,
  Nathan Chancellor <nathan@kernel.org>


On Mon, 13 Mar 2023 16:00:23 -0700, Nathan Chancellor wrote:
> There are two related issues that appear in certain combinations with
> clang and GNU binutils.
> 
> The first occurs when a version of clang that supports zicsr or zifencei
> via '-march=' [1] (i.e, >= 17.x) is used in combination with a version
> of GNU binutils that do not recognize zicsr and zifencei in the
> '-march=' value (i.e., < 2.36):
> 
> [...]

Applied, thanks!

[1/1] riscv: Handle zicsr/zifencei issues between clang and binutils
      https://git.kernel.org/palmer/c/e89c2e815e76

Best regards,
-- 
Palmer Dabbelt <palmer@rivosinc.com>

