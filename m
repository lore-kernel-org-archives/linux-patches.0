Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38318C333;
	Tue,  8 Oct 2024 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394251; cv=none; b=CSZb7g/rXwKQeuc5aS1dPCSaqwy0940r5nyRmHkbNV1FTKEpCFQ2bZJyxEQNVOuJ39cSxaYNHoUFZRohablfCJQ+6D+CoNONNpNgN59b3zz9sdGaUZQKHp563HiiNoUdvwMaxqpEpg522ebkQBtYSlcg8fW188wAh1kPX+a53XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394251; c=relaxed/simple;
	bh=rYjgt6DVsymNe9Imov7JnM9+Vc6IKcJ+A+UqK2KBM8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h74LqbTV0EwXFw/T9jQOQCZc9xeJvsU4TM3CR9QZXG+q7HGqVrVu+GvpEH2fojmIZZkIs7B4S0FnJJYvyczJNOyAMA2yDv5yBUtm3ucrfGd1NPtsWOVbldxw4u+4OJgyhWI1MNdscnSRTc2nMPLSDUmHkKQjgMlkgy7CYd+oSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uruerUfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uruerUfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B02BC4CECD;
	Tue,  8 Oct 2024 13:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394250;
	bh=rYjgt6DVsymNe9Imov7JnM9+Vc6IKcJ+A+UqK2KBM8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uruerUfOsRIwY2RG3PIgP1fOQgePUODwCg4Yzl4+eB4REwlAXYkZJu1cp4LXtCdJ3
	 NKJKr7Qmn/E2p9ZHdbwyIHjbcGPP/Y5xGDPLaBk3nWzaRA4xPSk3g0j2pnSWf95rnI
	 7kUfDTPSoWqjxQi6YjfzBklfDqIcG9OijNy2KVhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.6 366/386] drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066
Date: Tue,  8 Oct 2024 14:10:11 +0200
Message-ID: <20241008115643.787374832@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

commit 6ed51ba95e27221ce87979bd2ad5926033b9e1b9 upstream.

The RK3066 does have RGB display output, so it should be marked as such.

Fixes: f4a6de855eae ("drm: rockchip: vop: add rk3066 vop definitions")
Cc: stable@vger.kernel.org
Signed-off-by: Val Packett <val@packett.cool>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624204054.5524-3-val@packett.cool
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -484,6 +484,7 @@ static const struct vop_data rk3066_vop
 	.output = &rk3066_output,
 	.win = rk3066_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3066_vop_win_data),
+	.feature = VOP_FEATURE_INTERNAL_RGB,
 	.max_output = { 1920, 1080 },
 };
 


