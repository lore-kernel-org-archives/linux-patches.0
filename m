Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4161DF254;
	Tue,  8 Oct 2024 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393679; cv=none; b=ashEhP583GVizplKkFnLfIHK+qLkJZuqKjK7GY6kehdm4d3SK6l8GdaTq5682sB2rM5BJRM+oFg0/GRX7JbHIp2P/6+Nuc3mzwnc+8Vum4CDbwQsZlfw8oLg1HwcDyVsJMwpPSPvIa7haP6XiP94jriSdC4yGEHwDIqXnozDSc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393679; c=relaxed/simple;
	bh=S/iasr4wwxvYKVQAj/+7fhyLfhMcPjc0QY37usnQMkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhB0oCNgtozRyV+Si5FK4Ecb7ZsJZoZImuNLlHj9tBSBD2flVBmiWOQYLriyEXXxNsIHf/+Ky4NTJwwC2Mevcu4u0JwksxL4BVwZQMRQnfO5NG9Prrx9mkYcaghLKwBTH+oWlrOia7Fa1aDEFImF9KjG8W2Ir9IQgNy1rNpAptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EteLv4mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EteLv4mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C550BC4CEC7;
	Tue,  8 Oct 2024 13:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393679;
	bh=S/iasr4wwxvYKVQAj/+7fhyLfhMcPjc0QY37usnQMkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EteLv4mhBiamuB0KkitnQ/5KOptKHVmXtD3ctQHMqwgiQ48NjCQzxGKA7Jj0yji6O
	 7WCSuakEbCQFQi5pbldOBWwy0+F7uqpLB1/5mbPPu+Cf9DU2j2Mrg0eMqD8EVm7oOv
	 9r21QGxay8o671qUbx2fW0dIkIeq9Ag5O1da/pqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 222/386] drm/mediatek: ovl_adaptor: Add missing of_node_put()
Date: Tue,  8 Oct 2024 14:07:47 +0200
Message-ID: <20241008115638.142045752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -436,8 +436,10 @@ static int ovl_adaptor_comp_init(struct
 		}
 
 		comp_pdev = of_find_device_by_node(node);
-		if (!comp_pdev)
+		if (!comp_pdev) {
+			of_node_put(node);
 			return -EPROBE_DEFER;
+		}
 
 		priv->ovl_adaptor_comp[id] = &comp_pdev->dev;
 


