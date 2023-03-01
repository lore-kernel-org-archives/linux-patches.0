Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA834847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD6C433D2;
	Wed,  1 Mar 2023 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694143;
	bh=xRh/FOD4tGPXjQEIre6S1WqHlFAghzVKukTGpi4bKDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqdmI8rflF7EnQwBAH3mpn7uKHeWe9BMG+DuPjrzSj1tquezpanpAhrQ3N8xc6drj
	 ycZWPN4M1VCY8Q3njbn52zft7x5viwVypSpWiN7bungx/GzG/zDi1AkJZLQliqKv0y
	 H8cOQrX85rxomcckbqtjT9r2lf4ypvGBQVss/Xz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rajaram Regupathy <rajaram.regupathy@intel.com>,
	Saranya Gopal <saranya.gopal@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.2 15/16] usb: typec: pd: Remove usb_suspend_supported sysfs from sink PDO
Date: Wed,  1 Mar 2023 19:07:51 +0100
Message-Id: <20230301180653.871453119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saranya Gopal <saranya.gopal@intel.com>

commit e4e7b2dc27c4bb877d850eaff69d41410b2f4237 upstream.

As per USB PD specification, 28th bit of fixed supply sink PDO
represents "higher capability" attribute and not "usb suspend
supported" attribute. So, this patch removes the usb_suspend_supported
attribute from sink PDO.

Fixes: 662a60102c12 ("usb: typec: Separate USB Power Delivery from USB Type-C")
Cc: stable <stable@kernel.org>
Reported-by: Rajaram Regupathy <rajaram.regupathy@intel.com>
Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230214114543.205103-1-saranya.gopal@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/pd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/typec/pd.c
+++ b/drivers/usb/typec/pd.c
@@ -161,7 +161,6 @@ static struct device_type source_fixed_s
 
 static struct attribute *sink_fixed_supply_attrs[] = {
 	&dev_attr_dual_role_power.attr,
-	&dev_attr_usb_suspend_supported.attr,
 	&dev_attr_unconstrained_power.attr,
 	&dev_attr_usb_communication_capable.attr,
 	&dev_attr_dual_role_data.attr,


