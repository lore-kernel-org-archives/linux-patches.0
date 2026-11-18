Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022294;
	b=L5aiQXFF5G0hAj45kItGbkCr4ICHAs+kHokyCc4C7CwZxT2HZoemna48YSA9CN7ab+uD
	 7Tj5fPrmWwnKFOqXSNqfqXszMn52r5qn8gQxpmvrGlf3xeCkMMSrMPJBNbJhEMOlB6Qsm
	 L/wz8yQezYqo2j0gzv+TkpQ/9LipAf0Ku5G8/P4k9zINKV16u62cKM4bHZG9xvrwzdn/V
	 DQNGKMFZ8sH/DLRMQTmde0Gb6m0HYGlba2y6tCi/UAmNfrCDhWd4jV9h0bxfor0yMOiO6
	 lErOskvpb92YRxpmbk3copMCYwEgRFjJpLiZzKokTlAy9Gk9pCFVRUhfNBk7m5lHzcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oinI41GtbXY1aoumt/2QhwRfHSJdVJV45hT3Zj9m/mY=;
	b=IqSyVKZaWUcWjhW00HyxzVsplbqZJTlZJdTxuFUFKQu4G1nOeFsYOzETYY7ZAAW62bFj
	 kJqGfrm/rcW96rbJlssNmwsK1dCJ8u5p4nimXbjy3abqdQJ2erKzeFpjabCKFsir9yPNL
	 0ufVIxHnG1G5GOc3EhW4MgW8LPAhn4Nt3W8zUX9LoSG32uaERrLpiaHv9OE4F/RrrtUDE
	 JJCNsDBRwZVNgi6RbUr3W4/ZZ1RQH1CHAu3IOP/f4P0N4ql+KHPkIafIaeoE7bvnt4kxV
	 DdCUG7ZBW0VCiR5HbAXEXqbYKh6u6vnK74/LWRE4XmjbXKoE79/bWsq40BZg5STslow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDf3SwHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C770A606A31C;
	Wed, 18 Nov 2026 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDf3SwHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C5D1F000C4;
	Wed, 18 Nov 2026 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022294;
	bh=oinI41GtbXY1aoumt/2QhwRfHSJdVJV45hT3Zj9m/mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDf3SwHKuHlAQDHIKu0HdkvGTQK93dTL6q+l7FWdwi3tgcnQ0t7X3Xj/MMX2wnZJB
	 WtbJeTe/iZjY9P++3RhaI1X0eVHVt+jSXJXQDVyl84umHTJ0Y6ykvRTARmhX9Bl6DO
	 7hc79lFudDhn61SpnHZBVRYWBWujXlAm5/A0mxkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2610/2651] apparmor: convert duplicated dfa transitions to match_char()
Date: Wed, 18 Nov 2026 16:04:10 +0100
Message-ID: <20261118150418.217341977@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 31b309043583e..cf3b35a6b1cdc 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -617,7 +617,7 @@ aa_state_t aa_dfa_match_until(const struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	if (state == DFA_NOMATCH)
 		return DFA_NOMATCH;
@@ -628,22 +628,18 @@ aa_state_t aa_dfa_match_until(const struct aa_dfa *dfa, aa_state_t start,
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
@@ -678,7 +674,7 @@ aa_state_t aa_dfa_matchn_until(const struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	*retpos = NULL;
 	if (state == DFA_NOMATCH)
@@ -690,22 +686,18 @@ aa_state_t aa_dfa_matchn_until(const struct aa_dfa *dfa, aa_state_t start,
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
@@ -754,7 +746,7 @@ static aa_state_t leftmatch_fb(const struct aa_dfa *dfa, aa_state_t start,
 	u32 *base = BASE_TABLE(dfa);
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	AA_BUG(!dfa);
 	AA_BUG(!str);
@@ -772,13 +764,10 @@ static aa_state_t leftmatch_fb(const struct aa_dfa *dfa, aa_state_t start,
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
@@ -791,13 +780,10 @@ static aa_state_t leftmatch_fb(const struct aa_dfa *dfa, aa_state_t start,
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



