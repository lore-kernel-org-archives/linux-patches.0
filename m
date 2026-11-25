Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618676;
	b=WRxFmL2iUuwR30WWc2YJlDHK2lrCbLO83Ui+Z/zYBHbh7j4Ajnj9fNhTnCfdKfPBnEaM
	 4kwlax5CVf/5xze5Z88EZNyAHQbByDdy7tZO8lMk2rH0ANPmgDlIG72OpxsHJgMEt/Z8W
	 2h995paUWym8jke+jaEu34GqCpcBLYQd4+z3k23DF10crCXgHQePZ0iEY9nZb0/myERHn
	 LsSiGh6hC2lzwroh062iWgA8gVv8jUOKuaTcRI0XxNqQVl6KlYxGDsSWzv4i3p3J+QUa7
	 x/kr1upSbu5zthoquSLJapnc1iwPmID2yF+IsYNfyxEPMwVVo16s2IYU5xqr7BmOE4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zraTapeyT3SRhuDReZHkLV7qpR2qfbV9RiWMvQdXLT0=;
	b=u5wyRn4rIMFnm+4Crzr4/8UYH0brEnhLBUk/ebTarIzdGjQy4wGJcnhC5FtdqF/UKkcs
	 HLwtTrq+qPs5TtmJxm6dz4BlhcVLnhULHMyh0QOQLhomjxJQZvHzToH6smhAxeoP63nOR
	 GilEvcIqMJust37f+VI1dg8fqwvuAJU58FR6n50Srn1TCKuHHCDcA6xMRiGpr8hIHGZp/
	 pjObLsG5dnuAjeKOlgz7GPUJqPp2Kc2jJf+5k0ghqvsx07qgiNTJNBR5aDiLNiZt9ucfr
	 VQfQtvR2gesW7jBmwjHJNJC4UX5RFwmqcuG0d1/aKqup1Qev5mAKY8BLtFuSzC7SCNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJ3jFePN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04324606A321;
	Wed, 25 Nov 2026 14:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EJ3jFePN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2D91F000C0;
	Wed, 25 Nov 2026 14:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618675;
	bh=zraTapeyT3SRhuDReZHkLV7qpR2qfbV9RiWMvQdXLT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJ3jFePNU7gGrSQCJv984u2icCj6DLHqHiVipXHbs5rGsq5sfl545OjpkAY08CIDj
	 i3Bf8w/0TQTQ2wIF5rzFBDLrwdAp2zgpEGJMTHHkYNzRyt8LFwLGYXDXKNnfeYPghR
	 8T/HIh1yWqz3DI5Gs5Toc+VIk8qnGboxsMcI07Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0352/1005] net/mlx5e: TC, Fix double free of branch in failure
Date: Wed, 25 Nov 2026 15:28:10 +0100
Message-ID: <20261125143829.979725325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 31f9b43a3bb3d2201eadd147440252d0912dab21 ]

When allocating the false branch fails in parse_branch_ctrl(), the
already allocated true branch is freed but attr->branch_true is left
pointing to it. The caller parse_tc_actions() fails the flow, and
free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
free_branch_attr() on attr->branch_true.

Clear the pointer after freeing it.

This bug is theoretical and was compile tested only.

Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Tested-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b290beb4369ad..c40c7b55a54d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4005,6 +4005,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
 
 err_branch_false:
 	free_branch_attr(flow, attr->branch_true);
+	attr->branch_true = NULL;
 out_err:
 	return err;
 }
-- 
2.53.0



