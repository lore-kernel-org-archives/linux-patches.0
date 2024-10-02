Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C6E3D994;
	Wed,  2 Oct 2024 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880644; cv=none; b=JaC5hdqCJdbRhGPmuPbGICNBCAImEsVTOT5w8XBZAyyl2wPlij7xETK/lkn9qet5XQgf248KXYMkOZKUQVE3JIAr7tnt3yF2QIrTWZR6FodfDZ2fXHNx7W0jqPSeBEdokH8Nba/rmmJuFWm+tuDvQNJzzXRxzNiVac+X55H50Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880644; c=relaxed/simple;
	bh=5Fu/ZOmHDzhGy/Qz6FVFXORErFYgbNJa40MCd8Ftiak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcolENDE549tllG46TNORKTjf3I2IqH4Zl/kWyRfp8kjk+EIDqrpxenDOb2Zc3bP85mnlirh+G10mqkA7UKcEJkqshe/n5EDwYJkU9fcYoU8FwRhl+jEzQ3N9/oVFwxMJqkjyi3Pm3Z/0djP/JV3Hxr0dk0vjunSSQ5VtkPGf9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3UlnCr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3UlnCr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524E2C4CEC2;
	Wed,  2 Oct 2024 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880644;
	bh=5Fu/ZOmHDzhGy/Qz6FVFXORErFYgbNJa40MCd8Ftiak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3UlnCr9XFVfVh9bejpGvtedSfJWr4vgfn89QviO00OeGYXQ7h941VOcWhXFde3az
	 P3/AWTfDUw/m5AgEI+IoBYmc9QSobNRaakiU3o30cFhLexOrLMqNNTxG8X7x+bHZH2
	 YYjLn/6x5t4PJDeQywjztQC4kq4JhyJhjkk4abXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 502/538] thunderbolt: Fix debug log when DisplayPort adapter not available for pairing
Date: Wed,  2 Oct 2024 15:02:21 +0200
Message-ID: <20241002125812.255070484@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 6b8ac54f31f985d3abb0b4212187838dd8ea4227 ]

Fix debug log when looking for a DisplayPort adapter pair of DP IN and
DP OUT. In case of no DP adapter available, log the type of the DP
adapter that is not available.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1311,13 +1311,12 @@ static void tb_tunnel_dp(struct tb *tb)
 			continue;
 		}
 
-		tb_port_dbg(port, "DP IN available\n");
+		in = port;
+		tb_port_dbg(in, "DP IN available\n");
 
 		out = tb_find_dp_out(tb, port);
-		if (out) {
-			in = port;
+		if (out)
 			break;
-		}
 	}
 
 	if (!in) {


