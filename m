Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E27E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5201C433D2;
	Sun, 22 Jan 2023 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400199;
	bh=5MX3o62En2B+Goiw/vVWGqvguUarf+3plTUX1AJcfdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCZ0qMAOEc2tSVawYc/aLn5zWE27thtE3sIOtekPx4xGreQBihEkDy8UqWZMczvJD
	 6VKz00mCWTQSVz58/KhHRNyBZTFN3h9z1t/cObsgVNfZLK9s0xZtBX/DOI6Ht9aG6+
	 GKVgY5Qe+fwlUvBh9rtN6geg5ESBWRwt9Cx00IE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.4 38/55] usb: typec: altmodes/displayport: Fix pin assignment calculation
Date: Sun, 22 Jan 2023 16:04:25 +0100
Message-Id: <20230122150223.758951368@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prashant Malani <pmalani@chromium.org>

commit 9682b41e52cc9f42f5c33caf410464392adaef04 upstream.

Commit c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin
assignment for UFP receptacles") fixed the pin assignment calculation
to take into account whether the peripheral was a plug or a receptacle.

But the "pin_assignments" sysfs logic was not updated. Address this by
using the macros introduced in the aforementioned commit in the sysfs
logic too.

Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
Cc: stable@vger.kernel.org
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230111020546.3384569-2-pmalani@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -414,9 +414,9 @@ static const char * const pin_assignment
 static u8 get_current_pin_assignments(struct dp_altmode *dp)
 {
 	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		return DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
+		return DP_CAP_PIN_ASSIGN_DFP_D(dp->alt->vdo);
 	else
-		return DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+		return DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo);
 }
 
 static ssize_t


