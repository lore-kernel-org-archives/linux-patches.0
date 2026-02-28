Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94FA33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301138; cv=none; b=QXK7rAInqiqoPBqlPgcJj4FYUwM3aecLOLtetNZKTN67H2PWAs7nv/yFsJGxbnarBo6kXUM3CZBeq/zzsHiSG1S4LinErysRRv6UGZK3S49MNwM6LjhX551vtEXtjfePyfzeaPGZi7pucC+nCloaUh4EWeazV9AARSjWD5Xoza8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301138; c=relaxed/simple;
	bh=5rN1791otkXld9s0yk37EK1HmhIuksVPV/oWgb5wLiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGkBlQnV7+SbNW1MvYfvtwwMdB8OpAF7oFEpmF24wF9jpC7V9BnFdPzpIYLKGL8Un2G4y2A13JCkrMYZWmfmkXWsGnk2O4dVTe3PVae4HzgRO0PB3Xl1iLhXg+DdPAI8wUFs39f524/ht4ARaheUMLYd9eIPctHEDpnZhUeAikk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngVw4ibX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngVw4ibX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4A8C19423;
	Sat, 28 Feb 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301138;
	bh=5rN1791otkXld9s0yk37EK1HmhIuksVPV/oWgb5wLiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngVw4ibXqmJQwdH+HfghHCF+tXorywnuqAAh/PmcwjZLmWFBGJv4XouNMh5oayGEs
	 s4YuG+c8b4k8i31ZPuSnPU+Z+MrbwPEDWNixlKW24B4dhvvuCAMOJ9Hha4peq7GTpY
	 FC4BucDctyO0At4cHiNW00/obuzR4EylEA7jP7jZQsm8s4jaRpyB9Qvw8lkT9g3Ah7
	 pZuvGYSwOMMkkD1ONqb2J2GGGw8MCEZVunc4LDEIq6HedOD/PBy8FhiKlwHqVRZmwm
	 iXL6CKLj9YDfUogyktP0cfQnCZgObQitMKLj7tgnPjZupS4DfFPItCnTXxvW2sKsjw
	 MVymfaP+g6Ipw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/752] RDMA/rtrs-clt: For conn rejection use actual err number
Date: Sat, 28 Feb 2026 12:40:10 -0500
Message-ID: <20260228174750.1542406-299-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit fc290630702b530c2969061e7ef0d869a5b6dc4f ]

When the connection establishment request is rejected from the server
side, then the actual error number sent back should be used.

Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Link: https://patch.msgid.link/20260107161517.56357-10-haris.iqbal@ionos.com
Reviewed-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 2b397a544cb93..8fa1d72bd20a4 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1923,7 +1923,7 @@ static int rtrs_rdma_conn_rejected(struct rtrs_clt_con *con,
 	struct rtrs_path *s = con->c.path;
 	const struct rtrs_msg_conn_rsp *msg;
 	const char *rej_msg;
-	int status, errno;
+	int status, errno = -ECONNRESET;
 	u8 data_len;
 
 	status = ev->status;
@@ -1945,7 +1945,7 @@ static int rtrs_rdma_conn_rejected(struct rtrs_clt_con *con,
 			  status, rej_msg);
 	}
 
-	return -ECONNRESET;
+	return errno;
 }
 
 void rtrs_clt_close_conns(struct rtrs_clt_path *clt_path, bool wait)
-- 
2.51.0

