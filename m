Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046786;
	b=q07DnhUxC702SRlvxeXcpVIPOVD6pRcT3g38LPhpr8fkQiSP92wJb4NhsCGH2O71YtzO
	 CdeDTSOsDMeWm0NuqAcYwdWDiwuebDjrhZp3PD6qznfJUImyDAtpPMQEuyK1CGVZRmlc0
	 jN2VMF9F/+gkrbKZeGhHV/suPco+dUmc5Ur4g6A1zBgk3mpDPbhlJKVcIJLWtvNNmhCyM
	 zGWh3nUY0GizZ2guXJApVH3OxukWm8Ri/DLhbcsrKDAfxc4silUyIjCOcMFjN/d/iHpnk
	 wC7pqj/Znda8v+XsTZjf+vgz/gg5J4YXlzu9620Qpp/DKjEaw2Pdgs7lacJzlL4XTEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BXULTme6ex/kn4Aw/vEHeylec0Ma7RMDKnhlrdo2jfE=;
	b=QRBapdCcOpnkUigKCRcd1e6cssVv1JIliu4F5Mk4WP1wxmnJ5pztvLRlqJ6jkkkviiG2
	 j0MSlqm8O/VSVlzlHPIakMa0A/kmsT6B0JJ9YHAFbscG4G08VJv2OUkExj0h1dYz7ttYB
	 HToWgDnHLIunwyKX33ue8/jb70/59nXjEA3vdbhoj36i1l/s4Bm3Fb/xcv1fUUHiYCopG
	 nApWKEteEw703toJA7D8WHSx9ikgtEuR+8tHhQigVwM/WQQ4lrAzGXkE02MSQks2l6UWQ
	 Q9etZlEUFPr+V9XZ8jg5f3uJRRmY22WlOjZY0EOKp0SLA+oLEWDeWF+peN92hq8KeCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0xqMlaZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D1606A325;
	Thu, 19 Nov 2026 00:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0xqMlaZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475F21F000C4;
	Thu, 19 Nov 2026 00:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046785;
	bh=BXULTme6ex/kn4Aw/vEHeylec0Ma7RMDKnhlrdo2jfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0xqMlaZyKCzJl3yvLADfYoLfECPe+8pufhPACJX4DGRcRV9gLpD/DJvmYDwzMoJU
	 C4Sd3iv1YNDXebV6Oumd6QY3vDtOZA+CBticJZmdlQh2uXL8pQwxEb7F1donXLJuHm
	 5ARzsArJDjM/xdX6I2O34qw5QmCCQKByfJQ0guAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chung-Chiang Cheng <cccheng@synology.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1405/2857] splice: report related fsnotify events
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118150251.933762594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chung-Chiang Cheng <cccheng@synology.com>

[ Upstream commit 983652c691990b3257a07f67f4263eb847baa82d ]

The fsnotify ACCESS and MODIFY event are missing when manipulating a file
with splice(2).

Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Message-Id: <20230322062519.409752-1-cccheng@synology.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 79b496ebe382 ("splice: avoid stale f_pos writeback on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index d0230cf8ec571..30b669aca152d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -30,6 +30,7 @@
 #include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
+#include <linux/fsnotify.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
 #include <linux/socket.h>
@@ -1102,6 +1103,9 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 		ret = do_splice_from(ipipe, out, &offset, len, flags);
 		file_end_write(out);
 
+		if (ret > 0)
+			fsnotify_modify(out);
+
 		if (!off_out)
 			out->f_pos = offset;
 		else
@@ -1125,6 +1129,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 			flags |= SPLICE_F_NONBLOCK;
 
 		ret = splice_file_to_pipe(in, opipe, &offset, len, flags);
+
+		if (ret > 0)
+			fsnotify_access(in);
+
 		if (!off_in)
 			in->f_pos = offset;
 		else
-- 
2.53.0



