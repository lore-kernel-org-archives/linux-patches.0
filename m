Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A96230C36D
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762784636; cv=none; b=oFsUh68RLevgBFA8ckXIkaAestjasvOK1DOzFv+ABn5bCwZtN4x8JDTSCAN102toDJyzCTiFaOwDhoNXJ+R/IULKm8rGE0eX4P8Uzn1I9hRHY2sjvs5DTHwqMeY/VNODcqnXiz2s2LRy2AmwGYT7L+Opz+8gQRLQLBftnLX3laU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762784636; c=relaxed/simple;
	bh=JGZIzuVhWGC5kPsqULut5X8vxT48KYgXTejxFx9xV5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rek79fhnpko5aDtXJwbA3XdO45XFBTL9FzlYrBwNiCsXYZ5JWA7nL2uTu5ayid11Ynm7s/nimAB6IAnqHIMlZUVUPBTmPEAkiZmXhwLfGOzOOI3W0DtPWur10DF05GbuMDu/cYtVbUkBF2FNB6JPThh/1jh2zF0uBO8y6sTqaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gYwvnRf1; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gYwvnRf1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=MyqtwMhfj3aYB5/YZYHefwpNNP/5TyDe6z4hlolkG1o=;
	b=gYwvnRf1gXDq1/sUEjvMK6XeiqeZ/mQhNjHq181GZDVBcLsWfXzMtaWbg8iX5i
	aoVSlSxhcNndtiCfkr5mjHtd3llD0eZaNhMbQHusUrQrBCOCjEvN7QrMYAH9AD87
	aXy+aSnJfsfYFr5A9JgX4rz+3YcePIhqhgDCD8RMU/xn8=
Received: from [192.168.1.105] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDXnNFb9RFpkRvpDA--.18906S2;
	Mon, 10 Nov 2025 22:23:24 +0800 (CST)
Message-ID: <ca686233-f687-4147-b22a-72d0b0bedfcc@163.com>
Date: Mon, 10 Nov 2025 22:23:21 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
References: <20251110131913.1789896-1-ojeda@kernel.org>
Content-Language: en-US
From: Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <20251110131913.1789896-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:PCgvCgDXnNFb9RFpkRvpDA--.18906S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww17ZF4DXFWrCFykAw15XFb_yoW8tFWkpF
	Z3Wrs8Kry5Ga48tFW7Gr1xuF15X3s5Gr43JrWrXw48ZF17Z3ZagFZ29r45uFyUuws29ay5
	tFsFvF1jgw4qv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UtPEhUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiRR0Ca2kR4R9-swABs6

On 11/10/2025 9:19 PM, Miguel Ojeda wrote:
> From: Sami Tolvanen <samitolvanen@google.com>
> 
> Starting with Rust 1.91.0 (released 2025-10-30), in upstream commit
> ab91a63d403b ("Ignore intrinsic calls in cross-crate-inlining cost model")
> [1][2], `bindings.o` stops containing DWARF debug information because the
> `Default` implementations contained `write_bytes()` calls which are now
> ignored in that cost model (note that `CLIPPY=1` does not reproduce it).
> 
> This means `gendwarfksyms` complains:
> 
>        RUSTC L rust/bindings.o
>      error: gendwarfksyms: process_module: dwarf_get_units failed: no debugging information?
> 
> There are several alternatives that would work here: conditionally
> skipping in the cases needed (but that is subtle and brittle), forcing
> DWARF generation with e.g. a dummy `static` (ugly and we may need to
> do it in several crates), skipping the call to the tool in the Kbuild
> command when there are no exports (fine) or teaching the tool to do so
> itself (simple and clean).
> 
> Thus do the last one: don't attempt to process files if we have no symbol
> versions to calculate.
> 
>    [ I used the commit log of my patch linked below since it explained the
>      root issue and expanded it a bit more to summarize the alternatives.
> 
>        - Miguel ]
> 
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
> Reported-by: Haiyue Wang <haiyuewa@163.com>
> Closes: https://lore.kernel.org/rust-for-linux/b8c1c73d-bf8b-4bf2-beb1-84ffdcd60547@163.com/
> Suggested-by: Miguel Ojeda <ojeda@kernel.org>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com/
> Link: https://github.com/rust-lang/rust/commit/ab91a63d403b0105cacd72809cd292a72984ed99 [1]
> Link: https://github.com/rust-lang/rust/pull/145910 [2]
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>   scripts/gendwarfksyms/gendwarfksyms.c | 3 ++-
>   scripts/gendwarfksyms/gendwarfksyms.h | 2 +-
>   scripts/gendwarfksyms/symbols.c       | 4 +++-
>   3 files changed, 6 insertions(+), 3 deletions(-)
> 

Tested-by: Haiyue Wang <haiyuewa@163.com>

