Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C873168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A0FC433EF;
	Mon,  8 May 2023 10:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543131;
	bh=pGb6w6HtaXDEx24a+2DlEuJmROdO44tRP8LP0Vi4lNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4OoGyXRhk8czcx1ts0ItT5Z6DA8HZlo1dpfS1KGJXT+pS0q7orjpIc3sN1a/nQPG
	 QFAXO61TEBJOdE6eBwvt63oRsjNAnzDoT3BoE94ZMuzZM9orkwHiskOWGduwlclbOY
	 kKLrJKLm91dSNHwKQCHxEoxflnF9DOBzmR5FnbUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.2 657/663] thunderbolt: Use correct type in tb_port_is_clx_enabled() prototype
Date: Mon,  8 May 2023 11:48:03 +0200
Message-Id: <20230508094451.484827035@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit d31137619776f9c173a46a79bc7733a2b106061f upstream.

tb_port_is_clx_enabled() generates a valid warning with gcc-13:
  drivers/thunderbolt/switch.c:1286:6: error: conflicting types for 'tb_port_is_clx_enabled' due to enum/integer mismatch; have 'bool(struct tb_port *, unsigned int)' ...
  drivers/thunderbolt/tb.h:1050:6: note: previous declaration of 'tb_port_is_clx_enabled' with type 'bool(struct tb_port *, enum tb_clx)' ...

I.e. the type of the 2nd parameter of tb_port_is_clx_enabled() in the
declaration is unsigned int, while the definition spells enum tb_clx.
Synchronize them to the former as the parameter is in fact a mask of the
enum values.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1058,7 +1058,7 @@ void tb_port_lane_bonding_disable(struct
 int tb_port_wait_for_link_width(struct tb_port *port, int width,
 				int timeout_msec);
 int tb_port_update_credits(struct tb_port *port);
-bool tb_port_is_clx_enabled(struct tb_port *port, enum tb_clx clx);
+bool tb_port_is_clx_enabled(struct tb_port *port, unsigned int clx);
 
 int tb_switch_find_vse_cap(struct tb_switch *sw, enum tb_switch_vse_cap vsec);
 int tb_switch_find_cap(struct tb_switch *sw, enum tb_switch_cap cap);


