Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2661534A3BC;
	Wed,  3 Dec 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778448; cv=none; b=Cf44g6s33phTF2r3TT/twhEO5dBVPMH5oQOT0TG1gTKAfM3YchrWvDWXfDzGN8hxGaJ7gNwOOkemZzovOM1jaGYHp30IAxHzBli6LIzibPkO3MbhzQn+AOwFoG2pG5yXTLadCwi0G1jBUH/0+gdZKkkHF4IjAI/vq6yGQJRSfrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778448; c=relaxed/simple;
	bh=nvF5tRz6cbZ6VKW1k0qYQfKCaUw4DljIwpwg4p71XvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0jF7eYLjRcwQpL0pzlCsDRQ9GKebfFIkAXwBRit98M6Tb2+1kEvZTi0UvjTAaLnP/9oIf6mUFg6lFopKN9Vyq9g5VGxDQAdu1R5gOdMCLC1/NwHzYAyUTl0yuXHdxqSwmOf/5LS1rFFEXbJ411NMuojrn41IOYev8dANt8NVn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T5bDOSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T5bDOSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC1CC4CEF5;
	Wed,  3 Dec 2025 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778448;
	bh=nvF5tRz6cbZ6VKW1k0qYQfKCaUw4DljIwpwg4p71XvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T5bDOSFDGmKzOQTO+iiZynQrdPmnRn6vYCNv1BMboCN1hF/K/gmUkS9BBKWynINz
	 vkSDvp7HZYlwPMHiIxBOjaXm/BBu6z+Vqj+VX8hiyOieL1TMPK9MOGLNi56lN2xM/r
	 f/cWQdKuuvcCZnR2IppcDNSfjFR4RMgf1zHVEvHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 316/392] net: qede: Initialize qede_ll_ops with designated initializer
Date: Wed,  3 Dec 2025 16:27:46 +0100
Message-ID: <20251203152425.788765291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 6b3ab7f2cbfaeb6580709cd8ef4d72cfd01bfde4 upstream.

After a recent change [1] in clang's randstruct implementation to
randomize structures that only contain function pointers, there is an
error because qede_ll_ops get randomized but does not use a designated
initializer for the first member:

  drivers/net/ethernet/qlogic/qede/qede_main.c:206:2: error: a randomized struct can only be initialized with a designated initializer
    206 |         {
        |         ^

Explicitly initialize the common member using a designated initializer
to fix the build.

Cc: stable@vger.kernel.org
Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Link: https://github.com/llvm/llvm-project/commit/04364fb888eea6db9811510607bed4b200bcb082 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20250507-qede-fix-clang-randstruct-v1-1-5ccc15626fba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -194,7 +194,7 @@ static struct pci_driver qede_pci_driver
 };
 
 static struct qed_eth_cb_ops qede_ll_ops = {
-	{
+	.common = {
 #ifdef CONFIG_RFS_ACCEL
 		.arfs_filter_op = qede_arfs_filter_op,
 #endif


