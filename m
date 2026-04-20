Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5638322749;
	Mon, 20 Apr 2026 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700586; cv=none; b=FiWQYAM81z/zbW0ZPOPaVyeOnk3V063tc/KLnB8cwPcSn2VI240ndQl6wBwTWaech+ZE5gkq0V2JzXYqvdx79X3qvsrsmJWcDLyNlOmrVi7WJm29ddkibMopO/1WbA+Fam+icWpi1N07rz/oqgQHyyIFWw8KMQcj0EhR1YBne0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700586; c=relaxed/simple;
	bh=9mxVMI3Oa2urib/uaYj+CgL/6SSxDNoY5ZP1CyZmuPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoJ0KD+N4zaANgo1ZDaI8Vt7nGob9pDL7a1Ake5/RcQ5IgjFH6b1AOxRilYzTX37+i9Art0ivQyddNd38ADsKsEZVYAB4//0BNhkwm6F24Uu34aLzHe/YAqgLU894jAHweuNuZ98rh84ILyr7moYNvo4W30wNT5JnuJ7vM2rq0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJaPAJ22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJaPAJ22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E78DC19425;
	Mon, 20 Apr 2026 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700586;
	bh=9mxVMI3Oa2urib/uaYj+CgL/6SSxDNoY5ZP1CyZmuPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJaPAJ22uKbOS27aMNditYH0bcrm2DWp3ZbgfkS0cl+hOdeSkJKzfzeT3C5eccin1
	 7bNoxoFim6nZ8wkgMHHQW9pctkOKZf42/ici0ctfezdZamrr/9FFNIfTcuIYIJ0MZx
	 Jz00M4QEcQ8hvaaBtjGT5pXSDHlJseYl/TbOTSD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/198] ASoC: amd: yc: Add DMI quirk for Thin A15 B7VF
Date: Mon, 20 Apr 2026 17:39:49 +0200
Message-ID: <20260420153935.984892601@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 1f182ec9d7084db7dfdb2372d453c28f0e5c3f0a ]

Add a DMI quirk for the Thin A15 B7VF fixing the issue where
the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220833
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260316080218.2931304-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index c536de1bb94ad..6f1c105ca77e3 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -724,6 +724,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0



