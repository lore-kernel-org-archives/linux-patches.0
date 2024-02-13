Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09715F54E;
	Tue, 13 Feb 2024 17:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845300; cv=none; b=ufJN94V96nP1lFGofT3lQZcUPqBq1V164VDJgFk1HBYAlZZ9EjbK9ZjHbFYKRWw8DsFW8pxmUIQz2lxC+qoGUsFAST22Ikb/J9jLGnG2u0bQY/YfmIfRgbnua9nIRGVA/aq85BFxISWnMUDRVlML4Dzju79jh5hj1yNUz1+B/gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845300; c=relaxed/simple;
	bh=0WHTUDoLB/VM5PaxDik4NTabzvcHq3TJhVmWkxUOBiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT6PqIL8Fck2ro5omWvhAHSMNY0nqvTM09oZh8/RP5bZ/264Q72ToQEIe3GYxiA71cF1A4OQ0tIB5lzxQegirjTyh7/LHy+X2Ztgwle/i4P0+goImQjx+L4PU91h0bw+JHRXa9YI7jivAh4yzbLlDo+QJaiAjiWTMob4DS8plXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrDwLUaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrDwLUaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24451C433C7;
	Tue, 13 Feb 2024 17:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845300;
	bh=0WHTUDoLB/VM5PaxDik4NTabzvcHq3TJhVmWkxUOBiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrDwLUaqBNIWTXKIog9IUcKSo7sLaAJmpNZhtJo0OhNnu+MtUUhJet0qhPddNneAu
	 /xLTpzJsuZ+gCXb77XYRAszApJa+sScly0y6Tmv+54YY0Bpw9XtMP3gCsXK1xT4MRc
	 k9sNqBq69ei6K1Bl0R8kXCBSDwSuUSu2thhpo9dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Alice Ryhl <aliceryhl@google.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 014/121] rust: task: remove redundant explicit link
Date: Tue, 13 Feb 2024 18:20:23 +0100
Message-ID: <20240213171853.385926742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit c61bcc278b1924da13fd52edbd46b08a518c11ef upstream.

Starting with Rust 1.73.0, `rustdoc` detects redundant explicit
links with its new lint `redundant_explicit_links` [1]:

    error: redundant explicit link target
      --> rust/kernel/task.rs:85:21
       |
    85 |     /// [`current`](crate::current) macro because it is safe.
       |          ---------  ^^^^^^^^^^^^^^ explicit target is redundant
       |          |
       |          because label contains path that resolves to same destination
       |
       = note: when a link's destination is not specified,
               the label is used to resolve intra-doc links
       = note: `-D rustdoc::redundant-explicit-links` implied by `-D warnings`
    help: remove explicit link target
       |
    85 |     /// [`current`] macro because it is safe.

In order to avoid the warning in the compiler upgrade commit,
make it an intra-doc link as the tool suggests.

Link: https://github.com/rust-lang/rust/pull/113167 [1]
Reviewed-by: Finn Behrens <me@kloenk.dev>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Link: https://lore.kernel.org/r/20231005210556.466856-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/task.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -82,7 +82,7 @@ impl Task {
     /// Returns a task reference for the currently executing task/thread.
     ///
     /// The recommended way to get the current task/thread is to use the
-    /// [`current`](crate::current) macro because it is safe.
+    /// [`current`] macro because it is safe.
     ///
     /// # Safety
     ///


