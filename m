Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020767;
	b=SttFARKzfdjnMTOW4rkLGXLTGCGoRB6zvqCdKRGztKsWLuF84KtAp2r32qfIsUyILc62
	 8B/u7Yrdztc7zPF5AWTJgMn5pXZ6wIWVINfae9TM0sJ6y0tq1cStnhzbpKd5U4FAgLYFg
	 tTzEnKvFBmkp+nCAzcCe910BzC+UVG6zy9l6jJALCU6W7hiaDIGlSvUWY3dNVzSEKCjTZ
	 tuRCjzLpV9VT+eNNwzqUEFb9/9GAQhB2nYa3EUJpngWt6mO14iRwxb380eqUvQj1hLZF8
	 ZY79lhnbNdA85d59SKoXuzEK9VQSCiK/LR1bg9O3g7IqOtYg1Ir7qWHk7iJEe4DF2Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bs3sZdMNc166YE9AlrR9h0lcA4NlVhzlx61DsAdRjgM=;
	b=q1fkODB1FD6NxPqtm7ilefFL2EAxIYffE87y4z36Dg5PbtD6kx3yNgzY+FqEQpK9cdKr
	 XqIlj8YDWjMaoPRhn67aRDUr1N1AKA4elAn55EJoxhIgQ85RFkRVV+LmLjhDFTu22EFDX
	 Z+sCIdMoueyDJ3MA+gIHblUkf8S6SB6jGA/eBeVcaALm6FdkXBNPlT27X8cSLW+fDYZxs
	 vC+rLajTKcVMcuPiT/Nj9tH11oP9sd1gKCNW8rck47Pbw7K84j/NfXnDfjSumPuW/FsTA
	 UZL7UKOPg7c+gbolL9GfKXoMYpiBr2ll2VexAB+LbnS5hKBnwAy8obqDjK+3avWvUAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCBGmOgL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A6860A5BCC;
	Wed, 18 Nov 2026 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCBGmOgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D916B1F000C4;
	Wed, 18 Nov 2026 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020767;
	bh=bs3sZdMNc166YE9AlrR9h0lcA4NlVhzlx61DsAdRjgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCBGmOgLh2hVXyFyQo+YhqB7P5pogG022PM0ZPgpglwZiagrdA8Hr9p83gpkhhHwz
	 rne0cImY38Xb7xuT85Bsx4dsjO7J/0t9D1majNxz8oYSf1R6eKA3mx5zBdDABPArSH
	 b4mMGNRU7GeVPBK2U2CeUQyd7+8WOnlhWgZ7yHUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2070/2651] dpll: zl3073x: notify sibling pin when shared output config changes
Date: Wed, 18 Nov 2026 15:55:10 +0100
Message-ID: <20261118150400.576983692@linuxfoundation.org>
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

[ Upstream commit 0748e473b65a8c8690e250cdf7cc4f5a93252493 ]

The P-pin and N-pin of an output share the divisor, clock type, eSync
and phase compensation registers (outside N-divided mode). Changing
them through one pin changes the other pin too, but only the requested
pin gets a change notification.

Add zl3073x_dpll_output_pin_sibling_get() and notify the sibling from
frequency_set(), esync_set() and phase_adjust_set(). The notification
re-enters the pin get callbacks, so it has to be sent after
zldpll->lock is released and the callbacks switch from guard(mutex)
to explicit unlocking.

To always find a registered sibling, add a pin to zldpll->pins before
dpll_pin_register() and remove it only after dpll_pin_unregister(),
both under zldpll->lock. A pin that is on the list but not registered
gets no netlink notification, as dpll_pin_event_send() skips such
pins, and the only in-tree DPLL notifier ignores DPLL_PIN_CHANGED.

Found by code inspection, not triggered at runtime.

Fixes: 634ca2cb06d2 ("dpll: zl3073x: Add support to get/set esync on pins")
Fixes: ce26d7ca50a5 ("dpll: zl3073x: Add support to get/set frequency on pins")
Fixes: 6287262f761e ("dpll: zl3073x: Add support to adjust phase")
Reviewed-by: Petr Oros <poros@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20261011061211.448373-6-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/zl3073x/dpll.c | 155 +++++++++++++++++++++++++++++++-----
 1 file changed, 135 insertions(+), 20 deletions(-)

diff --git a/drivers/dpll/zl3073x/dpll.c b/drivers/dpll/zl3073x/dpll.c
index 6d9a6d21d30b7..1cdadb8e46fb2 100644
--- a/drivers/dpll/zl3073x/dpll.c
+++ b/drivers/dpll/zl3073x/dpll.c
@@ -123,6 +123,8 @@ zl3073x_dpll_pin_get_by_ref(struct zl3073x_dpll *zldpll, u8 ref_id)
 {
 	struct zl3073x_dpll_pin *pin;
 
+	lockdep_assert_held(&zldpll->lock);
+
 	list_for_each_entry(pin, &zldpll->pins, list) {
 		if (zl3073x_dpll_is_input_pin(pin) &&
 		    zl3073x_input_pin_ref_get(pin->id) == ref_id)
@@ -132,11 +134,42 @@ zl3073x_dpll_pin_get_by_ref(struct zl3073x_dpll *zldpll, u8 ref_id)
 	return NULL;
 }
 
+/**
+ * zl3073x_dpll_output_pin_sibling_get - get the other pin of an output pair
+ * @pin: output pin whose sibling is sought
+ *
+ * Output pin ids are allocated in P/N pairs (P even, N odd) that share a
+ * single HW output. Looks up the other pin of the pair in the pin list
+ * of this DPLL. A pin is on the list from just before its registration
+ * until just after its unregistration, so a registered sibling is always
+ * found, but the returned pin may also be one that is not (yet or any
+ * longer) registered.
+ *
+ * Return: pointer to sibling pin, or NULL if it is not on the pin list
+ */
+static struct zl3073x_dpll_pin *
+zl3073x_dpll_output_pin_sibling_get(struct zl3073x_dpll_pin *pin)
+{
+	struct zl3073x_dpll_pin *sibling;
+
+	lockdep_assert_held(&pin->dpll->lock);
+
+	list_for_each_entry(sibling, &pin->dpll->pins, list) {
+		if (!zl3073x_dpll_is_input_pin(sibling) &&
+		    sibling->id == (pin->id ^ 1))
+			return sibling;
+	}
+
+	return NULL;
+}
+
 static struct zl3073x_dpll_pin *
 zl3073x_dpll_nco_pin_get(struct zl3073x_dpll *zldpll)
 {
 	struct zl3073x_dpll_pin *pin;
 
+	lockdep_assert_held(&zldpll->lock);
+
 	list_for_each_entry(pin, &zldpll->pins, list) {
 		if (zl3073x_dpll_is_nco_pin(pin))
 			return pin;
@@ -909,12 +942,14 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll *zldpll = dpll_priv;
 	struct zl3073x_dev *zldev = zldpll->dev;
 	struct zl3073x_dpll_pin *pin = pin_priv;
+	struct zl3073x_dpll_pin *sibling = NULL;
 	const struct zl3073x_synth *synth;
 	struct zl3073x_out out;
 	u32 synth_freq;
 	u8 out_id;
+	int rc;
 
-	guard(mutex)(&zldpll->lock);
+	mutex_lock(&zldpll->lock);
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = *zl3073x_out_state_get(zldev, out_id);
@@ -923,12 +958,14 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 	 * for N-division is also used for the esync divider so both cannot
 	 * be used.
 	 */
-	if (zl3073x_out_is_ndiv(&out))
-		return -EOPNOTSUPP;
+	if (zl3073x_out_is_ndiv(&out)) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
 
 	if (!freq) {
 		zl3073x_out_esync_disable(&out);
-		return zl3073x_out_state_set(zldev, out_id, &out);
+		goto commit;
 	}
 
 	/* Get attached synth frequency */
@@ -937,9 +974,24 @@ zl3073x_dpll_output_pin_esync_set(const struct dpll_pin *dpll_pin,
 
 	/* Enable 1PPS eSync for this pin frequency */
 	zl3073x_out_esync_enable(&out, synth_freq / out.div);
-
+commit:
 	/* Commit output configuration */
-	return zl3073x_out_state_set(zldev, out_id, &out);
+	rc = zl3073x_out_state_set(zldev, out_id, &out);
+	if (rc)
+		goto unlock;
+
+	/* The clock type, esync period and esync width are all shared by
+	 * both pins of the output pair, so the sibling pin's esync
+	 * configuration changes too and userspace has to be notified.
+	 */
+	sibling = zl3073x_dpll_output_pin_sibling_get(pin);
+unlock:
+	mutex_unlock(&zldpll->lock);
+
+	if (!rc && sibling)
+		__dpll_pin_change_ntf(sibling->dpll_pin);
+
+	return rc;
 }
 
 static int
@@ -969,13 +1021,15 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll *zldpll = dpll_priv;
 	struct zl3073x_dev *zldev = zldpll->dev;
 	struct zl3073x_dpll_pin *pin = pin_priv;
+	struct zl3073x_dpll_pin *sibling = NULL;
 	const struct zl3073x_synth *synth;
 	u32 new_div, synth_freq;
 	struct zl3073x_out out;
 	u64 n_period, rem;
 	u8 out_id;
+	int rc;
 
-	guard(mutex)(&zldpll->lock);
+	mutex_lock(&zldpll->lock);
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = *zl3073x_out_state_get(zldev, out_id);
@@ -988,7 +1042,8 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	/* Check signal format */
 	if (!zl3073x_out_is_ndiv(&out)) {
 		/* For non N-divided signal formats the frequency is computed
-		 * as division of synth frequency and output divisor.
+		 * as division of synth frequency and output divisor, which
+		 * is shared by both pins of the output pair.
 		 */
 		out.div = new_div;
 
@@ -1013,7 +1068,16 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 		}
 
 		/* Commit output configuration */
-		return zl3073x_out_state_set(zldev, out_id, &out);
+		rc = zl3073x_out_state_set(zldev, out_id, &out);
+		if (rc)
+			goto unlock;
+
+		/* The other pin's frequency changed too - it has to be
+		 * notified about the change.
+		 */
+		sibling = zl3073x_dpll_output_pin_sibling_get(pin);
+
+		goto unlock;
 	}
 
 	if (zl3073x_dpll_is_p_pin(pin)) {
@@ -1039,19 +1103,22 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 		NL_SET_ERR_MSG_FMT(extack,
 				   "OUT%uN freq must be at most half of OUT%uP freq",
 				   out_id, out_id);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 	if (n_period > U32_MAX) {
 		NL_SET_ERR_MSG_FMT(extack,
 				   "OUT%uN freq is too low for OUT%uP freq",
 				   out_id, out_id);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 	if (rem != 0) {
 		NL_SET_ERR_MSG_FMT(extack,
 				   "OUT%uN freq must divide OUT%uP freq",
 				   out_id, out_id);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto unlock;
 	}
 	out.esync_n_period = n_period;
 
@@ -1059,7 +1126,14 @@ zl3073x_dpll_output_pin_frequency_set(const struct dpll_pin *dpll_pin,
 	out.esync_n_width = out.esync_n_period;
 
 	/* Commit output configuration */
-	return zl3073x_out_state_set(zldev, out_id, &out);
+	rc = zl3073x_out_state_set(zldev, out_id, &out);
+unlock:
+	mutex_unlock(&zldpll->lock);
+
+	if (!rc && sibling)
+		__dpll_pin_change_ntf(sibling->dpll_pin);
+
+	return rc;
 }
 
 static int
@@ -1098,10 +1172,12 @@ zl3073x_dpll_output_pin_phase_adjust_set(const struct dpll_pin *dpll_pin,
 	struct zl3073x_dpll *zldpll = dpll_priv;
 	struct zl3073x_dev *zldev = zldpll->dev;
 	struct zl3073x_dpll_pin *pin = pin_priv;
+	struct zl3073x_dpll_pin *sibling = NULL;
 	struct zl3073x_out out;
 	u8 out_id;
+	int rc;
 
-	guard(mutex)(&zldpll->lock);
+	mutex_lock(&zldpll->lock);
 
 	out_id = zl3073x_output_pin_out_get(pin->id);
 	out = *zl3073x_out_state_get(zldev, out_id);
@@ -1110,7 +1186,21 @@ zl3073x_dpll_output_pin_phase_adjust_set(const struct dpll_pin *dpll_pin,
 	out.phase_comp = phase_adjust / pin->phase_gran;
 
 	/* Update output configuration from mailbox */
-	return zl3073x_out_state_set(zldev, out_id, &out);
+	rc = zl3073x_out_state_set(zldev, out_id, &out);
+	if (rc)
+		goto unlock;
+
+	/* The phase compensation register is shared by both pins of the
+	 * output pair, so the sibling pin's phase adjustment changes too.
+	 */
+	sibling = zl3073x_dpll_output_pin_sibling_get(pin);
+unlock:
+	mutex_unlock(&zldpll->lock);
+
+	if (!rc && sibling)
+		__dpll_pin_change_ntf(sibling->dpll_pin);
+
+	return rc;
 }
 
 static int
@@ -1734,6 +1824,13 @@ zl3073x_dpll_pin_register(struct zl3073x_dpll_pin *pin, u32 index)
 	else
 		ops = &zl3073x_dpll_output_pin_ops;
 
+	/* Add the pin to the list before registering it with the DPLL core so
+	 * that it is findable as a sibling as soon as the core publishes it.
+	 */
+	mutex_lock(&zldpll->lock);
+	list_add(&pin->list, &zldpll->pins);
+	mutex_unlock(&zldpll->lock);
+
 	/* Register the pin */
 	rc = dpll_pin_register(zldpll->dpll_dev, pin->dpll_pin, ops, pin);
 	if (rc)
@@ -1745,6 +1842,9 @@ zl3073x_dpll_pin_register(struct zl3073x_dpll_pin *pin, u32 index)
 	return 0;
 
 err_register:
+	mutex_lock(&zldpll->lock);
+	list_del(&pin->list);
+	mutex_unlock(&zldpll->lock);
 	dpll_pin_put(pin->dpll_pin, &pin->tracker);
 err_pin_get:
 	pin->dpll_pin = NULL;
@@ -1779,6 +1879,13 @@ zl3073x_dpll_pin_unregister(struct zl3073x_dpll_pin *pin)
 	/* Unregister the pin */
 	dpll_pin_unregister(zldpll->dpll_dev, pin->dpll_pin, ops, pin);
 
+	/* Remove the pin from the list only after it has been unregistered so
+	 * that a still-registered pin is always findable as a sibling.
+	 */
+	mutex_lock(&zldpll->lock);
+	list_del(&pin->list);
+	mutex_unlock(&zldpll->lock);
+
 	dpll_pin_put(pin->dpll_pin, &pin->tracker);
 	pin->dpll_pin = NULL;
 
@@ -1798,9 +1905,11 @@ zl3073x_dpll_pins_unregister(struct zl3073x_dpll *zldpll)
 {
 	struct zl3073x_dpll_pin *pin, *next;
 
+	/* Unregister each pin before removing it from the list so that a
+	 * still-registered pin is always findable as a sibling.
+	 */
 	list_for_each_entry_safe(pin, next, &zldpll->pins, list) {
 		zl3073x_dpll_pin_unregister(pin);
-		list_del(&pin->list);
 		zl3073x_dpll_pin_free(pin);
 	}
 }
@@ -1913,16 +2022,24 @@ zl3073x_dpll_nco_pin_register(struct zl3073x_dpll *zldpll)
 		goto err_pin_get;
 	}
 
+	/* Add the pin to the list before registering it with the DPLL core so
+	 * that a registered pin is always on the list.
+	 */
+	mutex_lock(&zldpll->lock);
+	list_add(&pin->list, &zldpll->pins);
+	mutex_unlock(&zldpll->lock);
+
 	rc = dpll_pin_register(zldpll->dpll_dev, pin->dpll_pin,
 			       &zl3073x_dpll_nco_pin_ops, pin);
 	if (rc)
 		goto err_register;
 
-	list_add(&pin->list, &zldpll->pins);
-
 	return 0;
 
 err_register:
+	mutex_lock(&zldpll->lock);
+	list_del(&pin->list);
+	mutex_unlock(&zldpll->lock);
 	dpll_pin_put(pin->dpll_pin, &pin->tracker);
 err_pin_get:
 	pin->dpll_pin = NULL;
@@ -1974,8 +2091,6 @@ zl3073x_dpll_pins_register(struct zl3073x_dpll *zldpll)
 			zl3073x_dpll_pin_free(pin);
 			goto error;
 		}
-
-		list_add(&pin->list, &zldpll->pins);
 	}
 
 	/* Register NCO virtual input pin */
-- 
2.53.0



