Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF52812E1F8;
	Tue, 30 Apr 2024 11:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475497; cv=none; b=Mfdrr9fRunGOa3lu8SVUlhIoOBtHr4dwOU61ZDookMc6WmWiS1j/oGNsXe72rwVCEGb2m9BigjhqQVKZQmTt8R8flHkHRi3CnO3vzf4pzAV09wBBbW2/tprp4Zp3SXdg8FvrqWWRxBeh4ubC3zJmdBZWfBpw0STN2teZPKv6OLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475497; c=relaxed/simple;
	bh=52exE09QOeGQy/ycTOq9ptjLIxvLTVLWU2BVUh0ySeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qocEWAlCturWWTL9fgqktmkc/DKwPVph45mbix1EAerNM2zu33JWmL/ruy1OfBOXavlE8I1CNJNbeAZ358FLkS1J3kgkOGBacX6VHJ6WZFKEssLkYMRgwWIVOT5uZE5RdEuTUuwVSwW8iIaN/FI76N/xA0jWk1OsIIN67T6WkkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DP+UfFgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DP+UfFgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C263C4AF1D;
	Tue, 30 Apr 2024 11:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475496;
	bh=52exE09QOeGQy/ycTOq9ptjLIxvLTVLWU2BVUh0ySeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DP+UfFglcWNXe6poK2AURNJStI7U2D5PjkvZGBPX6ghdBz9nkIBS7seCO3+2C0sDy
	 WmzwpYqhLKsQ4YSNJuOfn7j6hJt6/wN8+uvVraBTiGh+3O/6L2qFSlmS+c+Lg8AD5H
	 HvsoMlApbr0NXzhUmIYfH+xVUaZqNCiG9D/gLvIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 112/186] rust: dont select CONSTRUCTORS
Date: Tue, 30 Apr 2024 12:39:24 +0200
Message-ID: <20240430103101.284870656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
@@ -1898,7 +1898,6 @@ config RUST
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
-	select CONSTRUCTORS
 	help
 	  Enables Rust support in the kernel.
 


