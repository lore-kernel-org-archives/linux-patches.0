Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059978;
	b=j+EaVDzAGjIKNknNoC02IYch6qJS2E1WYGHcPZs/NzOZXJIx0LmXF+O3xdi9tYzEGLPg
	 PZMBU0pHTpzSkJXpnfnrs4cLlRbD2lkUhyWxipDp59MyiSrBUN0QEfWNJ/XVqKAarPSjG
	 nxpXsxcpIQ2Su2KfgHA01SLxRP3D2wWCtzClOVYh7EqlfW5PKHjM69hKH7NPQp4g8lct0
	 4NUkJwsDJ9FTWoWGsEsMFkth5oB3zp6XEoGrR/dhzlENX/jUJxmL4bl1gMOdhIcuzKANr
	 ZvUic5GcUVFEBACaPeoBKfPE0VGC+ZOc1OTy4J1NSaGp08CQ6BgIxct2lgyFba0NmcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+vUQLoX1Nc6FLm4RcE3ZqSRYWE8i48CY7B4NPDBedM=;
	b=JI790DrJqpvXvSv0+uauJhkUaZuDm9D442F0dn4X6yvaBwF404/gpq2U2Ghtkq9mHhLE
	 RGEDCgHXsEaFWbTNBilfdBMMugnSHWu1rfIjWg+Gpxxm3r1yWTHcK1eKZyM7k66llM/mF
	 p7oFBw97Hsjbn7T9R1lfh4xWJl5PensXY7F4EyRkW4sZOX7BGECnoVRH64604csyokfto
	 EI/O7wt+uTXnx+NNUViKFmrL5s5vHxhitHYCaNAC6UbImnEPJn+YiDtgF1L+4NdUbjgYG
	 p19n5BwPi72GiwIGI/WjBxBGWp08mFEMWEM+IrGTUkYtIeH+jur8NBAv9T7XXV5yt9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJwo37kb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C74606A32C;
	Sat,  7 Nov 2026 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJwo37kb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B711F008A1;
	Sat,  7 Nov 2026 13:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059978;
	bh=1+vUQLoX1Nc6FLm4RcE3ZqSRYWE8i48CY7B4NPDBedM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJwo37kb4csKImEIFvw0TdTNldRU6QcHcFc79x+hUa+Nhu7a8PObEOfp4hilvCwc2
	 yRrSXN9XnucZnhjSI7u5dRjOPqvuNZmqT1MnBIxxUY8WBfb2mu+Cpq7voFkH0Kt0Jq
	 Hh9NUYO6Xmd8L6xuSHWrL6Ly3ZpLuzk1e+OQkmMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/869] x86/mm/pat: Use pr_warn() for early W^X warnings
Date: Sat,  7 Nov 2026 08:44:44 -0500
Message-ID: <20261107134852.147704185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit ea6fd393cb9e6811a748c7551de0dd3090f9dcde ]

Nathan Chancellor reports the following warning:

  CPA detected W^X violation: 8000000000000123 -> 0000000000000123 range: 0xffffffffc0400000 - 0xffffffffc0400fff PFN 100e00

from its_alloc() doing set_memory_x() during early retpoline setup.

The warning is not factually wrong but it is unproductive. First, the RWX
permission is temporary and fixed up by execmem_restore_rox(). Second,
at the time of the warning, all kernel text is mapped RWX. So there is not
even a transient actual security issue.

The right way to fix this up is to relax RWX detection during boot but
make a final verification pass over all kernel page tables before running
userspace.  There is code to do that today (debug_checkwx()) but it
must be enabled explicitly in Kconfig.

For now, retain the warning even if it's unproductive, but make it
scream less loudly: use pr_warn_once() rather than WARN_ONCE().

Remove the warning once debug_checkwx() behavior becomes unconditional.

Closes: https://lore.kernel.org/all/20260905044253.GA3816371@ax162
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://patch.msgid.link/20260913-fixes-verify-rwx-v3-1-5e1d6a08bd02@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 12b7de5f0957e..9fc18a091311f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -718,6 +718,21 @@ static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long star
 		return new;
 
 	end = start + npg * PAGE_SIZE - 1;
+
+	/*
+	 * If the kernel text is still RWX, gently complain, this could be a
+	 * false positive.
+	 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
+	 * the warning can be removed completely.
+	 */
+	if (!kernel_set_to_readonly) {
+		pr_warn_once("CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
+		  (unsigned long long)pgprot_val(old),
+		  (unsigned long long)pgprot_val(new),
+		  start, end, pfn);
+		return new;
+	}
+
 	WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
 		  (unsigned long long)pgprot_val(old),
 		  (unsigned long long)pgprot_val(new),
-- 
2.53.0



