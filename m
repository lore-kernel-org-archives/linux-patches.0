Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43D8296D3F;
	Mon, 12 May 2025 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071880; cv=none; b=PoxZgQp5CqRYgQyMJYKAAs+v5ocz8g6EtCjQ1EQguxotOZPUfhbheqq3aXHtrv1f5nCy4LFqtm6GZKTYr+pfyvXD7SDXq/IkIkKMYv312ZUcFBeFoHs3Aq4tgrcn+gG/ZmnGCaZhsxCNJ6KqvA3+53PRQ7ZYPD8lYW7CLTqLPdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071880; c=relaxed/simple;
	bh=LCeKNme0jntWnX5l/+hl3mmLAqPkQJTB20UGkAa4jEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LR/7BBq4AusWg6GieoXyzHrxoKVuLYzA9W9DGANQG0C6Mb67grcHp3nWHHWKDLhQoi+eSmAcCr67nUkF1LNYOhHR3I2HUpa6BkmoiUWStCIQaRvSdGTfOuTGQaJr7wds/RGjctkbK6McjzSqT6CCPkbcT10Bqf+9RNMpDsOVQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/cjdJGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/cjdJGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560B8C4CEE7;
	Mon, 12 May 2025 17:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071880;
	bh=LCeKNme0jntWnX5l/+hl3mmLAqPkQJTB20UGkAa4jEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/cjdJGQUGVyTDbYCY9YRnnNMDFl/XHz02H2YReNQ0VbHPn4ap+41haC9WTvCGyz6
	 89KfqfonFfZlI9idn/tyW0+JSUIVlj+jm+F/NdeQN3m2AtBlGssgpRM7P0N17VjJLw
	 /uhJrq4J5uHOUuDBe3Kbbqntbc/pdOZDH6LFXLos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuntao Chi <chotaotao1qaz2wsx@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 061/197] Input: synaptics - enable InterTouch on Dynabook Portege X30L-G
Date: Mon, 12 May 2025 19:38:31 +0200
Message-ID: <20250512172046.870301545@linuxfoundation.org>
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


