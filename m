Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033301;
	b=PdWe//ROxia6ISlUF9yE3/JcqCYRQQDqjmmjOPrXS9/XNbQK5BY/wOzJNJsZJIXw9Bw5
	 Q5dMsbpZY+Ot+DHnXGB3rgJc6mvNnq0licU32b4sHCxX24VjPwxuYvfZmy0hX8zTnPnhE
	 NqJIlYu5ofIuXHMsj/JkaWs8c7MBqQiDeOMBJHO61NaFcIk0S7mAPQBQ9AgZqRJB443+J
	 2JZKUrnbLHbeDnA8QxP5xzzjpBxYSGFCEx/EnlZwLjf63e01S0XUkxVgQHaD0MVLMMU+y
	 Bpw6Zu7ZbwlR9RgHGmoxuLdYVRX41FumijXgb8kIFz0kkz/hMQRvCppVzFEXpOqPffA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UVlksUAs5Ty+Dy2sN+jV2w4cht2dOGnGs0nuwWJ5RXg=;
	b=g/MrtvkA3zOnhLrbALTdF6D24ss+K9g/FMZ+WWBJTRE/FLELIBGXvD/BvPRUC6D+eSNp
	 jYPCHxqrDMW6WqmTuxFvIit4eh0Ub/YhKBYBsanvE8451v5syX0sqbx0FIRbBXgEkZNEL
	 Dwlf5GTEmNIBY2wXFtEJxYtxUcc9pSWaZGbxZ1RamJAZNNsrwlaQYekZVRSMZpcKpNj/W
	 LXLEt/+8k1fh9Cwmr5u5Gkh7EhC6w1LCE1Aww08AMlJ6RrneKF922tUKY0Lj4Nxi3fztz
	 ZJ98lxThjfFI1mDxy2pVm7K2Nf+BwBbJILlrp6g1spqpeIaFhAX+4PWT8mQa+5e9oAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVCHl1K3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAFD606A31C;
	Wed, 18 Nov 2026 20:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVCHl1K3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624541F000C4;
	Wed, 18 Nov 2026 20:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033300;
	bh=UVlksUAs5Ty+Dy2sN+jV2w4cht2dOGnGs0nuwWJ5RXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVCHl1K3LVjzubGPx5HsGwMuEuSV+VNDhnF4QWfLHRAZ1ifq31RQtJ/bBRUSUu+3h
	 Prw1PRCnpajDMuHBf2FxXBMd7hMerCSY4Jvl7M5/FWJMeaNA6mBt2bYzFs3SYh4z9L
	 VB0Z2q9YEIhObp1pq8DygMy66eIqfmXBPdVrPeL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1693/1756] apparmor: convert duplicated dfa transitions to match_char()
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150117.068247388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit e667fc72f7f4a54674962c324048ca2cc58bc703 ]

For historical reasons several matchers duplicate the dfa character
transition instead of using match_char().

This is because aa_dfa_match_until() and aa_dfa_matchn_until() were
written on a branch that did not yet have match_char(), and copied code
from aa_dfa_match(). leftmatch_fb() used the same pattern.

When match_char() added support for diff-encoded states, the change was
never ported to these copies.

match_char() resolves a diff encoded state by using def[state] and
retrying the same character, until it reaches a state with a valid
transition. The copies instead do a simple `state = def[state];` after
the character is consumed, so on a diff encoded state one byte is dropped
and the walk continues from the diff parent in the wrong state.

This makes an unnamed px/Px/cx/Cx transition resolve to no profile, and
exec fails with

  apparmor="DENIED" operation="exec" info="profile transition not found"

Convert the three copies to match_char(). For a dfa with no diff
encoded state this is a no-op.

This bug is latent until the kernel advertises policy/diff-encode.

Closes: https://gitlab.com/apparmor/apparmor/-/work_items/663
Fixes: 21f606610502 ("apparmor: improve overlapping domain attachment resolution")
Fixes: 031dcc8f4e84f ("apparmor: dfa add support for state differential encoding")
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/match.c | 52 ++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 7c11a52d542af..ed98f173f7f35 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -615,7 +615,7 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	if (state == DFA_NOMATCH)
 		return DFA_NOMATCH;
@@ -626,22 +626,18 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
 		u8 *equiv = EQUIV_TABLE(dfa);
 		/* default is direct to next state */
 		while (*str) {
-			pos = base_idx(base[state]) + equiv[(u8) *str++];
-			if (check[pos] == state)
-				state = next[pos];
-			else
-				state = def[state];
+			u8 c = equiv[(u8) *str++];
+
+			match_char(state, def, base, next, check, c);
 			if (accept[state])
 				break;
 		}
 	} else {
 		/* default is direct to next state */
 		while (*str) {
-			pos = base_idx(base[state]) + (u8) *str++;
-			if (check[pos] == state)
-				state = next[pos];
-			else
-				state = def[state];
+			u8 c = (u8) *str++;
+
+			match_char(state, def, base, next, check, c);
 			if (accept[state])
 				break;
 		}
@@ -676,7 +672,7 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	*retpos = NULL;
 	if (state == DFA_NOMATCH)
@@ -688,22 +684,18 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 		u8 *equiv = EQUIV_TABLE(dfa);
 		/* default is direct to next state */
 		for (; n; n--) {
-			pos = base_idx(base[state]) + equiv[(u8) *str++];
-			if (check[pos] == state)
-				state = next[pos];
-			else
-				state = def[state];
+			u8 c = equiv[(u8) *str++];
+
+			match_char(state, def, base, next, check, c);
 			if (accept[state])
 				break;
 		}
 	} else {
 		/* default is direct to next state */
 		for (; n; n--) {
-			pos = base_idx(base[state]) + (u8) *str++;
-			if (check[pos] == state)
-				state = next[pos];
-			else
-				state = def[state];
+			u8 c = (u8) *str++;
+
+			match_char(state, def, base, next, check, c);
 			if (accept[state])
 				break;
 		}
@@ -752,7 +744,7 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
 	u32 *base = BASE_TABLE(dfa);
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	AA_BUG(!dfa);
 	AA_BUG(!str);
@@ -770,13 +762,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
 		/* default is direct to next state */
 		while (*str) {
 			unsigned int adjust;
+			u8 c = equiv[(u8) *str++];
 
 			wb->history[wb->pos] = state;
-			pos = base_idx(base[state]) + equiv[(u8) *str++];
-			if (check[pos] == state)
-				state = next[pos];
-			else
-				state = def[state];
+			match_char(state, def, base, next, check, c);
 			if (is_loop(wb, state, &adjust)) {
 				state = aa_dfa_match(dfa, state, str);
 				*count -= adjust;
@@ -789,13 +778,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
 		/* default is direct to next state */
 		while (*str) {
 			unsigned int adjust;
+			u8 c = (u8) *str++;
 
 			wb->history[wb->pos] = state;
-			pos = base_idx(base[state]) + (u8) *str++;
-			if (check[pos] == state)
-				state = next[pos];
-			else
-				state = def[state];
+			match_char(state, def, base, next, check, c);
 			if (is_loop(wb, state, &adjust)) {
 				state = aa_dfa_match(dfa, state, str);
 				*count -= adjust;
-- 
2.53.0



