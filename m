Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5EF15E8B;
	Mon, 30 Dec 2024 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574307; cv=none; b=bkWt+AR9fOG3kuFvGRq4/NILgbyZ7LS9n+FjYmRk2lvD138Aq13KSbkbzFr19np05PDWpoZ3JiSwwgEzmsHGxekJOpp9xDPSpGAaZ38oqvL3+AWtsZJBfz+nG06DyvlCmjmH17v1DWqssnsBvWfnD/ns4hps1/sRZnWz/a0vLJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574307; c=relaxed/simple;
	bh=I4Rbn5swhUPgq8mCuC1201iihaCZKB3pbEaFcrp4tk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awZdt03KmKh54DTAJ4RrTZKyBysRh+YsSg38nEkYnKYBWwcQEp/KbuZFYXFx6bkXu4zPSVYyCpAYM/409HYOiila5fNyfYk/bF3SRGFK7I4DEIkiPQWwRcVFcayCENQNswCQPXWHYFfaP+O4TnLCGZ17yLOFMu57rjvhdW+Aeio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04vWWxGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04vWWxGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E0CC4CED0;
	Mon, 30 Dec 2024 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574307;
	bh=I4Rbn5swhUPgq8mCuC1201iihaCZKB3pbEaFcrp4tk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04vWWxGTmDfPPt6TgNMzl68vYJmlPanpWzywVA5ibJc1gJy9x7WNrgx6zHf+4XIje
	 qJFkAfnwyOpJdxoz0yP3ZUQrP1nvo2HegrJBx6faWGNwCyk85LoVjyx8OGriPDDfM6
	 SeVcq1koxq7/z4Y3t/J6o5rA6Dit4G+acoIwi4DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Koch <linrunner@gmx.net>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 098/114] power: supply: cros_charge-control: allow start_threshold == end_threshold
Date: Mon, 30 Dec 2024 16:43:35 +0100
Message-ID: <20241230154221.888786344@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit e65a1b7fad0e112573eea7d64d4ab4fc513b8695 upstream.

Allow setting the start and stop thresholds to the same value.
There is no reason to disallow it.

Suggested-by: Thomas Koch <linrunner@gmx.net>
Fixes: c6ed48ef5259 ("power: supply: add ChromeOS EC based charge control driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20241208-cros_charge-control-v2-v1-2-8d168d0f08a3@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_charge-control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/cros_charge-control.c b/drivers/power/supply/cros_charge-control.c
index 58ca6d9ed613..108b121db442 100644
--- a/drivers/power/supply/cros_charge-control.c
+++ b/drivers/power/supply/cros_charge-control.c
@@ -139,11 +139,11 @@ static ssize_t cros_chctl_store_threshold(struct device *dev, struct cros_chctl_
 		return -EINVAL;
 
 	if (is_end_threshold) {
-		if (val <= priv->current_start_threshold)
+		if (val < priv->current_start_threshold)
 			return -EINVAL;
 		priv->current_end_threshold = val;
 	} else {
-		if (val >= priv->current_end_threshold)
+		if (val > priv->current_end_threshold)
 			return -EINVAL;
 		priv->current_start_threshold = val;
 	}
-- 
2.47.1



