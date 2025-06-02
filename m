Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB8C19EEBD;
	Mon,  2 Jun 2025 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874621; cv=none; b=ORy6STYqU5ota7DiTKe4WxuIWs6O4ZSwv8imu/UHaQdXpj1djzhdkQSaI7nTkhUuVriGwk9hNVXISLn67G8w3ab/3E+hUaM4ioo7MT6TZuphh6B4VnSdlmAnXD1AVDNwoDVMY5HnquIcxf1Wq/inMDfsuGNcj8VOrkXhpjLRcG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874621; c=relaxed/simple;
	bh=xkoOe4j5WIgmWhRhd9n9niDeVJyjFTvMCNdlG4uCT3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0mIQzBwwkVvekyX9hFWuY8W9P90v9JX+evjKMToRLSJyetcHtp3nXJgQX1a/tWlZ/UGQ0Xg6ctQp4z3Sq7PcjEfcExJtp8vRn0yWXe1cbfyfUxzgOj4AEQqi8AgLzagObj21e9riLwzvqJELRMKpmsKubwwRqSzYuPlo9VvnR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmHJZvFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmHJZvFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B14BC4CEEB;
	Mon,  2 Jun 2025 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874621;
	bh=xkoOe4j5WIgmWhRhd9n9niDeVJyjFTvMCNdlG4uCT3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmHJZvFalRUar6FWOBU6K/Eete2uJZTRT4xom8Txl0BRpspHHhj8o+e12NdcUHzgR
	 +gL0URwi8FX9blFHslmCtW5rHkrhTkj/xOLpruVsDUBcuCFQle6k3FxLxbL204seJi
	 0P8tGCyOhao/BCfu9b8RG5P/Y5FvtmSnCuHmMnCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jt <enopatch@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Aditya Garg <gargaditya08@live.com>
Subject: [PATCH 5.4 083/204] Input: synaptics - enable SMBus for HP Elitebook 850 G1
Date: Mon,  2 Jun 2025 15:46:56 +0200
Message-ID: <20250602134258.931437980@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f04f03d3e99bc8f89b6af5debf07ff67d961bc23 upstream.

The kernel reports that the touchpad for this device can support
SMBus mode.

Reported-by: jt <enopatch@gmail.com>
Link: https://lore.kernel.org/r/iys5dbv3ldddsgobfkxldazxyp54kay4bozzmagga6emy45jop@2ebvuxgaui4u
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -186,6 +186,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2044", /* L470  */
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
+	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */


