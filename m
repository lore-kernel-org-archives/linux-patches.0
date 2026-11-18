Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015986;
	b=S6QB9KqF4fMkloKhxZHTf6cHQ2YeL+uOgmLo1sRLFKFyc0FG0N9F+Kw0n6MlvZC+jz1+
	 jDjWnk9wuf9qakCxXV4MGe19v72OMDTdK8E0J22TrxuWDhD/lLG+eKM16UOHHnGQRXUzZ
	 JuXQ8wpon/IuFk9RdcML7D+8FfxgZSv863DMyPot7Vd3WboQk4jQQJZgJQZu/QWiD/XSj
	 4MymxF+Ts+2s5IV1tLbpzHLr14wTWopWcQnYkKj7AU9ZKNFSFuAgxmVLV9eVl4LgesiUr
	 g9H3yBuUxTbIALLKawzIOAEaZlmKrkxWKYj2o7yqHZHidwpp3EuyS/57JzXobzPDNgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XcQDZeDThpdF6F9cQlKbtvXXSFdMLbyI1KILEMFF3ao=;
	b=3Z+ZZu/AxwNG8VuAaQsd+3R8I4QBHlBLDWotoujFUUyvAbkkk3ShXHZyWQgpkkjWsmiY
	 YTi0rNTM5Uz6hrMJHqDWIYs+EU3WIoa1haJHG/ruLrBjVoj0lfGdvMeBrg9AV0cak3ioZ
	 KcdJUV8wT3f1WdBuKYDr3l6o6MflJcZb8K+hCP7KG7Ldtzbl8UVnmIjrXVfiQt/jS8VUo
	 y3vKZ/i79OoH3QtaSO8V4797ascZAij6spMcwqmGDBdXYQ8LucTOqeuRvyjq4X6/OiV+7
	 A0cGvdzj/JBeGDSlrsahIqRQkg8dRRhI++GHRNGmIUbxLdYjlPL+kP9WMpiRLRxZW2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Mbu/Tug9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A9606A32F;
	Wed, 18 Nov 2026 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mbu/Tug9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C851F000C4;
	Wed, 18 Nov 2026 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015985;
	bh=XcQDZeDThpdF6F9cQlKbtvXXSFdMLbyI1KILEMFF3ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mbu/Tug9IgqvB1pyJBhgf0Gd7nN0lDI/q/ZcVFDez70ne//j2PbXrgmaKXBlEGZTK
	 iL4T4rFg+xwbNjX2En2jxWc8sHfeE/S8m5OyVgyDeflz0f/ed/MeWdbMLTAwyEmvK1
	 mlgu6fPtuyczoy0bSzgNYoUvi2yW6qqx0pjyc7BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Roland Dreier <rolanddreier@rivian.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0367/2651] firmware: arm_scmi: Fix error path leak in scmi_raw_message_send()
Date: Wed, 18 Nov 2026 15:26:47 +0100
Message-ID: <20261118150301.048024465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <rolanddreier@rivian.com>

[ Upstream commit 1adabdce41b93ee6f72f29daa1d3e1750e7b7bd1 ]

When the is_transport_polling_capable() check fails in scmi_raw_message_send(),
it returns -EINVAL without doing scmi_xfer_raw_put(), which will leak a
struct scmi_xfer.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260909-scmi-async-done-race-v2-0-cc5dec25c6be%40rivian.com
Fixes: 07cb8c324b63 ("firmware: arm_scmi: Add polling support to raw mode")
Signed-off-by: Roland Dreier <rolanddreier@rivian.com>
Link: https://patch.msgid.link/20260909-scmi-raw-v1-1-de3fa75d2c6f@rivian.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/raw_mode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_scmi/raw_mode.c b/drivers/firmware/arm_scmi/raw_mode.c
index 5ee21f6b70015..f01bf2f6ce1d4 100644
--- a/drivers/firmware/arm_scmi/raw_mode.c
+++ b/drivers/firmware/arm_scmi/raw_mode.c
@@ -711,6 +711,7 @@ static int scmi_raw_message_send(struct scmi_raw_mode_info *raw,
 		} else {
 			dev_err(raw->handle->dev,
 				"Failed to send RAW message - Polling NOT supported\n");
+			scmi_xfer_raw_put(raw->handle, xfer);
 			return -EINVAL;
 		}
 	}
-- 
2.53.0



