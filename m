Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FE6252904;
	Mon, 12 May 2025 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071931; cv=none; b=WesGRmYFdUjMxtywybdno2IyOSj7nLzZ4fTxzakHlRwPKs0b3bUZCxRU7vbTAKDoJsimAhVZuidpXhLlc6VQdhmoNK3wo99DrxD/uBYHVioYnIjQAG83vEFzHzyC/0fcvI/gH5fDJg1U1mJph/2IJFJTe1ghotX4U+6DzqZsik4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071931; c=relaxed/simple;
	bh=v3qc/xNcUOwZEZ19zfuPvWC+lnEjf3c360PXo6VY5jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js339LMJIMQltgEw1JYlvygQkL1/kBXLO1om98Ra4fZBSgf56jNqYyVUlylRfPBwDyucHGbuoJRUWEftkxbHl7AIEJORaPm4FKmesiGZKLY4KW4/hIDxysMM1xX0ZaXrEUEzCMdVURkO/wdeidGfdnkZnUFgQWOG1ElCyrlAfFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebQ9vlzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebQ9vlzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7399AC4CEE7;
	Mon, 12 May 2025 17:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071930;
	bh=v3qc/xNcUOwZEZ19zfuPvWC+lnEjf3c360PXo6VY5jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebQ9vlzt0KB0WExMoXLy8RRg5+coJaUV/g+kzKHKrp9haen/KRAWYA36LPM4WI4u3
	 mO30dxSytKFJeUUcoOvkPKrTtTu8TfaW3PYntflh1x1gAiSa/pQwhuZ7U16e95gv9L
	 gXo6uh2LsOwKyBAMDMAxkdHnIzSYAk9DcQDIHzCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Eilert <kernel.hias@eilert.tech>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 064/197] Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
Date: Mon, 12 May 2025 19:38:34 +0200
Message-ID: <20250512172046.987731941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 2abc698ac77314e0de5b33a6d96a39c5159d88e4 upstream.

Enable InterTouch mode on TUXEDO InfinityBook Pro 14 v5 by adding
"SYN1221" to the list of SMBus-enabled variants.

Add support for InterTouch on SYN1221 by adding it to the list of
SMBus-enabled variants.

Reported-by: Matthias Eilert <kernel.hias@eilert.tech>
Tested-by: Matthias Eilert <kernel.hias@eilert.tech>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB9597C033C4BC20EE2A0C4543B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
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
+	"SYN1221", /* TUXEDO InfinityBook Pro 14 v5 */
 	"SYN3003", /* HP EliteBook 850 G1 */
 	"SYN3015", /* HP EliteBook 840 G2 */
 	"SYN3052", /* HP EliteBook 840 G4 */


