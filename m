Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020756;
	b=EHN0PD5ncvb3cwjHFk6Ev6rMgiPpzmjvunEC9A6RJT6iauXY64OgF4wIO8Eow/waKAh6
	 73VFLNUp202DR7At4d+4muF23F71YRc33RXIicHc0ms+iUw/Z4tLg17v0NzYkMq9LJhF8
	 ALBmhIX9j+eX+jPyxfbGTWqLr8ZW6ssUFBWJBjpHH+eb7IJ1IyK9ncAd6RTs09iA/hiFq
	 NbwWAXfcq0lskhljl3P5T4O5HZVM0MHmf9uLOED88N9RK1CsNUhwUAulVFY2aAk3VwsIO
	 5Pqs7YHt9lVyAaZ1ordhX+UpKavWmNIj9dXwMkOj3FdHmhzaXGoCggO6e1AbUbEV1dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dp6/Sn9rMG0cC9v7XYXvmGiY62hct6IUA7cW1o8NwXw=;
	b=i9ccawx8bK64JniFldNs7LKbp/R9bJXaLS+iRBfbYYwJ+mAZ/e+TmeMMhbJI5HMBorkY
	 Wb2ay+j13FghHnZ2HVQxPJCyGJsso6pNYOSvNOxH/EIngLDiFpZEO/n471oNhfrGm0DSX
	 VDNbBrqBp9CBgAmDZl8ASYh19NsFdH3SX9iOvAMwPko/0tf6n2+kc4YHWqPH0rg0zqjdE
	 Mx75s2tJAPls8knvOeczVghK6uEFYadCmpWH10GMCYgzZ6Ai8USjKl1nHN4cxfRedKjTo
	 m7N+6ceQFgr8LWMIhrcw1IEFHFUpyRHpY/NdvlCY12ekz83RFl0OV6jHAnCW+IWeGSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQ2XOwmB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358B5606A320;
	Wed, 18 Nov 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQ2XOwmB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850AE1F000CC;
	Wed, 18 Nov 2026 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020756;
	bh=dp6/Sn9rMG0cC9v7XYXvmGiY62hct6IUA7cW1o8NwXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQ2XOwmBsNBVwoViIkEn8dMlDhfy4lNGOtq7bKWlmTww3tLb3spYqlzdO4F9hffvr
	 X6X4o+KISoXUgbcxwHrvaJ9rhV7PYwpJZVvQGbeLDV+AQ+aznctrypU71Ur+mgduHT
	 BwBMsJO7/IqcRX5HlWB2yB7jeyi6HymhdDf+MDaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2066/2651] dpll: zl3073x: do not offer 0 Hz as a supported pin frequency
Date: Wed, 18 Nov 2026 15:55:06 +0100
Message-ID: <20261118150400.433792456@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ac9d41d0f978e..768e5424de2d2 100644
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
@@ -295,13 +295,20 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
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
@@ -312,6 +319,14 @@ struct zl3073x_pin_props *zl3073x_pin_props_get(struct zl3073x_dev *zldev,
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



