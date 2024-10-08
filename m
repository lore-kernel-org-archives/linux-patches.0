Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C01DF263;
	Tue,  8 Oct 2024 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392928; cv=none; b=lTOoY8DuVi9twkpXGK6ZNDHeCffZdMvwZgGnUpVGcX9iJdsgodLxbQP03p9/oniN7qJ5Dmz1clqLSSmBnJ7V/aB+kQXP6YqFtDWExHuAa95d9kCb+WUr4c5/ly3dGqfmCWPTDY/QwOu4AfWJ2NE431XKxvhRg4vQMjCi+9M4jBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392928; c=relaxed/simple;
	bh=SE2ZVeUNqZBPpfle8nREmhZTAwjbzZKaXQojXB48G+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrJJ6JStHyMpPBebw9d6YYIVy3uXXEyqhWZmMZNnaXNlreD5fwrgEAR379O8JSMwXvQ6ye9NtMFxqxJ8GxpWfXaL7NTjGaYQY57bnJNytE2oqYw539AvR4hGKWoNY/7eK6sr8GFPhjZrvdj2IJf5IqJRU6njbNas/fNsIqBeIuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaSbb0S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaSbb0S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123E3C4CEC7;
	Tue,  8 Oct 2024 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392927;
	bh=SE2ZVeUNqZBPpfle8nREmhZTAwjbzZKaXQojXB48G+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaSbb0S06U1VqVQoWvzla8HQPDgR7+n5Y/ayLRnzJ11VPV1dPMxtBEvgeWibzsuke
	 jQYIA1qgIp51caG7cmFpL7d4+doNOTt+ptyFmDlAMyqLqG6t9JFYL0qaa8oR3B4fQ2
	 tmgsGburpClOpO3Abp9Re/0l6TE6QMGcTs/jg1U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.11 548/558] drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066
Date: Tue,  8 Oct 2024 14:09:38 +0200
Message-ID: <20241008115723.799471427@linuxfoundation.org>
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
 


