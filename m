Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800E509F06;
	Wed, 30 Sep 2026 18:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792213; cv=none; b=bvLyzMRuVCJhRI9n+xlWagnAIBLHU/mIFkWRmYF/U3A3vSu1ztBiIL2Ra8VwJbgCvhJHHUNFzIlTXd+pWIKOQJSTaE43NivchciODm8k3HNRpnMcP/cStYn3Fdsf/k50eEZYKx8Q5E3omNdJr8hrVJJ4MOK2BG8ffmUNanlhKnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792213; c=relaxed/simple;
	bh=V3gGvb7a64imj3ThUH0cVWVXZ+TGEreS4dvtUC+zra0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juL7AOHyf5rQBVpfXSGhV75gJxkHQ+WaWhR85wRAZXj+4olwHQuTRP2tnKMfRD5gbSjxMT/Byebge+quH4C1GMJbtNOeqqcnl1dpWRTYsjS50gISblTG6zYoXFklTCwIYpeF/pVDa3+qvXcHGco+bUS1YyY0ECW752tGhSAwek0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSw9qIpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSw9qIpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A72E1F00898;
	Wed, 30 Sep 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792211;
	bh=EKJfQL9gyd93mZhdcfAZPk5DgRRr3IBW5d2XJM/vpis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSw9qIpPEWMhVxKGQUxGpmITxDHXk/5O6sDxMWDX0+JQtMQc9LzQWlJ1Sv6Sj//nW
	 JNMfGAlKaH+9Yo9aZJEIF0tIJSIB9XgJYEVLuK1BPur2Kaw7H/LocXeVNJyFRIr/mj
	 uzMMw9owYVRuyAtSnRVT92vKT6K6SiwdDcZX/dCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 558/752] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 30 Sep 2026 17:27:08 +0200
Message-ID: <20260930152410.315585960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


