Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F0323535A;
	Mon, 12 May 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072492; cv=none; b=V7CSExKyZPgB6DDOBZO6TkFEstA9vlrcyfEbDmAUkuR4GHuHsZcORJXuJCpbC7Ny9bXjiM7e6K2BNfsZ+7xlMJzSkDPjDBBFGaQQ6h/tykNS7hmqjsiKO/WPvt8TX/qAGHKr0PL+xCOXh15B3ZOsks9NPqoojSiGd7Ileqt2+tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072492; c=relaxed/simple;
	bh=0UWnTfTtDMOi3qjUnU6wcmI3Yg+d1iykSV1zeTNIfe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2GwB99evFry1CZpzm5rHSWbQMkiheXXPZdu/Wtqq6BrbZnlSZXeFHLPhmKfXbyppUD8tIPc5Y1c5/q2WwEns1SerseVaNFRAbNGlMOzfd6OxPEMmvgmRP7phtz0of23b4UaSAVVvQdpCe16GLHH2pEi+dkFUcL3hKDPDSCD5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA1vBRWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA1vBRWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C63EC4CEE9;
	Mon, 12 May 2025 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072492;
	bh=0UWnTfTtDMOi3qjUnU6wcmI3Yg+d1iykSV1zeTNIfe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VA1vBRWrTsYI+LKoLesCUqSbUOQ8RBGx7Vv6hJPSxil0XyNEmdiefLnwDLi474270
	 ftV8Oz1/CmOfCRW9qSKbHX/GzUudw8bhszcrz3b3FJlR3UVbEbZEpxiMK1Nko1obYn
	 73i1KcgffqPHr2LsYj+LB5ojAd8Lqs6byDKzJRxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jt <enopatch@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 27/92] Input: synaptics - enable SMBus for HP Elitebook 850 G1
Date: Mon, 12 May 2025 19:45:02 +0200
Message-ID: <20250512172024.228193306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


