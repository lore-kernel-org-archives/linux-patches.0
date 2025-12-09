Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7142BE630;
	Tue,  9 Dec 2025 00:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239475; cv=none; b=DXoGzTfl7CgId87H8QvoPQDjLF7lwtKSJILgfMS34pxobHcyuUcAZ5UhhiwYfTLy3hYO9mv2vuoWHZdaMNte5N7s3ug7OJeku4vrjx7O2Bnpy/+JWCS22KNjNJ/WalbcYHQrMoDY/RTC3Uf6Mam9CD7gYjcBeDI6pXtjsf3zQnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239475; c=relaxed/simple;
	bh=cPEUzSo2ozj2vxIbDNrFSslF9k3k+7JuGuR4HRH8FrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htRU/LidYeBY2JTZ4AkBm3yAawawcPCTQMoxxBp7k+4SlhxRKE0Pc1z80qVeRUEnf45ybY6dRvEzUpglbLEc47wE9+sajXHmoNd44RmSg0tUdVeCionokBfrO7EwknMMfo/vo6I4dT4PIG3igKQn5we5EbjwFMTCPuln1LX2uf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4fxNn2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4fxNn2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789D0C113D0;
	Tue,  9 Dec 2025 00:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239475;
	bh=cPEUzSo2ozj2vxIbDNrFSslF9k3k+7JuGuR4HRH8FrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4fxNn2x/INWfawtKKYCn8b5VXgokE/WpN9wq393qOhLOMCpppJlx6gMLiDD1Z1P4
	 LXSwIOESDPtCyUh5d88y1PyRLr/BC8fuV+4PvsKMh5BoBwto0gU8+eNbFh25Aob/04
	 Lc0aNDX7YAJpGMTfIuHJMSys68x0PuBPjpOlQUuNctO0WGOYsyNQ/ji2MnQY+tfxKS
	 ivw3MIfmzpsOkur9jHNnLH2Dv40EQcXkciHei8J7ToA0ZaUv+UoQSfqduQ9LXma07f
	 M4Lrkpzjhp7et6xNjJC7A2Bf/1J21Zvu4seWTwL3MVVue+TZZ+QC7dOqK1oY4tLGrl
	 uQ4UIHrXHMnog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sasha Levin <sashal@kernel.org>,
	kernelxing@tencent.com,
	pabeni@redhat.com,
	kuniyu@google.com,
	mhal@rbox.co,
	ebiggers@google.com,
	aleksander.lobakin@intel.com
Subject: [PATCH AUTOSEL 6.18-5.10] net: restore napi_consume_skb()'s NULL-handling
Date: Mon,  8 Dec 2025 19:15:24 -0500
Message-ID: <20251209001610.611575-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4c03592689bc19df9deda7a33d56c6ac0cec8651 ]

Commit e20dfbad8aab ("net: fix napi_consume_skb() with alien skbs")
added a skb->cpu check to napi_consume_skb(), before the point where
napi_consume_skb() validated skb is not NULL.

Add an explicit check to the early exit condition.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary Analysis

### 1. COMMIT MESSAGE ANALYSIS
- **Purpose**: Fixes a regression introduced by commit e20dfbad8aab
- **Problem**: The prior commit added `skb->alloc_cpu` check *before*
  the point where NULL was being handled
- **Keywords**: "restore" indicates fixing a regression; explicitly
  references the bug-introducing commit
- **Tags**: Reviewed-by Eric Dumazet (top networking maintainer),
  Signed-off-by Jakub Kicinski (net maintainer)

### 2. CODE CHANGE ANALYSIS

**Before the bug (e20dfbad8aab~1)**:
```c
void napi_consume_skb(struct sk_buff *skb, int budget)
{
    if (unlikely(!budget)) {
        dev_consume_skb_any(skb);  // Safe with NULL
        return;
    }
    if (!skb_unref(skb))  // skb_unref() handles NULL!
        return;
    ...
```

**After e20dfbad8aab introduced the bug**:
```c
    if (skb->alloc_cpu != smp_processor_id() ...)  // CRASH if skb==NULL
```

**The fix adds `|| !skb`** to redirect NULL skbs to
`dev_consume_skb_any()` which safely handles NULL (verified via call
chain: `dev_consume_skb_any` → `dev_kfree_skb_any_reason` →
`sk_skb_reason_drop` → `skb_unref` which has explicit NULL check).

**Technical Mechanism**: The bug is a NULL pointer dereference. When
`budget != 0` and `skb == NULL`, the code would try to access
`skb->alloc_cpu`, causing a kernel oops/crash.

### 3. CLASSIFICATION
- **Type**: Regression fix for NULL pointer dereference
- **Severity**: HIGH - kernel crash/oops
- **Category**: Core networking bug fix (not device ID, quirk, or DT)

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: 1 (adds `|| !skb` to existing condition)
- **Files touched**: 1 (`net/core/skbuff.c`)
- **Complexity**: Trivial - single condition addition
- **Risk**: VERY LOW - adds defensive NULL check to existing early-exit
  path
- **Subsystem**: Core networking (`napi_consume_skb` is used by many
  drivers)

### 5. USER IMPACT
- **Affected users**: Anyone using networking with drivers that call
  `napi_consume_skb(NULL, non_zero_budget)`
- **Severity if hit**: Kernel crash/oops
- **Scope**: Core networking path = HIGH impact potential

### 6. STABILITY INDICATORS
- Reviewed-by: Eric Dumazet (authoritative networking maintainer)
- Signed-off-by: Jakub Kicinski (net maintainer)
- Obviously correct fix (adding NULL check before dereference)

### 7. DEPENDENCY CHECK
- **Depends on**: Commit e20dfbad8aab must be present (the bug-
  introducing commit)
- This fix should be backported to any stable tree that contains
  e20dfbad8aab

### CONCLUSION

This is a textbook stable backport candidate:

1. ✅ **Obviously correct**: Adding NULL check before pointer dereference
2. ✅ **Fixes real bug**: NULL pointer dereference → kernel crash
3. ✅ **Important issue**: Kernel oops in core networking path
4. ✅ **Small and contained**: Single character addition (`|| !skb`)
5. ✅ **No new features**: Pure regression fix
6. ✅ **Expert reviewed**: Eric Dumazet and Jakub Kicinski (net
   maintainers)
7. ✅ **Restores previous behavior**: Explicit goal stated in commit
   message

The fix is minimal, surgical, and addresses a serious crash in core
networking code. The dependency on e20dfbad8aab is the only
consideration - this fix must accompany that commit in any stable tree.

**YES**

 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6be01454f262a..9f9ea86620ace 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1458,7 +1458,7 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 void napi_consume_skb(struct sk_buff *skb, int budget)
 {
 	/* Zero budget indicate non-NAPI context called us, like netpoll */
-	if (unlikely(!budget)) {
+	if (unlikely(!budget || !skb)) {
 		dev_consume_skb_any(skb);
 		return;
 	}
-- 
2.51.0

