Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94E425A2D1;
	Fri, 10 Oct 2025 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102255; cv=none; b=p4bx6HEo2gwzQ9nhwT/NOKkEtVog5kHK888SiOB8Ow4csRwTU0UlTP7malx5G8CoP6G8noPHMiH5ogy+qeUN2K/ktcXi0seicAG6j996xEWY07L4ffynDViRoU0W9KBppQSiqI71xXaqWdotuRrbXCmqozB9N7/NYKCSe2Yruro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102255; c=relaxed/simple;
	bh=nbFXG9nTHMSbcNnTUNl0CmuPy2h8KSfzLJfQkJtbbXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EY93Q2pDOnEe3FZkngR6zKn0gt63HaFuDP9ctyEOTjjKBQMUZH3MTs4PrSNw4CgXMmkflfdPQvu9l0lJ+Na/5PkLD/DJytlGah/jJlxnQMajGLo0Nyze4fhWOj/OGnHOp2Sn2Bbg51D9ux33FTcYgysESbaLbFLdEtqHd6pf4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiJz1agd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiJz1agd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC92C116B1;
	Fri, 10 Oct 2025 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102255;
	bh=nbFXG9nTHMSbcNnTUNl0CmuPy2h8KSfzLJfQkJtbbXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiJz1agdRFzWvFLY1T9g3bXBgLrFblrUACtBelbYz71vK2kyqIT/AS2D7wGmDcSBE
	 de/07C0bi2VRz5lAMlO0s9ZI19eJpaB085FXSCi7ekSPfwjq0QUr7JU1CStp8et8hA
	 w5PgMbT/XysHeIKbXgp6UN26W7/FquNab2U+23gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.17 08/26] rust: pci: fix incorrect platform reference in PCI driver probe doc comment
Date: Fri, 10 Oct 2025 15:16:03 +0200
Message-ID: <20251010131331.512745211@linuxfoundation.org>
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

commit 855318e7c0c4a3e3014c0469dd5bc93a1c0df30c upstream.

Substitute 'platform' with 'pci'.

Fixes: 1bd8b6b2c5d3 ("rust: pci: add basic PCI device / driver abstractions")
Cc: stable@kernel.org
Signed-off-by: Rahul Rameshbabu <sergeantsagara@protonmail.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/pci.rs |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -240,8 +240,8 @@ pub trait Driver: Send {
 
     /// PCI driver probe.
     ///
-    /// Called when a new platform device is added or discovered.
-    /// Implementers should attempt to initialize the device here.
+    /// Called when a new pci device is added or discovered. Implementers should
+    /// attempt to initialize the device here.
     fn probe(dev: &Device<device::Core>, id_info: &Self::IdInfo) -> Result<Pin<KBox<Self>>>;
 
     /// Platform driver unbind.


