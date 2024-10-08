Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72691D27B3;
	Tue,  8 Oct 2024 12:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391042; cv=none; b=A8MPf5br7xb4duiH8CgOhYUgHYBzwNFjwYq3VfIeD0HxZMviTpw/yXq9IE8MzBFkLyzqhmn1f5J6GRatkfh2FDunzjX4QOtU3tDEuPEHcN57pkBQCAEnRH5mvVbFfCPsp7gJQFYX7NRlwl9T2cz4eIR7de1M1ozraacRB/XU8AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391042; c=relaxed/simple;
	bh=0euepMjmnXtsj4A37n3imijBzaH4sJYnnp1NUhiErjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+Kh7Al6LrZEfvtBULQ4qWodw++SM9XHtt78eBO4SCSuaAeLBYj+8I7VgQH9WUqhQoNzgbyLtR4FKwci4o//j+zywY6if4Lf4fu15Mrr9gbTZQtzv1NZvCdLABEzWyHXMOeAtKl0Xy2f16Z0SlczMGsOVxqxvRqEaTDUPMIFNas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2k/fvXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2k/fvXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D38EC4CEC7;
	Tue,  8 Oct 2024 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391042;
	bh=0euepMjmnXtsj4A37n3imijBzaH4sJYnnp1NUhiErjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2k/fvXnhuIp8jtOIR4SzXa0UcUB1cw/cGwvt9dbsW9PF6cahZDCE4vUqg7VHF6kW
	 WXFKg9mC4JRCcJ89BmyzlEwsKZpDQX5+EMp5WW20xSHK4Zk8hN0SXjob3L2q6sXvsW
	 ZwrGZ2r2pwYhQcw/IQbepKsyuPyZqdhyGI8q5Bhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.10 473/482] drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066
Date: Tue,  8 Oct 2024 14:08:56 +0200
Message-ID: <20241008115707.126094371@linuxfoundation.org>
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
@@ -515,6 +515,7 @@ static const struct vop_data rk3066_vop
 	.output = &rk3066_output,
 	.win = rk3066_vop_win_data,
 	.win_size = ARRAY_SIZE(rk3066_vop_win_data),
+	.feature = VOP_FEATURE_INTERNAL_RGB,
 	.max_output = { 1920, 1080 },
 };
 


