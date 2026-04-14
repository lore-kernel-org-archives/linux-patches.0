Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5985212548
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776204150; cv=none; b=mTviIp4n7aWMLGFaQBuw0rz1tmjtJbVzEhx62FMhdJQWOnHDIlo9//JCjsjjynyeeE5/ACYMW2UJKtpNWSreNbDVW/c2xCEFaH8gv3U31ZQb20vsGjVmopam0oMGR3w4xrc/tET3t8lvfuRMHwSoT9jOn0VA8BKQhNCdT2bPTM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776204150; c=relaxed/simple;
	bh=m199cVXs81n8q8bMlzDeZwKDZHhxeuNFt1D3j8fFGLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5mS5ulSlJKtb9cwrNQoVDL1fDywrBhAQ6FGZhfoBq25QBgc3llRUkMaRbdbeumEg0YQGQZxJNReM1COWHfNSqBnyQgJmSomFyZpjOnXQbwfIqlpeRxESmdU5KDQjMpkv2wQKHXffF0lX/qLwKAI9KQvmNmsBDTi9N0O4sEeqbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DYz5THIf; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DYz5THIf"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fwJCy1bm3z1XM0nw;
	Tue, 14 Apr 2026 22:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776204135; x=1778796136; bh=Rox/6Lq0+L+k6+vltBDza/jr
	kE0m5EXCfVzPYz2aa4s=; b=DYz5THIfHpt3hqyI0kEMFfc6DLV9+JvgdWv7PV4k
	gODM/j4j3qOkGetmJmu65pzMHYr1SV8vkwRTEhPONsWDIHhtDWQjFHL3G1zNMpIW
	9nuy7bxdNzB79WLQ1L2aCrhAjMBbwJAlPZEWGoMfz5McNJzfzrdEj6uo10qXw+8s
	w4k3WD8tNPDFvFP0ijf5isVOo79Ixf8D1xN3cpFx1CswuYUMcK049dFCExz04xnB
	V4FjqOf5xyzad/66tFenf7MFLoqBX+2MjhUFqHz8h+ETEciBkh4zGvSO7DpBYpDx
	xfU5ADTJWd1sTqo83MKz8mEuGkRrIhFhryVYY/C7UX+j/w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UmMCJYZWE1Ej; Tue, 14 Apr 2026 22:02:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fwJCn4PzLz1XM0nq;
	Tue, 14 Apr 2026 22:02:13 +0000 (UTC)
Message-ID: <e0ed2159-814b-44fe-bc58-89c52b3c3f45@acm.org>
Date: Tue, 14 Apr 2026 15:02:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 040/491] wifi: cw1200: Fix locking in error paths
To: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Berg <johannes.berg@intel.com>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
 stable <stable@vger.kernel.org>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155820.553917826@linuxfoundation.org>
 <408661f69f263266b028713e1412ba36d457e63d.camel@decadent.org.uk>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <408661f69f263266b028713e1412ba36d457e63d.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/26 1:48 PM, Ben Hutchings wrote:
> On Mon, 2026-04-13 at 17:54 +0200, Greg Kroah-Hartman wrote:
>> [ Upstream commit d98c24617a831e92e7224a07dcaed2dd0b02af96 ]
>>
>> cw1200_wow_suspend() must only return with priv->conf_mutex locked if it
>> returns zero. This mutex must be unlocked if an error is returned. Add
>> mutex_unlock() calls to the error paths from which that call is missing.
> 
> These error paths already call cw1200_wow_resume() which unlocks
> conf_mutex.  So this is introducing and not fixing a locking bug.
> Please drop this from all stable queues and revert it upstream.

Agreed.

>> This has been detected by the Clang thread-safety analyzer.
> 
> A bug report against that analyser may also be in order!

The analyzer is fine - I was the one who misinterpret the output of the
analyzer. The patch below should be sufficient to address what the 
thread-safety analyzer reported and shouldn't introduce any functional
changes. A structure definition and a few include directives have been
moved to allow the compiler to verify the __releases() annotation at
compile time.

Bart.


diff --git a/drivers/net/wireless/st/cw1200/cw1200.h 
b/drivers/net/wireless/st/cw1200/cw1200.h
index 48f808cdc1cb..583e85fd8260 100644
--- a/drivers/net/wireless/st/cw1200/cw1200.h
+++ b/drivers/net/wireless/st/cw1200/cw1200.h
@@ -24,7 +24,6 @@
  #include "wsm.h"
  #include "scan.h"
  #include "txrx.h"
-#include "pm.h"

  /* Forward declarations */
  struct hwbus_ops;
@@ -88,6 +87,13 @@ struct cw1200_link_entry {
  	struct sk_buff_head		rx_queue;
  };

+struct cw1200_pm_state {
+	struct cw1200_suspend_state *suspend_state;
+	struct timer_list stay_awake;
+	struct platform_device *pm_dev;
+	spinlock_t lock; /* Protect access */
+};
+
  struct cw1200_common {
  	/* interfaces to the rest of the stack */
  	struct ieee80211_hw		*hw;
diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c 
b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index 2b6afe221268..5ab9211dfd4b 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -21,6 +21,7 @@
  #include "hwbus.h"
  #include <linux/platform_data/net-cw1200.h>
  #include "hwio.h"
+#include "pm.h"

  MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>");
  MODULE_DESCRIPTION("mac80211 ST-Ericsson CW1200 SDIO driver");
diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c 
b/drivers/net/wireless/st/cw1200/cw1200_spi.c
index 52386dfb5f4a..b942472e0e69 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
@@ -24,6 +24,7 @@
  #include "hwbus.h"
  #include <linux/platform_data/net-cw1200.h>
  #include "hwio.h"
+#include "pm.h"

  MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
  MODULE_DESCRIPTION("mac80211 ST-Ericsson CW1200 SPI driver");
diff --git a/drivers/net/wireless/st/cw1200/pm.c 
b/drivers/net/wireless/st/cw1200/pm.c
index 120f0379f81d..a7b39c75fc56 100644
--- a/drivers/net/wireless/st/cw1200/pm.c
+++ b/drivers/net/wireless/st/cw1200/pm.c
@@ -155,6 +155,7 @@ int cw1200_can_suspend(struct cw1200_common *priv)
  EXPORT_SYMBOL_GPL(cw1200_can_suspend);

  int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan 
*wowlan)
+	__cond_acquires(0, ((struct cw1200_common *)hw->priv)->conf_mutex)
  {
  	struct cw1200_common *priv = hw->priv;
  	struct cw1200_pm_state *pm_state = &priv->pm_state;
diff --git a/drivers/net/wireless/st/cw1200/pm.h 
b/drivers/net/wireless/st/cw1200/pm.h
index f516eedfe03c..0074abf46ee0 100644
--- a/drivers/net/wireless/st/cw1200/pm.h
+++ b/drivers/net/wireless/st/cw1200/pm.h
@@ -9,19 +9,15 @@
  #ifndef PM_H_INCLUDED
  #define PM_H_INCLUDED

+#include <net/mac80211.h>
+#include "cw1200.h"
+
  /* ******************************************************************** */
  /* mac80211 API								*/

  /* extern */  struct cw1200_common;
  /* private */ struct cw1200_suspend_state;

-struct cw1200_pm_state {
-	struct cw1200_suspend_state *suspend_state;
-	struct timer_list stay_awake;
-	struct platform_device *pm_dev;
-	spinlock_t lock; /* Protect access */
-};
-
  #ifdef CONFIG_PM
  int cw1200_pm_init(struct cw1200_pm_state *pm,
  		    struct cw1200_common *priv);
@@ -29,7 +25,8 @@ void cw1200_pm_deinit(struct cw1200_pm_state *pm);
  int cw1200_wow_suspend(struct ieee80211_hw *hw,
  		       struct cfg80211_wowlan *wowlan);
  int cw1200_can_suspend(struct cw1200_common *priv);
-int cw1200_wow_resume(struct ieee80211_hw *hw);
+int cw1200_wow_resume(struct ieee80211_hw *hw)
+	__releases(((struct cw1200_common *)hw->priv)->conf_mutex);
  void cw1200_pm_stay_awake(struct cw1200_pm_state *pm,
  			  unsigned long tmo);
  #else
diff --git a/drivers/net/wireless/st/cw1200/queue.c 
b/drivers/net/wireless/st/cw1200/queue.c
index c2f2c118224c..d926e7c84531 100644
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -12,6 +12,7 @@
  #include "queue.h"
  #include "cw1200.h"
  #include "debug.h"
+#include "pm.h"

  /* private */ struct cw1200_queue_item
  {
diff --git a/drivers/net/wireless/st/cw1200/sta.c 
b/drivers/net/wireless/st/cw1200/sta.c
index 5d8eaa700779..6dfdee52fdb2 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -17,6 +17,7 @@
  #include "fwio.h"
  #include "bh.h"
  #include "debug.h"
+#include "pm.h"

  #ifndef ERP_INFO_BYTE_OFFSET
  #define ERP_INFO_BYTE_OFFSET 2
diff --git a/drivers/net/wireless/st/cw1200/txrx.c 
b/drivers/net/wireless/st/cw1200/txrx.c
index 084d52b11f5b..7160059030ba 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -15,6 +15,7 @@
  #include "bh.h"
  #include "sta.h"
  #include "debug.h"
+#include "pm.h"

  #define CW1200_INVALID_RATE_ID (0xFF)


