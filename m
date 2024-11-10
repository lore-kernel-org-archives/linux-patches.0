Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7E14F121
	for <patches@lists.linux.dev>; Sun, 10 Nov 2024 10:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731236220; cv=none; b=FnwLUcE4E5Sv4lyUHNj0BjPESgML4XV4jHH8qLP3FUARr/2ObC1TzWcoYyWx4loz4oDNZCcQhlLaEWj9Mo3qk1Jk8hlP0Q6tG5BKHUoaI8HhNp8JPTdSJyVpp2y2ZODIUc3FAZaHoUW1UL1CdNfyZwWkxRLqREXEfcZtOwbrsvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731236220; c=relaxed/simple;
	bh=fApCHzHaNaMN9ZQJrGXmdWes5ZsjF+zWr97kyjUl1Ww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bPYyMbCLH1VA/wxAH0GwUo4/sgAxDzZsphjTlSs4Bgreb5DHmaD3lVUqmZoKVdVwB+PVxyBwV1fuUmBQdcZ1fDORTUA3MZrsst4+x+2Gn72y7gJhLrmseatuT5lcC3CmrYBWqITKo1xsAc9tSTMMhzKNfiEG8zGCJq3pE/VmsAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WpWG8prj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WpWG8prj"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37d41894a32so2065473f8f.1
        for <patches@lists.linux.dev>; Sun, 10 Nov 2024 02:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731236217; x=1731841017; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6pZc1K5vHW1yLRrOq46D/RKiIu83zxt8iuFPjL5iSM=;
        b=WpWG8prjDErzC9nk31n099grf3amgg6AVVTATrFM8ocKNsvuUXsfkOFScfX4Lo97Zg
         gifFJYo1eECHNksE2OGiNJxILF1XerQIMKkwBAoHa2vMMOPFjT83/ZLFDLLd3pV+Ia2w
         aw9pv4oooSRlYGbhLmpr9z7oznbVKIQrXCr4KoHYANNyhKmR8UXZ+npZyUmHgNVh/sc/
         zTjMfndjv+SfTxdz9NlY0KOrd+TqfLSxHxKEvcLSf0RZCbqo5r2VaHXRHgZBHU9RfTUZ
         Ggi8YcmRKabyuivpywsvrYdSK2WjoBn5Whow/uRVwUWmf66fLOePDcGwema0p9tISflW
         rvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731236217; x=1731841017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S6pZc1K5vHW1yLRrOq46D/RKiIu83zxt8iuFPjL5iSM=;
        b=T2RSrxUmjEPk0BA3arElhAilHfmtdu5OP5G+FJUEznng27MXsM0fcEh5wMtL3CkPCN
         gp8g7S03tbXJZHD7Z/H3SNMfrEDt21/01Gl+OaYF7NdyHYVYE7oL7O3T/l0eP8NPNH08
         4UPjSrmd+g2bS7MLUUOrUAdk5XpY7IbEIwC/KCv20ajUItwl9XAvs6GuTQWQlI5DsVgu
         WH6Od/E0VsTiFg1IMnzbkjhf2OYwkMJwUGoeqbZGUDhx2Zrw/isTSfC/G5BX8UzjfGp5
         l+XoHtjiNMG0Wnavi+PN94DCjF/PaB3ajLhpZ9VE6WeN6HtAfmbKDU5vakg3trE+Wxfl
         F4Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWS/ioM8UtpXeNP7haJ99eTt0qhX0a3LqFFvGWdJuiDRqcU/4bQrhGetDnTjM5Z0OU8OxCDVJry@lists.linux.dev
X-Gm-Message-State: AOJu0YzXp2MFsIfCyrG7EdXnp+yH0tt9T/x4nI0N0Fzi2SK70lxGInBL
	FMOW9tLxjnI3CnezmpX3K+OcfkHy6RJ3wVgOVnzhmkjkZuYTP02QoWzDGtJgFB8gsz/+L5L1hB4
	1Uqs+JjaLQBShRY0Wfa2sKuKZN4hJhl/m+fyt
X-Google-Smtp-Source: AGHT+IHMoahnfY0BITCuLZrb0MEqyF9R5+UE+yA+o8e4yfiWrcrbfycPVvQoH4GneTAdVu6kkPrdqxT9YFq58Bk4Ryc=
X-Received: by 2002:a05:6000:1acc:b0:37c:cc7c:761c with SMTP id
 ffacd0b85a97d-381f1a6675fmr6413285f8f.3.1731236217034; Sun, 10 Nov 2024
 02:56:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241109165520.1461400-1-ojeda@kernel.org>
In-Reply-To: <20241109165520.1461400-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sun, 10 Nov 2024 11:56:44 +0100
Message-ID: <CAH5fLghd2qdW02CeX5QgP2p2mwgxGEj93MrW5G-T1zOCVaUOhw@mail.gmail.com>
Subject: Re: [PATCH RESEND] samples: rust: fix `rust_print` build making it a
 combined module
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, patches@lists.linux.dev, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 9, 2024 at 5:55=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> The `rust_print` module, when built as a module, fails to build with:
>
>     ERROR: modpost: missing MODULE_LICENSE() in samples/rust/rust_print_e=
vents.o
>     ERROR: modpost: "__tracepoint_rust_sample_loaded" [samples/rust/rust_=
print.ko] undefined!
>     ERROR: modpost: "rust_do_trace_rust_sample_loaded" [samples/rust/rust=
_print.ko] undefined!
>
> Fix it by building it as a combined one.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Closes: https://lore.kernel.org/all/20241108152149.28459a72@canb.auug.org=
.au/
> Fixes: 91d39024e1b0 ("rust: samples: add tracepoint to Rust sample")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks for fixing this, Miguel!

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
