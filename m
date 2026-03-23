Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6B125393B;
	Mon, 23 Mar 2026 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278168; cv=none; b=PmhfZHpilcdlRRCWSM2KugDuHUQyfYbZb0FeuBvcVCqeo7CFaozrec7QGiOqyTCild6uB2WX0pHHwro+6wanqIKMSdwApH8lpNTq8bSMa0F6BJPa3mFRJxKrXCD/sW2aLCMVJGtiWc0X/EGkP4Y8jDfL2264huMH009hhWEH26c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278168; c=relaxed/simple;
	bh=B6/zT3lc39Vydu7N5qrRISpji3Y1mWuK/O4vVuayAX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1SO3jHUuQRcpeVJtnHmVsz1KbIU7D4YnDgFlrPUF6t6ZkVedNyP6QRU/I73muJADfFs5BqUpNFZfn/flPA0DuB7uzpQahi7YTWZC37Wk73YLr4At0fUaclYhQx+NtVQxxiZbGt8WY8qZQhpDnrAvMJDRX99jbpyBQY4UPYxbS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R75r8oum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R75r8oum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BB2C4CEF7;
	Mon, 23 Mar 2026 15:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278168;
	bh=B6/zT3lc39Vydu7N5qrRISpji3Y1mWuK/O4vVuayAX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R75r8oumfuL4wT5zf6I2/9bGcgb2QZaMyeYm0wuTo8lmK/ycwxVdf1ZfSj+fJe51T
	 A1q6pQ+DSO4luLPqO3YnJiDXlVf1d6JpxEU9gqiuG4yQWKqbEq1uyB22bp0npWVUGX
	 Y/SA1xaPUP15VPKjaRnlDK+6wHOEh/PyDYkXqX+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/567] net/mlx5: IFC updates for disabled host PF
Date: Mon, 23 Mar 2026 14:42:21 +0100
Message-ID: <20260323134539.297183689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4913d364e9774..c59fd31719a13 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11799,7 +11799,9 @@ struct mlx5_ifc_mtrc_ctrl_bits {
 
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



