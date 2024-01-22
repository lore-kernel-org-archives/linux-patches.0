Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEEF6BB56;
	Tue, 23 Jan 2024 02:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975390; cv=none; b=RtSVooZgTdE6NLi0D8zhTS5dIA2HLNVKdAGsFygNxk2B0i5C5g7LvyE+2sXYBmiHDN/o0tj+l8hbnxb75/lo8/o1UzTa2DU1mk/DrRwRuP+lt0XuQ2Y30kT5kKXvOAeMBAq5rfAI5MHjIdmMwWf/BX87nc1Ae5+4El0uI4ba17o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975390; c=relaxed/simple;
	bh=oE46ogXbzCGExEnS1Rr9T3UloIPdyLt4Y+7xein2BdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOoQVBxxt9/clir/7vvjXc3M/RQ1N0w7QPDpqa/FfDzYYqcoC6X3s6fWRtou/tDHwjBoVaN0Xg0seHesH3peefNGZhLk5DrYqO71yqbPERJI7GRAASJptWJwVoaugeaGAHouPn5epTYVACXoFWbPyDp8cbD14xMWS6Hkm7mGhyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2aMU35N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2aMU35N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C550FC433A6;
	Tue, 23 Jan 2024 02:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975389;
	bh=oE46ogXbzCGExEnS1Rr9T3UloIPdyLt4Y+7xein2BdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2aMU35Nc6TZodlbFBofN0kucjXGwcUDM/G2AVlG6adahOW/yj1GlNh2B2tuEYMd4
	 tVs1WElllra0G4g59e1dP47yJ+y2mP8jTc9Y+P8KXBWHMje8Faq0TNJ6yMep6CYvzj
	 pIcHrIjiNlc0jrWeFJOSQEw9phd0bBfp08KDhDDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 350/583] rust: Ignore preserve-most functions
Date: Mon, 22 Jan 2024 15:56:41 -0800
Message-ID: <20240122235822.731854401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Maurer <mmaurer@google.com>

commit bad098d76835c1379e1cf6afc935f8a7e050f83c upstream.

Neither bindgen nor Rust know about the preserve-most calling
convention, and Clang describes it as unstable. Since we aren't using
functions with this calling convention from Rust, blocklist them.

These functions are only added to the build when list hardening is
enabled, which is likely why others didn't notice this yet.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20231031201945.1412345-1-mmaurer@google.com
[ Used Markdown for consistency with the other comments in the file. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindgen_parameters |    4 ++++
 1 file changed, 4 insertions(+)

--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -20,3 +20,7 @@
 
 # `seccomp`'s comment gets understood as a doctest
 --no-doc-comments
+
+# These functions use the `__preserve_most` calling convention, which neither bindgen
+# nor Rust currently understand, and which Clang currently declares to be unstable.
+--blocklist-function __list_.*_report


