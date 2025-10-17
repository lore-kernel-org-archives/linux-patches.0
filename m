Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D112036E9;
	Fri, 17 Oct 2025 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715318; cv=none; b=Us15kj4S/WDFn6qdZwgnrpYWxbooO3czj912l2/T2BgyzqlOEpFN7xye3muiklOkjOcuXDBCQ67cX4/4BsY60igyt3vOjJan4vzlBIRR4hGCYZYAT+hT3rirxlyTYVT277FK4dogaO9IuQrmeaOmYYBQULUwqvCn4rCt4Jigmx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715318; c=relaxed/simple;
	bh=sNfk25xPdowTHFQkpp6qUX3CRe0G7HCDYr8MSauWpXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lu4K6LxW6co6COsSqdpkVYb/UpfYoBIg8BXhAaJPVCF3fjLopMiEH7TgdGu+PadyqYEFwM5+oZtNWYkMChwUBwSW9PQsg5F9h4Fgm70edLI6vYMYmMCgvz8KVMCkNT/ATxR/uW2X3z1QVkipR3xzMgbz09kpxB2gvtzk4aLEaKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oC5TMBEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oC5TMBEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D347C4CEE7;
	Fri, 17 Oct 2025 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715318;
	bh=sNfk25xPdowTHFQkpp6qUX3CRe0G7HCDYr8MSauWpXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oC5TMBEWkaZMYBNFBsALmWRZruAXTuoDnq9zi1ZZYU6IpjtcD5dxd21Or9HPtzoZs
	 eH0ClxudOr2uGUiRIBzi+D99wNjhP5FNeYKg4RBI+Zc99soJQHUM9tYTwCpAr0z0Ud
	 NzoAXMvlY4KCGcZQPMjZNiP43xr4gBHDFJ7Cp3Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 175/371] media: platform: mtk-mdp3: Add missing MT8188 compatible to comp_dt_ids
Date: Fri, 17 Oct 2025 16:52:30 +0200
Message-ID: <20251017145208.261800231@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit bbcc6d16dea4b5c878d56a8d25daf996c6b8a1d4 upstream.

Commit 4a81656c8eaa ("arm64: dts: mediatek: mt8188: Address binding
warnings for MDP3 nodes") caused a regression on the MDP functionality
when it removed the MT8195 compatibles from the MDP3 nodes, since the
MT8188 compatible was not yet listed as a possible MDP component
compatible in mdp_comp_dt_ids. This resulted in an empty output
bitstream when using the MDP from userspace, as well as the following
errors:

  mtk-mdp3 14001000.dma-controller: Uninit component inner id 4
  mtk-mdp3 14001000.dma-controller: mdp_path_ctx_init error 0
  mtk-mdp3 14001000.dma-controller: CMDQ sendtask failed: -22

Add the missing compatible to the array to restore functionality.

Fixes: 4a81656c8eaa ("arm64: dts: mediatek: mt8188: Address binding warnings for MDP3 nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
+++ b/drivers/media/platform/mediatek/mdp3/mtk-mdp3-comp.c
@@ -1530,6 +1530,9 @@ static const struct of_device_id mdp_com
 	}, {
 		.compatible = "mediatek,mt8195-mdp3-tcc",
 		.data = (void *)MDP_COMP_TYPE_TCC,
+	}, {
+		.compatible = "mediatek,mt8188-mdp3-rdma",
+		.data = (void *)MDP_COMP_TYPE_RDMA,
 	},
 	{}
 };


