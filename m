Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EDB8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E759C433EF;
	Tue, 28 Mar 2023 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014971;
	bh=6533pZA8P+3NraJqqN7msuAhzPQsnUM19RaSYFVyKUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6HGbJyaCKL3/B4tIK0NPNQNHgllDI+4ug0YXN2MaMjPLNQFaeSafOg7r+ObSpD+d
	 yG34RYrZ8LfLEm0tEUr8zYAjnPMFgG4/voZN0HflH4D8IkMC1hw3YdV+dSHDDCgdkq
	 zYD9erdYuZvYvL0Q65FoP3idp9kXLZuWgPotpOis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 119/240] thunderbolt: Call tb_check_quirks() after initializing adapters
Date: Tue, 28 Mar 2023 16:41:22 +0200
Message-Id: <20230328142624.741474656@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit d2d6ddf188f609861489d5d188d545856a3ed399 upstream.

In order to apply quirks based on certain adapter types move call to
tb_check_quirks() happen after the adapters are initialized. This should
not affect the existing quirks.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2960,8 +2960,6 @@ int tb_switch_add(struct tb_switch *sw)
 			dev_warn(&sw->dev, "reading DROM failed: %d\n", ret);
 		tb_sw_dbg(sw, "uid: %#llx\n", sw->uid);
 
-		tb_check_quirks(sw);
-
 		ret = tb_switch_set_uuid(sw);
 		if (ret) {
 			dev_err(&sw->dev, "failed to set UUID\n");
@@ -2980,6 +2978,8 @@ int tb_switch_add(struct tb_switch *sw)
 			}
 		}
 
+		tb_check_quirks(sw);
+
 		tb_switch_default_link_ports(sw);
 
 		ret = tb_switch_update_link_attributes(sw);


