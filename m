Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B0633986F;
	Tue, 17 Mar 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768127; cv=none; b=XVtAahRFWPy8oinM3qFrl45zvrkJyC9cGncuLAI03ycJ97KXyaROunW7mknwI1Diq9RzDonIlzmK2/k0iVD5t/o76718czmZIyAsp0ex4qjzUWu+HI3Zw7sAILclC3TqcbOBWap/mlLNkzROcI7RaSUvzkeBNhiYF6HhPW6Snck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768127; c=relaxed/simple;
	bh=mRxu0bKmRUDO7jFybH3zwg5cwCFkIi1rn4yP/eIyPKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a95G2hnHkIWu/3zXWD3/PTt6h4uP4OlWnoNi8yKpYdHe31ZLoStZtyxvj75oa4tvQY+vyy/Wn+pGGj4LmKKdYXuM/EqbovPv6Cgo2jsoA5DKW4i0tqRwhUdDLoFg1NSnu9cuGR6R9KMQ/xtW/WZpa9ITj0+X/LvI2pnx8Kl2ceA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RTbs7uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RTbs7uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1260DC2BCB3;
	Tue, 17 Mar 2026 17:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768127;
	bh=mRxu0bKmRUDO7jFybH3zwg5cwCFkIi1rn4yP/eIyPKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RTbs7uqfXD5VJdiUkbsLgaqZ0rI08E6pCfwiLnrRzgvPAxlhhN2MBH6qvDCzgMbi
	 4dVpAcZY+jLloKorL1sInjHuq/l2A2fykiG5GvuBqaEweG3PVshBpc6gjAbbXh+4Iy
	 v3n1AQnGnLAdHk9SvsMCHXY3u7qbU1p5E9efKDkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filippo Baiamonte <filippo.ba03@bugzilla.kernel.org>,
	Maximilian Pezzullo <maximilianpezzullo@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 236/333] ata: libata-core: Disable LPM on ST1000DM010-2EP102
Date: Tue, 17 Mar 2026 17:34:25 +0100
Message-ID: <20260317163008.116602409@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>

commit b3b1d3ae1d87bc9398fb715c945968bf4c75a09a upstream.

According to a user report, the ST1000DM010-2EP102 has problems with LPM,
causing random system freezes. The drive belongs to the same BarraCuda
family as the ST2000DM008-2FR102 which has the same issue.

Cc: stable@vger.kernel.org
Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Reported-by: Filippo Baiamonte <filippo.ba03@bugzilla.kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221163
Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4157,6 +4157,7 @@ static const struct ata_dev_quirks_entry
 						ATA_QUIRK_FIRMWARE_WARN },
 
 	/* Seagate disks with LPM issues */
+	{ "ST1000DM010-2EP102",	NULL,		ATA_QUIRK_NOLPM },
 	{ "ST2000DM008-2FR102",	NULL,		ATA_QUIRK_NOLPM },
 
 	/* drives which fail FPDMA_AA activation (some may freeze afterwards)


