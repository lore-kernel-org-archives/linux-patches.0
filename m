Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033842;
	b=dTxSDeodaDCMb8GIG6eph4qyu012OURlBwB+pddxW0vm+Xv29eRqxG+3RX4PW968s6y6
	 rJnKNE7E6I4OAekuVU2GAYn6e18iO9CFx+z+pHK8FKGhFq17CdrOhst0j6z3Cgj5cSRZc
	 0v9dzscL0xq7Gzxnx0Gsvi/BFaEqDr4vpLcfIrs7W5cHsl83qmC1ygHeTrp3lJg9n+W1e
	 aVfweOq+hhg/biEFK/a6ejHwHeU0lsituc76YmnwXyJWsOr/bKyKuzaCH/iHxjdeZAaBW
	 /TFJoBFghokHjYBxWxk/Pl41rL7bOD94e4SRocv1PZjoSfjq3pKGW0dL6yxpk7yWBag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YN2UCHquedlducvOXivsvJQIZdT+sFWsMspoqe/3c5k=;
	b=urB2gryyrmO1po8+aipK34lq3znF5nCSaeZg0leHbiT0jpxEQiBB5txjZBD93vl6jDZu
	 y1zfvAUVnVH30kiLm1WJziOAjP1ricMWf+EaoB7exPTbY/lyD3oRmaZCQ67q0Ub065DNm
	 JxLDLSeanbtrb8019eqRoWsQC0xtWBo3hloO2GCeoNoZLtziVqhtEddjpyF3GvGJPsmtk
	 2NjJUUs1lYh+BgpbxswyYc7IIXRqZFHCl2MlyafKlDuM5yatXAysMt313Q0j+vlVTrhYR
	 ar52HnQiYiI8K+p0MrAT5uEABYICp0qG1j4ckBVTy/B4yjtK8yYZNgGFj8OPqgC19cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OaI6zBy/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6813606A32C;
	Wed, 18 Nov 2026 20:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaI6zBy/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FD51F000C4;
	Wed, 18 Nov 2026 20:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033842;
	bh=YN2UCHquedlducvOXivsvJQIZdT+sFWsMspoqe/3c5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaI6zBy/Ih/QdKHqbltVlqmkWZKaEGvmikziAaPknD34HIWg8ID7CV7P0vJX56J39
	 Sn4rhCEArhJ78oVHFlV0x9jF6bvCHhDBF3cCbHKmWpuCtySZualx8SC6U57LWu1xzk
	 yRHhOKCinXXl9EhNKQmvYNz3iPscPERipr6WLETY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0156/3318] net: sfp: add quirk for HORACO copper SFP+ module
Date: Wed, 18 Nov 2026 15:12:58 +0100
Message-ID: <20261118150319.229108283@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 1bb028baab541900d3603d4f93c1c0fb5aba5401 ]

Add quirk for a copper SFP+ module that identifies itself as "OEM"
"HC-10GE-113C". It uses RollBall protocol to talk to the PHY.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260719100158.874882-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 38ab35e57127c..7d0cc601a56eb 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -546,6 +546,9 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_F("YV", "SFP+ONU-XGSPON", sfp_fixup_potron),
 
+	// HORACO HC-10GE-113C uses Rollball protocol to talk to the PHY.
+	SFP_QUIRK_F("OEM", "HC-10GE-113C", sfp_fixup_rollball),
+
 	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
-- 
2.53.0



