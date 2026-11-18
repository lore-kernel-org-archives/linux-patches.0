Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035572;
	b=FEzVHrd28q2JWF/do1SPc4EHaJk0fyAH7wz+/EHz774sqtR5eicAo2du6Ryl2npkqxTt
	 lJm8bRSMO1tU+ayRhPhJBXMRAXb5Z8A9uX1/oRgikC/+nSSH4KddcTE04FV9lVGJiwSbX
	 nMXGExGwh/fUKVWZiTJarZ3IRAG/qQoic/zb3MzekUYkkggOHmQADNseVcPwrTwN/towu
	 IawO7aBNtw2bquisDs8KipNE6NXeguJYJJ5UaMonaOgBXU2ntcgQWuZLk5HgqPZVYdVr5
	 1H3DPq1m6nRW4CdvCOFgIINZinrJg/rfWfQPebbUxWkCn7gqVvnIaYAtn0uSK4Xyhuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VT+CmfMNfp+cfG5jwdgnvbISu1VkQTcH3IxBl/7yS+o=;
	b=QbjRBfFqL2ffsGZG+9I3Fm8IfLr1jatEt1Fkm1zByw/YcYqETkq3vr0/c3UE/2iDztWG
	 LZDGDIhkBEwseq/VfEZW9R6zuKkWemWwUM0/BwA807RSUiPdE9XljoEBvyS6BPlKDCmUa
	 8P03pyPzYRjg04/ROZA+8ML5WA/cCLRfBIs6N5ywbsv4WRVUm+iVsrTv/7odgjRLAw1wu
	 lZWEM3Uwrpm0K2XqqrUKFxdyQVsG5cuBgHOk8OeNStwgBE0+Iz1yxQjLm96jKh8HN1cEl
	 gB7O6FygxL6fPfeoj36ZZk82md3I58jOK3tyFpjbR+PQKDAZ6/fppcBCxM1yLJQgQqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06zBPnoA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7719606A334;
	Wed, 18 Nov 2026 20:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06zBPnoA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228BC1F000C5;
	Wed, 18 Nov 2026 20:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035572;
	bh=VT+CmfMNfp+cfG5jwdgnvbISu1VkQTcH3IxBl/7yS+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06zBPnoADD1JsecA6pmK2xy6k1BRF00E8Mn79NI3UXk75Sz1KpAGyfutnXttns0yQ
	 RxL1BCrUPDgnxv7iSErHySRhywcaS74Y09dyAZnP4Gv5mYQktlCX3a1Qdap0hY0Jay
	 DFtVKJ5OjmPTXNEiYbVEcH8aXzVfAPgNungKjvWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 6.6 0753/3318] media: rc: Fix build failure with CONFIG_LIRC disabled
Date: Wed, 18 Nov 2026 15:22:55 +0100
Message-ID: <20261118150341.247073992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 0c795849fd70d6bdb99aea5dd08d9b43128612f6 upstream.

commit 37efd09ba2c6 ("media: rc: Ensure registered is cleared in error
path") broke the build if CONFIG_LIRC was not enabled.

Fixes: 37efd09ba2c6 ("media: rc: Ensure registered is cleared in error path")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202609230511.Em5Osw74-lkp@intel.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    3 +++
 drivers/media/rc/rc-main.c  |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -774,6 +774,9 @@ void lirc_unregister(struct rc_dev *dev)
 	unsigned long flags;
 	struct lirc_fh *fh;
 
+	if (!device_is_registered(&dev->lirc_dev))
+		return;
+
 	dev_dbg(&dev->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		dev->driver_name, MINOR(dev->lirc_dev.devt));
 
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1981,8 +1981,7 @@ out_lirc:
 	scoped_guard(mutex, &dev->lock)
 		dev->registered = false;
 
-	if (device_is_registered(&dev->lirc_dev))
-		lirc_unregister(dev);
+	lirc_unregister(dev);
 	device_del(&dev->dev);
 	/* registered already cleared above */
 	goto out_free_table;


