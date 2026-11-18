Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021121;
	b=Ny6krpofsD2ysnctfHyz834TrIlI4OaM3Wc/G+K++Qe/3C8uUjVVfKZGTYdB/Y8iJttY
	 zrfyEslIhMGspFCXigCJOIngXNpaJdln+XZF0EKxbk6H4o+erIGVaHFgOH/RRwErDrNLi
	 Llznx8qRgY+mmW7OHENozSpIUInQbTfWSbbyANo3h1ggOFhxclXt5W1QDoUxpX5dZyNt1
	 Kr+/xaEnEjd/m7gT5U6t6dqXUnnD9v496JDfz/fDuJJoUvdbVD7waeWpAtPysiiu4TC56
	 RNIAMDlNKZFSBVC7o5F3EzFwpoRuuLxAUULIL2FLVtFaK7H5Jc8cmCGPoC2mDwGBPjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oLElMP3n86M40EBOvlBov8n3q9Uket79Pj8Dyb/gPg4=;
	b=HviCC4nJJlc8VfLKCD7ygj7QAfluEGq30auVsrFrNtHr6f0fHVKL3ygaOm1aNpeo4aJn
	 YzmXl7o9a14cIieq5X46nHcm00vlEFfehPY7N/B/AEISkMsvEiw0uka6aCjFrDnrpN7VE
	 Kr5ZstV1XVypnnWHNkQb6rt/2M+G1S1f/HWSw7XyyX6gZGZfTZcRvKrHu2Keen8eGqoGO
	 DBZmQeC/bYo7c+w1QHNe/o5PAPVlhLoHhVFiBC1DwKT9kdFewUw1ZrVRsFVp2FITXVmrC
	 Sk1jHmwicS1Iuk/a5q87lY9PpInHokdWWJ6jBPyRBhxRlZnCjjYjFxLoOPg1PzfDhWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOS2Fm9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A47D606A31C;
	Wed, 18 Nov 2026 16:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOS2Fm9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A021F000C4;
	Wed, 18 Nov 2026 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021121;
	bh=oLElMP3n86M40EBOvlBov8n3q9Uket79Pj8Dyb/gPg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOS2Fm9+2ulKs3ZDi718IlVTzZr+cvir1muu5wgiKZ+tyIqGw2IAzBt34O8mu1ekK
	 NqieyhBFDKz5XPbqVbRRjhSw9FYx1XuqlcmguFbFFuc7EUXmsDXQbhzpZOp5sT5P94
	 +mC9dO9M2dvuVeCRowae40YWMso5+EOHFSrQMZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2195/2651] RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler
Date: Wed, 18 Nov 2026 15:57:15 +0100
Message-ID: <20261118150404.751993288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit bb75e5580b15cd23ededf15683a5ad67d7b61aab ]

In MLX5_IB_METHOD_STEERING_ANCHOR_CREATE, the user-supplied u16 priority
is passed directly to _get_flow_table() without an upper bound check.
This can lead to out-of-bounds array accesses on dev->flow_db priority
tables.

Check that priority does not exceed MLX5_IB_FLOW_LAST_PRIO before calling
_get_flow_table(), matching the existing validation in raw_fs_rule_add()
and mlx5_ib_create_flow().

Fixes: 0c6ab0ca9a66 ("RDMA/mlx5: Expose steering anchor to userspace")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261018144907.20123-1-serhatkumral1@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index e63fdb4bc3e3f..bc2c15c7172ba 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -3014,6 +3014,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	if (err)
 		return err;
 
+	if (priority > MLX5_IB_FLOW_LAST_PRIO)
+		return -EINVAL;
+
 	obj = kzalloc_obj(*obj);
 	if (!obj)
 		return -ENOMEM;
-- 
2.53.0



