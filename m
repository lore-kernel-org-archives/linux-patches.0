Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDC18B470;
	Tue, 30 Jul 2024 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356198; cv=none; b=ZR6lhngvDlpqmgo5bt0lMih6c7Oodl6BamsczgtZOaZ4FNFpv/1e2rbYrsG6Fu8kr7iAsdosQJBEpXxvlwe19+tsAKsnX7pCeyF+tUkHI1AbGzjVGfqrfMbSQ6V0qPOIawRUWbIfWQlNsDR1iOe6+TbaaKW2Rs/uWxxFtkuL7Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356198; c=relaxed/simple;
	bh=AC6iZqGaLpbYIcWmB2L/NfqF6PBRU4awOZFLsW+Ng7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPP5zQ7B6lZKhjGhj742IKntc4H2a9ubRZeDp2Y12TC8yWaMAsnjaKmt7rKs2m/C7cttECRMYzJNAxXAqvkg3eWS4YM9wLSuww/TXwSON+uEDArlSOV9XEL+vR6VwQWfV7XdwMnMnDEiAjoLlXqgOy+uPDBhWYUQnC5M3dMPiT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGH9sW3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGH9sW3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD4BC32782;
	Tue, 30 Jul 2024 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356197;
	bh=AC6iZqGaLpbYIcWmB2L/NfqF6PBRU4awOZFLsW+Ng7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGH9sW3V6DkkvXbFwqup9+ygeEDnyPprYVhOWDzpCK+NLvupxsETVtipb9z9OBCIV
	 1FK0r+ei3aeI7XeaVK27DyfhgrK2RUqG+SD785hmVmaHf3ONqzMKBpjfQu9woE+g+n
	 hUbGehuXwqfywiaK2T1aRrx3IAB9yMBm+LYywjqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 128/809] x86/xen: Convert comma to semicolon
Date: Tue, 30 Jul 2024 17:40:04 +0200
Message-ID: <20240730151729.674160931@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 349d271416c61f82b853336509b1d0dc04c1fcbb ]

Replace a comma between expression statements by a semicolon.

Fixes: 8310b77b48c5 ("Xen/gnttab: handle p2m update errors on a per-slot basis")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240702031010.1411875-1-nichen@iscas.ac.cn
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 99918beccd80c..6bcbdf3b7999f 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -730,7 +730,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 		 * immediate unmapping.
 		 */
 		map_ops[i].status = GNTST_general_error;
-		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].host_addr = map_ops[i].host_addr;
 		unmap[0].handle = map_ops[i].handle;
 		map_ops[i].handle = INVALID_GRANT_HANDLE;
 		if (map_ops[i].flags & GNTMAP_device_map)
@@ -740,7 +740,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 
 		if (kmap_ops) {
 			kmap_ops[i].status = GNTST_general_error;
-			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].host_addr = kmap_ops[i].host_addr;
 			unmap[1].handle = kmap_ops[i].handle;
 			kmap_ops[i].handle = INVALID_GRANT_HANDLE;
 			if (kmap_ops[i].flags & GNTMAP_device_map)
-- 
2.43.0



