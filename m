Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA24D1DE4CB;
	Tue,  8 Oct 2024 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392288; cv=none; b=YShB+briFDjpcMjRVJgLOBjvu7sfwgP/ZxZMI7aSV5D8mpKn5hCW5S7teii3K5IAsvLKxIORtncGtVVO/SAk7UE5qQoKNjVl9MVC6yAIQ15Kx/JXpwXMDy6PGLM6sdTHTb0DNqt95IBYyz0jD8YHsWfSQFH+mMxzp+DXbJjD8Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392288; c=relaxed/simple;
	bh=i5WsZr1tqWu7x7l4WHhSrPK5ZmVDFZaqV3ZRdgxHvT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0qXdlZJX1OyNzq8j+LtQdkSQf3sa9SeHbZ5hGrPEb3HmAZ0b8fXLJ1W3qnjKeuojv4yn4pe4iMRm5nfq103tUVayrjcRAdBWFOQSOz1WyQ5GDcDWFp3SqT84/UkFPLdfQYy5WIVoZUydhhB0bGnj6jYDhXSebu4fexP0R/8N0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXog+Y0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXog+Y0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4879FC4CEC7;
	Tue,  8 Oct 2024 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392288;
	bh=i5WsZr1tqWu7x7l4WHhSrPK5ZmVDFZaqV3ZRdgxHvT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXog+Y0yIowb3zkN0V5xVhBOtNL3WsYj8QcexAjmmt0uvBOSs2x4OsnKugSHS5606
	 et49WmmAi0uitLsyacN4wgsakI00Pm6TQICU8DG4Z5NqjwXxuxrssG73Nt+xkYTzQU
	 f4793vnRFtaPVPImOwmcyg6Cx9c1euricCg9lNIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.11 370/558] drm/mediatek: ovl_adaptor: Add missing of_node_put()
Date: Tue,  8 Oct 2024 14:06:40 +0200
Message-ID: <20241008115716.855623758@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 5beb6fba25db235b52eab34bde8112f07bb31d75 upstream.

Error paths that exit for_each_child_of_node() need to call
of_node_put() to decerement the child refcount and avoid memory leaks.

Add the missing of_node_put().

Cc: stable@vger.kernel.org
Fixes: 453c3364632a ("drm/mediatek: Add ovl_adaptor support for MT8195")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240624-mtk_disp_ovl_adaptor_scoped-v1-2-9fa1e074d881@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
@@ -523,8 +523,10 @@ static int ovl_adaptor_comp_init(struct
 		}
 
 		comp_pdev = of_find_device_by_node(node);
-		if (!comp_pdev)
+		if (!comp_pdev) {
+			of_node_put(node);
 			return -EPROBE_DEFER;
+		}
 
 		priv->ovl_adaptor_comp[id] = &comp_pdev->dev;
 


