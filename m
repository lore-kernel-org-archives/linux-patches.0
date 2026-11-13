Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590041;
	b=nXHebSXY8Qifx0V6+TIFHDL2z8g7MVQuTC99hcgPnhqD31Tic9wYKAMNVeeSulbjI4Dn
	 DH1NmHxeIGTvvwg052EpF2tevmkBLGUfCfXFVqM4WoGAOMWBmoa8b4tYtWb90dyRDNVqX
	 kp7JwpuU5LXlaoptPlRD6DNRkcYHrd5wEOee9F3ibyLIO2xJS1gNOTnM6ZxH+LELIYi2f
	 I601FuZ/9YMm+zsYkuHz5jJONjYWbuTSt/yu/eDLOptzU92vOmIg1oK8g772OCHe+6Czp
	 mdHz98Y1EBW/ZQh63fzM5jbpBDBsNYeXPj9EYsdBb7JM0zO61OpFbwkTcTdlxWK0Ang==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SHxw9IC5sHQFExmBXeCrBOH+loqqR4h6t8BzWNDV/cA=;
	b=4F2A8G8vR0NCTHMgBZWhEOxJigODbzQwpiTqp971VgASFcTl0Qzp46TvGu/+C7RBPBKb
	 NMQnfQP1CUjgQ7NMxgs9JBFwSydzm8AXaCRPdp8/0zz2itxsXfwVzjmxLoqtGXqZujFsf
	 DE20Hs45BXfi//bHKEdGxlzmuZiHzMZmXeEYqc9/RlEwMc8E8A6SkPFIAn7UPfQD1E1Qb
	 lSGc5432dj9lswDgFUuwaNH/Lv8j0YU8C44wsZwCgd0FijVztEMJWOrUxjDGiTvzLX0KG
	 q3pPykO0dOZ4r94YxaWv1SjeTzG8MgUzGr/1xQFjJYN8zMOHt6rlllfqDWNcWVI3grA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vEOKFps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EAC60A2616;
	Fri, 13 Nov 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2vEOKFps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11A81F000CC;
	Fri, 13 Nov 2026 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590041;
	bh=SHxw9IC5sHQFExmBXeCrBOH+loqqR4h6t8BzWNDV/cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vEOKFps75CfFqS9ar/LfeCoVrQdzuYLLYfhG8JZzRtP5wVLVKbfyzd9yDMuGH+yP
	 6TEf4fGGHpUjhBm3NGectND9r6mevN4EYFS+26jhRXplPLzK8Aql1UsdjHnz2plx1a
	 1uHuSb8ZQh5okic//GVXziroE1hVsL1OYUkwMt3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/686] rust: bug: pass TAINT_WARN to warn_slowpath_fmt() on UML
Date: Fri, 13 Nov 2026 10:43:29 -0500
Message-ID: <20261113153823.475423680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 951d09ca450ca76a695016ea76c3fa653bd20439 upstream.

On UML, `warn_flags!` calls `warn_slowpath_fmt()` directly. Its third
argument is a taint number, but `warn_on!` passes its bug flags there.

As a result, `add_taint()` gets 2304 instead of 9 (`TAINT_WARN`). The
warning is not recorded: `/proc/sys/kernel/tainted` stays 0 after
`warn_on!` fires, where it should be 512. It also causes an
out-of-bounds write in `add_taint()`.

Pass `TAINT_WARN` directly, as C does on UML.

Cc: stable@vger.kernel.org
Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Link: https://patch.msgid.link/20261001123103.2198104-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ Adapted to the single-argument `warn_flags!` macro. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/bug.rs | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/bug.rs b/rust/kernel/bug.rs
index 53dbdaec3560b..364d90c6404c7 100644
--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -79,13 +79,17 @@ macro_rules! warn_flags {
 #[cfg(all(CONFIG_BUG, CONFIG_UML))]
 macro_rules! warn_flags {
     ($flags:expr) => {
+        if false {
+            _ = $flags;
+        }
+
         // SAFETY: It is always safe to call `warn_slowpath_fmt()`
         // with a valid null-terminated string.
         unsafe {
             $crate::bindings::warn_slowpath_fmt(
                 $crate::c_str!(::core::file!()).as_char_ptr(),
                 line!() as $crate::ffi::c_int,
-                $flags as $crate::ffi::c_uint,
+                $crate::bindings::TAINT_WARN,
                 ::core::ptr::null(),
             );
         }
-- 
2.53.0



