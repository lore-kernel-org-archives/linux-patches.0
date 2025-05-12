Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586BD1519B8;
	Mon, 12 May 2025 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072829; cv=none; b=bZnnyqiHk6ke2EvD+oYNwblxjKiI03fMvBY6JXfZXfqMwVDF+zDFeJeZ05xx75t7pWPM9CdZ5PneRXQjinN3WWquz+w02t9PHUX/skezdrSwAgwSy8D8SYng5ekXGdZ3Fsz/jFbpM5fiXc/Sr2e/D8Hgi5j/DMHp0FHAeFyXA6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072829; c=relaxed/simple;
	bh=f/ruqs5DGqHwH+XZLrhAY641fvctPvxzT8/T+D+bals=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrhB0ySn7ZYXJs3/Ei/Uha2S1ltZ41gFCbwNhumUPLVjmNUTAgxnoU3pyyNZJXvZgqNYh3W3FOf4HbYKxnfku/CJhd7zdJj8Tl+w8RnLF43EOXxm5l+6ADoIiy1261cYCbVZGUI809EyWhNjFwH7kOoGfJmVHZDQo3/2GtuNt5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm2Fy6Hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm2Fy6Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC0FC4CEE9;
	Mon, 12 May 2025 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072829;
	bh=f/ruqs5DGqHwH+XZLrhAY641fvctPvxzT8/T+D+bals=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm2Fy6HrAPGN4eeqgyOpBa1rAwhjNoShubqlKeSYM7ure/2L7P9Udg+pQZaUqzeJN
	 XRBMcsULBemQemqOItaN46AnGn1MRd29Be76gSLXF+aENJXy2U1i5zyG7epfhT+JYD
	 BDzsh194KkyvNkvjDzrkTMif8YBOkXfdkSNFfT1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 061/184] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon, 12 May 2025 19:44:22 +0200
Message-ID: <20250512172044.219643455@linuxfoundation.org>
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

From: Aditya Garg <gargaditya08@live.com>

commit 47d768b32e644b56901bb4bbbdb1feb01ea86c85 upstream.

Enable InterTouch mode on Dynabook Portege X30L-G by adding "TOS01f6" to
the list of SMBus-enabled variants.

Reported-by: Xuntao Chi <chotaotao1qaz2wsx@gmail.com>
Tested-by: Xuntao Chi <chotaotao1qaz2wsx@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Link: https://lore.kernel.org/r/PN3PR01MB959786E4AC797160CDA93012B888A@PN3PR01MB9597.INDPRD01.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -194,6 +194,7 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"TOS01f6", /* Dynabook Portege X30L-G */
 	"TOS0213", /* Dynabook Portege X30-D */
 	NULL
 };


