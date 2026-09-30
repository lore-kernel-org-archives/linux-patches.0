Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CA84E3245;
	Wed, 30 Sep 2026 16:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786788; cv=none; b=V5t2VkSjzm+LGa9CX8lYh6M8zDTmAcs1tTd6u7bo7MBigPXOKEEy9gQHYFZuxHna5jT2h0uJGT9uFSaBgP+VOy+/0dIQC+U9xSzGY/3UZsWVTUS9Gb/UfKVYNEe06TgYhCVEDBD1WOGFpyR0MEsRj4GLbHWbyDVI+a+EwYlAt08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786788; c=relaxed/simple;
	bh=OSpikaKBoOGPRcjxDCDsj3bCGZ2NdFYdTds26NRn04Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPWVp9nKRrWYGeP/j+JqL/JxqndoYG0czjX6PLTRVwlmaKV3QU4mG5DWZLBQiEsPLxmWmm3UaRo182WlHHHuG+DG6Vv/B0MJUt6RWLcZQeE2mzUKCKZdshRTxcQQAOcg1Ajm/hjXPWGI8YqMdmqqx15zLtRW1D7fuDMsUHp0CCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcMNGiD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcMNGiD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1491F000FF;
	Wed, 30 Sep 2026 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786787;
	bh=x7BCezNSFcayH5m8ZT0oie8i8KXYFA4GEInpcICIkoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcMNGiD//crNoDKnDwoZoBlGFcijzfZFBhoYNoLGFbWNbMovomSdo2GxWOw1HxkE7
	 y43Xz33naPnJItRjbZJ3SAxFLpBbpbeSbBhtTALt9nKqz7ftHB4aIV00GSE2+MajTz
	 6txqtbrwYREYgqHYpdK31KAzgUTbSn2K/u8skG7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 978/982] tools/thermal/tmon: Fix compilation warning for wrong format
Date: Wed, 30 Sep 2026 17:28:34 +0200
Message-ID: <20260930152437.750820073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Eckert <fe@dev.tdt.de>

commit 9da39ef332c417ce52732564c1c682a6e1209302 upstream.

The following warnings are shown during compilation:

tui.c: In function 'show_cooling_device':
 tui.c:216:40: warning: format '%d' expects argument of type 'int', but
argument 7 has type 'long unsigned int' [-Wformat=]
   216 |                         "%02d %12.12s%6d %6d",
       |                                      ~~^
       |                                        |
       |                                        int
       |                                      %6ld
 ......
   219 |                         ptdata.cdi[j].cur_state,
       |                         ~~~~~~~~~~~~~~~~~~~~~~~
       |                                      |
       |                                      long unsigned int
 tui.c:216:44: warning: format '%d' expects argument of type 'int', but
argument 8 has type 'long unsigned int' [-Wformat=]
   216 |                         "%02d %12.12s%6d %6d",
       |                                          ~~^
       |                                            |
       |                                            int
       |                                          %6ld
 ......
   220 |                         ptdata.cdi[j].max_state);
       |                         ~~~~~~~~~~~~~~~~~~~~~~~
       |                                      |
       |                                      long unsigned int

To fix this, the correct string format must be used for printing.

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20231204141335.2798194-1-fe@dev.tdt.de
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/thermal/tmon/tui.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/thermal/tmon/tui.c
+++ b/tools/thermal/tmon/tui.c
@@ -213,7 +213,7 @@ void show_cooling_device(void)
 		 * cooling device instances. skip unused idr.
 		 */
 		mvwprintw(cooling_device_window, j + 2, 1,
-			"%02d %12.12s%6d %6d",
+			"%02d %12.12s%6lu %6lu",
 			ptdata.cdi[j].instance,
 			ptdata.cdi[j].type,
 			ptdata.cdi[j].cur_state,


