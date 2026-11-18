Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023084;
	b=KGNAhiONB3/AicgUYfCDXBNNSFpxFfP4Zk7uk7yNjvORryrNo9pAcUUC86TQjMw+f+3B
	 j0onmncnIfB9+rfELjzSIv00ztgK0A5Rc6ESujGW7LJjRPMIymqVOlueeYrQ2ec4YHI+8
	 JuXGpO9zjLDnyxTXtRbUMPpO5fIa6DAYDDmfITOVEuNul7f5EorsD+y5AvfvVnFA/n91u
	 eA8rqXJv6g3porRfPyvwn40aYCtOdE1a3DoSAG0FbMgxST9+8cXzNqFRadOrrSuuNuWCQ
	 3Sr5+dFxoiYgbbDrWdUrWtV39CsPUC9kBuMAKDzAWIk84sSUeLbS+Nt0IZbKlXiodyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjo/7pWK/fWZX4OXuMlc8qNpe3OF8I2dpDIGA41KeHI=;
	b=eTrGA4d4GMaw59yoDSdSDnaik3TqWDF7Jgex62UhWrUy/T9g/a/u/rMxkmzJ5TxW4PAL
	 uN4l4r9tRD6xmrMFmCJ4lhKIWdlblQXs+6zp/GkHp35WD/OIEHeUtDOummWzujTPo4oQN
	 k3YmkDBr5Svy9unL9VOpN/dAtYheUl0u3R84eHDcs5vqclyAkxJH0mU1FC3FslN7kRTl4
	 LYbHpg2m1ipuvt2zgCvm0SbVqk+vJW7CSLS1WA/GX+kudFUK3E9YKamSvTUdrJRuwzliZ
	 /V5QFbJxSvd0hGEDA8X3UNGdJieEHIIqvwyOFaOs7RTqTSCcr0AhVsMjNgIcuU2K7Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZLaPH3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC5606A325;
	Wed, 18 Nov 2026 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZLaPH3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0801F000C4;
	Wed, 18 Nov 2026 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023084;
	bh=pjo/7pWK/fWZX4OXuMlc8qNpe3OF8I2dpDIGA41KeHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZLaPH3Vc5Xvz3NYllC+2TrVVvushZXqNMUJ9U/k3Gjtj5Z764VSbp7EPt6xcJszC
	 iGc7itzGcR+IyeS0MwyMJYeABj2MEgn67djXlGwSfOKDZ1024dFJd1Z1fT5yvIuthm
	 VUISN0k6uiykamMXw8SaG/5H2KTNBEXlCL/cfOuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Faure <boris@fau.re>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0192/2151] soundwire: intel: initialise quirk_mask before reading it
Date: Wed, 18 Nov 2026 15:32:07 +0100
Message-ID: <20261118150128.774807662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Faure <boris@fau.re>

[ Upstream commit ee8a8cfe4e8d3c67456e554c988017c252710a25 ]

sdw_master_read_intel_prop() declares quirk_mask without an initialiser
and ignores the return value of fwnode_property_read_u32(). When a BIOS
does not describe "intel-quirk-mask" for a link, the property read leaves
the variable untouched and stack garbage decides whether
SDW_INTEL_QUIRK_MASK_BUS_DISABLE is honoured, so the link may be marked
hw_disabled at random.

Initialise it to 0, matching is_link_enabled() in
sound/hda/core/intel-sdw-acpi.c.
Found by code inspection, not observed at run time.

Fixes: 395713d8ca43 ("soundwire: intel: handle disabled links")
Signed-off-by: Boris Faure <boris@fau.re>
Link: https://patch.msgid.link/20260820212220.226912-1-boris@fau.re
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 347e06ad6edba..a15c79a6d68e1 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -156,7 +156,7 @@ static int sdw_master_read_intel_prop(struct sdw_bus *bus)
 	struct sdw_intel_prop *intel_prop;
 	struct fwnode_handle *link;
 	char name[32];
-	u32 quirk_mask;
+	u32 quirk_mask = 0;
 
 	/* Find master handle */
 	snprintf(name, sizeof(name),
-- 
2.53.0



