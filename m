Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2705D2528F7;
	Mon, 23 Jun 2025 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685805; cv=none; b=G4I3lABJaeKMesK0wYJbri7T8v2lIy/RU4HPEdb+3BFzT3vl6VH9qNwbHreQqEDt30+l56/B27ddVd3exiMhme08McWetg1q0FnBOg8fjR2giUpA1ylfRXt5eKZldPETrioehsxD0UeHbtTHsAydyMvewLSjpyfVMzh9sgF5DBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685805; c=relaxed/simple;
	bh=0owHNhFPBLS3P08uXbimrt69yarYkNN9DVbYiWMkhOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWCkrgt4VEGES98+sDPnWInYuHNQ/hOHQvesbhbDlOQ7abGWc/cf3csdZlOxzeeEJmeJHCUl1CeoLiscABeu/jo43wdsMwyccsfL89BIWGwAaz4+knqXT/1kHzc5LQqBb06DFB4Aa4GmwzFGUAy3L2MZuBA4x4CzCahqJqkBci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBbx60nL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBbx60nL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AE0C4CEEA;
	Mon, 23 Jun 2025 13:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685805;
	bh=0owHNhFPBLS3P08uXbimrt69yarYkNN9DVbYiWMkhOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBbx60nLozySd4VrsQRKZYPgXr2+qG5vR0CCVUxvAjxWAIFdwRll1de/0MCstZDu1
	 TaflG4Aq1dowmwnk1frY0SyrjtdEyMeXlpx1GOIHNA1VaWsYKeg2b4KOfq1PmhaJwp
	 mwEFWDCtZdINgQMNYqnIDruwHxQa3feHXmLEToBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 027/290] media: i2c: ds90ub913: Fix returned fmt from .set_fmt()
Date: Mon, 23 Jun 2025 15:04:48 +0200
Message-ID: <20250623130627.803263816@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit ef205273132bdc9bcfa1540eef8105475a453300 upstream.

When setting the sink pad's stream format, set_fmt accidentally changes
the returned format's code to 'outcode', while the purpose is to only
use the 'outcode' for the propagated source stream format.

Fixes: c158d0d4ff15 ("media: i2c: add DS90UB913 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub913.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ds90ub913.c
+++ b/drivers/media/i2c/ds90ub913.c
@@ -453,10 +453,10 @@ static int ub913_set_fmt(struct v4l2_sub
 	if (!fmt)
 		return -EINVAL;
 
-	format->format.code = finfo->outcode;
-
 	*fmt = format->format;
 
+	fmt->code = finfo->outcode;
+
 	return 0;
 }
 


