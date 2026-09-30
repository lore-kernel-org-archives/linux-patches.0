Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F215111B5;
	Wed, 30 Sep 2026 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786105; cv=none; b=QRqhMj/FVOYTFyhO9+zjnfthzftlEswXkhml1HWEqq+xuxY41ANg0t+nCMuybRK0zCuKmIp/6fz7e1yA9c8K+7ZMaKnfo5D3KqRIuHtbLbllSrMdxg260VRG26tBcp+cXO63UwG9yR2klHVuh2SKfR9xHIZ//CfEcG29yF3rGiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786105; c=relaxed/simple;
	bh=Rdd4ioj6m0lf5gveTdfZ+IjdvcMPu4IMsq9gJ7DQxJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqzB1cQCyPTKeKnIxW0+Vf7KNLqH7z1SpUHXajV6rDB16oG1ffSPiNvzu/E3QszZfjvn10xsBQaZy6VvUGNzaiuc9vhRwjveTMAcnofzBGDH8HRi/P60F/c2cpUQQ3h2mgMjsbjPm8A8CuOTIoF61ve5IRRk+Lqy0zanQEPDi14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/wqMy4P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/wqMy4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9A61F000FF;
	Wed, 30 Sep 2026 16:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786104;
	bh=ExSTx3sj8Umv3q30o7o0nF+4b0kux/arF/eprrk3Mdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/wqMy4P/6cb7kquGiR5ppOFd1fVhRQadFx5Utd/OWli6DnshI5W3fPh+Nru69d1M
	 j0mzGBZ4mWiIfHTTKkK/6QvyNFAegnySPzJxDMB9jsJArBKSS7Rc8FOxx2UqFPczra
	 R69MBaB0t4/zm8EedwOmUzzmMWwT1dsVWev+TbfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 745/982] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 30 Sep 2026 17:24:41 +0200
Message-ID: <20260930152432.756085639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit fb5022278b6ea7f1838e3ef78028d5d5e3375f65 upstream.

Check that btns_desc->package.count is not 0 before accessing
btns_desc->package.elements[0].

Fixes: 4c3362f44980 ("Input: soc_button_array - add support for ACPI 6.0 Generic Button Device")
Cc: stable@vger.kernel.org
Reported-by: Shashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-input/20260909091440.3384C1F00A3A@smtp.kernel.org/
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909093934.29411-2-johannes.goede@oss.qualcomm.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/soc_button_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -377,7 +377,7 @@ static struct soc_button_info *soc_butto
 		}
 	}
 
-	if (!btns_desc) {
+	if (!btns_desc || !btns_desc->package.count) {
 		dev_err(dev, "ACPI Button Descriptors not found\n");
 		button_info = ERR_PTR(-ENODEV);
 		goto out;


