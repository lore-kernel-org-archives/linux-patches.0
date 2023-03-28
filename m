Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373B68BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABCFC4339B;
	Tue, 28 Mar 2023 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016131;
	bh=MA/BiwKsbizVCW16gqZq+/AU1RDDZ1Trv9N6royqNvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3Fka1oV/fc3MG+mLKg9tVM2H4wvfeCk6KENmgE8VusFjnb/Vf/bnmx0gAzyWxpxy
	 lOt+EAyDiB/SypYblaP4JN40hGgJniH0BjsZfKLMppuJK2DGojcAPYJpIgTloVrJCN
	 V4iVMX8HwsSBrR5o4R+6jGd/B28/l8sxofv2mCFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 077/146] thunderbolt: Call tb_check_quirks() after initializing adapters
Date: Tue, 28 Mar 2023 16:42:46 +0200
Message-Id: <20230328142605.914471683@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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
@@ -2750,8 +2750,6 @@ int tb_switch_add(struct tb_switch *sw)
 		}
 		tb_sw_dbg(sw, "uid: %#llx\n", sw->uid);
 
-		tb_check_quirks(sw);
-
 		ret = tb_switch_set_uuid(sw);
 		if (ret) {
 			dev_err(&sw->dev, "failed to set UUID\n");
@@ -2770,6 +2768,8 @@ int tb_switch_add(struct tb_switch *sw)
 			}
 		}
 
+		tb_check_quirks(sw);
+
 		tb_switch_default_link_ports(sw);
 
 		ret = tb_switch_update_link_attributes(sw);


