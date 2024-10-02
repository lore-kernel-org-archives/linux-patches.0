Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2576B1CFEBE;
	Wed,  2 Oct 2024 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879960; cv=none; b=c3QzKu85nYwbiISMiAD96uorXiy2nNesnYw9mpFa+DglCYEAjmgmCBFwiCIeE3Zlk9xdWNSW8FlsG1Wdl8ZEpVIYRktDBZuPcbBFBak0hF8mqIDYpddFnAh12BwIhK+GlZ2LpLMrCytCMl+bWKngC87FZFHbr+XkhHBJ3at+NUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879960; c=relaxed/simple;
	bh=QVgayeBH3hSWthDoe1JAiIURFY9sQTNDneBoynWxZ34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaGUpqV1rSIYzRS7mH1zL65Wc+TXmUrU2xIc6VtsjfhzBXDDKco4J3QwNYhr/DIcPHDvX6Gun8TBTlnwLUSseeodIiXq3ZfErjDzAGufY9DYscxEfpZ9oRrPpuY6+9RWgM2iCXQW+yKciHOR8smr4XG1yDhrcevhDkrtrzyM9GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTncNmQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTncNmQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A293BC4CEC2;
	Wed,  2 Oct 2024 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879960;
	bh=QVgayeBH3hSWthDoe1JAiIURFY9sQTNDneBoynWxZ34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTncNmQy+SoSD2pR6lvVtqtMI1f++Mn8ZthAAu9OtQNQT0tHV96p/8id6YfdLnyij
	 9LIdr1sfYbyMv3/Dtqod6yF15Son+hy0fo0JFT9OErvyUXWV8ix6JjwvUJiOGy3OL6
	 Fo+jrKwK+vLr4/NAu/oefx33WjKsstSPwnj6AtM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 295/538] media: platform: rzg2l-cru: rzg2l-csi2: Add missing MODULE_DEVICE_TABLE
Date: Wed,  2 Oct 2024 14:58:54 +0200
Message-ID: <20241002125803.902656575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 07668fb0f867388bfdac0b60dbf51a4ad789f8e7 ]

The rzg2l-csi2 driver can be compiled as a module, but lacks
MODULE_DEVICE_TABLE() and will therefore not be loaded automatically.
Fix this.

Fixes: 51e8415e39a9 ("media: platform: Add Renesas RZ/G2L MIPI CSI-2 receiver driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240731164935.308994-1-biju.das.jz@bp.renesas.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c
index ad2bd71037abd..246eec259c5d7 100644
--- a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c
+++ b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-csi2.c
@@ -854,6 +854,7 @@ static const struct of_device_id rzg2l_csi2_of_table[] = {
 	{ .compatible = "renesas,rzg2l-csi2", },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, rzg2l_csi2_of_table);
 
 static struct platform_driver rzg2l_csi2_pdrv = {
 	.remove_new = rzg2l_csi2_remove,
-- 
2.43.0



