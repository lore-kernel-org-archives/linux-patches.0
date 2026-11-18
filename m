Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042727;
	b=VIbGwAaFXCQwDQhPKUUaDOcFSm8yueiQUKgRV2F3la/S8IsuRMLkfDWE2NwXpYdF5uLd
	 m9EzHeq12qzX031oAqaMZ502CXkNbxEL7cqY1v2E3zSw3FYoEcXU0v/gwisEqnA8tyJrQ
	 pbSEM+yeNeWqvjlYY4Q1hjpRNZFXQjtJbHCSMWkYvM1kpZ3Rzkb2Ws+nGnHIINNrnAyvz
	 OgMJK0zdBe/s2YyusAgPsSAsv5AfdgDG/NGfTqY3hfpBM1kh5c5aFq0wnHqUFupjA/LX+
	 giTmVKoJtirDw/Eoty9qy0Qtpm0tyrpNVx859TKF4r2SWaN6sNPkqk0+h7rOAUf7i2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YV5uzamK5ENBN5d/tYI/gGF7toEQojNUl39vfcj+V+I=;
	b=LurNZSsTzjBGKF37X8y+TaBYQb/nB3dDvKh+jxIfbOv27svbKnrCo8Pc/n53C0bpg07d
	 ZstHcx23jk6/sEwWQmK0qxh6+9Ke9VlkslL4A3gcG9SrdkOm2yLMa1zZWmRjOJiVEJrKr
	 gDe+fyVMqwpWaJ7quQox6YuDccVcJAnKNzCMhRRMV8UUmoQCPIMyrZvYZTp7dR7w0qM9t
	 gYNnsBJ7oxt32YSOH28edHYtGK770gy734u1S+tXRvMcATBMiBzImIs41w+oy3DInJT+Z
	 I5nylom9Y163s5nyy8A0K+gE7Jn2WmOjbuqECmks08d+qq2VJ4/zzWE4Fgc/oCKpPXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzdNd22O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7869606A32A;
	Wed, 18 Nov 2026 22:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzdNd22O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4910E1F000C4;
	Wed, 18 Nov 2026 22:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042726;
	bh=YV5uzamK5ENBN5d/tYI/gGF7toEQojNUl39vfcj+V+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzdNd22O3Ku7Y5QZRphXV0LPtawUOuPM1bfIBmK+5t1lJ9CpQCddt0HC+1P5uhIOL
	 dXNQfkP41r3wI7R4PKrl2w7ue5SZvk/vJ7M7l4h7xzH7/B5/SwsLpUi5LlLrPndM70
	 F4cxCKeuH5uglR1z/m8pnQ3hCj+woaFMd3c6sH2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3272/3318] apparmor: convert duplicated dfa transitions to match_char()
Date: Wed, 18 Nov 2026 16:04:54 +0100
Message-ID: <20261118150457.777054433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5d2fe77e6ab96..97628fa996f12 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -607,7 +607,7 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	if (state == DFA_NOMATCH)
 		return DFA_NOMATCH;
@@ -618,22 +618,18 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
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
@@ -668,7 +664,7 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	*retpos = NULL;
 	if (state == DFA_NOMATCH)
@@ -680,22 +676,18 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
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
@@ -744,7 +736,7 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
 	u32 *base = BASE_TABLE(dfa);
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	AA_BUG(!dfa);
 	AA_BUG(!str);
@@ -762,13 +754,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
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
@@ -781,13 +770,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
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



