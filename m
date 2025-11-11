Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F192FD7CA;
	Tue, 11 Nov 2025 01:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824377; cv=none; b=Zi5EQy+DgI3JwDpQeowmb9e/etnt3Zi+1faGQbOtOlTFglYamfaAwxXBpDGKK2snxjxG97YivWFAV5ZVO5udWO2IKbi+prx7vt+tMXDruCAfotji+0t6GEMWIVS72V1LWxNGeq+3ULaJDDywAGDLSOzK7GNLkZdMf6mNE9RuQCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824377; c=relaxed/simple;
	bh=gb2lo9eafL3inZ/vR5F+jbHMTdNoAQuoXvjdabHz1HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4jsQn2hOqf4pc/jhuybw+UlAF/h24daeg/DRrkQipb9dftuATbOQTL3xVVGA2L3RIJaO8dR1bMnCUmsRT268eYGOixl3KITfu7kquddntrGUNC8ejbZv/cz+Z+TL8y+kGEblogUO0cynOqzrLVTLLOhuS64SR/OF2bNt0QjpdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ae8eLELt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ae8eLELt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39206C116B1;
	Tue, 11 Nov 2025 01:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824377;
	bh=gb2lo9eafL3inZ/vR5F+jbHMTdNoAQuoXvjdabHz1HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ae8eLELtv+4YUt3FR2ctLq8TeHM8qxmuxH/Xnem8aq7Z2A0YgdkIqIcjRfLbCJFj9
	 wytLeC4AbEu1yNFahJdomY341bUMujNMNlHqM1CobzPsnaNqVhHhKxjB3ofStL6RAq
	 P3hLEwlbUZ2iYgwpjkBDRISMNlkfn0RUsMx+b4qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 483/849] drm/xe/i2c: Enable bus mastering
Date: Tue, 11 Nov 2025 09:40:53 +0900
Message-ID: <20251111004548.118828098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit fce99326c9cf5a0e57c4283a61c6b622ef5b0de8 ]

Enable bus mastering for I2C controller to support device initiated
in-band transactions.

Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250908055320.2549722-1-raag.jadav@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_i2c.c b/drivers/gpu/drm/xe/xe_i2c.c
index bc7dc2099470c..983e8e08e4739 100644
--- a/drivers/gpu/drm/xe/xe_i2c.c
+++ b/drivers/gpu/drm/xe/xe_i2c.c
@@ -245,7 +245,7 @@ void xe_i2c_pm_resume(struct xe_device *xe, bool d3cold)
 		return;
 
 	if (d3cold)
-		xe_mmio_rmw32(mmio, I2C_CONFIG_CMD, 0, PCI_COMMAND_MEMORY);
+		xe_mmio_rmw32(mmio, I2C_CONFIG_CMD, 0, PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
 
 	xe_mmio_rmw32(mmio, I2C_CONFIG_PMCSR, PCI_PM_CTRL_STATE_MASK, (__force u32)PCI_D0);
 	drm_dbg(&xe->drm, "pmcsr: 0x%08x\n", xe_mmio_read32(mmio, I2C_CONFIG_PMCSR));
-- 
2.51.0



