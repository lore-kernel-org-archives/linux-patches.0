Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB45E255F4D;
	Mon, 12 May 2025 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072495; cv=none; b=JwWQZ83XFEPFNKgsYy+qTTO31dB3NWGZq5+dxk8ocb1cl+ulWzVLTuXoHUm1Qqz7PjT1cZBtjwuonHw/F4OcBMCITGDQSaZL2WMhwaDtOP4W/3APjQ5mw2b1O5OqCCq/ZayNOJlH6/j9C0ykvdrPtkQn/r7kTXJoDF1ZCqjEtNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072495; c=relaxed/simple;
	bh=wxKed310yA570lM3vXTSANHsVppJ1PyLOyDOfmcDVZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RON1eOS7CHSKtLnVl2EVGKmml4RUp/Yi+05Ul/Pg91+TBnWLrQO//s21wHCj5Qhbun5k1qR0zU++K+UPwHG0hzD+DoAw2liSTmx66Czy4z6tlFqXzgtWZVvj1XNLKRBabLhGbz2eY/Hiw0IXwv5WgFMmj4bvh8DlNppa3KSH5Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXwvA6e0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXwvA6e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA857C4CEF4;
	Mon, 12 May 2025 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072495;
	bh=wxKed310yA570lM3vXTSANHsVppJ1PyLOyDOfmcDVZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXwvA6e0UASrUaOn+uZyrYv7CmMp1EMXvTUymvrqowjyBuK5IyJf3buSP3BRu4w6K
	 nXq2pAuutZI4wlyINZj8/KhR3i1qSUhkf78E22bxaj89r4y0qHFUA/rDgiIzHJR8+z
	 Plz5Vvg9lp9SKrOUgzzNGHFeaVLh8YtD6SM/EB2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Eilert <kernel.hias@eilert.tech>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 28/92] Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5
Date: Mon, 12 May 2025 19:45:03 +0200
Message-ID: <20250512172024.268593192@linuxfoundation.org>
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


