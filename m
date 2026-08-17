Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57BB3E95AB;
	Mon, 17 Aug 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974107; cv=none; b=CVvUdiLdrGabMsasMcwx02eaGmlM0vb61bYJX7hmwnW8Lj7JCv7QN9ajh7DsX16PtF1Cv4jFxH4S6++D3MzyUDEDEN/GIMV3/rECiJ+XL62BnjrAOcjab/Z0BICI59K0Kqv1uoL3Bw5tT2kn/DliKMpMyYhzXiFKrW0Xg1xee4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974107; c=relaxed/simple;
	bh=TN2SSz6nrVNc0TpfzjFpRj47vKlB3HUsOboUXx0vi4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPUBrC3gAiJGS5Y1pugoUcHJoYck9RgEWBhV9L9QueELYQUlGyuw+2rF6f9NiHAGxhirCxHOUrxJ83A5REznt0V4s2c/l2iGiHLk6kY0//DgmKUqBPGQBoTJOT8/S+ZzW7U4UIyZpvVujwIxezFBUMRiUzpI7/QStsBhUMWF/m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vecsKB6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vecsKB6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051E51F000E9;
	Mon, 17 Aug 2026 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974103;
	bh=YA8UiaE5K4ui2WsQ1fbAQZWRc+/1C3/yUPbOJkAFO1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vecsKB6rTdFvlym9TSSCD8pRbN4ie1MGTAhLsv+QSM/jB+wZHmR8p23wX3Adgue7w
	 qlJsKvx0zCuSLnfaQjnok4VbnSVsxa1T3VhbZuuyIP2Te/KKB9Z99iC0eqK8UrvGta
	 0dkh1mpxdLPZVCI7teRGJizZ5x5ooerQvTZXVYqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 091/271] bnge: use int for bnge_fix_rings_count() return value
Date: Mon, 17 Aug 2026 15:30:16 +0200
Message-ID: <20260817132540.514657314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2cbd8a4e5e09aa232a1f8d56ce3d070b18ab2b10 ]

bnge_fix_rings_count() returns 0 on success or a negative errno on failure
However, bnge_adjust_rings() stores its return value in a u16 variable,
causing negative error codes such as -ENOMEM to be converted to a large
positive value.

Use an int for the return code variable so that error values are
preserved and propagated correctly.

Fixes: 627c67f038d2 ("bng_en: Add resource management support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Bhargava Marreddy <bhargava.marreddy@broadcom.com>
Link: https://patch.msgid.link/20260801100923.1498570-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_resc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
index 0e94f092813e0..4711dd4945ffe 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
@@ -163,7 +163,8 @@ static int bnge_adjust_rings(struct bnge_dev *bd, u16 *rx,
 	u16 tx_chunks = bnge_num_tx_to_cp(bd, *tx);
 
 	if (tx_chunks != *tx) {
-		u16 tx_saved = tx_chunks, rc;
+		u16 tx_saved = tx_chunks;
+		int rc;
 
 		rc = bnge_fix_rings_count(rx, &tx_chunks, max_nq, sh);
 		if (rc)
-- 
2.53.0



