Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1940F503BDA;
	Wed, 30 Sep 2026 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783727; cv=none; b=sj8vOEYPNCLy/5qc1RYZ15rSNBLdEjJBZCEsRbxfVa5T7Lb4EXedQAbBKZDJHCFOhLxt+V7BJeigrnnbFUgukGe3BKu7cweDr/y+Z2QgIAg0Wnux/o/p6iFjlz0aF8T6Uf4xGG86qvyFdb81qLGk7f9gmZAZoZuuugAsQ2XUAtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783727; c=relaxed/simple;
	bh=mf4QcCYGevYKUlEx/n/FblDaMZFKwCXUdnsOOSRdTJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2Jno2MqU79+3UjcOj8ZI69FFT4R8D5v8vKFyVUQJ1JLVxdXdEqeYZV5vL1ktOj66+GOP5mq2Z4iMKo4fIZxcWOVBtscMGpp+7nHDA7UWqUx7pKJ7weI2opOfOv8CfXV40W5VaHKvD9fqApGrqWJ2OfPslicvPKTV+ZK7UMgcKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IftmoP2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IftmoP2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666591F000FF;
	Wed, 30 Sep 2026 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783718;
	bh=xa47DnvFY0oj18wyxJbvolNKYcoNU1PUWqlXva5kVmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IftmoP2/sGeFX3sOuDdxOvWgtHDTKAKEwwzwIClBeNnla0coKiKH5yVQGH19YAWVC
	 L8lQHuGhH4PWdm6o35TDNhqRkaHPb3u1QNoNAW8l7bKgBnGoTHrKnfAnElvQy7u215
	 8zB1+Ob6SZ0O9IU6c+q/6H+YwpX4j8ysNUxQFtrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 453/595] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 30 Sep 2026 17:25:46 +0200
Message-ID: <20260930152357.424558214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


