Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12F951C337;
	Wed, 30 Sep 2026 18:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792725; cv=none; b=HQ9CgL1o6wwx89NdD7Tf2+BUBjHIvrdXCfcDYFQRbtUg8NLsH4fob4cx4ZNQqcL5RRpYEvRjf4oaWcha0pVqAXCi2ORb8vUODSB9rwiEtz0+Wcv+GZFyBZdzmlbTi1CVbQVmlBk6uNxCz5I9uBDkdMuzqG5sLseVg9GLrRi1nY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792725; c=relaxed/simple;
	bh=gpTVRFD7NKnEWQnKQYSfve2S9GVTHor8+tcD3u419Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Zqm0pl1hD1w7P8x2Ej52MISR6lNWD0vT6Zp9rwpwvPOvXPJBrCEIWIsigTyNV+G1QnmCuMkd+7SIsFzMRXrOVoWMVgARL2AvLAOZiBj8f1KF2Uy/IIYZKn7TaFGrwGDfu2J7u7iZMdSWo6+iFQdlnPyYmZ2lN5TnSMxsBF9Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Eyy3xVa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Eyy3xVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CC11F000FF;
	Wed, 30 Sep 2026 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792723;
	bh=4r+GRcLUP3ewuqRTn32iy9CIRqQtiRotkuzbGiatKkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Eyy3xVa79crS15tMO5FhbwEFQWipJUExJOc1fvHNL6Eil7+hf0DTGYN2Ii8jygkK
	 oiDgE3NrT3p3rA38KlXMgAb/0BQYuUuZ1qGFgyBVwCafel6zcoDiAgY4eFr/BqOTkL
	 fkZfpveickW0RO13+U4oUWZkITVzEhxi7MrnatK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.15 749/752] tools/thermal/tmon: Fix compilation warning for wrong format
Date: Wed, 30 Sep 2026 17:30:19 +0200
Message-ID: <20260930152414.422443114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


