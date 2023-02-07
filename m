Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9440A2C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEB8C433EF;
	Tue,  7 Feb 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775452;
	bh=FxBU7vErTeNHAohOXWl9BD2RiOQuUY5rggdj3gXBc5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyR0XYzEKfSk8ls0aoFCsIH39+Ix8t1zKtEjG8CN+6epr3t0WOmcfNs7UlciHZnXP
	 inDhTK5mlVJyEHsJEnYvBRfVSeSnTiDR4ZU/oTbxxUSatFoNV7bjtVqJgX9Subc+n0
	 EEkyrDKNb0t/WGeIRYqABVWRXvaPJFkU/+9uYtHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/120] drm/vc4: hdmi: make CEC adapter name unique
Date: Tue,  7 Feb 2023 13:56:26 +0100
Message-Id: <20230207125619.403223495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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
index 9b3e642a08e1..665f772f9ffc 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1854,7 +1854,8 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
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



