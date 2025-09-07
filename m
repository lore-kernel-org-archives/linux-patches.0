Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AEC1DE8AF;
	Sun,  7 Sep 2025 20:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277233; cv=none; b=Pcyh41bQyPLulSxMfEz+jz/NMOfvjYNxO3NyBc2mhl2fB1Nv4Dhv2mmtNi56GtmzRrmdYQll1/F7UVm+h8CzDNznl9AGdJv0kz7JV174YQrjhbyOgKju4s8AL1qDMdD53d786viOhPHCNPrc22ukOpPpcYhgJnwPCsY/SQnyFbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277233; c=relaxed/simple;
	bh=VnN7ZKHO3jhCGCgkj+c7at6HbuvkdVi6d6F4i6wNFDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cb9Yy2Ukd3K2rqpsCNjj/xpKbqFDqa+eEbl5rNEiDEEtlXcTCmnCSHnj4wHV1q1zI1LDXB72sMQdsBwuL9NoQiLcU8FeiYcDqPsOlD2tH4qbMdraHv6Ko1aH9FKa/dIVPYn6B5ROSX3hp1YIZLBREtdiNjRutoaYEf2562XbX3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUP7ws9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUP7ws9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C6BC4CEF0;
	Sun,  7 Sep 2025 20:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277233;
	bh=VnN7ZKHO3jhCGCgkj+c7at6HbuvkdVi6d6F4i6wNFDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUP7ws9fCZveIX9YMdArbtMsplEqPyRiqTjejdXx53JtLwkMlu+8bDeadGHY65BcW
	 9HvPOY1LUVMmLZkbqdDP1I7+Qbre3CquR5mpT405FnNjxxBC2xAwNu03mo8F2ryIK6
	 6+GkhQ1A3vqZcY6OOC2p7WsPltMjj41OTjqpJ1VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 125/175] net: dsa: provide implementation of .support_eee()
Date: Sun,  7 Sep 2025 21:58:40 +0200
Message-ID: <20250907195617.814078515@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 99379f587278c818777cb4778e2c79c6c1440c65 upstream.

Provide a trivial implementation for the .support_eee() method which
switch drivers can use to simply indicate that they support EEE on
all their user ports.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/E1tL149-006cZJ-JJ@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Harshit: Resolve contextual conflicts due to missing commit:
  539770616521 ("net: dsa: remove obsolete phylink dsa_switch operations")
  and commit: ecb595ebba0e ("net: dsa: remove
  dsa_port_phylink_mac_select_pcs()") in 6.12.y ]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dsa.h |    1 +
 net/dsa/port.c    |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1399,5 +1399,6 @@ static inline bool dsa_user_dev_check(co
 
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
 void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
+bool dsa_supports_eee(struct dsa_switch *ds, int port);
 
 #endif
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1589,6 +1589,22 @@ dsa_port_phylink_mac_select_pcs(struct p
 	return pcs;
 }
 
+/* dsa_supports_eee - indicate that EEE is supported
+ * @ds: pointer to &struct dsa_switch
+ * @port: port index
+ *
+ * A default implementation for the .support_eee() DSA operations member,
+ * which drivers can use to indicate that they support EEE on all of their
+ * user ports.
+ *
+ * Returns: true
+ */
+bool dsa_supports_eee(struct dsa_switch *ds, int port)
+{
+	return true;
+}
+EXPORT_SYMBOL_GPL(dsa_supports_eee);
+
 static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)


