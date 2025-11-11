Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E374204E;
	Tue, 11 Nov 2025 01:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822980; cv=none; b=Npci2zIFO35LvYh+fRXmg4YgkPt2JcKFOV44g9omQChwTH9JuzhuzW9W0anHtW+1oGJcHp3/lJgUwsq59VI4ydJm9etUezFlCk+kOhthEt18Weem/FfoiDxBCXSVjyAJ2TTgZqOhGwcAmMPZeV/PUaiIFnj2lvD7kPhdqNW4aLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822980; c=relaxed/simple;
	bh=d+pl+7WNnA8nYXIHaFyBFrXutgGwL+n0GOM7wfiFDro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH6/eL0wBviCSMQlWtv/uyS5nWl3lG0XQASCyXv1+DnW557z0GaeD8FWGg73WQDEbig7/O4EpCFPJ2xlcI2deobZ+PH4z+u5nEZhyYUhB14IvLaLLKsf0PjkUZh3WnfsMC+mpokPE5fbrkif3c2KrUFz0EYwL/Ktg8nyyIDhoag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jo7wh64H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jo7wh64H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C3DC116B1;
	Tue, 11 Nov 2025 01:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822979;
	bh=d+pl+7WNnA8nYXIHaFyBFrXutgGwL+n0GOM7wfiFDro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jo7wh64HBdk9ZnI1KBntLa+DTtxzjKGV9Iy135EPPCKQWa5CKHLLKrNjj1L2yfULB
	 GzmiWrsLlFobIq955RGKKnzVU5OnAfCb8iHhXYbQLCz4ZnYW05zctDzwPGiOsxzuty
	 P8tT+bTVlx6JGQElFRk/mOt0M/WF3HVKMVZsSTgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 168/849] arm64: zynqmp: Revert usb node drive strength and slew rate for zcu106
Date: Tue, 11 Nov 2025 09:35:38 +0900
Message-ID: <20251111004540.495710930@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 767ecf9da7b31e5c0c22c273001cb2784705fe8c ]

On a few zcu106 boards USB devices (Dell MS116 USB Optical Mouse, Dell USB
Entry Keyboard) are not enumerated on linux boot due to commit
'b8745e7eb488 ("arm64: zynqmp: Fix usb node drive strength and slew
rate")'.

To fix it as a workaround revert to working version and then investigate
at board level why drive strength from 12mA to 4mA and slew from fast to
slow is not working.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/85a70cb014ec1f07972fccb60b875596eeaa6b5c.1756799774.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
index 7beedd730f940..9dd63cc384e6e 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
@@ -808,8 +808,8 @@
 			pins = "MIO54", "MIO56", "MIO57", "MIO58", "MIO59",
 			       "MIO60", "MIO61", "MIO62", "MIO63";
 			bias-disable;
-			drive-strength = <4>;
-			slew-rate = <SLEW_RATE_SLOW>;
+			drive-strength = <12>;
+			slew-rate = <SLEW_RATE_FAST>;
 		};
 	};
 
-- 
2.51.0



