Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC164086A;
	Tue, 11 Nov 2025 00:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822031; cv=none; b=NXJG+ljDoCAslpR7BPZSl8Sx+4gitGoEeMpmPQgH6nH5fIqyBnrvVAl2dUlHxb1khpCxxDDB1KR4fNW+MQkFWC6wreu7E7IGkrlolmL2V+vN+C/D27WvR1q0peGeFetMw3cv11LDfsHG0ZTK/2fmEd7Kpuuy2248h1JK+aK3gFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822031; c=relaxed/simple;
	bh=Acc+Q1MjG1m2jnpFttqxrzekHXgp0taMB2pzz4piVkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKbRtUWRcPjl89pXVDiPS5kgrucqW9qZqllDuETGRAGU0LvaSPDPam1R/5IU2t1TpMtvMYzaCEsPp5jqMoipJS01Bn9v3tugxn3fvpvy1LQbYMUstzFYIVK4Ul0mBNnkW+4p+7GolM/3vjPybAnnyOr1dg6HArXb+4bq5ghTe8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llPh2dW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llPh2dW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9400AC19421;
	Tue, 11 Nov 2025 00:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822030;
	bh=Acc+Q1MjG1m2jnpFttqxrzekHXgp0taMB2pzz4piVkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llPh2dW4nqGL0ybBkasZzuSFeRLAwnFuPNTjUqq3U4Kac3+uH9yoOu7L7iHvPoyjo
	 eEhWwthBipP2hbY9SPry+F481rhUdunaoFzH4iWhP8EHG5TCkzuUxI1ree4IFttEOl
	 8yF2nRLUv2jn60wSvLiwsYZ58xaWFjg5rmbRcbg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.17 001/849] Revert "Bluetooth: L2CAP: convert timeouts to secs_to_jiffies()"
Date: Tue, 11 Nov 2025 09:32:51 +0900
Message-ID: <20251111004536.501135976@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

commit 76e20da0bd00c556ed0a1e7250bdb6ac3e808ea8 upstream.

This reverts commit c9d84da18d1e0d28a7e16ca6df8e6d47570501d4. It
replaces in L2CAP calls to msecs_to_jiffies() to secs_to_jiffies()
and updates the constants accordingly. But the constants are also
used in LCAP Configure Request and L2CAP Configure Response which
expect values in milliseconds.
This may prevent correct usage of L2CAP channel.

To fix it, keep those constants in milliseconds and so revert this
change.

Fixes: c9d84da18d1e ("Bluetooth: L2CAP: convert timeouts to secs_to_jiffies()")
Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/l2cap.h | 4 ++--
 net/bluetooth/l2cap_core.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 4bb0eaedda18..00e182a22720 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -38,8 +38,8 @@
 #define L2CAP_DEFAULT_TX_WINDOW		63
 #define L2CAP_DEFAULT_EXT_WINDOW	0x3FFF
 #define L2CAP_DEFAULT_MAX_TX		3
-#define L2CAP_DEFAULT_RETRANS_TO	2    /* seconds */
-#define L2CAP_DEFAULT_MONITOR_TO	12   /* seconds */
+#define L2CAP_DEFAULT_RETRANS_TO	2000    /* 2 seconds */
+#define L2CAP_DEFAULT_MONITOR_TO	12000   /* 12 seconds */
 #define L2CAP_DEFAULT_MAX_PDU_SIZE	1492    /* Sized for AMP packet */
 #define L2CAP_DEFAULT_ACK_TO		200
 #define L2CAP_DEFAULT_MAX_SDU_SIZE	0xFFFF
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 805c752ac0a9..d08320380ad6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -282,7 +282,7 @@ static void __set_retrans_timer(struct l2cap_chan *chan)
 	if (!delayed_work_pending(&chan->monitor_timer) &&
 	    chan->retrans_timeout) {
 		l2cap_set_timer(chan, &chan->retrans_timer,
-				secs_to_jiffies(chan->retrans_timeout));
+				msecs_to_jiffies(chan->retrans_timeout));
 	}
 }
 
@@ -291,7 +291,7 @@ static void __set_monitor_timer(struct l2cap_chan *chan)
 	__clear_retrans_timer(chan);
 	if (chan->monitor_timeout) {
 		l2cap_set_timer(chan, &chan->monitor_timer,
-				secs_to_jiffies(chan->monitor_timeout));
+				msecs_to_jiffies(chan->monitor_timeout));
 	}
 }
 
-- 
2.51.2



