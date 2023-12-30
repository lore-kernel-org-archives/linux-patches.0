Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D858473;
	Sat, 30 Dec 2023 12:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCD/PtoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB82C433C8;
	Sat, 30 Dec 2023 12:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937919;
	bh=KnN0ICKvT3I4Aeu2T4eOmw0xns58uTcmhef2Q9GQghA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCD/PtoEq6dM80Lai3tgviShwrwehCeSO+1cIT24N7r0MC4HbXTpiV/NuIX7QRWsR
	 iyUFLOWdT8RpnDX/ff59yVKT5HkgTXQo8HFYgQB9jPBtYKpVJNPK9+JOQrIArbuaSk
	 hivfkQmuPO9PDfb//nYt8T9VRp724ol0KSdOyhjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 114/156] usb: typec: ucsi: fix gpio-based orientation detection
Date: Sat, 30 Dec 2023 11:59:28 +0000
Message-ID: <20231230115816.085996152@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit c994cb596bf7ef5928f06331c76f46e071b16f09 upstream.

Fix the recently added connector sanity check which was off by one and
prevented orientation notifications from being handled correctly for the
second port when using GPIOs to determine orientation.

Fixes: c6165ed2f425 ("usb: ucsi: glink: use the connector orientation GPIO to provide switch events")
Cc: stable <stable@kernel.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20231208123603.29957-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_glink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_glink.c
+++ b/drivers/usb/typec/ucsi/ucsi_glink.c
@@ -228,7 +228,7 @@ static void pmic_glink_ucsi_notify(struc
 
 	con_num = UCSI_CCI_CONNECTOR(cci);
 	if (con_num) {
-		if (con_num < PMIC_GLINK_MAX_PORTS &&
+		if (con_num <= PMIC_GLINK_MAX_PORTS &&
 		    ucsi->port_orientation[con_num - 1]) {
 			int orientation = gpiod_get_value(ucsi->port_orientation[con_num - 1]);
 


