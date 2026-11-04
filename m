Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831201;
	b=ofYGuX3o8lZKM1ZBkLFdiZpmUJX9AAYOfS+0032dZ29tS46CTUeczMxiAZaaoWyDxB74
	 9sV6ZkcinQnbH6SWWiwDcUL3mBZZVkkq1PFDC5k/Z+bXrXGEeXPEvhKYq9drVMrd678dC
	 bmIZNp874E1PTXxZOBM1Oipt/4l3aZQxmnXTaZfsKi4QS2v8JkLKFJMbDW45Thbas5Roq
	 4v8HP6KBKFRwUnSuyfzTr3EGfZ2Ur1bgzg6IY8omxpKBJX62Bs7rgweMr/o7YBnW/u9iN
	 7jbCb0R6BZMI4Eu+y4PGEKA4IedlVsiTpbNoWkXvNHV7gDRKqGk0vwhuQSpArFSnRgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wuu25iZzeZBdKH5cmEpLRWxvtcDd4YuYWT17mO6SSMs=;
	b=zRPlORXAB0P/XmZTasIk0nJwlT1kK4K8Et8CmSK1jGW4dKCJkg3CqR1Pxbm1bGtLLUuA
	 vx+zmeqCsR0v3sBqT3tzWAPFehKALnc3FQbAM+jqhRdVjNlYejTkRqoG41VQM5IoAkxnu
	 fqBqgfhwsLJPpWWKHrbCu7yAL81ATIIt4BFe4EQjIj9yUjzzs4J78bIDFwmYGHOrTdfuu
	 UNnML407n/VHCRIguvufcsSNxW8cgIV9llhWt7Zuz05moRSl41N3CrOoSS9fIi7bnmeX2
	 1zs9asyV7TeiJSgc1kzDLWDshb/P0kO4EdC+EZ1p/FxMoIkQ6WdFH+22OmNkE8ZFL0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecvcigq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14635606A847;
	Wed,  4 Nov 2026 22:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecvcigq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FC31F000C1;
	Wed,  4 Nov 2026 22:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831200;
	bh=Wuu25iZzeZBdKH5cmEpLRWxvtcDd4YuYWT17mO6SSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecvcigq0vf6Z6aRHcTtus/d+mBK4hCm0O85zmQ+jjSLv/9dObqCWKty53yDpXcYHB
	 wkW/qrZiq/NUpAPg77dokqPV3N6DM2w2luSk8Lj77nYbXR4cZCmnlFFjqpHZf64j6j
	 oOwnI+PpWQHODic0PFumDA2W7Bj9h5dPlw0/z9/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <tchiu@tenstorrent.com>,
	Jesse Taube <jtaubepe@redhat.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0561/1005] riscv: hwprobe: initialize pair->value in hwprobe_one_pair()
Date: Wed,  4 Nov 2026 16:04:54 -0500
Message-ID: <20261104211059.603484793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Andy Chiu <tchiu@tenstorrent.com>

[ Upstream commit d0fc6fab20460add1f27402cd8b945d094a56b21 ]

The vendor-extension handlers reached from hwprobe_one_pair()
(hwprobe_isa_vendor_ext_thead_0() and friends) only OR the present bits
into pair->value via VENDOR_EXTENSION_SUPPORTED() and clear their own
missing bits; they assume the caller has already zeroed pair->value.

That holds for hwprobe_get_values() (it zeroes each pair) and
hwprobe_get_cpus() (it re-initializes its scratch pair per key), but not
for complete_hwprobe_vdso_data(), which reuses a single pair across all
keys without re-zeroing. A vendor key therefore inherits stale bits from
the previously probed key, and the wrong value is cached in the vDSO
all_cpu_hwprobe_values[] and handed to userspace on the fast patih.

Zero pair->value once at the top of hwprobe_one_pair() so every handler
starts from a clean value regardless of the caller, and drop the now
redundant zeroing in the *_BLOCK_SIZE cases. hwprobe_isa_ext0() keeps its
own zeroing because hwprobe_ext0_has() calls it directly, bypassing
hwprobe_one_pair().

Fixes: a5ea53da65c5 ("riscv: hwprobe: Add thead vendor extension probing")
Signed-off-by: Andy Chiu <tchiu@tenstorrent.com>
Reviewed-by: Jesse Taube <jtaubepe@redhat.com>
Link: https://patch.msgid.link/20260725001614.2578617-2-tchiu@tenstorrent.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
[ sashal: Dropped the hunk that removes pair->value = 0; from the ZICBOP_BLOCK_SIZE case, since this tree has no ZICBOP key; the rest applies as upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sys_hwprobe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 460fb297672e6..9b254f3952811 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -263,6 +263,8 @@ static u64 hwprobe_vec_misaligned(const struct cpumask *cpus)
 static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 			     const struct cpumask *cpus)
 {
+	pair->value = 0;
+
 	switch (pair->key) {
 	case RISCV_HWPROBE_KEY_MVENDORID:
 	case RISCV_HWPROBE_KEY_MARCHID:
@@ -293,12 +295,10 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pair,
 		break;
 
 	case RISCV_HWPROBE_KEY_ZICBOZ_BLOCK_SIZE:
-		pair->value = 0;
 		if (hwprobe_ext0_has(cpus, RISCV_HWPROBE_EXT_ZICBOZ))
 			pair->value = riscv_cboz_block_size;
 		break;
 	case RISCV_HWPROBE_KEY_ZICBOM_BLOCK_SIZE:
-		pair->value = 0;
 		if (hwprobe_ext0_has(cpus, RISCV_HWPROBE_EXT_ZICBOM))
 			pair->value = riscv_cbom_block_size;
 		break;
-- 
2.53.0



