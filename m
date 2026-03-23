Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2DF3803EF;
	Mon, 23 Mar 2026 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275268; cv=none; b=G/QIibyHKvtb9tCZayOth2RM0QwB+lxDMWv6W+ItcMm2Jqu4t97KpB8JhqC8j512dgPhqeuwjiyWS3OOJswLa4xzMNwqTcRgVNVEQWg5TSk5REpIcYiEl+Tt544MVinecH7gXd2gxeXsBHjSu7uCyLv6uvxcRYf2Vrq6TL5vB2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275268; c=relaxed/simple;
	bh=r2HH5Y7TzJ7OSr0nkX7NldpDkVyRL4wUaY0TOeuUJ6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szXKQ31prJjA0gT9dRiAFoNy4lRV2V+qCzIZnRE3vFdIPK/6/k6t3xQJhgovql9hyue47+HhMpmM4nq1MmWWfT11JOoQZP8vrUesrqss6k5AUpscd7Ln/BKkoMttHonjiLK+Yp5yKqzS2MFe1wZ4+WmYYeRrw/gyS4Dew7Cc+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kanAtf8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kanAtf8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26E9C4CEF7;
	Mon, 23 Mar 2026 14:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275268;
	bh=r2HH5Y7TzJ7OSr0nkX7NldpDkVyRL4wUaY0TOeuUJ6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kanAtf8SuAAvmgTpn0iqek5ESpaGGqEX2qTACAYkH1u6dMX3B0VyejZ3lzGOjXssg
	 ICWSwQsW/W+p0m+6uoP7n0mWtJAj9ALp4LmhJFPVcQBty3sScRIIUpWj6+8aec1MDd
	 ZDnF8uIMlTOjbGfIid7pI3Pva2C4V6tIMpGcf+30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/460] net/mlx5: IFC updates for disabled host PF
Date: Mon, 23 Mar 2026 14:40:31 +0100
Message-ID: <20260323134527.571772864@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit cd1746cb6555a2238c4aae9f9d60b637a61bf177 ]

The port 2 host PF can be disabled, this bit reflects that setting.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1752064867-16874-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: aed763abf0e9 ("net/mlx5: Fix deadlock between devlink lock and esw->wq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2b1a816e4d59c..6ea35c8ce00fb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -12282,7 +12282,9 @@ struct mlx5_ifc_mtrc_ctrl_bits {
 
 struct mlx5_ifc_host_params_context_bits {
 	u8         host_number[0x8];
-	u8         reserved_at_8[0x7];
+	u8         reserved_at_8[0x5];
+	u8         host_pf_not_exist[0x1];
+	u8         reserved_at_14[0x1];
 	u8         host_pf_disabled[0x1];
 	u8         host_num_of_vfs[0x10];
 
-- 
2.51.0



