Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50B4625
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 03:52:20 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-39c82204e62so4186598b6e.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686801139; x=1689393139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cb+dev0gi3mOMoRwFhsdS2OBBCly4pJkh/R4J7IbY+Y=;
        b=hevgJyNa92SUhRA4jSL4apc9un7ooERZR6KZUDIGuQ555+v5l9VIy1ZaddPfH5Lpoh
         HOjPiQig0uZ38Bp4MnQWRPUU/4VBl2xLHCWqituJhvHx1VvPMEt7VgTmVSESZjrBddYY
         ag8/FkWyxiINE6286GWL4fKk1dldIHOBfCO+pQ7F3w6JUu7p55QiXAGAqfeqOWwYGE0y
         /2wLpTMPlnuLDwHWil2qzMvyy1JeKS/VtiQIety5QsEeSa+AJcMV4HwaSZHVkr+ECk92
         VhQ0+KOviNI3N1PL7R0skiklRE3KrJfhxm3BaaaZ7mgMD4gwLxBrmOAjNHXJkzrXrDmN
         Uj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801139; x=1689393139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cb+dev0gi3mOMoRwFhsdS2OBBCly4pJkh/R4J7IbY+Y=;
        b=Ij4Ql33DCFI+IB/4hbYLk/grlM1ILFIGrbmpD8zzDMHVKTV948Fj3pjoCwxU14R4+D
         TpuDUj+wYDpr3CY/JBlYwOPvoKHXSYLV/oBuLJYeFSQgcIK6iwuvRThSqntJ/azvi4Hl
         eclhyObQ79YhjbB90EUU2/vLLOAsORhrhQUbWakATSu/noDaD4Xgb4lxJ1HkFl+1ZOYv
         rfNnkMrWrI9DxAe221RhG5F8znGKPKcmuyBva1Bzxt4qZfZwOcHGvZyQyPkYLJ2xd72G
         K/h9pBrl7ihOzNrrvt/O5buXaot66rbVWUpvUeNN4FhQgnEDXzqiPDtFzdCzc1GyweQN
         +t8g==
X-Gm-Message-State: AC+VfDy3i66dkZ1RgFx/4bZXF+jXxvHiaYEo4oSFXoBr3kng/WoIqjH+
	XBdi2WgUUbE2AYEqQwd0Yb4=
X-Google-Smtp-Source: ACHHUZ6TBgwkoBuExJECC3LHCYuqlfHoGKSK1w1caiD/ZoHx9m2PFGtaZJjverxSgFIrVruuYYLyWg==
X-Received: by 2002:a05:6808:1119:b0:39a:98c3:b9f3 with SMTP id e25-20020a056808111900b0039a98c3b9f3mr10023523oih.41.1686801139612;
        Wed, 14 Jun 2023 20:52:19 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id j189-20020acab9c6000000b0039600e3376asm7042303oif.1.2023.06.14.20.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 20:52:19 -0700 (PDT)
Message-ID: <0cfe45d9-74f0-c198-0fb9-74d24d36b621@gmail.com>
Date: Wed, 14 Jun 2023 22:04:45 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 3/6] rust: sync: make doctests compilable/testable
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, David Gow <davidgow@google.com>,
 Brendan Higgins <brendan.higgins@linux.dev>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>,
 kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-4-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230614180837.630180-4-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/23 15:08, Miguel Ojeda wrote:
> Rust documentation tests are going to be build/run-tested
> with the KUnit integration added in a future patch, thus
> update them to make them compilable/testable so that we
> may start enforcing it.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
