Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2793E26B087;
	Thu, 13 Feb 2025 15:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460860; cv=none; b=GHMDrShU8G8dvSW+p2iN2D6xG1XE2HxLj8JjYANmgQylBsdizOPy/LBMf5jvkssCZ8MCVyddR4Eh2ft81EBe9xT2O4M+snZTGrs+F1mnea4+SHl2dZmeiJ3JUuUxFjcmUgca8nZ8DEebXRNAaz4f++7QftKkZQd1hTr9TzqGwbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460860; c=relaxed/simple;
	bh=YxvYPvyya/oy1JBBqEVflm6C+NzgwSC9LpkrbNWZHAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2W3KV1N6vQf8F5sQeiImShqB7TYPw3PR8uTzcLM0eUZ2Ehi8WRh/XtqIV0brRdnb834h+gwWGM2lvgGnu1FH+Y38Ava4O7CebgA2sRdF7kXhMln+mz2N27NVYfhU4/Fk6iGvo4Bjw93xUsHoHswjm6E6t2ymIDlFTDCMCrE0Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svubSovI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svubSovI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89268C4CEE4;
	Thu, 13 Feb 2025 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460860;
	bh=YxvYPvyya/oy1JBBqEVflm6C+NzgwSC9LpkrbNWZHAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svubSovI6lX4ebkMY6SsH+eGdhVaAWHltiL/7HSyLEPOXHgspH+k4WkfufsFne/jM
	 5MjWCPe7VhCBmGNrt1uxBp9Pcd+u/1EdzJ7u+/XrHel5SLgpUDmOXY57qXNimsKQxI
	 L5tllHeoB1bMHf4G4T5TBgEqqL+04Uf2/kqdxeHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 206/273] media: ov5640: fix get_light_freq on auto
Date: Thu, 13 Feb 2025 15:29:38 +0100
Message-ID: <20250213142415.464216876@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
@@ -1982,6 +1982,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


