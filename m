Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27454279795;
	Fri, 12 Dec 2025 02:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505359; cv=none; b=lNNZVs9UKrlw4N5q+m4q2wTIdlKmkwnOXXERgDh0b4E28PwxLFGnO6eYEVRriVgoOwyiDz+2X1NZzZbOXROATcf3mczLVbCYCg+mmqBAG4FCS/TVPolL/TvdAQIJa9Gs7RlRQ+gQbuG53sfWZyDbPzEVZCT7rpxuKL7gHF/kLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505359; c=relaxed/simple;
	bh=Pr9ZqcgkhMbKEi6u0ojDh7ueS1n1UgUm4OBdvVYogOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebuG1IFWp8bFTx7e8I5edTZrgXwwjJvkCxZTLvAXH/yj7gH2HN9az1Z+GHmPoQ0Ru9fBtc44wR+ENiaMqoWnUU8oMGIac8aLlHwv2XWolLBoGimpd6qqTE2yWJcPYh4bWN1oG3p9uRO9MDb2Es7PmZoCSECXtrIfF+CsiAiuqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrmR7j6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrmR7j6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4946CC4CEF7;
	Fri, 12 Dec 2025 02:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765505358;
	bh=Pr9ZqcgkhMbKEi6u0ojDh7ueS1n1UgUm4OBdvVYogOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrmR7j6PV0p9nGIgTFJ1HRRwCRBCXqsvtP/ao8kAuurXEJNFKcGY6Le/E3HGFNZRE
	 ggP2azQQHBmOGiEpvgF2DwPlf+QfPoyl3CMOOuUulQULlo4oT4wBvcoldC/wn9bKwy
	 FiZg40wEohHEFIO080maMnoDIa8SfOujU0uZDTK4Kq0gc+IF9Hs7zr1K7XTgGKsy0X
	 imjZYsBqGjDqVBkoVSbwElBsKy4grbazDRiG93aezA4qj4QyoD7pTO6zA9dEPayoek
	 dqT1fB416W2IDUXB9rgsPDybNpZiW8PK/X3aJwbPGr+QN1kn9DRt140ayU0ppLPPLg
	 mZ24QL6qgpAmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justintee8345@gmail.com>,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] nvme-fabrics: add ENOKEY to no retry criteria for authentication failures
Date: Thu, 11 Dec 2025 21:08:58 -0500
Message-ID: <20251212020903.4153935-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212020903.4153935-1-sashal@kernel.org>
References: <20251212020903.4153935-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Justin Tee <justintee8345@gmail.com>

[ Upstream commit 13989207ee29c40501e719512e8dc90768325895 ]

With authentication, in addition to EKEYREJECTED there is also no point in
retrying reconnects when status is ENOKEY.  Thus, add -ENOKEY as another
criteria to determine when to stop retries.

Cc: Daniel Wagner <wagi@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Closes: https://lore.kernel.org/linux-nvme/20250829-nvme-fc-sync-v3-0-d69c87e63aee@kernel.org/
Signed-off-by: Justin Tee <justintee8345@gmail.com>
Tested-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS
- **Purpose**: Add `-ENOKEY` to prevent pointless reconnect retries when
  authentication key is missing
- **Tags**: `Tested-by` (Daniel Wagner), `Reviewed-by` (Daniel Wagner,
  Hannes Reinecke), `Closes:` (lore link)
- **Missing**: No explicit `Cc: stable@vger.kernel.org` or `Fixes:` tag
- **Maintainer signoff**: Keith Busch (NVMe maintainer)

### 2. CODE CHANGE ANALYSIS

The change is minimal - single line modification:
```c
- if (status == -EKEYREJECTED)
+       if (status == -EKEYREJECTED || status == -ENOKEY)
```

**Where `-ENOKEY` is returned:**
- `drivers/nvme/host/auth.c:720` - No session key negotiated
- `drivers/nvme/host/auth.c:973` - No host key (`ctrl->host_key` is
  NULL)
- `drivers/nvme/host/auth.c:978` - Controller key configured but invalid
- `drivers/nvme/host/tcp.c:1698,2080,2112,2121` - Various TLS/PSK key
  failures

All these represent "key does not exist" scenarios where retrying cannot
help.

**Function impact:** `nvmf_should_reconnect()` is called by all three
NVMe fabric transports (TCP, FC, RDMA) via
`nvme_tcp_reconnect_or_remove()`, `nvme_fc_reconnect_or_delete()`, and
`nvme_rdma_reconnect_or_remove()`.

### 3. CLASSIFICATION
- **Bug fix**: Yes - fixes futile retry behavior
- **New feature**: No - extends existing error handling pattern
- **Follows established pattern**: The `-EKEYREJECTED` check was added
  in v6.10 (commit 0e34bd9605f6c) with identical logic

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: 1
- **Files touched**: 1
- **Complexity**: Trivial
- **Risk**: Extremely low - change only affects reconnect decision for
  an already-failed authentication
- **Regression potential**: Near zero - the code path only executes when
  authentication already failed

### 5. USER IMPACT
- **Who is affected**: Users of NVMe Fabrics (TCP/RDMA/FC) with
  authentication enabled
- **Severity without fix**: Wasteful reconnect retries, potential log
  spam, resource consumption
- **Not a crash/data corruption**: This is a behavioral improvement, not
  a critical fix

### 6. STABILITY INDICATORS
- Tested by Daniel Wagner (NVMe developer)
- Reviewed by Daniel Wagner and Hannes Reinecke (both storage/NVMe
  experts)
- Clean, simple change with clear semantics

### 7. DEPENDENCY CHECK
- Requires commit `0e34bd9605f6c` ("nvme: do not retry authentication
  failures") from v6.10
- NVMe authentication feature itself was added in v6.1 (`f50fff73d620c`)
- Backport applies cleanly to trees with the `-EKEYREJECTED` check

### Decision Rationale

**Pros for backporting:**
- Trivial one-line change with zero regression risk
- Fixes real wasteful behavior (pointless retries that can never
  succeed)
- Follows existing code pattern already established
- Reviewed and tested by domain experts
- Semantically correct: `-ENOKEY` means "no key available" - retry won't
  create one

**Cons for backporting:**
- No explicit `Cc: stable@vger.kernel.org` tag from maintainers
- Not a crash, security bug, or data corruption fix
- NVMe authentication is a relatively niche feature
- Bug impact is resource waste, not functional failure

**Conclusion:**
This is a low-risk, obviously correct bug fix that prevents wasteful
behavior. While it lacks explicit stable tags and isn't fixing a
critical bug, the change is so simple and safe that the benefit-to-risk
ratio strongly favors inclusion. The fix completes the authentication
error handling that was started with the `-EKEYREJECTED` check, making
it a natural complement to that existing code. Stable kernel users with
NVMe authentication would benefit from not having pointless reconnection
storms when their keys are missing.

**YES**

 drivers/nvme/host/fabrics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 2e58a7ce10905..55a8afd2efd50 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -592,7 +592,7 @@ bool nvmf_should_reconnect(struct nvme_ctrl *ctrl, int status)
 	if (status > 0 && (status & NVME_STATUS_DNR))
 		return false;
 
-	if (status == -EKEYREJECTED)
+	if (status == -EKEYREJECTED || status == -ENOKEY)
 		return false;
 
 	if (ctrl->opts->max_reconnects == -1 ||
-- 
2.51.0

