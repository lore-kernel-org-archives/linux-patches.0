Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590703;
	b=e/8JlkecAQIFT8qQK/bX9Qep3AEOrWloOR/V5BP1ScLqj7vMdbhKVZe+d358KfJR4HBd
	 ssayzRtnGhP0UuZZZs9IR4GLJHvt7dPakV65y/Dl9IDL0wPZtAn+RBXDDK3iY+6hiXlbh
	 vUR/eT+gBHo9asldcBWUjQblgQvQMUoeqvx6V4V3XH+HGUcb4/0jJgHQ8uWv3/vkxo/wY
	 dXebhNKxpjuPKTZzW0t47Jg/1wiZUkYjml8ZUxora+z7/z7XPMu6IPbqHBh2VRsbxkrV/
	 SHsBdliE1o4PFQcPdnY9gNaXfq0zA45n/nUL15Uhjp1z649B2RbiHhUA9R9uD+lqJXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ys7rQiFu+Tp7JFzkA1fCgzcl1G1W8kgHiZJHMuFg/Cs=;
	b=e+khKfkzrO/JBYequgoW3ebBZgTCgK6+eWhTVLTMkZQj1lAIjzfdunPzPQT/BPokuvFx
	 EfUIfKxwUFWDGOwgzSpZdqnRImaiZEXmyPgKLFJ+/8dhpaAJOMmotQA5nGwoy4MQdEwHW
	 +CIf0VYoJT0gGevfnyoKnmwKGZDiRUJ7K9Vwe6G88Yud6M5xDil4yfwqK6z/sBormX7RX
	 B3p+B8fTWSCaB2b+5WMzz5zBVdp9IVgJiyjU1F8Coe5jyM2gnk2bAKNQBFFN+Uo3HjeIk
	 GbE7uwKfxPJqvZUCSgJZEhE+2hjHNp15ckQZmjMy8Spu8fN1Tgat6c79yzgHCDMQDjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUyIaOwl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF7F607A5C9;
	Fri, 13 Nov 2026 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUyIaOwl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7265C1F000C5;
	Fri, 13 Nov 2026 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590703;
	bh=Ys7rQiFu+Tp7JFzkA1fCgzcl1G1W8kgHiZJHMuFg/Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUyIaOwl+LXDSlcl1iWWsAcz0youzhHZHhvEBLP3bPjpNtKCHe+AWqH4OVlhuG+ve
	 Ez7H2JPxU3LyEoKbZGOdVS0oRiJXY2euoP1qtA2e5L5+YQCCNh2yvbzDzm7t0SNiJb
	 dnDYjSiWtv44bokO/hNtyzFAkrqpVt2XpytV9GuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Rong Zhang <i@rong.moe>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 614/686] platform/x86: lenovo-wmi-capdata: Do not stop the AC notifier chain on error
Date: Fri, 13 Nov 2026 10:52:27 -0500
Message-ID: <20261113153842.690506864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Rong Zhang <i@rong.moe>

[ Upstream commit 3b53e691e907086672b72d0544e4bf27efd4250d ]

Returning NOTIFY_BAD to the AC notifier chain stops it by preventing
later notifier blocks from being called, but our error is non-fatal for
other AC notifier blocks, which should continue to consume the event.

Return NOTIFY_DONE and add a dev_warn() on error, so that the AC
notifier chain continues. This also aligns with hp-wmi.

The function documentation was copied from elsewhere and makes no sense
here, so correct it as well.

Fixes: e1a5fe662b59 ("platform/x86: Add Lenovo Capability Data 01 WMI Driver")
Cc: stable@vger.kernel.org
Tested-by: Navon John Lukose <navonjohnlukose@gmail.com>
Reviewed-by: Derek J. Clark <derekjohn.clark@gmail.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20261019-lwmi-wmi-new-api-v5-2-71557d28d058@rong.moe
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo/wmi-capdata.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/lenovo/wmi-capdata.c b/drivers/platform/x86/lenovo/wmi-capdata.c
index ba843b6604b06..c7fa1c2969561 100644
--- a/drivers/platform/x86/lenovo/wmi-capdata.c
+++ b/drivers/platform/x86/lenovo/wmi-capdata.c
@@ -188,13 +188,11 @@ static int lwmi_cd_setup(struct lwmi_cd_priv *priv)
 
 /**
  * lwmi_cd01_notifier_call() - Call method for cd01 notifier.
- * block call chain.
- * @nb: The notifier_block registered to lenovo-wmi-events driver.
+ * @nb: The cd01 ACPI notifier_block.
  * @action: Unused.
  * @data: The ACPI event.
  *
- * For LWMI_EVENT_THERMAL_MODE, set current_mode and notify platform_profile
- * of a change.
+ * Refresh cached capdata on AC status change.
  *
  * Return: notifier_block status.
  */
@@ -213,8 +211,16 @@ static int lwmi_cd01_notifier_call(struct notifier_block *nb, unsigned long acti
 	switch (event->type) {
 	case ACPI_AC_NOTIFY_STATUS:
 		ret = lwmi_cd_cache(priv);
-		if (ret)
-			return NOTIFY_BAD;
+		if (ret) {
+			dev_warn(&priv->wdev->dev,
+				 "failed to refresh capdata on AC change: %d\n", ret);
+
+			/*
+			 * Our error is non-fatal for others, and we still want
+			 * the other event consumers to process it.
+			 */
+			return NOTIFY_DONE;
+		}
 
 		return NOTIFY_OK;
 	default:
-- 
2.53.0



