Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B389B273803;
	Mon, 29 Dec 2025 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025454; cv=none; b=H+eRSI2V6XDjW3jwY2BKsdrcIEv/hmfsEvuiTKGpVlzXimcfNfZu58ab5Dz7cXFwbE52LeSsFXqdcWr1/D5D38FYYAyjUbtnzcJdvmrECZYSfyfAThDptVPKeOe1Lkg8JQcWczrCOUvtsvxCmOCIW8Tm2ZJSSQXzzCsM70EsYLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025454; c=relaxed/simple;
	bh=9Zy3p3X6Kr9mGoP9bl4QCcp8QPRF3kS+lSDk4gdI0Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfTd2yZzjro5ZdJEyuORD4qrQD4FflasLQF79eUl5b8J7aNV9g1SxezJ51E+I8naDBwaaH7nTl35WOQjxGPp93muL1hDK77L+IA6LOyJSxKXED5GVH06d0CQ0r6cA/SgpvmXnavONheHRuQNagNNQirdmpc1x9fk5pBSZXGljyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjqIAzjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjqIAzjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED50C4CEF7;
	Mon, 29 Dec 2025 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025454;
	bh=9Zy3p3X6Kr9mGoP9bl4QCcp8QPRF3kS+lSDk4gdI0Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjqIAzjQpK2GH8fiKQ6FjJnxzx4CCpY/M+L6CKFxnOkubl11dxgXIfwzeq7G91lXE
	 7+fxFaKu5GrcMFJSjx2Efn/tVQ/S5unNVqf0gY0XaVKDcOt+ElHPce2Fdz7HsnWpdA
	 FO/XHOrrgZdGNV39y0mBX5f+/IpWW6jqhk+9QZ6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 220/430] rust/drm/gem: Fix missing header in `Object` rustdoc
Date: Mon, 29 Dec 2025 17:10:22 +0100
Message-ID: <20251229160732.448651778@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

commit e54ad0cd3673c93cdafda58505eaa81610fe3aef upstream.

Invariants should be prefixed with a # to turn it into a header.

There are no functional changes in this patch.

Cc: stable@vger.kernel.org
Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251107202603.465932-1-lyude@redhat.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/drm/gem/mod.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -184,7 +184,7 @@ impl<T: IntoGEMObject> BaseObject for T
 
 /// A base GEM object.
 ///
-/// Invariants
+/// # Invariants
 ///
 /// - `self.obj` is a valid instance of a `struct drm_gem_object`.
 /// - `self.dev` is always a valid pointer to a `struct drm_device`.


