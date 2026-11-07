Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064237;
	b=Lw3bRPqHhvtkvosGC+aT8cMCNWj6rxSKSIVrwaLWpjyXu7a7enbkGmPm3eKRYJ3Gyq7D
	 2WXP7KWx6xugqa4XlEKvmuxhVYJZwd2YmWGvlJHbCjSLWuREhOrilzahW2bG6FjW3/NUa
	 1YUROUj/X763Z1TKL+QuKe9eS8ojm40R8mZATvvgZsC+eQbRUFoVBOS+DH3hwgg+o36Hx
	 pk1QaKU31bUtp0AXpRYCOCzFKWciYLmPCbXBoW+P/7CP8p7t1KB6bl04qRvq5H7RI2fQN
	 QoVXwYgmAq0xI7QSCWzBnTtcM3bWqt7ggMyOifpXy4tXfEk+uk4Q1KCtgFT+mUQ9buw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=g7bV9oX6da3G/tv+IXIEkOn1GXWBpTmrJdOMUDSiqiA=;
	b=QBF3cKD2KkMwSVj2SgE1scCCyb0/SMFWGdUdXN83IIsBLckqRw9sCnpvo68UhBq/MwKq
	 oc35xMl6N6AHbXCBSKA/QDGuXqw40YeT8N9xgjHnF55oAbBovKBHE/6A1FigTR6El8KC6
	 Vgb8d8qd5TppYfMwQ0ijkBrhofXja4axzgekP2C5sMeqblzvi+1RucsHLke4sC0J8BXWP
	 PADAeP1fVx06st9rE8guPuTxO0mjisfyiL+JIy4GRWZN7TLy4fkltL8VrlsGSIt+Y3aWQ
	 G4JcmvL++BRtIPEZ7GAvfeDaDK8GIQn0moHZuOp48YD7x+jVePvQiG2qAiS/bTDInWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GL947NIH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC62606A332;
	Sat,  7 Nov 2026 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GL947NIH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487FF1F008A4;
	Sat,  7 Nov 2026 15:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064237;
	bh=g7bV9oX6da3G/tv+IXIEkOn1GXWBpTmrJdOMUDSiqiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GL947NIHpEkYwOux1qdLEcVvoMSIUS4prtCFO+deMgYVckTQa6VwX+IzvcpadKq93
	 Y2fJmPd3YiY1s6q6nFWUBV2L1VzKUua4HU51UxzLqFAiNL1HLcZQr0lckL5a8J2nd9
	 7Cj9ZRHuBvf5VbPhlefRZbo+VIrpv6PntKDIbk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0301/1257] platform/x86/intel/pmt: Block mmap when callback is present
Date: Sat,  7 Nov 2026 08:43:17 -0500
Message-ID: <20261107134947.768785747@linuxfoundation.org>
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

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit 0d4cd92b41dd33a3112959f9be86002ff309de73 ]

With the introduction of the .read_telem() callback, control
for access to a devices data area must be done by the callback
owner.

This means that an area cannot be mmap-ed with the default PMT
handler.

If the .read_telem() callback is present, do not support mmap.

Fixes: 045a513040cc ("platform/x86/intel/pmt: Use PMT callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260910135954.1586360-2-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index d0ab8e33c62a6..c25892a511804 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -417,7 +417,14 @@ static int intel_pmt_dev_register(struct intel_pmt_entry *entry,
 	sysfs_bin_attr_init(&entry->pmt_bin_attr);
 	entry->pmt_bin_attr.attr.name = ns->name;
 	entry->pmt_bin_attr.attr.mode = 0440;
-	entry->pmt_bin_attr.mmap = intel_pmt_mmap;
+
+	/*
+	 * The read_telem callback controls access to the memory area. Block
+	 * usage if the read_telem callback is present.
+	 */
+	if (!(entry->cb && entry->cb->read_telem))
+		entry->pmt_bin_attr.mmap = intel_pmt_mmap;
+
 	entry->pmt_bin_attr.read = intel_pmt_read;
 	entry->pmt_bin_attr.size = entry->size;
 
-- 
2.53.0



