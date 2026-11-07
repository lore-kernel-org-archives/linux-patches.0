Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064132;
	b=LE/8PK3FPH8cdvLrEjjIHX4ChWbJGnx+ZYq1TNmhsLPjCr2TjIC/44Pn4m/Q8PXP4dlk
	 fKGp9QLQ3rH3Gx9kXLi98piLQAuqJ0uJOGiORlPxVYvnKKKyDbJLbAbFfzKLMV64VZX23
	 QBivxlJBTfFtxWKcXxVqgOUDuLszn1MRDFF9BywJsn6yHgSmooblUfG8kGZyGEpGDa5rq
	 X6b13L4Qhcm6Tw6wH3QMnHqJgUTLazNo3/NVwhQydwodJocyNg6QXEbJ12fVmtY5JnVfZ
	 DHJUotpTZqnK7bUeNtM01b/USzJ9hgae9H3j9E7z9Z8BdNO/P/gk1CHj62AJcOl6srA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i1XGpSEvWUuSQ+k3UPvqd40NF6RtcErN3vSzXo1xL8c=;
	b=ZNZpiJppNnpYLgcnFDpI9v/q/yqYA1aAVu6uFYyNXAybI0WdatqX2mgnpUo+rA3DV6KY
	 iwmki4pRVE9HpTyXOlcZyrCTaR8mcgopJWNnIJqghEURXC5rIDmk51o9AWg8gamwoHM6Q
	 LPYKpqlyNaTsWjtMMIX+1B5sOpTIjsuGqcawDGvNTqswew05hVk7q81VqiB0Spp6hSvDM
	 7d5O1672x1T2/nkrijS+s5DU2lW0RAdAgCJjOb8IVvl5rQqvnwJhHt/kI7u+cma6pux+L
	 G+3NPpBCadPVuZX/hk8ISHdwHgfN9oMXipIDk3IjQjQh2rsHT3JMZA8nMNkIuQ/qlFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09BWQw8B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8651606A33B;
	Sat,  7 Nov 2026 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09BWQw8B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD771F0089F;
	Sat,  7 Nov 2026 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064131;
	bh=i1XGpSEvWUuSQ+k3UPvqd40NF6RtcErN3vSzXo1xL8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09BWQw8Bn/rUtwLwAlYFiTG+96mj0BxXd02OTg6BO00iz4iDIKYkbIZs3ooEMQWoM
	 n5RY5kop3AQhskamnwZ0JgVWbYrqhy78faF7OkeVnhYKSx9MRVCKh2PHtmghleNs1L
	 2qG5UMnw/39g9Gafi8UV83bDeKezorhinGA6XHQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0283/1257] mfd: Fix MAX77705 dependency on regmap
Date: Sat,  7 Nov 2026 08:42:59 -0500
Message-ID: <20261107134947.292447136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 2fdae2d590a0a5ad4cd60bf8e7a6ecba7265f268 ]

The max77705 uses devm_regmap_add_irq_chip(), so add REGMAP_IRQ
and REGMAP_I2C to what the core driver selects in order to provide
these APIs.
This fixes a build error:

drivers/mfd/max77705.o: in function `max77705_i2c_probe':
max77705.c:(.text+0x250): undefined reference to `devm_regmap_add_irq_chip'

Cc: stable@vger.kernel.org
Fixes: c8d50f029748 ("mfd: Add new driver for MAX77705 PMIC")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260827-deps-reg-max77705-v1-1-c83a74d3d428@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e4fd4572472f9..857ca3bb0d5bf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1006,6 +1006,8 @@ config MFD_MAX77705
 	depends on I2C
 	select MFD_CORE
 	select MFD_SIMPLE_MFD_I2C
+	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	  Say yes here to add support for Maxim Integrated MAX77705 PMIC.
 	  This is a Power Management IC with Charger, safe LDOs, Flash, Haptic
-- 
2.53.0



