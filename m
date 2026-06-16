Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E93A16AC;
	Tue, 16 Jun 2026 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626088; cv=none; b=EUSkMXMjxu5qoH78Y1OiUBvG9Rm4eIDjMK6ykgRPXOlE9NAF+b6mMFQJBkSw3dz4CJHCgRJpBRmwTETxoUsxAQVkZ4v4ELmNVWC4WEagFQkK2Hc4Kw+tV81QZL3HuC5U29qqMqvPrht9g4EHzCgMYUMmjwGw/eQxbrsvO+IvENw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626088; c=relaxed/simple;
	bh=Dw4Tq46thps+FR4nXuVSSBSoqV0gDOrlfYp+2sUMezo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP1uwn8UGm5y6V7vdE7DzpKi+bTzxU7ffMIWjLI+ksi4bh12KxV2Cfnl/qc+rmSF/aaZLCMUTLaxNXTMuIRjgVExDVFhBUHl/3W5L2/TWSiHPA6jFbjtVJl+0BwmTrxFCMeMy089W930oi2vNtp5PPDwWfJuqbXrRHrmFPlrbog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wytCFO0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wytCFO0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB9F1F000E9;
	Tue, 16 Jun 2026 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626087;
	bh=jfESegxATxTJiwNyz+qt/9/sYBo6IQI1ghs4WD+GXsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wytCFO0DeuXhufVh2GyRREKdbJ0CWaSx5e1AJKViewdlctYfTk2oMaiLzgcsKeS7y
	 r9dwVXUqXf02kfFmd+DZyxoOGbaBhFAFJ9NNQz2CtKYqH6aoeAnCx7n+1+wxpEyehy
	 +IdKmrLh8p1E1cz6Syvvh1jUgMjjgn1YH3+qKY+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitor Soares <vitor.soares@toradex.com>,
	Kendall Willis <k-willis@ti.com>,
	Sebin Francis <sebin.francis@ti.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 263/325] pmdomain: ti_sci: add wakeup constraint to parent devices of wakeup source
Date: Tue, 16 Jun 2026 20:30:59 +0530
Message-ID: <20260616145111.712000533@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kendall Willis <k-willis@ti.com>

commit 4db207599acfc9d676340daa2dc6b52bfca17db4 upstream.

Set wakeup constraint for any device in a wakeup path. All parent devices
of a wakeup device should not be turned off during suspend. This ensures
the wakeup device is kept on while the system is suspended.

Cc: stable@vger.kernel.org
Fixes: 9d8aa0dd3be4 ("pmdomain: ti_sci: add wakeup constraint management")
Reported-by: Vitor Soares <vitor.soares@toradex.com>
Closes: https://lore.kernel.org/linux-pm/c0fe43a2339c802e9ce5900092cd530a2ba17a6b.camel@gmail.com/
Signed-off-by: Kendall Willis <k-willis@ti.com>
Reviewed-by: Sebin Francis <sebin.francis@ti.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/ti/ti_sci_pm_domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/ti/ti_sci_pm_domains.c b/drivers/pmdomain/ti/ti_sci_pm_domains.c
index 18d33bc35dee..949e4115f930 100644
--- a/drivers/pmdomain/ti/ti_sci_pm_domains.c
+++ b/drivers/pmdomain/ti/ti_sci_pm_domains.c
@@ -86,7 +86,7 @@ static inline void ti_sci_pd_set_wkup_constraint(struct device *dev)
 	const struct ti_sci_handle *ti_sci = pd->parent->ti_sci;
 	int ret;
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev) || device_wakeup_path(dev)) {
 		/*
 		 * If device can wakeup using IO daisy chain wakeups,
 		 * we do not want to set a constraint.
-- 
2.54.0



