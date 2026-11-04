Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827106;
	b=wpqphW18h3USNmq3uk2Brm7yZyH/DeWqOKSCvZTwju2quEYVeHaQUG8DD7CBFYCDIhAn
	 iXxoigvLnz66KjRY5x/HS2aLz3ny1I+17c/KoAXUk5dAiPKSMkIbKXSEJS4E6g32BUqdo
	 MC54Gbo2BBFiaHHsnEpGokG5v1Xlcb6xXKi3PI1YAu3dlp0+qiCY6ToB3sFyDc4IlxqfP
	 GBouw0BZiaShe7ZBWsJ88rXO1b0mdtFLDZq7nt1sTXVBG04BFf/69+Q4t7EWMTSFVjabJ
	 WmPUjsk4g4r+E1UN7Q92Rjjm/FInkQdCoRtinGRLA19lXS1+HK+FWi0AD7xaNbcpJfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KnIJj4SOmj2iGjCCYza+dO9sWW+L0MHG/GAN8tWNqJ4=;
	b=1r5dO4ugMbW7+NnM000Z3vviqg//Kn17vEnKm62C2ApKDFlzAa4y91S0bIaQM4vufG+j
	 TPBMFC0+VcltINDcr8krzpNwm07+tvHR9PoqhX528F7K2gGltjfla2iN0+c6PiKXGP6GF
	 FHskADh4e1aAPygQg+Y5tpGk9dvcBnS6cKEArBeY5sR6CkWXYa5XaxZUzFDGCzLEP1sKS
	 TuPF0hYSvHZ6tvLL9sgkDk8RQZw0Apkxu0TYsBaR4lIEYH7CV8Saz437a7GQtBIy2MWdZ
	 4xqL5LftHKtw8+P2Fi1PeUo7vKNp3YdA7XACJKfgHInc11ZuhMMinj7WUYwC+r0gkEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jlr8OW5z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE3606A869;
	Wed,  4 Nov 2026 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jlr8OW5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629031F00A18;
	Wed,  4 Nov 2026 21:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827105;
	bh=KnIJj4SOmj2iGjCCYza+dO9sWW+L0MHG/GAN8tWNqJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jlr8OW5z3MfT9AA93TPJ9+BdtXw/XrvLrwpn/lsNhnKVHSfzYx7fuRxZJPf1bHDhH
	 pteAYcKhquPWAlnnAALvX4hZIQM4lhHSLyYb2VX0wTAVExkx8I2S7nh9DRqGj5LURS
	 yT+ILqT6EvhYod43fJV9fHWykrIcOBCJnphkOplI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: [PATCH 7.3 198/547] rust: bug: update the SAFETY comment for warn_slowpath_fmt() on UML
Date: Wed,  4 Nov 2026 16:06:22 -0500
Message-ID: <20261104211043.768074397@linuxfoundation.org>
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

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 5c94956f2bfb87025c1eaded6c51d5841d38d333 upstream.

The SAFETY comment says that it is always safe to call
`warn_slowpath_fmt()` with a valid null-terminated string. This is not
true. The taint argument must also be a valid taint number.
Commit 951d09ca450c ("rust: bug: pass TAINT_WARN to warn_slowpath_fmt()
on UML") fixed a bug where it was not.

List each condition that the call meets: the file name, the taint
number, and the null `fmt`.

Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Link: https://patch.msgid.link/20261002104550.2877930-1-tomo@flapping.org
Cc: stable@vger.kernel.org
Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bug.rs |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -88,8 +88,10 @@ macro_rules! warn_flags {
             _ = $flags;
         }
 
-        // SAFETY: It is always safe to call `warn_slowpath_fmt()`
-        // with a valid null-terminated string.
+        // SAFETY:
+        // - The file name is a null-terminated string with `'static` lifetime.
+        // - `TAINT_WARN` is a valid taint number.
+        // - `fmt` can be NULL, and NULL is passed.
         unsafe {
             $crate::bindings::warn_slowpath_fmt(
                 $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core::file!())),


