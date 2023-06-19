Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C9A8BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0765FC433C8;
	Mon, 19 Jun 2023 10:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171660;
	bh=hUtoEXZDlmJzh4XGBA977ve4bjEXQo4VZVWNtydMkAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQL7n1M8WkBg5D/seAzPdNvGJ/sFrsKbvUKv3tZWPHeBdwqzdiQLN89OAQO1Wmc+Q
	 Q0/c2xpBV6XxGvZ7UJTqp3NUi2U4VWJ180wHswNg0jQjmGNhPz3wvtvgQ6w5OZEYkD
	 kyqeQeyr9ZKET03M/gA3aea2Y+3PmQxjB9SSn5kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	Pavan Holla <pholla@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 084/166] usb: typec: Fix fast_role_swap_current show function
Date: Mon, 19 Jun 2023 12:29:21 +0200
Message-ID: <20230619102158.879576517@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavan Holla <pholla@chromium.org>

commit 92c9c3baad6b1fd584fbabeaa4756f9b77926cb5 upstream.

The current implementation mistakenly performs a & operation on
the output of sysfs_emit. This patch performs the & operation before
calling sysfs_emit.

Fixes: 662a60102c12 ("usb: typec: Separate USB Power Delivery from USB Type-C")
Cc: stable <stable@kernel.org>
Reported-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Pavan Holla <pholla@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Message-ID: <20230607193328.3359487-1-pholla@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/pd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/pd.c
+++ b/drivers/usb/typec/pd.c
@@ -89,7 +89,7 @@ peak_current_show(struct device *dev, st
 static ssize_t
 fast_role_swap_current_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%u\n", to_pdo(dev)->pdo >> PDO_FIXED_FRS_CURR_SHIFT) & 3;
+	return sysfs_emit(buf, "%u\n", (to_pdo(dev)->pdo >> PDO_FIXED_FRS_CURR_SHIFT) & 3);
 }
 static DEVICE_ATTR_RO(fast_role_swap_current);
 


