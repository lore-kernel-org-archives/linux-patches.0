Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027190;
	b=HCBrqf1sv4y+QKmqCIWZHmhDbcCL+FSFhCpKUk5WshWedbqlYIltKaI/6ynWaSaJEQXO
	 /Ip+1yTDjYgWJRIWR5LIMw6sUkseNgDGfgk+AtB8K+zs77zVxaWEPJrs0TKmIiwpfHsqY
	 VXYHc9qsS5zOF6nGSm6ui0MxJhIE6851RXsNvxt3u09D+f2mVVOsO9D/sopvAhj/P7fSi
	 2AeB/4v85CfXjmJx/Mtmbm+GbkotxpMv1J1tywtEADhVz31GERTBfQnOD0LLKngB1eRVk
	 DvxqYQki5xTZCAKcNvt9jxmDRvWdorK4VWl8hG982TtnBeXwQeqzhjyc0jqugvW5kgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nzo/rIM47oMdb1VAtl+0RdiHxi2tw5lx/eMF+ZNpv7Y=;
	b=zJt2ejisEhCNTCdx8NoQTwyWyo6AZVskSChBFqmCMK9hn6lIZqlWQ/qGwz35J3RSqmUH
	 C3QUGDy2Rx/xc8ADs05zOdn8Zr8AH1BY0wkawSeZ5ukt8zMIkBJwazTsUrcE20oz01fkl
	 jxHRaknYNjKc39XcOETSI4Cn94SMP/RfevHV6VYXQtFL1CL6EYKbdGiGRe05YzMkDm+7f
	 jR734/LUCLW5TyJNaHOjRbHwqdu9oQsiau/zOcjPjtq+YOnuUuva7xPcogreuoCbt7u8j
	 FvGM7ijH4/99BBQlWRW6mdg9V5th4yZyebAlLqGPMuw/Fr6cgZi/NieSPQZ6gW7lsVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMXCNwdb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E9606A31C;
	Wed, 18 Nov 2026 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMXCNwdb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DA91F000C4;
	Wed, 18 Nov 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027190;
	bh=Nzo/rIM47oMdb1VAtl+0RdiHxi2tw5lx/eMF+ZNpv7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMXCNwdb7Og/ew7hcEx0ZTQ1bmAXrlTdiTOWG7rcjMGWTNE5jFTptGNflYi97CN8i
	 LrRFwtPIF4Z1aV+1oThuDYaNadN32GbW8isYTJ/v2K/FU5rhx0F6Qlgo5IxefbC/dA
	 T+P/JtL93K4Rr06aPo2dGSVX9prumkLiTjKM4vp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1703/2151] dpll: zl3073x: do not offer 0 Hz as a supported pin frequency
Date: Wed, 18 Nov 2026 15:57:18 +0100
Message-ID: <20261118150223.859276021@linuxfoundation.org>
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

[ Upstream commit 23171065fb436195981ca32f9e49dcf852dbd018 ]

zl3073x_pin_props_get() always adds the current pin frequency to the
supported list without checking it. A sub-Hz frequency reads back as
0 Hz, so 0 Hz can then be requested and the output frequency set
callback divides by zero. A 0 Hz entry in the firmware node is not
rejected either: it is offered for an input pin, and for an output pin
zl3073x_pin_check_freq() divides by it at probe time.

Do not add a 0 Hz current frequency and reject 0 Hz in
zl3073x_pin_check_freq(). If the list ends up empty, do not publish it
at all, as the DPLL core rejects an empty non-NULL list.

Found by code inspection, not triggered at runtime.

Fixes: 85a9aaac4a38 ("dpll: zl3073x: Include current frequency in supported frequencies list")
Reviewed-by: Petr Oros <poros@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Fixes: a99a9f0ebdaa ("dpll: zl3073x: Read DPLL types and pin properties from system firmware")
Link: https://patch.msgid.link/20261011061211.448373-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/prop.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/dpll/zl3073x/prop.c b/drivers/dpll/zl3073x/prop.c
index 51748b0e523bf..9a1911427eb7e 100644
--- a/drivers/dpll/zl3073x/prop.c
+++ b/drivers/dpll/zl3073x/prop.c
@@ -30,7 +30,7 @@ static bool
 zl3073x_pin_check_freq(struct zl3073x_dev *zldev, enum dpll_pin_direction dir,
 		       u8 id, u64 freq)
 {
-	if (freq > U32_MAX)
+	if (!freq || freq > U32_MAX)
 		goto err_inv_freq;
 
 	if (dir == DPLL_PIN_DIRECTION_INPUT) {
@@ -293,13 +293,20 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 		goto err_alloc_ranges;
 	}
 
-	/* Start with current frequency at index 0 */
-	ranges[0] = (struct dpll_pin_frequency)DPLL_PIN_FREQUENCY(curr_freq);
+	/* Start with current frequency at index 0. A sub-Hz frequency is
+	 * read back as 0 Hz and cannot be set, so it is not offered.
+	 */
+	j = 0;
+	if (curr_freq) {
+		struct dpll_pin_frequency freq = DPLL_PIN_FREQUENCY(curr_freq);
+
+		ranges[j++] = freq;
+	}
 
 	/* Add frequencies from firmware node, skipping current frequency
 	 * and filtering out frequencies not representable by device
 	 */
-	for (i = 0, j = 1; i < num_freqs; i++) {
+	for (i = 0; i < num_freqs; i++) {
 		struct dpll_pin_frequency freq = DPLL_PIN_FREQUENCY(freqs[i]);
 
 		if (freqs[i] == curr_freq)
@@ -310,6 +317,14 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
 		}
 	}
 
+	/* The DPLL core rejects a non-NULL list without entries, so do
+	 * not publish the array at all when nothing is settable.
+	 */
+	if (!j) {
+		kfree(ranges);
+		ranges = NULL;
+	}
+
 	/* Save number of freq ranges and pointer to them into pin properties */
 	props->dpll_props.freq_supported = ranges;
 	props->dpll_props.freq_supported_num = j;
-- 
2.53.0



