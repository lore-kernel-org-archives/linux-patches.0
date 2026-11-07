Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065119;
	b=oSkvmupH9bSi5UUQuK7xowiSEO4iXus579Bw2vC9RI/OeXQl2a1JCbacykZdkVj2LVst
	 h3pDfHu0iwPiytWQG7f0NCLYfF6HBy5Mk00Y2vqy4l0sbkPXGMSf5jOheOUQEwiosvTMS
	 f302GkYxl1UkwHdGUOyEvvzMEcVtnCGLTBHz0XFVEXbLiozFb5TzMuNYUFm/Y5qV9zr8q
	 XtYcFgw9ow3Uiv0Eyd+oc/cnYWkAxhf49g8FWScszfrO885vnZuuqpsEUWWS6cXt2ZUDi
	 Z0gsCVrGGeG9Rfr03QapWmdq8RZtSi2jmi44/VN75ie7JXZFB0igHV7fLiT+8RFD1fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V/EVb0B47fiqR+4rh4PxYcHxdTHtO5uUDfEO1P/3r5E=;
	b=j6ky1WBMJALO7B9fIc1nOz/jp3XLXu46KExy03QrE2yUW6iMA54See4zwMYYUXjT1CF4
	 1l8cZvs4qTbzZUMp782A9ijBqJk/F7RKhNXan/Lv7SDFasjE+UPpI1A2NrrAm/v1vHaTE
	 zhSQ1D+ucUR9aI6yT8IUZEnx1JBb+g1QlFLvlrdl4oEj1d1OYA+Ja/OUd6b04syXcjeRv
	 CakfVwdZLziMu+3Pbh2ujkj4svxqkFcQk/ev1ottS6P4RWLZs4GfEVloofTZ3w2eIxdBt
	 v8RA/Zpt1um2lqvyu28T0NP9NtGil7I0SkCwMzf/6XTV3hZDnP8ZsrQz4Ha/AFBARAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+u31W6U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDEE606A32E;
	Sat,  7 Nov 2026 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+u31W6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D971F008A1;
	Sat,  7 Nov 2026 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065119;
	bh=V/EVb0B47fiqR+4rh4PxYcHxdTHtO5uUDfEO1P/3r5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+u31W6UB4mStacrPEHZr5fA7cc82RjbaPrhqEUZhja/3DqlKUjV8kxkncjcZgMkf
	 8wAJ4OQtczeBbf4eEPLyBQ5WblribS5dRZUMl7Um3qEoMnpR9/CKv/PaSU4BOtuHEF
	 bKwKylo5yly9SIwvWCRX8yMCXuBNdX+CgREQshIw=
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
Subject: [PATCH 7.3 0944/1257] platform/x86: lenovo-wmi-capdata: Do not stop the AC notifier chain on error
Date: Sat,  7 Nov 2026 08:54:00 -0500
Message-ID: <20261107135005.422016962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index d5e9615661364..58787da959b4a 100644
--- a/drivers/platform/x86/lenovo/wmi-capdata.c
+++ b/drivers/platform/x86/lenovo/wmi-capdata.c
@@ -774,13 +774,11 @@ static int lwmi_cd_setup(struct lwmi_cd_priv *priv, enum lwmi_cd_type type)
 
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
@@ -799,8 +797,16 @@ static int lwmi_cd01_notifier_call(struct notifier_block *nb, unsigned long acti
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



