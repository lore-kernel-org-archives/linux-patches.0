Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F318323D297;
	Mon, 13 Apr 2026 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097935; cv=none; b=KtsrhNtS0m+od30k7jRDqtp2W9vpbsv5P7gsrDyO61RsV32w1KbngqQf0MeTM1/5DxMyPP8X3UJiI22pz5/pV7vaCdkp5Eq8m6luqhJljyzXuMparJ5s3cXyD62QSiVTwcN8C3V4lccnHhZ41P1ET44REswmFdcRp0N40Tvt+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097935; c=relaxed/simple;
	bh=EaxKpVxTEmfwMtcRdYFfmWLHpT+nPVuu5hhp3+qwpDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVO/4BgKe5yClxSnKHzfoWq/2Xp0TtUHiZVUw83UwKDWIRRgBZymUwETi1gII3DLXRX7YnUpom8TpvybNM9/UKrUbY3VPad9ieujhdQ6hkd7GJF68pvBnWb1eUNZKE9HmoGB7puuMLo4FAO06DzXZU3zb0FYX7tMwPAFSVZR8XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exLy9Ido; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exLy9Ido"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF05C2BCAF;
	Mon, 13 Apr 2026 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097934;
	bh=EaxKpVxTEmfwMtcRdYFfmWLHpT+nPVuu5hhp3+qwpDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exLy9IdoUvldqb53LRPwSAx2jI2J3xfAwcuXtvX8FKN0aBI7Z3NavkY/HAQRQYKne
	 HswAFOxQGsJtJZxJ9LZKPE2LblIAMy66tMXHCxTPbRtzriDokiOz+D8RpfVrEv6ftQ
	 4LVh8GKknx+MWJ61iE/Ynfedgg1V4oPy/f/qoGOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Lubomir Rintel <lkundrak@v3.sk>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/570] platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen
Date: Mon, 13 Apr 2026 17:57:39 +0200
Message-ID: <20260413155842.782069548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2061f7b042f88d372cca79615f8425f3564c0b40 ]

The command length check validates inlen (> 5), but the error message
incorrectly printed resp_len. Print inlen so the log reflects the
actual command length.

Fixes: 0c3d931b3ab9e ("Platform: OLPC: Add XO-1.75 EC driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260310130138.700687-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-xo175-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-xo175-ec.c b/drivers/platform/olpc/olpc-xo175-ec.c
index 0d46706afd2da..d8a9a215a14cd 100644
--- a/drivers/platform/olpc/olpc-xo175-ec.c
+++ b/drivers/platform/olpc/olpc-xo175-ec.c
@@ -482,7 +482,7 @@ static int olpc_xo175_ec_cmd(u8 cmd, u8 *inbuf, size_t inlen, u8 *resp,
 	dev_dbg(dev, "CMD %x, %zd bytes expected\n", cmd, resp_len);
 
 	if (inlen > 5) {
-		dev_err(dev, "command len %zd too big!\n", resp_len);
+		dev_err(dev, "command len %zd too big!\n", inlen);
 		return -EOVERFLOW;
 	}
 
-- 
2.51.0



