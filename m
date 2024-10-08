Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF0A1DE2AE;
	Tue,  8 Oct 2024 12:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389660; cv=none; b=uR6qNX6ajREZm0iMQIDJ9Dt6rg+yP4GOxWCgRUozUOLerRQE24wYbFNZ/D5YLuaoUc0WMO7XO6ss1M2df0/11GPxfVnABHJ1XxsNCFwi2WsoZPQjKAqYJpH9COepvnKK7ravOGoHye59FNYx2nwVh/O7OQ3ZZvXAS7Ep8FBl/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389660; c=relaxed/simple;
	bh=qpCMkQXOH16CCqDfWyG0KcvBC926UwZo7bswy7605vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7ypVSmAkWIn/JBNkKGiLwmim29g49s/K8Axt/CG6ef28OWUHXRFsSCFwlUA4pnEKX49tVdipritXJwHXjQGLmNN3Bzn9fsLBm3+y48q9tJrN778eU5WB2x2s+fnIji1RJgYZjCmQzv4YGU4hvts+Nv0BV0Aj7qsW5y5DSHYb+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbA3OZjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbA3OZjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869B2C4CEC7;
	Tue,  8 Oct 2024 12:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389660;
	bh=qpCMkQXOH16CCqDfWyG0KcvBC926UwZo7bswy7605vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbA3OZjXQ7q0MEujc1UXNL+i7GjAy5yn+q50ewyaunzGzqcPJNNZKGWUuu8uRB7oP
	 a6jkxepE2+hq07ig1oIjKuliBGkLIGAxSwNDt31Bil3cR/KRwjmoSDF5ZMf2HhRW1B
	 NcD5CwUlJKnxBSFB/CDQ2r8qzetPwDTya1DH1g5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 027/482] selftests: netfilter: Add missing return value
Date: Tue,  8 Oct 2024 14:01:30 +0200
Message-ID: <20241008115649.368373998@linuxfoundation.org>
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 10dbd23633f0433f8d13c2803d687b36a675ef60 ]

There is no return value in count_entries, just add it.

Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index bd9317bf5adaf..dc056fec993bd 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -207,6 +207,7 @@ static int conntrack_data_generate_v6(struct mnl_socket *sock,
 static int count_entries(const struct nlmsghdr *nlh, void *data)
 {
 	reply_counter++;
+	return MNL_CB_OK;
 }
 
 static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
-- 
2.43.0



