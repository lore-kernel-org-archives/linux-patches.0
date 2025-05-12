Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7F4296155;
	Mon, 12 May 2025 17:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071042; cv=none; b=gk6wbQnYCUD5w1GhO3nfJ/a+fo16Rv8/rYzm31nlnPXMDo2MV0s8wz2/jpBiO2qdHO8aCDEYA9gmTOIIR7yPrFvWj7F5PM/XXCccsTNImWJcT+/o67BSoVzQEArTbdf4BYnbRWurgbhonQspb3/4UnOCK/KHk0smzfkfYJbKo+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071042; c=relaxed/simple;
	bh=Z/NdMS/y8i3jNKpebjLJ+XCYTBENdMTlrDD8YUTaul4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5SWZmcBnHI5R7bB97qZNqCFiSmH+DSBsyvTWs+YKBs0ZO8yktCArHlk4/iTwuZH6F/XpG7Ik+ICdGT/A4vK5reN5mxMO5sQCVMtkJz8Bt90CN23eU6FFi8SrtbwmnmA6I0GzLC8L5Efnl67kNYnLM3Egs548EQpI1G/aCIfE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4Upi6Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4Upi6Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D666C4CEE7;
	Mon, 12 May 2025 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071041;
	bh=Z/NdMS/y8i3jNKpebjLJ+XCYTBENdMTlrDD8YUTaul4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4Upi6RmcNriXDU11xti4DP/7+fVbrXC4MOzelKfNUKKm7WNgKSwxcbtxaU0O4zPP
	 MzuoTB2RRXOSj138iNXYTOZdxJM29tfygyVQlQw+63Y0asuzj1Zs6cLAjVIK41c2L0
	 QTVBoWuu0cspkUEm6yZFSS1sd6w6EvHwLwi2h7Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jt <enopatch@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 18/54] Input: synaptics - enable SMBus for HP Elitebook 850 G1
Date: Mon, 12 May 2025 19:29:30 +0200
Message-ID: <20250512172016.383645392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f04f03d3e99bc8f89b6af5debf07ff67d961bc23 upstream.

The kernel reports that the touchpad for this device can support
SMBus mode.

Reported-by: jt <enopatch@gmail.com>
Link: https://lore.kernel.org/r/iys5dbv3ldddsgobfkxldazxyp54kay4bozzmagga6emy45jop@2ebvuxgaui4u
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -188,6 +188,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2068", /* T14 Gen 1 */
+	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */


