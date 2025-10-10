Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48A21F63FF;
	Fri, 10 Oct 2025 13:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102258; cv=none; b=uH8XDjhu13AYD/d1IzfxdKjNzHbht92PS4fybwD5YUTUrWwNy2P9RTy7uNvgj7L0MRoZuA+N/JGT4+gtOt7Cnkd2t/d8jdbsq3bNEbpSk59CBAEzCTeXbUERB6k4UQ29mN4zDZSX+DmQ4ZQ0ZlpL768Ta+Dp7TXr7UMgp4jhpYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102258; c=relaxed/simple;
	bh=G+2f6cW64bjKBogqmN1KiCmyvVNaEVIexNNHy6syRQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUzptN8+j+AhoyzwB2CnmlhiFNU0gw6Ft4gTFYTa8UgnwFEWc2/pQ0IypohXeQUskw3VVwXiQBhRkVPK/qVzWHBJp6d8Q+IVRvxBGxQMzYM9pI2Evb8wsyOISfEZNMEMFdf3QpnBuf4vTYoeme+/mC/Z0vRr4DQglnvZqYTXtSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nE7vdrYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nE7vdrYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A87C4CEF9;
	Fri, 10 Oct 2025 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102258;
	bh=G+2f6cW64bjKBogqmN1KiCmyvVNaEVIexNNHy6syRQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nE7vdrYfxtlpza8ZqgZnc6dX9J1f0huy/Rk/5eFu6Vcc/g5RUu4RRgd1SBdXKscGT
	 AWPQUr95tMn7WYQdmi62w/EGCwW86eCiXZ4ZOt+gu6FT5sUfnTk90ORq/Svd4Q46Zm
	 lyPGCqfxhABT3ixRQPsdFqVIVNenR74BCwUyDOfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.17 09/26] rust: pci: fix incorrect platform reference in PCI driver unbind doc comment
Date: Fri, 10 Oct 2025 15:16:04 +0200
Message-ID: <20251010131331.548001275@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <sergeantsagara@protonmail.com>

commit a404d099554d17206d1f283c9a91f0616324f691 upstream.

Substitute 'platform' with 'pci'.

Fixes: 18ebb25dfa18 ("rust: pci: implement Driver::unbind()")
Cc: stable@kernel.org
Signed-off-by: Rahul Rameshbabu <sergeantsagara@protonmail.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/pci.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -244,7 +244,7 @@ pub trait Driver: Send {
     /// attempt to initialize the device here.
     fn probe(dev: &Device<device::Core>, id_info: &Self::IdInfo) -> Result<Pin<KBox<Self>>>;
 
-    /// Platform driver unbind.
+    /// PCI driver unbind.
     ///
     /// Called when a [`Device`] is unbound from its bound [`Driver`]. Implementing this callback
     /// is optional.


