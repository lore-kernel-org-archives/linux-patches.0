Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749436826E;
	Wed, 30 Sep 2026 19:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796557; cv=none; b=MHnn+6DcnVYxvm30U0LiTjpDfRhM80g81EPFVIGupvYiorel6szrenZkDqDKKR28AMkHem9vf9Sb1pu9QJgcWSpyS65txUE6QD+X4hpAfhzkw1yLntNOzIkG2zjrSxPfz0hDvedy+LlV/QAyRkCfPThzcKnSQGw175iHzQiezXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796557; c=relaxed/simple;
	bh=pngXEvDlGwRXJlMeuTIMy9/Kwbf/HHkuos4qefhnEx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvNqZo7TtBdZnn80ShhMliIRrSfcd0YVns9TWbrFUZYEcsjW3Re0MaJBjiSWuXMDslCdP0aS6ZnulZWQF9NV+DvUHa6+6slLROB3xOorE5BQN7C6oeXD9t56O05wAWAyBqSdqh1vTH7DXZHp70qbdONm8bocPIiIGCKsTaW5HfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAgSXPrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAgSXPrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670491F000FF;
	Wed, 30 Sep 2026 19:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796555;
	bh=mme054pr8+U+ozeYzc/qmAtj/szwb9WDxkvTst7fGh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAgSXPrPEOlW6DVboJ4uSWBU9qETKorTAMH1IuWxw/bn6jrD0hZHBBW1f+pTkDJRY
	 688iMxkcWmuWvQ4DbGcJFtduX9hLejER/97z6Pu7xYqlq4M7IP+tzZv8tGcZP7u7bh
	 GCLxlEMMHMA281Ajpev/1cs+ex2zfDWCfikD+bls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0900/1193] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 30 Sep 2026 17:26:24 +0200
Message-ID: <20260930152454.237476442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


