Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061062;
	b=QrLAkYYpeKNYO68P66AtvKfGNSm90haqJepxXXzFYTn97TK2yAaESRunJgAb7hkAU6jL
	 xpuo5LxF2oPKEcNrg5F8GR/4TgjASmViHThJFdHPTZ9juUlf5ZaonebI+LPt1kmh6av5o
	 Pps8K+sPSoYvBnuaIJAQzu+Z+skpyjscKeqlrdU+Q/hRb76R3GPhVlSmhT9UrZ9ZbnLIC
	 nt+SxQBtjTq/00YQKpxAAIDB6p7hGjS8FGBGN1yoXEQPoOqe9L5Cv5pPO+ZIKVtppyxT6
	 NEIcrgh3IqxEoEvEvM76zkyJD53C67N8c50c9Q4srAo8ZsHB0mikqTKCp/SmqsvB9hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0QUwiHKlb/VfCcFkB+YStlcJ39QfIksSeq+hg0wugAY=;
	b=DvI5feXcrj7lQPmuNj+VmSLaDJkkfos6msrOn5Xh/RHxptJxIG6yRWKcN2WQXdqN89CW
	 ThG84509MvDFGtLkrkOy7axOE2igyR3MDgK3IZ1ii6vy/mNtukSpfSA4HfEMnDkcOtdzd
	 nNzisc2j2k6GtvgqdUFw0fJ+UWn2SI/PVyrKLl6aXZl6clgr9vJj3HytSa4KNO4E8szki
	 lyQE3JfZufHSvDhszHAmsMc9hHKYevyTfegqj0inq18Ilw7Sg9cdkSyYLEMtewaXM/aiQ
	 1Gy6mv+1EO6XqO80mmyQBO6BOaAX2RX+VWJdVCGXE5EySuGkr6tTpLdKSkAS+n27gzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umJeVkXk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA86082BC8;
	Sat,  7 Nov 2026 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umJeVkXk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC521F0089F;
	Sat,  7 Nov 2026 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061062;
	bh=0QUwiHKlb/VfCcFkB+YStlcJ39QfIksSeq+hg0wugAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umJeVkXk4Cm/+F2grjFcXSA6Nir8EKvj0t6IxaQYOHCvUw3bjZim5Tmu3ucH9fJW2
	 EbX/iKO5ab7z1bcjAtaiMoEAHEU0IwLl8LbYULbcnNYslOTJ2q5htfWhof7P+RceiS
	 P84Wa5w9OSUxZ6/kdeyddtVEQofEPn+dZiKaMe3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0391/1536] ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD
Date: Sat,  7 Nov 2026 08:40:07 -0500
Message-ID: <20261107135008.585830044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit fd8ed52ecea6b93e23d52cb2758fb4fb4029067f ]

Add DMI entry so the YC machine driver probes on this model and
the internal DMIC works.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221485
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824130302.553419-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index a21e85c09e1b0..3516844d99689 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -507,6 +507,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m18 R1 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



