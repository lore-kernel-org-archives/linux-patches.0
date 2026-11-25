Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620016;
	b=SmT39dVsLvMeP7Nap+1GjLJtdKPAhv98edvKs2XBOSMAzt75WXzWugBVOSX2j3ld6FL5
	 1M7WS39MhhTVshh6OZUskGtVZVqlGs4kREgXPyiIy8pbCOIHGA99Hh7sV/j2NaOoHtq1U
	 9P1V+u9Fqtf5723RQ78iKkGPLYp7I6Kmda4WXVLtw+PpVs/Xh91ONHaaNTmQSfW+r5kMc
	 V5ePXxHTE/xmi0qdsAbh0oq9q/Vw0tRQGwUVzz2Rg6Bzop1Tn2Au5WPa1pkLhoROgESt7
	 x4cZ0Dlu6dXa++ac12dkwEj9LjKo1a/kl3FOZZXodAQ3eyITAxBxZYPhxwBcq49olOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvm+ZSAw5kFylMh9UC3brQs5+0RQb9lGT1imR2HVBWE=;
	b=V9F57Ve7lx6wcYmGG1AZyUe4C7cm0+lPepWRL1r31W7+TkgBhdlmcdnuLgTJ1Gc9A6ur
	 nncaYAf0p1w0QoqEqXwAmFi2g5c2X5QMRFtDcveK5HtoHKe9+G6rSE41t/UISjkTjrQsq
	 5ufjgICw1se/bxutMn7C4wzlbdK89lWseLTt4wNoMpgmVo5Eetr++oU9fLACCvArdKHv1
	 8EifNHLiM69T1JA+7XSZJ5/vGl4V4+gulY/K5WTe0qEyreCmXuyAhObEELjhTPN3gOfED
	 NUnJVVwm56jeiCLnIxXJ90HwJIKXfNKt2VYCFo27FpmLMqnTq0pnxSJJGNdoJ7wYreg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lf9TNGNv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B6D606A31E;
	Wed, 25 Nov 2026 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lf9TNGNv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F22D1F000C4;
	Wed, 25 Nov 2026 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620015;
	bh=rvm+ZSAw5kFylMh9UC3brQs5+0RQb9lGT1imR2HVBWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lf9TNGNvivs7Aq7TgvvB+NfqAaVQmYd+puhcOexAls5IuNUV1xwZOUEMn7u+n2LCz
	 bg7RhMspTDm6Y6WVe6UGM0b7VLR5JGfC/Rkd/d/htR/7KWnSammolTF/zdk9guD7NQ
	 QBEAJFYUJk2bP0X2tJ6M48GFRNDwpAiDZQk6EtW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.3 0744/1005] kbuild: rust: support stabilized flag `-Cprofile-sample-use` for Rust >= 1.100
Date: Wed, 25 Nov 2026 15:34:42 +0100
Message-ID: <20261125143839.180442215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

commit 1178120c3bed1733aea1c465200a6b42f8a7105d upstream.

Starting with Rust 1.100.0 (expected 2026-11-12), the
`-Zprofile-sample-use` flag has been stabilized as
`-Cprofile-sample-use` and the former is not available anymore [1].

Without this change, when building with `CLANG_AUTOFDO_PROFILE` set, one
gets in the latest betas and nightlies:

    error: unknown unstable option: `profile-sample-use`

Thus pass the right name.

Cc: stable@vger.kernel.org # 7.3.x
Link: https://github.com/rust-lang/rust/pull/155942 [1]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20261106073528.93371-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.autofdo | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.autofdo b/scripts/Makefile.autofdo
index 57a3aba6ffc2..32c18df237f1 100644
--- a/scripts/Makefile.autofdo
+++ b/scripts/Makefile.autofdo
@@ -13,7 +13,7 @@ endif
 ifdef CLANG_AUTOFDO_PROFILE
   CFLAGS_AUTOFDO_CLANG += -fprofile-sample-use=$(CLANG_AUTOFDO_PROFILE) -ffunction-sections
   CFLAGS_AUTOFDO_CLANG += -fsplit-machine-functions
-  RUSTFLAGS_AUTOFDO_CLANG += -Zprofile-sample-use=$(CLANG_AUTOFDO_PROFILE) -Zfunction-sections=y
+  RUSTFLAGS_AUTOFDO_CLANG += $(if $(call rustc-min-version,110000),-Cprofile-sample-use,-Zprofile-sample-use)=$(CLANG_AUTOFDO_PROFILE) -Zfunction-sections=y
   RUSTFLAGS_AUTOFDO_CLANG += -Cllvm-args=-split-machine-functions
 endif
 
-- 
2.56.1



