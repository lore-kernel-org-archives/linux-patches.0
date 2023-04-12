Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEBB2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1705CC433D2;
	Wed, 12 Apr 2023 08:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289003;
	bh=YQnNQt7CxdHc4JbsKj8GZDSEirSM6ocPn87ivi1fzSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOuqE2HGZBZryC/GLnVZ2sQAP6gUxOnO7KeAvr/dqX4Zsxfvdve5+DA3ieVE9a2Jq
	 3Vxhi0DFarslTxDyyWkKNxQqU8PT9VjRTO0R+8nx0ADn75iUzkfAR/oz4FoNsKmNeD
	 CPqyAQSlz68rVvVBN/d3Gu1HTDNig34Q3QlZQDTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 6.1 099/164] counter: 104-quad-8: Fix Synapse action reported for Index signals
Date: Wed, 12 Apr 2023 10:33:41 +0200
Message-Id: <20230412082840.860469130@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Breathitt Gray <william.gray@linaro.org>

commit 00f4bc5184c19cb33f468f1ea409d70d19f8f502 upstream.

Signal 16 and higher represent the device's Index lines. The
priv->preset_enable array holds the device configuration for these Index
lines. The preset_enable configuration is active low on the device, so
invert the conditional check in quad8_action_read() to properly handle
the logical state of preset_enable.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230316203426.224745-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/104-quad-8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -368,7 +368,7 @@ static int quad8_action_read(struct coun
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
-		if (priv->preset_enable[count->id])
+		if (!priv->preset_enable[count->id])
 			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
 			*action = COUNTER_SYNAPSE_ACTION_NONE;


