Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AA41F936;
	Thu, 12 Feb 2026 01:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858629; cv=none; b=MNXeAlXZBegz6JzQaUAwxKFZ3iRMnvWRxiioVHzSl0bCk/fb9K1DbfNBLEnVb5JpXZ/WoTwxUm7WOIgXUTgkn7dAxBV3kdLvOX8G9xjiw2j9mWGbhtLJFaOpblxuBzjM00fww3kNu2SYz2RUN7nvWSyBhI8FtTAGq5vZaJbIRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858629; c=relaxed/simple;
	bh=JJMyvz9Gyol/tePNZ0QStCdz7UvkRz/nPoOYJJd6dDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRAXQiSEnXMBJ2BC0Qoh7DLHuR8uZN4AjiNMc+Vbs5pbyoaGx32B/ph6r5aACvOfEsaTx6ssFZQ/umTWl1DRHktyyIzORt0E3FjBuV/OE3g4n/JWTthIB1/khu+AI3n5+FGDZAkmy8mGs7BeaBJZNwlqEz7xb+V1tDwzhIZiRmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOBJGzlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOBJGzlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55981C19425;
	Thu, 12 Feb 2026 01:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858629;
	bh=JJMyvz9Gyol/tePNZ0QStCdz7UvkRz/nPoOYJJd6dDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOBJGzlkISwvtVJfn5LNgM1vAY6ukAVSSdZ/hL4MKnPKObUBPNnbFphcGBOh85nFW
	 DMacmioWLlUimP313y3Mftewfkfujsm5pUZ4aMdlAtQe68PODAXMncPvIQUIp1yW8u
	 HU+YHEpWWalOXguySxERBLdZtFGSTtBVBy9NNwDfmQvITy21t6Z/WtGG1GcQIVsO+Q
	 ZcqOeiyXiTxdqUoSdrp/TTxg9YuSpLJLIzMOGY8VkMqnpzaEkiFLvSOrEtDVCrsv9x
	 Ina+YBP4gbpIydbHetPnp9cHvTL/srbDjrxEYvGcn0qVJ8yOtTvE8H3qLJzB5OedfL
	 9bORJy3LighdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] bpf: net_sched: Use the correct destructor kfunc type
Date: Wed, 11 Feb 2026 20:09:43 -0500
Message-ID: <20260212010955.3480391-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit c99d97b46631c4bea0c14b7581b7a59214601e63 ]

With CONFIG_CFI enabled, the kernel strictly enforces that indirect
function calls use a function pointer type that matches the
target function. As bpf_kfree_skb() signature differs from the
btf_dtor_kfunc_t pointer type used for the destructor calls in
bpf_obj_free_fields(), add a stub function with the correct type to
fix the type mismatch.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260110082548.113748-8-samitolvanen@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

---

## Commit Analysis: `bpf: net_sched: Use the correct destructor kfunc
type`

### 1. COMMIT MESSAGE ANALYSIS

The subject and body clearly describe a **bug fix** for CONFIG_CFI
(Control Flow Integrity). The key phrase is: "fix the type mismatch."
The author is Sami Tolvanen from Google, who is a primary author and
maintainer of the kernel CFI infrastructure. The commit is acked by
Yonghong Song (BPF maintainer) and signed off by Alexei Starovoitov (BPF
co-maintainer).

### 2. CODE CHANGE ANALYSIS

The diff is extremely small: **6 lines added, 1 line changed**, in a
single file.

**The bug mechanism:**

1. `btf_dtor_kfunc_t` is defined as `typedef void
   (*btf_dtor_kfunc_t)(void *)` in `include/linux/bpf.h` (line 228).

2. In `bpf_obj_free_fields()` (`kernel/bpf/syscall.c:855`), the
   destructor is invoked as:

```855:855:kernel/bpf/syscall.c
                                field->kptr.dtor(xchgd_field);
```

This is an **indirect function call** through a `btf_dtor_kfunc_t`
pointer (expecting `void *` parameter).

3. However, `bpf_qdisc.c` registers `bpf_kfree_skb` — which has
   signature `void bpf_kfree_skb(struct sk_buff *skb)` — as the
   destructor:

```452:452:net/sched/bpf_qdisc.c
BTF_ID_LIST_SINGLE(bpf_sk_buff_dtor_ids, func, bpf_kfree_skb)
```

4. With `CONFIG_CFI` enabled, the kernel **strictly enforces** that
   indirect calls match the expected function pointer type. Calling a
   `void (*)(struct sk_buff *)` function through a `void (*)(void *)`
   pointer is a **CFI violation**, which triggers a kernel panic/trap.

**The fix:**
- Adds a thin wrapper `bpf_kfree_skb_dtor(void *skb)` that matches
  `btf_dtor_kfunc_t`
- Marks it with `CFI_NOSEAL()` so the compiler retains CFI metadata for
  this function even though its address isn't directly taken in C source
- Updates `BTF_ID_LIST_SINGLE` to reference the correctly-typed wrapper

### 3. ESTABLISHED PATTERN

This fix follows an **identical, well-established pattern** introduced
by Peter Zijlstra in commit `e4c00339891c` ("bpf: Fix dtor CFI"), which
applied the same fix to:
- `kernel/bpf/helpers.c`: `bpf_task_release_dtor`,
  `bpf_cgroup_release_dtor`
- `kernel/bpf/cpumask.c`: `bpf_cpumask_release_dtor`
- `net/bpf/test_run.c`: `bpf_kfunc_call_test_release_dtor`,
  `bpf_kfunc_call_memb_release_dtor`

When `bpf_qdisc.c` was added in v6.16 (commit `c8240344956e3`), it
**failed to follow this pattern**, registering `bpf_kfree_skb` directly
as the destructor instead of using a type-correct wrapper. This commit
fixes that oversight.

### 4. AFFECTED STABLE TREES

- `bpf_qdisc.c` was introduced in **v6.16** (commit `c8240344956e3`)
- The file does **NOT** exist in LTS trees 6.12.y, 6.6.y, 6.1.y, 5.15.y,
  etc.
- The file **exists with the bug** in: **6.16.y, 6.17.y, 6.18.y** (all
  confirmed)
- `CFI_NOSEAL` macro is available in all three (introduced in 6.8-era)
- v6.16.y has a slightly different `BTF_ID_LIST` format (needs trivial
  adaptation), while v6.17.y and v6.18.y match the patch exactly

### 5. SELF-CONTAINMENT

Despite being patch 8 of a series (per the Link URL), this patch is
**completely self-contained**:
- The new wrapper function only calls the existing `bpf_kfree_skb()`
- The `BTF_ID_LIST_SINGLE` change just replaces one function name with
  another
- No dependencies on infrastructure changes from other patches in the
  series
- No changes needed to kfunc registration, BTF_KFUNCS, or other
  subsystems

### 6. USER IMPACT

- **Trigger condition**: Any BPF qdisc struct_ops program that results
  in an sk_buff being destructed through the kptr destructor path, on a
  kernel compiled with `CONFIG_CFI`
- **Impact when triggered**: Kernel panic/crash (CFI trap)
- **Affected users**: Android devices (which enable CFI), security-
  hardened systems using BPF qdisc scheduling
- **Severity**: High — kernel crash with no recovery

### 7. RISK ASSESSMENT

- **Lines changed**: 6 added, 1 modified
- **Files changed**: 1 (`net/sched/bpf_qdisc.c`)
- **Complexity**: Trivial — a type-correct stub function and a BTF_ID
  reference change
- **Regression risk**: Near-zero — the wrapper is a transparent
  indirection that adds no logic
- **Already proven**: The exact same pattern works in 4+ other BPF
  destructor sites since v6.8

### CONCLUSION

This commit fixes a **real kernel crash** (CFI violation → panic) that
affects any system running with `CONFIG_CFI` enabled when BPF qdisc
struct_ops triggers destructor calls. The fix is tiny, surgical, follows
an established pattern proven across multiple other subsystems, and has
near-zero regression risk. The affected code exists in 6.16.y, 6.17.y,
and 6.18.y stable trees, and the patch applies cleanly to 6.17.y and
6.18.y (with a trivial adaptation for 6.16.y).

**YES**

 net/sched/bpf_qdisc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/bpf_qdisc.c b/net/sched/bpf_qdisc.c
index adcb618a2bfca..e9bea9890777d 100644
--- a/net/sched/bpf_qdisc.c
+++ b/net/sched/bpf_qdisc.c
@@ -202,6 +202,12 @@ __bpf_kfunc void bpf_kfree_skb(struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+__bpf_kfunc void bpf_kfree_skb_dtor(void *skb)
+{
+	bpf_kfree_skb(skb);
+}
+CFI_NOSEAL(bpf_kfree_skb_dtor);
+
 /* bpf_qdisc_skb_drop - Drop an skb by adding it to a deferred free list.
  * @skb: The skb whose reference to be released and dropped.
  * @to_free_list: The list of skbs to be dropped.
@@ -449,7 +455,7 @@ static struct bpf_struct_ops bpf_Qdisc_ops = {
 	.owner = THIS_MODULE,
 };
 
-BTF_ID_LIST_SINGLE(bpf_sk_buff_dtor_ids, func, bpf_kfree_skb)
+BTF_ID_LIST_SINGLE(bpf_sk_buff_dtor_ids, func, bpf_kfree_skb_dtor)
 
 static int __init bpf_qdisc_kfunc_init(void)
 {
-- 
2.51.0

