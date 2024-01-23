Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9914B1FC4;
	Tue, 23 Jan 2024 02:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975773; cv=none; b=o7AwOu4LDvdVvwiWU2dvBbGR8e9MWAtmyi3kcDvBEmbnxvUPjAlFJr7iTLO07PLDX65snXLdKCNqY+C4NYuJb4MfUOfUeJApT8zygBlyR22pviXInxnWLKCcMD3BaKOpXwypidUL56wPNGb+okiAZM6AY4CfrY3/AK2RSJ53Ft4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975773; c=relaxed/simple;
	bh=FXqnlaYO4vO2kEOK8emK31Zf2astjsV73igkzwEecEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APzIOMNEqrLUuYRgPLDwDKI99g8uGPFRVN73fz66qXs6VLkTA8kOE5Tar/LrZOcTH3lA6ZPOkLEws3hNvGPRZLNLAONsiwi8X3gyX62yF/s3xQ2GSfyJ3PcuHFM/BtNm/3O/jClbG8XyPSVrFwvN1VTkmeUF7A5PwNwG2pGEn/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joQ/PV6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joQ/PV6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A667C433C7;
	Tue, 23 Jan 2024 02:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975773;
	bh=FXqnlaYO4vO2kEOK8emK31Zf2astjsV73igkzwEecEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joQ/PV6j8EEDEFgVwc51lLCgQye0NvOJruDmMywVoi2H/G+zr/3bXopr+OwYoJvth
	 SxVfVfxWb+Qp6OYXOVubGcpmX8RHNmnni3MW8staJysJzCuzBp2SjUc2FYFX7hV6wp
	 JLTGihXMOLXJyOUdOVTfMIyi4N9TTQXGKuEpYyLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 556/583] net: dsa: vsc73xx: Add null pointer check to vsc73xx_gpio_probe
Date: Mon, 22 Jan 2024 16:00:07 -0800
Message-ID: <20240122235829.162926137@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 776dac5a662774f07a876b650ba578d0a62d20db ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240111072018.75971-1-chentao@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 4f09e7438f3b..c99fb1bd4c25 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1118,6 +1118,8 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
 
 	vsc->gc.label = devm_kasprintf(vsc->dev, GFP_KERNEL, "VSC%04x",
 				       vsc->chipid);
+	if (!vsc->gc.label)
+		return -ENOMEM;
 	vsc->gc.ngpio = 4;
 	vsc->gc.owner = THIS_MODULE;
 	vsc->gc.parent = vsc->dev;
-- 
2.43.0



