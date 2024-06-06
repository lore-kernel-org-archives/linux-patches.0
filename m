Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA8197A7F;
	Thu,  6 Jun 2024 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683006; cv=none; b=Gqzypv4da0y/DZYOzfXDMzHZeBZMX9VfP94exxdePHjxHe4WJ+MFy/IXZ/E458K4F+iRE4L1Gn/R+4AT0m4x1Q0hTEN+d4TKpsplrc31AZaWfgfSv4HFDA6z2NwcKvDzvVeNlHV6gwbdUc67RdssJjo7ldyKrDY98oYaJ1RAeN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683006; c=relaxed/simple;
	bh=zc8Co/DP+RL2v5RUsTt31JDi4LxByYSvfWVKqqZEuhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOEjnO/5+Al4KwIXrRLOL+He/NcInER+hop0lrMW80p4tInOgxYVP3ZgYULiHKoas8lubJkg1C7Kr4letJpDDwjSCccSsZgZVAnQRd4Xhp/s75GS9mhfVsQc6cmoQxtqnNoY9oGGaNB2CDxPh1Bl2gCELn9IeheTQ0JLu8Djzso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB9Oq8/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB9Oq8/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F471C4AF09;
	Thu,  6 Jun 2024 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683006;
	bh=zc8Co/DP+RL2v5RUsTt31JDi4LxByYSvfWVKqqZEuhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB9Oq8/5TZD3yZoexQB0qlj9qHtsl08oILerh1jwrguvwW+zDMGynMpBy7zSOMfM8
	 2S2FTYeIekiLmSKQ+wmQAGJoRx3YngsPpmbmnzubDkwlcdBsp4LNfdukX5cgjaYiYY
	 lZPo/EwHg38cYhaJHiYzNWIGOPVUEEMLZU553l80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 213/374] KVM: PPC: Book3S HV nestedv2: Fix an error handling path in gs_msg_ops_kvmhv_nestedv2_config_fill_info()
Date: Thu,  6 Jun 2024 16:03:12 +0200
Message-ID: <20240606131658.943979110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b52e8cd3f835869370f8540f1bc804a47a47f02b ]

The return value of kvmppc_gse_put_buff_info() is not assigned to 'rc' and
'rc' is uninitialized at this point.
So the error handling can not work.

Assign the expected value to 'rc' to fix the issue.

Fixes: 19d31c5f1157 ("KVM: PPC: Add support for nestedv2 guests")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/a7ed4cc12e0a0bbd97fac44fe6c222d1c393ec95.1706441651.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_nestedv2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
index 8e6f5355f08b5..1091f7a83b255 100644
--- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
+++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
@@ -71,8 +71,8 @@ gs_msg_ops_kvmhv_nestedv2_config_fill_info(struct kvmppc_gs_buff *gsb,
 	}
 
 	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_RUN_OUTPUT)) {
-		kvmppc_gse_put_buff_info(gsb, KVMPPC_GSID_RUN_OUTPUT,
-					 cfg->vcpu_run_output_cfg);
+		rc = kvmppc_gse_put_buff_info(gsb, KVMPPC_GSID_RUN_OUTPUT,
+					      cfg->vcpu_run_output_cfg);
 		if (rc < 0)
 			return rc;
 	}
-- 
2.43.0



