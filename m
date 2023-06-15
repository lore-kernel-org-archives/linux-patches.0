Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8E6625
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 03:52:26 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1a1fa977667so6039083fac.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 20:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686801145; x=1689393145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cb+dev0gi3mOMoRwFhsdS2OBBCly4pJkh/R4J7IbY+Y=;
        b=HMGneszKZx3DqzPLVRN595fUIlQMoOFQ2J56MaxufPmvXS0GSk7iYI/Y413o+U8WSg
         3m5z1Z7pA3YIuC9U+f7iTixOyu86MN6n6BFpoQGHM7MxYMcKi2QYMgjbEnIQtit7w5e+
         gVS3WQLbjd8+e52iDqi8iKlHgihvS59TvHn1X5CLif0MTYKiB7/4wn0H5He6nP8+z2VX
         HpqeNxJ2LkRDmYxHO5FOudd5jNTiMEkEDfCut2loLTffQ/54fU5pxQ598SuYZjbFMfTI
         aP0OJt7MX7iUNd1yjIx0NnvetMXGv7R5lkye6tLEu9Mpz9rxkGRhTl0Zycv2WELM559s
         CORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801145; x=1689393145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cb+dev0gi3mOMoRwFhsdS2OBBCly4pJkh/R4J7IbY+Y=;
        b=Mx+VVS40msh7rzEDbWhWaUi/NJDEqhmdVMMs7iCi5AuX1sZiSrpw22UEMe48hAq7Y1
         6VvF+Nya0lhGdxo5FwzovUi69NBHo3yV78kUIi6m960suRKK64TIQJNCTX3CA/WchX23
         X0YaTPUl42KRHDajTytFYYoMK3H/MLNjHsLxehDaGksuZ2EK0fSZ2h4Z/S7vgQy/8KZz
         mfBhwceChHo3VqD1MfyAA35RZHyQ7MGQkPej+mkp3o/smo/T7kbbkYFMvEMIrf34l+TV
         KSSGQOELqHeWASYC45PxicG05zbrVAfLAmprwCy+za8y5wzEtnmQSHQclxWChQiqPXvq
         57PA==
X-Gm-Message-State: AC+VfDy9nkbfpCrNVZ6KG7B5U+4Bniwm1ArGfMYFemolcptPv5EL2Yp9
	5Djsi4SPRIz3YSMczVYL92c=
X-Google-Smtp-Source: ACHHUZ6ObkR3NCdWKvmSDOzhkha4QMAJLH4kdLTv1KHz+3JqI8z5nQ/R2og8O4aQ3HTjlnYq808aOQ==
X-Received: by 2002:a05:6870:c355:b0:1a6:67e2:6ea8 with SMTP id e21-20020a056870c35500b001a667e26ea8mr10791546oak.36.1686801145472;
        Wed, 14 Jun 2023 20:52:25 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id g17-20020a056870c39100b001726cfeea97sm9606098oao.29.2023.06.14.20.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 20:52:25 -0700 (PDT)
Message-ID: <94de067c-e848-cc3d-406d-e9d7e14dbfd1@gmail.com>
Date: Wed, 14 Jun 2023 22:06:07 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/6] rust: types: make doctests compilable/testable
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
 <20230614180837.630180-5-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230614180837.630180-5-ojeda@kernel.org>
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
