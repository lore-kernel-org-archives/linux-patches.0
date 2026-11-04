Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827094;
	b=MnAO3hXzv4tmRQ9KbSYg8Jxf5fU0R0b9tBTytlupwlDFeUG6XTdNEReZ7sFAVv/CBVfp
	 AKLjCzacPwpDszggiiPE5Gpp4wAo2hlAn3ly5S+b3jXXBu8A9jPIJim64iJKqPZ8c+a02
	 EXaXVWuOAJ1moknjL2DZ6qYHN0WYsJkwI5lFGr+txDc26MwBkPrSWpSCypiYEtjY9r1tp
	 sloo74et085KFN98OKRMfCViOf7oRHmlN9MZDETNj4LZUPOKK/VJcplAGlbDmFVaNlhyt
	 E+YcZR9l+fCC04LvjZjQXBKVyfAbDGhaJbGQMJ8aC/tyyWIBOFwTtoYKNtURv/1UbTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ioRxv9pJLgWRm4/ZdH7IOtooizJylqFc1D+4TMpzNBw=;
	b=dk1NKbmNPbdrueokscFmANq7tPNJAiWu4pl7TaFqHVf19kIFO+xXKGUBF76B6upfP0xZ
	 SDuAqgM9jSLAW5vzIsZ/PelDNzTpwRxRv2SorHwaK58zAUHw8UapJ6GoQPk8+cTENO3tE
	 q6xouMqXbltrTwuPD2gJh6Jom7yJ4PTB9eL+3M58SlG3i1aK8pSCzxZ1N2o6MVJCbwmws
	 unhP7rgg9BZbUBwGup05jKCFGrz/yBinVueTGoWTlZoYEWPOKsumFtBGXpNC4aCtb3GH+
	 pObJ4hZghBiUafzAkkP0HQCHobMVPelUHULPGRBKYvPf9kAJ2Coz29Ft4Of4zKu6QiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=093D36qL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557FB60841B0;
	Wed,  4 Nov 2026 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=093D36qL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46A01F000C1;
	Wed,  4 Nov 2026 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827094;
	bh=ioRxv9pJLgWRm4/ZdH7IOtooizJylqFc1D+4TMpzNBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=093D36qLJAAdvTrE47vTcEoiJyMCfv4cLXgi8wk9E1zq8BgQa5acIa+4JBIdGw67g
	 UTnbiQtgt9PZLm3EUC5jmchSg/wINvM8mZVDPBINrKQHyZJxZR9+dEea0b+eZ096Xb
	 VE78cLyaxD4cQV2aPrYVrCjft4RniAtmllUjYAK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.3 192/547] rust: bindings: fix `VM_MAYSHARE` blocklist entry
Date: Wed,  4 Nov 2026 16:06:16 -0500
Message-ID: <20261104211043.590872424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit f9a6960c7b27c03becd50a2a7620273d80e4040d upstream.

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added constant helpers
for the VMA flags and blocklist entries to suppress their direct bindings.
However, it listed `VM_MAYEXEC` twice and omitted `VM_MAYSHARE`.

Thus fix it.

Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Link: https://patch.msgid.link/20260930123645.302318-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindgen_parameters |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -50,7 +50,7 @@
 --blocklist-item VM_MAYREAD
 --blocklist-item VM_MAYWRITE
 --blocklist-item VM_MAYEXEC
---blocklist-item VM_MAYEXEC
+--blocklist-item VM_MAYSHARE
 --blocklist-item VM_PFNMAP
 --blocklist-item VM_IO
 --blocklist-item VM_DONTCOPY


