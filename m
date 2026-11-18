Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018257;
	b=of74EK+5c1HZecNOqdik6HjHTK9w8IejT6syw+WZC0kqhD2y4Eq8X1J8npDCETKxD6ak
	 8sQXOzmuuhypqaVCXDZz3vGAEj2VWsdjjFns0oqAfeu/IeECpettobJXqGgiQTxLo3arA
	 ZcOFUZnQh1qFfz7JpVJe5UDMb+ir5vZKvsylPJjT0jmV1KmkAAf0ouldqIBfSEoviRqgB
	 I6YpMtTcNUnm/FQmKm2X2++DELFBggP+Taigygb4Mxt7PFGiB4XwOLVEqgAGx7hUZxjip
	 SRkYjVb/8U2zRby1MWAhGnAl/rJOn4vBP9+jArCjOxlkNXHJg/a3wIj5FxvdyF000kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Wt2a5oQpTx0uwpJv6XOBjxTJIIyqxDrmehcOEv3RDtw=;
	b=MER0a/ioTpqzO2wZXRFRbS2vsmVcs5NZ/sQH8O0IN21/9pDA8FhLUmCqy64QP9LdRqsM
	 Kbq8v8jTEayH5qAh/9MmplRhmDWpQkKGAEZ7NZ9IhwjUHFh2VsBWGYF0pLpVIuVBvxfLV
	 GEsbOGBMiuuUtf1q3TN9QlfKfpKOtMWUTBaB9O8rUxWejOoIH71aRVFjPbU9Hp6f88uvb
	 vhr7eDmqvTmuzEwRuokpvh3cBojLO0FTe3zt3S0xgTUVn///WHZu4HwTx68KHc0YQURDZ
	 QL/K0x6kwlERzkAvDHzHxckIZafB9eiXRsU53w9OlBGE+V7KDaSQCKtruLCSy7H/sog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+s8zfJY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37ED606A31C;
	Wed, 18 Nov 2026 16:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+s8zfJY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A261F000C4;
	Wed, 18 Nov 2026 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018257;
	bh=Wt2a5oQpTx0uwpJv6XOBjxTJIIyqxDrmehcOEv3RDtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+s8zfJYBl6jNR3ZPQUyEYpHCIVeFaOGHzooL6zdkwWxWERn7puP4UqdpYf/6ADI1
	 x1OEJIR4YuI1mZa8YrRZ8RGjoSZU5b6BdKq17cigIP5NLJZ9ORXZegi1uRSYs7x+IY
	 iyqboPByZXKiOjQTgs9PS+ffrlJxFAvX7rTN0EHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1135/2651] rust: macros: allow non-ASCII characters in `authors`
Date: Wed, 18 Nov 2026 15:39:35 +0100
Message-ID: <20261118150328.868115951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiébaud Weksteen <tweek@google.com>

[ Upstream commit e91836593fbfb0014c290e9a0bbd86d0b98c1d2f ]

Module authors may have non-ASCII characters in their names. In C,
`MODULE_AUTHOR` allows arbitrary string literals which are emitted as
raw UTF-8 bytes into the `.modinfo` section, and multiple in-tree
modules use non-ASCII author names.

Originally, the single `author` field permitted arbitrary string literals
including non-ASCII characters. When support for multiple authors was
introduced in commit 38559da6afb2 ("rust: module: introduce `authors`
key"), it reused the `expect_string_array` helper that had originally been
added for module aliases. Because that helper enforced an ASCII check,
`authors` inadvertently became restricted to ASCII-only string literals.
Later, when the macro parsing was rewritten to use `syn` in commit
c578ad703ae9 ("rust: macros: use `syn` to parse `module!` macro"), this
restriction was carried over by using AsciiLitStr in `authors` type.

Change the element type of `authors` in `ModuleInfo` from `AsciiLitStr`
to `LitStr` so that UTF-8 author names are permitted.

Fixes: 38559da6afb2 ("rust: module: introduce `authors` key")
Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Acked-by: Petr Pavlu <petr.pavlu@suse.com>
Link: https://patch.msgid.link/20260917051147.98775-1-tweek@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/macros/lib.rs    | 2 +-
 rust/macros/module.rs | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 24f96feaeb34a..ea2e232b61b1d 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -129,7 +129,7 @@
 /// # Supported argument types
 ///   - `type`: type which implements the [`Module`] trait (required).
 ///   - `name`: ASCII string literal of the name of the kernel module (required).
-///   - `authors`: array of ASCII string literals of the authors of the kernel module.
+///   - `authors`: array of string literals of the authors of the kernel module.
 ///   - `description`: string literal of the description of the kernel module.
 ///   - `license`: ASCII string literal of the license of the kernel module (required).
 ///   - `alias`: array of ASCII string literals of the alias names of the kernel module.
diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index bc7027f8dbb2c..0a7b9e24c9600 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -369,7 +369,7 @@ pub(crate) struct ModuleInfo {
     type_: Type,
     license: AsciiLitStr,
     name: AsciiLitStr,
-    authors: Option<Punctuated<AsciiLitStr, Token![,]>>,
+    authors: Option<Punctuated<LitStr, Token![,]>>,
     description: Option<LitStr>,
     alias: Option<Punctuated<AsciiLitStr, Token![,]>>,
     firmware: Option<Punctuated<AsciiLitStr, Token![,]>>,
-- 
2.53.0



