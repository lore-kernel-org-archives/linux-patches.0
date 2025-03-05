Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD27253F3C;
	Wed,  5 Mar 2025 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198702; cv=none; b=OeY5j8eG2sUj4s2lc7SeyEDYjhT6Zp1rgaknZ227Mf3Yb7FbSHbSwWPp09of6xbYav4/lVaTz/+YAd+ffLQD/C+c2sS3O/fqs5kA/qRj13OjPWluHY7symovQXt7PP1/Lu6r7NVXfsrlxobCnVdFwGMLL/R2EgbaCyJbaieAVy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198702; c=relaxed/simple;
	bh=YPMIV+rJvdueSg8vpytdqPgbxSROPcbcq9X9NO2AS6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjje03zwKXSTNFVLxF4/6Xun3sxtB+sllTpxx3MIHAIu2CQD5QaNR/AJW77rouooF1Pkm0dEnXPV8PMF8z7cGE+jGwGEaCkNNGp4/W/ZMGBeJ8/CWOQiASfU5N5ePazFjQbgF6jpur9pZ39yoYqLyCti1zGuOKg1AMAOCQqY1L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XS6dbAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XS6dbAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD83EC4CEE0;
	Wed,  5 Mar 2025 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198701;
	bh=YPMIV+rJvdueSg8vpytdqPgbxSROPcbcq9X9NO2AS6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XS6dbAQtkrj/2VpP/0J9sJ8qxlhZb1N42n2ZdCs15DsvS6+0A91OFR0SKOjIG50Y
	 o3IPdO84n7XhP+2eywIxsh2jLQpY8Yel8tlcQ/cGAQnLZgGNgRZ/y0YGGNypRi1Nvr
	 r/Rh31WuSfuLf/LbcHNbcDL6Utsy+fgafzTq4+2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 118/157] net: enetc: remove the mm_lock from the ENETC v4 driver
Date: Wed,  5 Mar 2025 18:49:14 +0100
Message-ID: <20250305174510.054981472@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit 119049b66b883c7e7e575a0b69dc6e3d211662cc upstream.

Currently, the ENETC v4 driver has not added the MAC merge layer support
in the upstream, so the mm_lock is not initialized and used, so remove
the mm_lock from the driver.

Fixes: 99100d0d9922 ("net: enetc: add preliminary support for i.MX95 ENETC PF")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-8-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -672,7 +672,6 @@ err_link_init:
 err_alloc_msix:
 err_config_si:
 err_clk_get:
-	mutex_destroy(&priv->mm_lock);
 	free_netdev(ndev);
 
 	return err;


