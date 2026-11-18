Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035238;
	b=jK0/3XGF1FYSEJWpkO6+5QwX1RG41KnYGN4m/CxCXk2APrVP4WVf54oxAEdu27vRKMJM
	 ZcEITZAMhWcvSu5L61w7P664+oz6FNd/+NolX45wlorp0oB5NktQgb/GTL+w7FJaR4voB
	 B7Eok1q58AK8cRkqRniLQNmgwgjoVMZbbX6JfUK/7sShc+i9PtB33i2RrlZtxN8QAr63W
	 nrmNW4qvnACiuD/MnBCcd5yECoPkdXC7vohucvn5UzAmaDuRUg7I7tU1VgU7cWe7Q02FF
	 VTpYfq1EIg89YeMwWwDZrSNlQaXvWywy04B1YwHZOx/rh79yiZk/RJdjgcY+0mqpp5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Jvao30bTbH4WagoUSVd4nmnfYLucpgLuowjSuAE0Kc=;
	b=O17mTIHo5P6bL+Rhiv5s/NbmwpIouqYaO1iPOuNBmtHMUF2WgtuII8+3cgPmcsi222Fz
	 5Bg92wdLQCcgoBnFKcf4TvW/zmHMxanfxWRFueiR71XuyO3nWIGgTepMcfUPrB2dYfzsm
	 3uK6Z+5zFJyZhdYlDX3qtb9owogApXyKB7pW/Vx5XQNHzWkOBd8Q/v73GkWBff5leVybT
	 gdA6IFjTmUG0jhNEtgkrdd6qEMu2xR3JCW8nh/77kvjpWFVKUxWxD9zZE/L3JT1F9Pcem
	 u35PxJIpMAV6lj9z9hpPN+IdwoJMCPlCE8mL+NS0WyEfnVPqfNQN76BLjYUhtDdz8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odRDDTKg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B2E606A320;
	Wed, 18 Nov 2026 20:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odRDDTKg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4845A1F000C4;
	Wed, 18 Nov 2026 20:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035237;
	bh=8Jvao30bTbH4WagoUSVd4nmnfYLucpgLuowjSuAE0Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odRDDTKgRm7pViDWEFI1JpebuhetRiN5t5HNSeN54P488vzFJMJFOXb5z8lnmFMvP
	 B+zfjdfAletckYE7vVVDiSW555q3rTpnXc811KybXdsEcZooE1/oOBE/odneIT8Uiu
	 VL53EQRNvTkNbV2ze4pVyecdfMClyXqJV/uS/ap0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0655/3318] xfs: assign an owner to scrub_stats_fops
Date: Wed, 18 Nov 2026 15:21:17 +0100
Message-ID: <20261118150337.686337027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit fe67a493c7a76cf75556152af24285a114f69d34 upstream.

LOLLM complains that file_operations structs for debugfs files are
supposed to have an owner set so that the module can't get unloaded if
someone's sitting on a debugfs file long after unmount/rmmod.  Fix that.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -286,6 +286,7 @@ out:
 }
 
 static const struct file_operations scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.read			= xchk_scrub_stats_read,
 };
@@ -313,6 +314,7 @@ xchk_clear_scrub_stats_write(
 }
 
 static const struct file_operations clear_scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.write			= xchk_clear_scrub_stats_write,
 };


