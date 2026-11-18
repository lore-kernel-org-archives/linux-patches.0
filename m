Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018468;
	b=lMLMvVK01HSRJpf0ti4muXcGb/gOLPq4zxKpU+U0f07I+8e3caZMWgn3OVrwNjDO6duF
	 Rwpp8CIE4+qy6celwBs5ufklYk+tPL/i16FqsfUz5eVzqCPv1aifqzxunXCO+BNjazg8I
	 aisw8VFERYfNZlKJim367OxxtPOxCF8XlnvpvW4Z9U4Bg7Kx7tW3VWLLTEaSTKDKnRLAg
	 DfDXSDAFtvU8IomiKXrGHPmpPt3achUvGeA9/k9O0Rcop7DWc6+ARAi8iFqajRm6nBi7a
	 pLM7jwzS5geMoJq6oqlcy+o9zucV3ljtKmNcJT/URofOCyLA1w8nqFCGgWCkKfYEZwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oY2pJwysh6Ls7OKOyzqcVpBonyQZhyDCKmeS5GJSbXw=;
	b=YLccIrWUrdMOrUv1bESuW3r89zq6opo4CTgJq61QP6A3/0z3cZwXir7dOxaguzboqW+n
	 LxD+Kz80o5R8eYrF/LrbgBrvrzjyetcaJhCAzg25eDy4K1r2gNtxGi76NvC40J1g5B1aY
	 btDm39dvvMgym/+4GOOKMjn1/k0bXB5ns/DdKxtZDcAL6ZBRyh1BsjO9SkN7F4BfdFRPR
	 Dq9Dy0b6lnPNMU1T8/HGqA5GPqAaK9jq4eweR+T4ffL+eZQYM4F+MCHgWWyMGVGP/yBEq
	 c20yAH/FIDadZdRadgNqzW3nPjhRqHHN1/+pr399IQ2tOkor2Tlg7eqPZYthOPq9Ddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RV2PpwCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29DA606A31C;
	Wed, 18 Nov 2026 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RV2PpwCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126D61F000C4;
	Wed, 18 Nov 2026 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018468;
	bh=oY2pJwysh6Ls7OKOyzqcVpBonyQZhyDCKmeS5GJSbXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RV2PpwCfkgw4Z2gmJ8o148KQ/McjLnUSXQf/ynYXPXFGPipAq0qs/w+Gq265OBUjV
	 SSwP0HybIVu6kcGe4xsNU1cjAa4sXVFgxZRVaP3K3aW954JXh9NtzlT90Z5eTZxr3i
	 R5NxUwSBbXR+0NAGhk9XGYNpwKojcPgiZ/druizI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1250/2651] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:41:30 +0100
Message-ID: <20261118150332.984268202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit a7d32fa14bc74d1786a2f0513b6f0815bd4be311 ]

commit fc5377668c3d ("tracing: Remove markers") deleted the marker code
and the modpost output. Follow-up commit 8723eaeff59a ("Kbuild: clean up
marker") removed it from clean and mrproper targets. Both are from 2009,
so the file is hopefully no longer in anyone's tree, drop it from
.gitignore as well.

Fixes: 8723eaeff59a ("Kbuild: clean up marker")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/8cbe913b9f80dc6fea73a9e3d51429db2b38905f.1790838401.git.jstancek@redhat.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 1 -
 1 file changed, 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 9875120ea7bde..01e6a1f7a49e4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -75,7 +75,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.builtin.ranges
-- 
2.53.0



