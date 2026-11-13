Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590042;
	b=HQEA3gF+kSymjIjMuBRO0t8yMIQaGty3SFDLR02qiUK3UjotLT763yJJLLGlxAGScDOy
	 3GW6WUbEG+yMxr3JhkU24cJejMjgBvey3i3K+TQ9wgHmwRlfeTfTHt53NHqSTKdpl56jQ
	 u52mbWJGAOG0BOfdZl9F3Br3wm4EovceixhEtRfs6rQTj1+kzZerOxO1R52oZHB06RWtO
	 DKabW0yJ9BkLvW6ciK0Hwgn7QkMODrVkWjQBDavicfRSlTAet0CUP92ospIWlCZ0KSf1I
	 FqNAXoPf6WTD6gsQ9sevr/q7p8a0/B6tHmMG6q6ci/gdz9ZKmeyuv7eWe7gmCWxjZdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jRmHboX68aW/giMfhQRVAE9a7KO052laiRKlU86HVTo=;
	b=BH/WyuIglDryifsqUG4RvzZtA8n2UZ8YQG48SJh1/0cQvHr3M54pA9u1aeQp1lIKK5r4
	 ReKSun6N12nqDugpnxw6DFYx84+/hUM9pStwCbBv0gtZ8PaTWg5Xr6LWUhx9o5pj+SyIa
	 LFM3te6AbsPQ6p7XnhWo7VF9PHs1imzPMj5cwFF3TLetC/IGC7TBjeiQlh86M1dnO7C12
	 d2VjWwZ7z0wi86tx1bWx7WpLjSMOHu0uuTlayzMYqsxgANx3EOXlMoAhPFw7BiBTXUR58
	 5xG0/SY07opZKZDY+iFyURPGWDNM3nhsMSHjwyUIqtXFoUdD7dBcmrRsyR7GFAGRTvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YtF3XM/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0760A2617;
	Fri, 13 Nov 2026 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtF3XM/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5DE1F000CC;
	Fri, 13 Nov 2026 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590042;
	bh=jRmHboX68aW/giMfhQRVAE9a7KO052laiRKlU86HVTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtF3XM/y7sJwNsbBU1ato6rqJcxAxUZpsxq/ynu0ZoYXDa1jnyFIIltQVmt3KxIrp
	 JjTpMcaOlmauU67yoL4nCNMxNLBSpyT/3Bc5jLt0vJGOQER+vTi+LTIeX5zFJHDZkV
	 nLB7GI5J1gyxWqfBp96FVrsX0+7doyr6hOIyM6zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/686] rust: bug: update the SAFETY comment for warn_slowpath_fmt() on UML
Date: Fri, 13 Nov 2026 10:43:30 -0500
Message-ID: <20261113153823.506951596@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/bug.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/bug.rs b/rust/kernel/bug.rs
index 364d90c6404c7..95bfd195c986a 100644
--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -83,8 +83,10 @@ macro_rules! warn_flags {
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
                 $crate::c_str!(::core::file!()).as_char_ptr(),
-- 
2.53.0



