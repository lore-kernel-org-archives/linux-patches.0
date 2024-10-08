Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074CB1DE3A2;
	Tue,  8 Oct 2024 12:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390516; cv=none; b=orMLapbWK+31M6nYovqBJpY0Ok+cdks1Hze9MvyhpAF7vFkl+9EP0ylmJZcoKNWIa+VunsQYN/LPBBOImC7QSKVgqPr5OGRG0W0YoAMPxfSk1L93t5xBv4Nva+lyHLMaj8btxVeXRsEOKTE970O30ymPjToJwCiTKrzQOOjaRd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390516; c=relaxed/simple;
	bh=98D1hdTlsHWQPnGFbChhh1fwn7ppEVk5e3mBV9O65y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bR+LXvCJmgqpnDpxXXhmlXKmtwz3Q9WJn65Rbu3B5PVOXHCzmYgX5GTud1WM8X3jmTQQmEWNzhLUeC310FkV+ppsnVKlJS3eq6sCl/AX3Y6XGyzFrjGjsbCUZTg8SKB3PiQs5Bz0gUFf7Levh4dXANDDDcJxFKfgR/ezZhEIfEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxkNkxJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxkNkxJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67180C4CEC7;
	Tue,  8 Oct 2024 12:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390515;
	bh=98D1hdTlsHWQPnGFbChhh1fwn7ppEVk5e3mBV9O65y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxkNkxJkNUJwmwg+setlU194qouETkoVyjJccjG9nFZw9vy4OwCYPn4tdUYDaHi4Y
	 rudJ6Bbw7YQ1n+I5vI2OEK/GCi2tc3e5+Th4FJ5sTSAN3AbBHutmdggG378VlFc0ng
	 dDgOb3MIJcbUNxpaJljcUbvis+Aymb9CIucVXGQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.10 312/482] drm/mediatek: ovl_adaptor: Add missing of_node_put()
Date: Tue,  8 Oct 2024 14:06:15 +0200
Message-ID: <20241008115700.712232965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 


