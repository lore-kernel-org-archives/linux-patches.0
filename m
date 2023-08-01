Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDF81FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5937C433C8;
	Tue,  1 Aug 2023 09:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883310;
	bh=6nDTA5dSPRFhD+LRx17yxe+1axQfS9QwS/DF8h6+PUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+vsi7MVtukeHzXB+r4MIREViwIum0BXSyPQgLJnoEmn6KyaPNFWSWG3JstX9z8rn
	 wUzCtg0mmjcbxn4RIKtYnc2Dp9HcLGjASYPCljqrxqMsU6jMZsrO9eZuAyD1mVccz6
	 nhJvCDlY6n+fSzNKzkFSCwuhXi7cjRJAqRJj0m8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.4 161/239] usb: typec: Use sysfs_emit_at when concatenating the string
Date: Tue,  1 Aug 2023 11:20:25 +0200
Message-ID: <20230801091931.432511949@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyle Tso <kyletso@google.com>

commit 609fded3f91972ada551c141c5d04a71704f8967 upstream.

The buffer address used in sysfs_emit should be aligned to PAGE_SIZE.
Use sysfs_emit_at instead to offset the buffer.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230623151036.3955013-4-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1288,9 +1288,9 @@ static ssize_t select_usb_power_delivery
 
 	for (i = 0; pds[i]; i++) {
 		if (pds[i] == port->pd)
-			ret += sysfs_emit(buf + ret, "[%s] ", dev_name(&pds[i]->dev));
+			ret += sysfs_emit_at(buf, ret, "[%s] ", dev_name(&pds[i]->dev));
 		else
-			ret += sysfs_emit(buf + ret, "%s ", dev_name(&pds[i]->dev));
+			ret += sysfs_emit_at(buf, ret, "%s ", dev_name(&pds[i]->dev));
 	}
 
 	buf[ret - 1] = '\n';


