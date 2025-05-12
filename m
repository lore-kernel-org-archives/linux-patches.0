Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E74E1519B8;
	Mon, 12 May 2025 18:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072898; cv=none; b=V9ismHsISi0zJJ2ivcX74iwLB24oFWXsogV6X98xeykm7WzhNE9Df/a/Nkzkq4P2nnEhS8MdfwWnwk2DhT6b0UGksm8gaiMOgFDO4FITilxqyoywm6D59HyoeaZaIrtkexD/hhRDgZZ2lgqFFjsM8Aotrsfa/32GiHcErteWpv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072898; c=relaxed/simple;
	bh=PGtPPNN1/ng4WOXQQWKpV5tFclkWq98l6rs44qHiOQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u40CwMN5Gj4YUmYQwbHOKdGBpUBMxmJq/0LXSOqjjtQ/GQM/xIBF4z81wP7REMinOitW/1GcAPz1+YSXyTLZCYqKOaJtQWzI0u88jHzmh88hwMqoNW+Cb3ZOLVVjLlEvjfmjLaIF5S3hha3FfePtr1XEsqc4eQDOmLepIEZ74HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxApos15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxApos15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D050C4CEE7;
	Mon, 12 May 2025 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072897;
	bh=PGtPPNN1/ng4WOXQQWKpV5tFclkWq98l6rs44qHiOQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxApos156YILJEnffPl2bcoyv8ciJurYEYPSmwteTMYcd6ZjzInvwUg6tycj1d6v9
	 aaYuCHRn8ZxL9vIqOH4njXHD6Jw3DSvaBoBUVsASxWCYvUc//5K+E02vk+pH5bezvg
	 UspQP3Jt2faOnTsoh2n+3N7SnECgsnZX652Mmi0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jt <enopatch@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 063/184] Input: synaptics - enable SMBus for HP Elitebook 850 G1
Date: Mon, 12 May 2025 19:44:24 +0200
Message-ID: <20250512172044.402703751@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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
@@ -190,6 +190,7 @@ static const char * const smbus_pnp_ids[
 	"LEN2054", /* E480 */
 	"LEN2055", /* E580 */
 	"LEN2068", /* T14 Gen 1 */
+	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */
 	"SYN3221", /* HP 15-ay000 */


