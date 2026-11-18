Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061690;
	b=H6nbSzogC0xVgttt0y5hp7uliJ99s9iafRsXvnNs3yex2V90nQJnf//OWnIRO+x/RRZC
	 tN+N6hw0RVSTtc8NdRYOpbYniioDlY54z2ZA7Lfukk7zk8CZU07Ju9RQcpWio69QIksOv
	 uL5WOxiNakkumziFkWxZ+BACuAkF2pqDmq+qH7IoNeikPMZ1QQrZrV8Hkpdav9sKW1dQf
	 qmqqSshrH+mQaq+/Pysurl8ZcdSXWNJgu8BwEZn7ddYsY4bBw+aK/m0Re07cFjM20SJ00
	 LG4CjziXFuUcMkrvuhnkB9XyyI7QmxpHvz7dgFvA7rz1DKYUF8YSDctUE2ull8c4M/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0EJKshVAdkZG+CguEhbOeoqY9//dBgvEI0eQ0gANUgg=;
	b=O3DocibdN5P69dl95vMjf4KurOsrR8q69gjzAX38VOQWISbrQbT6sYokeyWl6oS+lheK
	 zmhgcByikeBeNIcQJJqgFKx68r9jBAwE/gU5THIhRFGPhXV55+CbgF30rLWCokz0C02wS
	 /dqOb4kNwccVkm6S2mxqiFSs+KZpNTovW501PbPmy2zNlSPmK8sg7Cd87xPCMBZAR/mne
	 dkBjGKbsi/6fkTd3N3KCsgC/dPGNuyvxfPKQCs5/3C1UZHo/Uj4DllEp92A52fesHPlmj
	 jlLTLdPEAGgGkTZxAQ+8uQ+t2yh8CUSSDtTYOm0LRfs//9NUGX5OkqROLbMPVLIuF5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJfxmYQb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B22606A32C;
	Thu, 19 Nov 2026 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJfxmYQb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1021F000C4;
	Thu, 19 Nov 2026 04:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061690;
	bh=0EJKshVAdkZG+CguEhbOeoqY9//dBgvEI0eQ0gANUgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJfxmYQbzHpdBChfvtXANVpRFulqWQ0WQym9hCWgtZbfRQ99KJN+LU6kSPEDA6f18
	 G82IjIdILuFXnwjwc5Yov/Q674094QPYfm5C7VrUIrm/8TRCZamTPBXyE4OTa9WDc5
	 uDSAXkhE0U/tBDJ6FrV7n20+Ub1wmv+r9c5D0glU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1602/1848] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150026.597994198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 810ccc792193909ba9bbb4246e0eb0de14dad724 ]

__cci_ace_get_port() looks up the device's "cci-control-port" node with
of_parse_phandle(), which returns the node with its reference count
raised, and only compares the pointer against the probed ports.  Neither
the match nor the no-match return releases it.

Drop the reference on both paths once the comparison is done.

Fixes: ed69bdd8fd9b ("drivers: bus: add ARM CCI support")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://lore.kernel.org/r/20260923164122.596910-1-oss.patchbox@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/arm-cci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index ab9b49451f8f2..25a741e48573f 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -167,9 +167,12 @@ static int __cci_ace_get_port(struct device_node *dn, int type)
 	cci_portn = of_parse_phandle(dn, "cci-control-port", 0);
 	for (i = 0; i < nb_cci_ports; i++) {
 		ace_match = ports[i].type == type;
-		if (ace_match && cci_portn == ports[i].dn)
+		if (ace_match && cci_portn == ports[i].dn) {
+			of_node_put(cci_portn);
 			return i;
+		}
 	}
+	of_node_put(cci_portn);
 	return -ENODEV;
 }
 
-- 
2.53.0



