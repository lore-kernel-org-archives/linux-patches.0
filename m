Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E2A12C487;
	Tue, 30 Apr 2024 10:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474369; cv=none; b=ETKtm2zirMHtK6zLSwUAH20mh5p+uwUYYPPksJurc8F8QBNhZHzC252JL03QgIORq2GgHT6Dc5NdM2OaED7yx6ry5bu8NdVwLGZ5ZSAxTOxX3hFLLTnjTfk8vgf05fEwarQLlP+uqBUomdwE5VaNC5uifkgj1P7TvqATgvvaunk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474369; c=relaxed/simple;
	bh=SWcoPSLxCXskqVVJwNefBCmsM8mmi2ZGqxRrrm7wX4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLPY0gUR7gInH4Ob94R4oMfjarwVJTpiyNiANnYWynuJEA/qyZgcEWqFTUmiP0CMiqUJeyzjfqe2FuRL0UqQztdOiJMKWsRolFklRt5+cO1ySfcum8tPW8emGVvsLomwsiqPNujRCJhrpxy/PkDO8wyqOqktfI8H/eS4pikxgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuCif9Jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuCif9Jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3658CC2BBFC;
	Tue, 30 Apr 2024 10:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474369;
	bh=SWcoPSLxCXskqVVJwNefBCmsM8mmi2ZGqxRrrm7wX4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuCif9Jmu7k4vaml3uak6BgErhvAE6yL1Pz6zolQwGFJTz4PxwgGlD5hg2Ltp7Xum
	 3XDPvxVonZLL0kOQLq3Y0Gdwn9daRhAN7j7Rw+HtOYeZvGlU+TFVQxyoYpB9Vgc/4q
	 E3/ESe3nPdrY1do2J1jppQZtq+qlX3J8O9fcaT1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 136/228] rust: dont select CONSTRUCTORS
Date: Tue, 30 Apr 2024 12:38:34 +0200
Message-ID: <20240430103107.726554402@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 7d49f53af4b988b188d3932deac2c9c80fd7d9ce upstream.

This was originally part of commit 4b9a68f2e59a0 ("rust: add support for
static synchronisation primitives") from the old Rust branch, which used
module constructors to initialize globals containing various
synchronisation primitives with pin-init. That commit has never been
upstreamed, but the `select CONSTRUCTORS` statement ended up being
included in the patch that initially added Rust support to the Linux
Kernel.

We are not using module constructors, so let's remove the select.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Cc: stable@vger.kernel.org
Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Link: https://lore.kernel.org/r/20240308-constructors-v1-1-4c811342391c@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1908,7 +1908,6 @@ config RUST
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
-	select CONSTRUCTORS
 	help
 	  Enables Rust support in the kernel.
 


