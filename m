Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11271C4A24;
	Mon, 10 Mar 2025 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629479; cv=none; b=bVJmIVjAmRQifaJkrwVc2ojQTv3qgxki3Hjg9LgsaNN8DHvxvZB6nIGs4qHwUg2v0o/WHGmv22lTYyMvSluJOCSp39N5xrW3JSXDqS8sHYFSzMU96hszuvIDmAX5H3axnAr41aZ11/qSvdohPCiTGytsXTF+UBJX1/NsUlem9nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629479; c=relaxed/simple;
	bh=sG6hS+GbQAn4bEAnW1DQAjoI7YIFy35Akr31K+Qc7Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5uG+GkE7pBfhvJUHQ1AU9FHfxH5LZS6d/Jf8dfLzSqfkHNe6eiqqE41h/imFyCJaQVthJzKGiC9uc+5mtxWDf0nKzqQGbbiMzlKpT+d0TVxLkIiVM+mErpsdMQH7SHPeWCsxvZ5rDpFul5vj61FNqKB6xGy8Lkns9vN/SakmYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usJu+w2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usJu+w2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD98C4CEE5;
	Mon, 10 Mar 2025 17:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629478;
	bh=sG6hS+GbQAn4bEAnW1DQAjoI7YIFy35Akr31K+Qc7Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usJu+w2opovaQoqwsFkuAwoyzqO++dw61jxuaBO4z944IbkSXfEikJet1Bd/E1sv8
	 lMbBOtBikqoMi415PnPd7FemvctKMpbBhMKhnVde1mkiX2WtP8eZZACmTekaGJFI4o
	 h+0ug5/WsNUGgyhgk1YhiOSK50br993HX7ppR3Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 308/620] media: ov5640: fix get_light_freq on auto
Date: Mon, 10 Mar 2025 18:02:34 +0100
Message-ID: <20250310170557.775931717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Bobrowicz <sam@elite-embedded.com>

commit 001d3753538d26ddcbef011f5643cfff58a7f672 upstream.

Light frequency was not properly returned when in auto
mode and the detected frequency was 60Hz.

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5640.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1406,6 +1406,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


