Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056769;
	b=D9FgDE/nJKhFL+kZ3L9eAhoVHEPyRkdmaRWbGNgcLe2PTHmIjs9VjoWzcCwwUHdzH+ra
	 91tcuNYmwjzrwO15Q9QX2C1juXCDdJdVV2aoo2XohAWV6INvMryKIyzb/Mf3ad8cejAn1
	 lfWZiBwKjE5FtLg7jIZ2XqbggEE7CulkJBBrWRmtC1thioOJD0brYwvVm5oO1U1t94u7+
	 F2sxjnspnYmgvaxwYvyTv1cM8z3KJhRkvSliE0b72LwVJtBtbkkzZRAc5IKp0VjqMnRL1
	 hlCmdYCSJ4V2oqYOAACwkSHK/6f8OP8spJ8386w1uDllzblntuX1LDH2fsLStr3yK4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1RSxojlqzaIT5YmmUQRDaZTKxPvG/OlOMJVXW2i3HK4=;
	b=F4ptgBYMOvaWJZ9qxCCv3BZrA3r1nPdkRgeAoV3D0m2yvUU0hmZdN8guqgoDGugFBB2j
	 10IT+VeeeiYoUQpEiVzTFWWjbCO/e+7x97xo4Ml9Sny82BFgaL9mM5jN3gjunVObCOubz
	 iTH9+2ocXisau/U/GX8RqmJu9wc2+D2JI81qw/WN4Eqy02FNfXWEWWDmKAPQAcJ0L5ypz
	 n9xwY9hJp8zxluaTFUhLhFYEe44w5C3N1MRf5mH/Vo4kxcG8fh1gTdmr9zAfKjERRzymm
	 /o8ABg8fYGjnXA5M55ik6vp4hpizXV7amRpi1BDxMeoJ8I2yUrKZ2h1QkSipwcq3P7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNhrXteS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452F3606A31C;
	Thu, 19 Nov 2026 02:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNhrXteS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949191F000C4;
	Thu, 19 Nov 2026 02:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056769;
	bh=1RSxojlqzaIT5YmmUQRDaZTKxPvG/OlOMJVXW2i3HK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNhrXteSqP1qJdJdfwcn5jIlKUziIMLUI2aNLTaaU7jLhJyMTbLEiw6admvvH97Zc
	 une66rckObWEmRQc4Dg56dQ0uJ1mqv+QA8nqXcuAEYPFBu83I+qDdYSNwHrT3d0g0U
	 tBIELjqZcoGlQlqlVGDIrpPYfGkFrMD56fjfK950=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2106/2214] regulator: irq_helper: Provide helper for trivial IRQ notifications
Date: Wed, 18 Nov 2026 16:03:02 +0100
Message-ID: <20261118150134.884507290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit a764ff77d697a4a13e69b3379cc613f7409c6b9a ]

Provide a generic map_event helper for regulators which have a notification
IRQ with single, well defined purpose. Eg, IRQ always indicates exactly one
event for exactly one regulator device. For such IRQs the mapping is
trivial.

Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/603b7ed1938013a00371c1e7ccc63dfb16982b87.1637736436.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8a6d73e316f9 ("regulator: irq: freeze deferred hardware access during suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/irq_helpers.c  | 41 +++++++++++++++++++++++++++++++-
 include/linux/regulator/driver.h |  2 ++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index a44a0b30a6516..5ab1a0befe12f 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -320,7 +320,9 @@ static void init_rdev_errors(struct regulator_irq *h)
  *			IRQF_ONESHOT when requesting the (threaded) irq.
  * @common_errs:	Errors which can be flagged by this IRQ for all rdevs.
  *			When IRQ is re-enabled these errors will be cleared
- *			from all associated regulators
+ *			from all associated regulators. Use this instead of the
+ *			per_rdev_errs if you use
+ *			regulator_irq_map_event_simple() for event mapping.
  * @per_rdev_errs:	Optional error flag array describing errors specific
  *			for only some of the regulators. These errors will be
  *			or'ed with common errors. If this is given the array
@@ -398,3 +400,40 @@ void regulator_irq_helper_cancel(void **handle)
 	}
 }
 EXPORT_SYMBOL_GPL(regulator_irq_helper_cancel);
+
+/**
+ * regulator_irq_map_event_simple - regulator IRQ notification for trivial IRQs
+ *
+ * @irq:	Number of IRQ that occurred
+ * @rid:	Information about the event IRQ indicates
+ * @dev_mask:	mask indicating the regulator originating the IRQ
+ *
+ * Regulators whose IRQ has single, well defined purpose (always indicate
+ * exactly one event, and are relevant to exactly one regulator device) can
+ * use this function as their map_event callbac for their regulator IRQ
+ * notification helperk. Exactly one rdev and exactly one error (in
+ * "common_errs"-field) can be given at IRQ helper registration for
+ * regulator_irq_map_event_simple() to be viable.
+ */
+int regulator_irq_map_event_simple(int irq, struct regulator_irq_data *rid,
+			    unsigned long *dev_mask)
+{
+	int err = rid->states[0].possible_errs;
+
+	*dev_mask = 1;
+	/*
+	 * This helper should only be used in a situation where the IRQ
+	 * can indicate only one type of problem for one specific rdev.
+	 * Something fishy is going on if we are having multiple rdevs or ERROR
+	 * flags here.
+	 */
+	if (WARN_ON(rid->num_states != 1 || hweight32(err) != 1))
+		return 0;
+
+	rid->states[0].errors = err;
+	rid->states[0].notifs = regulator_err2notif(err);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_irq_map_event_simple);
+
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 6324677ca8abf..a98d6389effaa 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -699,6 +699,8 @@ void *regulator_irq_helper(struct device *dev,
 			   int irq_flags, int common_errs, int *per_rdev_errs,
 			   struct regulator_dev **rdev, int rdev_amount);
 void regulator_irq_helper_cancel(void **handle);
+int regulator_irq_map_event_simple(int irq, struct regulator_irq_data *rid,
+				   unsigned long *dev_mask);
 
 void *rdev_get_drvdata(struct regulator_dev *rdev);
 struct device *rdev_get_dev(struct regulator_dev *rdev);
-- 
2.53.0



