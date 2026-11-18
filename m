Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028300;
	b=5OpS0ez102DBKlG48uDZhS1yeEnCZWckcsWgIp19C/4GNtWfjQkLEOPWwWacnbSOndx+
	 I+nCodF+ELdAPDtHw+sEYQR/dXjERAGP7C6NXT6YF//2bvuA/SNVNYjpTQ5LyayaGQF1b
	 8Zfw9H5fX5jlGRDZbC5B0XvX9O7rFT7KzoxXabLgYJtHWalJSEeO9SyCUfEun4qodrhWW
	 OADyUKRUWInNlEsbZkAVBe/dB+KOoGZDLY9ZjXWAnrov0bUjn7nYqlnz/qB9HAAF36i+3
	 KnXUsN5sydkpqNZVCN9s1yRFBCdFivuxdR/YMN5Hc1c4j05YpNZJUeqD+3sYbOSfjug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oziJn69nkegSGcrhIvPlfdVxaKCe6PxiStxedP2+2Iw=;
	b=QnWhV4XIC9ZVwj9z9P3Ys0aKPOxFfH1KSNBFlF/7hx4kHiyYyNVAb/M17Kgal1H8klQF
	 gOySf8vcMUQilAW3ygEAuX3D8l26I+8jWxPmz+mKaGKmDxdAnZmPZ6by2FeDxkVw2xzom
	 hNgoZ4k/p6ReXRwFm0o41Wm2EZkxQ9Not+fYvKUBJ7dQ0tfkaDtnH+/u3NEGRHB9Idp+D
	 lSosfelDs9RK6HaiDTsizhlmtfSfM1ZAZvWUY6Ap683UNjCUV5X0jAkFnHGo2lS4T0sdD
	 NI/XsnqS9ubqOhdOIgQjzCNLynnG4XQ0sMH8/uQ8dqqU4tkiJ7GqBz+UP6V11Nw/byw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l112W8H2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F7F606A32F;
	Wed, 18 Nov 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l112W8H2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BE01F000C4;
	Wed, 18 Nov 2026 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028300;
	bh=oziJn69nkegSGcrhIvPlfdVxaKCe6PxiStxedP2+2Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l112W8H2o18eFNTMxOjM5+hIqLckBVdnueSNIWQAgijBDbY6K1y7c+qCCMJ88wTtf
	 xt+NtQlWw0V1IRTeRwxpy6Wdn3q/OSCw53wI1HndDjYUcuZnyj+hopvl0+iEt7CGiO
	 FBsi3BOL/8RAZdz1dKFrId4KeLIIF+J6SNTz3YQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2097/2151] apparmor: convert duplicated dfa transitions to match_char()
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150238.084633667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1e79f269a9bb6..5efd9d1fd0f4b 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -614,7 +614,7 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	if (state == DFA_NOMATCH)
 		return DFA_NOMATCH;
@@ -625,22 +625,18 @@ aa_state_t aa_dfa_match_until(struct aa_dfa *dfa, aa_state_t start,
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
@@ -675,7 +671,7 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
 	u32 *accept = ACCEPT_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	*retpos = NULL;
 	if (state == DFA_NOMATCH)
@@ -687,22 +683,18 @@ aa_state_t aa_dfa_matchn_until(struct aa_dfa *dfa, aa_state_t start,
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
@@ -751,7 +743,7 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
 	u32 *base = BASE_TABLE(dfa);
 	u32 *next = NEXT_TABLE(dfa);
 	u32 *check = CHECK_TABLE(dfa);
-	aa_state_t state = start, pos;
+	aa_state_t state = start;
 
 	AA_BUG(!dfa);
 	AA_BUG(!str);
@@ -769,13 +761,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
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
@@ -788,13 +777,10 @@ static aa_state_t leftmatch_fb(struct aa_dfa *dfa, aa_state_t start,
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



