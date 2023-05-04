Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBC37E
	for <patches@lists.linux.dev>; Thu,  4 May 2023 12:40:35 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-38eb2984c82so148287b6e.0
        for <patches@lists.linux.dev>; Thu, 04 May 2023 05:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683204034; x=1685796034;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=35PE1h4pn1H3d9SWO+8b0I5Y/uShSGFf9sil//g3S48=;
        b=HO2Mrqz66zmORlnliP7P/qqLTd7aBsXSFdRsEd9qam/1QTKL+5Id65vN4S/svCm6HN
         m/sycne3kjRoy0ScrIFGrqQ9yZWnVrhTBan7e2BBuxcbMzvOTNs6evdO4v8Vo13l55yp
         FTVtKuNsUCvRJnzEO3IlicLkpcaIwe72FlKVTKDf8K/m4RmVC2te5AXXGjA4xQFeqCud
         TVNUf6KFcWQ9lQ73h2ZGriwNXQOTVAT4VXU5jnXRirUldThOvLuVzUu/CQXkUuYRCG3U
         vQtGHcoZw0VfILZjwBt1J3sf8/ZBYK3nyc/Fps6iX1X6V3pWQkPiRyejNlzZhTwdD8le
         KLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683204034; x=1685796034;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35PE1h4pn1H3d9SWO+8b0I5Y/uShSGFf9sil//g3S48=;
        b=SRT3+UEFur4l1t7WiSjJcJuYN3VOGcknAYEZmI81Am/8d+RR2Q7vLZH/2vMy07L+2Q
         5JT5iINAIeTLsAH2Ehk+WVBBYwz1oaceBqOWLDMjrLX270IsEzIeeZiDk2lWg9/0R91/
         gX5aG6iyWbRmmHlNlPpAr/ba3GBvbY1gqLr6mKrEXJKI/FL2Ocj5uVcBZ9Ipu7qZ5MNr
         apxdXfB6+sCYytCC4K7g/BUbNonzQ5lPyMwAI4FurheF9cGS4dJNHLM1ci1TrCcOd6Cl
         cjxIKYhXP2qX1Xzt+EEUx0Ie3qpKQ4Mdnk/TAxP+twclCZnu4GUSALbrifs/LTDHtUdG
         u/bg==
X-Gm-Message-State: AC+VfDxsgEhH+ZAo92nLJUjNtNH8QiZ6xsP2fhXHG4xrgFpgIwSXGHcH
	RoO3VYCHJLgKl/MmCc7yxyY=
X-Google-Smtp-Source: ACHHUZ4r0+KY1d0rd8nU9V16WDWrIjDjYajmTUEyv85OdpnQF4ASPMu/ZnHHR+GkxdcEAnHXGOoioA==
X-Received: by 2002:a05:6808:23c1:b0:389:4c8c:d069 with SMTP id bq1-20020a05680823c100b003894c8cd069mr1589556oib.57.1683204034303;
        Thu, 04 May 2023 05:40:34 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id k12-20020a05680808cc00b0038dd5bf922bsm1540620oij.22.2023.05.04.05.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 05:40:33 -0700 (PDT)
Message-ID: <bc2cbdf3-16fc-7b16-375c-a753afff42cb@gmail.com>
Date: Thu, 4 May 2023 09:40:30 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2] rust: error: add missing error codes
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230504064854.774820-1-aliceryhl@google.com>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230504064854.774820-1-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/23 03:48, Alice Ryhl wrote:
> This adds the error codes from `include/linux/errno.h` to the list of
> Rust error constants. These errors were not included originally, because
> they are not supposed to be visible from userspace. However, they are
> still a perfectly valid error to use when writing a kernel driver. For
> example, you might want to return ERESTARTSYS if you receive a signal
> during a call to `schedule`.
> 
> This patch inserts an annotation to skip rustfmt on the list of error
> codes. Without it, three of the error codes are split over several
> lines, which looks terribly inconsistent.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>   rust/kernel/error.rs | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
