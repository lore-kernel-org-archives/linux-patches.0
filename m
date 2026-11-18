Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016698;
	b=fNbqyRwkFhMhiKKKie1ULzlt1i3hbt+7EMtSNrrukUFe4NmA0mLKy9ZG2cQ1wGCtxeqB
	 yypbTBIdLpJkpS2RQhg+q2laT3GGcYi9f7cz5qhaVLwWQZU60083EiiqZ08cSORZwDmDw
	 p8qih1xnMiETRMsSTAt5ZUcdySUvvPXeXwE8+/yORlalwL7jOTGeuav/e0eXibKfRqtPr
	 n9SUUTNIzzlm8Hxf2LS8Oy1t2LhrdXZ0ihiEUFb8lY3ds4eHj9cJOGRyPs/q6OXEYt3Gy
	 FxQ9lLvEmpPw1L+BktFBs96aJGnsweM7fE3GKXBTRMU9vsNVipv8LzcozlogMy1QXPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=94RapR1uDClbJaT2EbdHKMNxKFJvl/XVzD4tKQvc/dQ=;
	b=F2t3CSWcsGUF0SW4m5umTWAN6NojvxQPw1wNJlx2WpwYOw8JZRs14fhBmyVc3o1G/ZGm
	 cI62Ja+SdQmJsoeFvKXmE68xQ9xjP8HdEsGaiCzmWYSCKbHUVb8I71JRq9TAstxCYQfdb
	 zmtNtJ2eKkdWLTIosmsk90jolPnzpSvQExt8S0KxsUT5ORYeXih9GkOpgWlPm5TCX5a3+
	 DEXcyRcLfsDWzy2wpxm/8fpbaAhrvV5zk0+WpoXOAslOjn/dVn3R3Cshk6Tl2s/qNlaNG
	 Zf5KE1uDmpLIISMEq+5H6Nex7W/4yrjMVdeHXFFcJ0Pw0gek+jN1PQjZt6vOQ8pdCEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6zEs8pl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0742606A31C;
	Wed, 18 Nov 2026 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6zEs8pl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362711F000C4;
	Wed, 18 Nov 2026 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016698;
	bh=94RapR1uDClbJaT2EbdHKMNxKFJvl/XVzD4tKQvc/dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6zEs8pltUh54BPWhsZ4aRADO0otrDOgMOnHUKH2R/I2Bw1hT5wXLc3W8WWOer4qc
	 6BfVuye1NNQko2hiLgDhz2EhRyFLbgtEFx3yxKr4BZjjlCAbpBVjJ3AtB/MSX3nOT4
	 XHVp9g4biIz/m/DDvPzuKvIqB2H3kPjCBA+dk4ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0622/2651] i3c: mipi-i3c-hci: Fix runtime PM violation in i3c_hci_free_ibi()
Date: Wed, 18 Nov 2026 15:31:02 +0100
Message-ID: <20261118150310.089561585@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1570265b225757e3684a7c13c36915823f62675d ]

i3c_hci_free_ibi() calls __i3c_hci_disable_ibi(), but the latter
requires runtime PM to be resumed.  The ->free_ibi() callback does not
guarantee that condition.

The cases where ->free_ibi() may be called without a preceding
->disable_ibi() do not require re-enabling runtime PM handling:

- runtime resume failed in i3c_dev_free_ibi_locked(), so it skips the
  IBI disable but still proceeds to call ->free_ibi()
- the device has been re-enumerated under a new dynamic address in
  __i3c_master_add_i3c_dev_locked(), which tears down the old device
  descriptor and deliberately clears olddev->ibi->enabled (to avoid
  sending a DISEC to the stale old address) before calling
  i3c_dev_free_ibi_locked().  As a result ->free_ibi() is reached with
  neither a hardware IBI disable nor runtime PM resumed.

In both cases the important requirement is to prevent further IBI
processing for the device.  That can be done without accessing hardware
by removing the device from the ibi_devs[] table.

Replace the call to __i3c_hci_disable_ibi() with clearing the
corresponding ibi_devs[] entry under the controller lock.

Fixes: 650716f23eac4 ("i3c: mipi-i3c-hci: Fix race in i3c_hci_addr_to_dev()")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-9-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 166d9f70f4358..1ede0d2428cfd 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -675,11 +675,13 @@ static void __i3c_hci_disable_ibi(struct i3c_hci *hci, struct i3c_dev_desc *dev)
 
 static void i3c_hci_free_ibi(struct i3c_dev_desc *dev)
 {
+	struct i3c_hci_dev_data *dev_data = i3c_dev_get_master_data(dev);
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct i3c_hci *hci = to_i3c_hci(m);
 
-	/* Must ensure the IBI has been disabled */
-	__i3c_hci_disable_ibi(hci, dev);
+	/* Must ensure IBIs for this device will no longer be processed */
+	scoped_guard(spinlock_irqsave, &hci->lock)
+		hci->ibi_devs[dev_data->dat_idx] = NULL;
 	hci->io->free_ibi(hci, dev);
 }
 
-- 
2.53.0



