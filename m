Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C613296FDB;
	Mon, 12 May 2025 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073311; cv=none; b=Jwzb6zxqHEo3wIw4+mwDCRaoxHasUbQdudmL3vw4TBbZWc0pAtstWbPvuPkPsODgoUzG/3jS0nOsSzSm7t1JwIuGZuuD9b7+5th1bg1BMAu7wKyNHXR74ET+TG4bnQz/it/Sm27Bt/sfWHv9l28rEPnTRWc5khij3aEDYHdewLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073311; c=relaxed/simple;
	bh=7rSrdep1n4H1n2y3IXtX2/t8TjyVFLScdJ2lWgGQ/Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLnHKCHl6kqKSuLa4SJI8T8vDpfRONrUUS2NyYAP/BLCC3L7vo85QFanEiHw0VukMSTQWVnbO0LiMW2q2cReTxlPHP1Mcyb0xuKajZF7wuk0srbrZuxi0TeIc/tZABv9qC5akf3ePa5RUnt9gFZbjBcED7CuwOcuxTXwuPHDNtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJd+beu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJd+beu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD971C4CEE7;
	Mon, 12 May 2025 18:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073311;
	bh=7rSrdep1n4H1n2y3IXtX2/t8TjyVFLScdJ2lWgGQ/Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJd+beu8UZ5n5fhLN+/OAexF7UctjJdxqr4JEfflaCr1WbnJpEX3/ye5GX9MKQTqA
	 zzzQW+DYZbZB5PcA4wTzf7KeQqcZTXvzdNIu0UgY13RG/ihcfbniZcasf2aiYar5Kb
	 YkxEbZcr3uPlIaW7Km3ftmSMB0xG4IoeVVyNntSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jt <enopatch@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 035/113] Input: synaptics - enable SMBus for HP Elitebook 850 G1
Date: Mon, 12 May 2025 19:45:24 +0200
Message-ID: <20250512172029.101356103@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


