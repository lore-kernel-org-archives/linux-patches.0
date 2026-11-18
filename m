Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027188;
	b=XC55f1EfHgz2i8lfakGumG5hU7M62ao1pIlLwfHQaIQrAPKxcEVvG7Zw9DBmMrIX7w45
	 ZDt7ndNlk7x24cLBxADBD4x6KInUpvHaRrB7hIxq3OQlNz4bAnpXHEtO62+mHq7QPNrtQ
	 k14bSMfkvuaSJhH/Ym6PNRoKcHc3NkbYXv0e9uph1lA8b+UsxAOWC9k9cXiGvfOomT4AL
	 RgEuTAPGBIwqxeS5LD8vtmebgsp/O0UcVe/jMNuOGdZbKucorNAcyDSPRbwbOlmCGw6rP
	 /pDNR+C9//QX9HpAugIST3JIN6nDUdnHGmTVzjkCFvKcZRlzNKZ90qI4HG45EKjaT7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gdlPw4Y/5c3FVKZoViQ89FUixiLF1BIAoapWPEwHNXA=;
	b=XJEEOjqrgE7KZ6XV4sdF/96bQu6JNeCgogPOMPC9JK28Vuu9JXQKl0U+dMYHis0YMgS9
	 qDhu4t+VOqhNuXYYt2sZGv6esOoKDeuhQJoghuXMG/XEag5f1oBxCs5IvAyDCsDNFc3Q/
	 YMs9+nV3Uv2Q0aLoFEvbDOJM1BW/X7dS675NNMyZUjIGW2E1NSJAghfVSboQ7R+GxHc8q
	 o/ljf8/fcLqJNM0sHvhC3qVyH7Wbm6wm+4m/5EXFrrerJal6UJhK/ntfJNNxNkZP4iqxj
	 Ol/shiIuHnbnxBN0fKd1KwS5p8YJgKqEUPgj2VCiCeradfwYuWXRQM6BCvlr98DP7mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxmV0D+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF42606A32A;
	Wed, 18 Nov 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxmV0D+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746C21F000C4;
	Wed, 18 Nov 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027188;
	bh=gdlPw4Y/5c3FVKZoViQ89FUixiLF1BIAoapWPEwHNXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxmV0D+vVheCG6dRuORGj8ur4/E7bKSUM5+6L1kbqz/gymnId9BDkUgrOAFsZYS68
	 4LRNk/9lKXggdhpzrbyOen2wlzsDUd/Eta3EaA+/dhXY2G97r2LjGKtQzFEqdso+1l
	 YqPJQAGU/juk+4tT+s6d+nDuy1H3pGkcE2gUXntE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1702/2151] dpll: zl3073x: Include current frequency in supported frequencies list
Date: Wed, 18 Nov 2026 15:57:17 +0100
Message-ID: <20261118150223.825053351@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 85a9aaac4a38a7ce68f30bd7678fca4e8c687fe2 ]

Ensure the current pin frequency is always present in the list of
supported frequencies reported to userspace. Previously, if the
firmware node was missing or didn't include the current operating
frequency in the supported-frequencies-hz property, the pin would
report a frequency that wasn't in its supported list.

Get the current frequency early in zl3073x_pin_props_get():
- For input pins: use zl3073x_dev_ref_freq_get()
- For output pins: use zl3073x_dev_output_pin_freq_get()

Place the current frequency at index 0 of the supported frequencies
array, then append frequencies from the firmware node (if present),
skipping any duplicate of the current frequency.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20260205154350.3180465-3-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 23171065fb43 ("dpll: zl3073x: do not offer 0 Hz as a supported pin frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/prop.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/dpll/zl3073x/prop.c b/drivers/dpll/zl3073x/prop.c
index 4ed153087570b..51748b0e523bf 100644
--- a/drivers/dpll/zl3073x/prop.c
+++ b/drivers/dpll/zl3073x/prop.c
@@ -193,9 +193,10 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 {
 	struct dpll_pin_frequency *ranges;
 	struct zl3073x_pin_props *props;
-	int i, j, num_freqs, rc;
+	int i, j, num_freqs = 0, rc;
+	u64 *freqs = NULL;
 	const char *type;
-	u64 *freqs;
+	u32 curr_freq;
 
 	props = kzalloc(sizeof(*props), GFP_KERNEL);
 	if (!props)
@@ -207,6 +208,7 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 		props->dpll_props.capabilities =
 			DPLL_PIN_CAPABILITIES_PRIORITY_CAN_CHANGE |
 			DPLL_PIN_CAPABILITIES_STATE_CAN_CHANGE;
+		curr_freq = zl3073x_dev_ref_freq_get(zldev, index);
 	} else {
 		u8 out, synth;
 		u32 f;
@@ -220,6 +222,7 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 		synth = zl3073x_dev_out_synth_get(zldev, out);
 		f = 2 * zl3073x_dev_synth_freq_get(zldev, synth);
 		props->dpll_props.phase_gran = f ? div_u64(PSEC_PER_SEC, f) : 1;
+		curr_freq = zl3073x_dev_output_pin_freq_get(zldev, index);
 	}
 
 	props->dpll_props.phase_range.min = S32_MIN;
@@ -230,7 +233,7 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 	/* Get firmware node for the given pin */
 	rc = zl3073x_prop_pin_fwnode_get(zldev, props, dir, index);
 	if (rc)
-		return props; /* Return if it does not exist */
+		goto skip_fwnode_props;
 
 	/* Look for label property and store the value as board label */
 	fwnode_property_read_string(props->fwnode, "label",
@@ -262,9 +265,10 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 	/* Read supported frequencies property if it is specified */
 	num_freqs = fwnode_property_count_u64(props->fwnode,
 					      "supported-frequencies-hz");
-	if (num_freqs <= 0)
-		/* Return if the property does not exist or number is 0 */
-		return props;
+	if (num_freqs <= 0) {
+		num_freqs = 0;
+		goto skip_fwnode_props;
+	}
 
 	/* The firmware node specifies list of supported frequencies while
 	 * DPLL core pin properties requires list of frequency ranges.
@@ -281,19 +285,25 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 				       "supported-frequencies-hz", freqs,
 				       num_freqs);
 
-	/* Allocate frequency ranges list and fill it */
-	ranges = kcalloc(num_freqs, sizeof(*ranges), GFP_KERNEL);
+skip_fwnode_props:
+	/* Allocate frequency ranges list - extra slot for current frequency */
+	ranges = kcalloc(num_freqs + 1, sizeof(*ranges), GFP_KERNEL);
 	if (!ranges) {
 		rc = -ENOMEM;
 		goto err_alloc_ranges;
 	}
 
-	/* Convert list of frequencies to list of frequency ranges but
-	 * filter-out frequencies that are not representable by device
+	/* Start with current frequency at index 0 */
+	ranges[0] = (struct dpll_pin_frequency)DPLL_PIN_FREQUENCY(curr_freq);
+
+	/* Add frequencies from firmware node, skipping current frequency
+	 * and filtering out frequencies not representable by device
 	 */
-	for (i = 0, j = 0; i < num_freqs; i++) {
+	for (i = 0, j = 1; i < num_freqs; i++) {
 		struct dpll_pin_frequency freq = DPLL_PIN_FREQUENCY(freqs[i]);
 
+		if (freqs[i] == curr_freq)
+			continue;
 		if (zl3073x_pin_check_freq(zldev, dir, index, freqs[i])) {
 			ranges[j] = freq;
 			j++;
-- 
2.53.0



