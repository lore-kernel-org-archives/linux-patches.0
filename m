Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039252;
	b=JNKhCcU11iGFOaVu6/d8eKFnj1rlhiFZzlmuYaHvHtMBHXEOELHZHfVpJ/XbiUIORSqR
	 iFxEnOdIw/CyxI4xDj2yIau/zpczKy+hJoDtRDQfIhj+LzHw3/2PR1zoMclzHlsx/jOx2
	 WtcyObXdD5ZQB10rk9JmgZjCa002gr+jDsBKg4sG/0YTjJ57d9jbEV4sil0pv+C+4R7g+
	 LInFRk8nqeQaKm4QApNo0qFcXsITmvVeiqrEGgm8ys9+zzXwcBfx3uTorM4AY0uXMudv+
	 wUlOKrKag8ezo6wiri/TFcbe0R0fP1ANBGqcx6/QVBIiiEWDLeQm2ZiAAvFkY9Kiy+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDz5NT313nRNLbxPuJla5VsRd5vNu2Q0CV97bJZuN+w=;
	b=p6bkg+ZmlLED9R5axXZDgyrqd7IN9XxBjHuz6mMP9CpBsH8wXgAsCCyGoE/jDbKpmNFV
	 I4r0uVewhfVVFfEprq+6BXNvqGjR9ITkTVRMrIah7BErWkQ/LL1OZ6MHc4LPaSABq/7ah
	 0QJzXa3TgJTT+a3RpaPmeqOqMeB9m/V3nhV/uFOfnQZSlZAqxwRTNfRkT7twNQOJOTUwS
	 fAnDQFPwikUP4x4udEt6BCIf/4Mq8gizhc1uDW7a3eUfnjYfAOYZ5ovpCbUspXMxYqm7Y
	 xFdgxsbvPI7VS/Cuee8AD7rFUO++SyC2+djrsYIEGu9zjOfhwFKwIqDZvBABwUpmagQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL7kljns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5EA606A320;
	Wed, 18 Nov 2026 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL7kljns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2646F1F000C4;
	Wed, 18 Nov 2026 22:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039252;
	bh=mDz5NT313nRNLbxPuJla5VsRd5vNu2Q0CV97bJZuN+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL7kljnstFphCZ9jfp5wvrDZAFwCEa2WgxNSrxgyOPaVODQ2j2QG6VDSN7TTJ/c+R
	 6Q/41XIdqtP2vzJRoi6ZP0PLVKQOlN9v7mxYJ/XOvByI2L7mSmLSJleJX+HVl6qFFe
	 xJegjecJVvKsSjcwZ3h8quoAsyTDyzuCGHuh6hDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Faure <boris@fau.re>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2034/3318] soundwire: intel: initialise quirk_mask before reading it
Date: Wed, 18 Nov 2026 15:44:16 +0100
Message-ID: <20261118150423.064188200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bdfff78ac2f81..d5d0a4c4ae145 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -124,7 +124,7 @@ static int sdw_master_read_intel_prop(struct sdw_bus *bus)
 	struct sdw_master_prop *prop = &bus->prop;
 	struct fwnode_handle *link;
 	char name[32];
-	u32 quirk_mask;
+	u32 quirk_mask = 0;
 
 	/* Find master handle */
 	snprintf(name, sizeof(name),
-- 
2.53.0



