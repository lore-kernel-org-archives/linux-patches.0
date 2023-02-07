Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9CD3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3193C433EF;
	Tue,  7 Feb 2023 13:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774848;
	bh=rMGPGMMpDdNB0kUYCRGADfBTPFd+uUAo8tksG7uoc9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVARC1+QfbcpSkahN3jT092YjO2HW5XiIZfgFFYJw9Ajsy/AJAJrhanA6wsm7kBtw
	 dvD5vpUuAIcy7VkF7yMSv6/1Tzga0P9Ad6RmlZj+WLhEihUbTodBagjrSsb9FTVAbe
	 vbqgwNs5x0KuFzzb31NlEPSg2ssXbN0NcXeFvHSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/208] drm/vc4: hdmi: make CEC adapter name unique
Date: Tue,  7 Feb 2023 13:54:38 +0100
Message-Id: <20230207125635.393502605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 51128c3f2a7c98055ea1d27e34910dc10977f618 ]

The bcm2711 has two HDMI outputs, each with their own CEC adapter.
The CEC adapter name has to be unique, but it is currently
hardcoded to "vc4" for both outputs. Change this to use the card_name
from the variant information in order to make the adapter name unique.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 15b4511a4af6 ("drm/vc4: add HDMI CEC support")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/dcf1db75-d9cc-62cc-fa12-baf1b2b3bf31@xs4all.nl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 470432c8fd70..c4b73d9dd040 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -3009,7 +3009,8 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	}
 
 	vc4_hdmi->cec_adap = cec_allocate_adapter(&vc4_hdmi_cec_adap_ops,
-						  vc4_hdmi, "vc4",
+						  vc4_hdmi,
+						  vc4_hdmi->variant->card_name,
 						  CEC_CAP_DEFAULTS |
 						  CEC_CAP_CONNECTOR_INFO, 1);
 	ret = PTR_ERR_OR_ZERO(vc4_hdmi->cec_adap);
-- 
2.39.0



