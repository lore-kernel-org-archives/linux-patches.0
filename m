Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AFA1A0724;
	Mon, 14 Oct 2024 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916937; cv=none; b=AP08gio8XC4H0wzbnJZIurVEq1js8Y3UVYAGc6DyV9sYqkkuERK+21Sj/XMQw3u6ACN68ZwBQvxdwUJOht32E9YWDspca/gvcSWE9yiouW3OEY5xh+BIFtum56JydN1sGHw6zaQ+gd0pzQCR+wTVuT1+L+/vnv2qQ+NuHNhscdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916937; c=relaxed/simple;
	bh=qgdTC5cBTl45qxLzRw+m3iexeL9UX6To9ygHWYPmLu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDjubapSIrRY+f6gq5o6S/HMM5MumoaIt3AYd9BhCzdkez2RGgF2CbNnNg5lcTWwtNImQxwL4la3QzDnHG1Z6lhH6eFo/zAybKX41vhznWU/wOrTe5tTiySinExMcVsSFOSnMtLBvX1xYK8ZtSldUaKMM9+IA09BzEpnpdrJUFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5ZWYpsu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5ZWYpsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461C9C4CEC3;
	Mon, 14 Oct 2024 14:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916936;
	bh=qgdTC5cBTl45qxLzRw+m3iexeL9UX6To9ygHWYPmLu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5ZWYpsu7uZx69hULlxsPGCDbXw5LXI8ER6fluEQ4xLtyAK53A+92Ps6QVOBVAdOf
	 X+COtUSbJrMHjHGL6QbxYXx9Kg4zkNrI57KQhwfP3YhuNzsnuTJmd9MVOQAKfp8715
	 T+5lW4RkBPe0hRTNPkrm2Q3uFKWlPRiiWsrUtmvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdravko delineshev <delineshev@outlook.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/213] PCI: Mark Creative Labs EMU20k2 INTx masking as broken
Date: Mon, 14 Oct 2024 16:19:41 +0200
Message-ID: <20241014141045.910119149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 2910306655a7072640021563ec9501bfa67f0cb1 ]

Per user reports, the Creative Labs EMU20k2 (Sound Blaster X-Fi
Titanium Series) generates spurious interrupts when used with
vfio-pci unless DisINTx masking support is disabled.

Thus, quirk the device to mark INTx masking as broken.

Closes: https://lore.kernel.org/all/VI1PR10MB8207C507DB5420AB4C7281E0DB9A2@VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM
Link: https://lore.kernel.org/linux-pci/20240912215331.839220-1-alex.williamson@redhat.com
Reported-by: zdravko delineshev <delineshev@outlook.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 486efe7b7cae1..54061b65a2b72 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3614,6 +3614,8 @@ DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 			quirk_broken_intx_masking);
 DECLARE_PCI_FIXUP_FINAL(0x1b7c, 0x0004, /* Ceton InfiniTV4 */
 			quirk_broken_intx_masking);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_20K2,
+			quirk_broken_intx_masking);
 
 /*
  * Realtek RTL8169 PCI Gigabit Ethernet Controller (rev 10)
-- 
2.43.0



