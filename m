Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA9633ADB0;
	Tue, 21 Jul 2026 19:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661440; cv=none; b=QfiC4KN3WBbyFNubkxcIEA1d2HuqobCvbLg/mzo5y1ZBQMtHIKOpAOu03Gnf1huCsJtRH6ZE7tQohQlyrqOme8dh7iCnKSnilREFbOHNb1MyPV+IhM5nl5nlXe4R/9b0yBY2myyU4/wmHbnq+4Vmxwp36GRoJhX8mrapOWalnNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661440; c=relaxed/simple;
	bh=0RTRjRVrpBDdKrWgBXW/o0EwClitZcsGfk+7/1/c8SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU5Nwosa5x+H/UDDI28mh4yOfJ6MlMN/77SIJS7rwrMJapnVly9MmDXdvcWRP7F9ktPRVOF12UlQw+2sDMjbDS1b3IixVHC3ESGb2V2hUGmUBJxd4xyFKcMB0iKK3F5/wPk9mQWhHlOV6/11ThaXyO2HPV2RHIGTYb04RLwKKik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0omjLFbF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0omjLFbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681801F000E9;
	Tue, 21 Jul 2026 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661438;
	bh=uEEz0ZZIJhHo9X10cN7UIdGmRLZ196melIaYHOTrNB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0omjLFbF8dDx19pJwr0cDBOeQ5tDO3vt04Lkg/rPOgXe3j+jDY/4HcUzSaLf+Do7+
	 49TVXB65Kl79F1ccW+WSrLww21OzOFuL8TfnRkKmpdT7lbIpPF1XZUHQ+kqEuRixrI
	 yhHy2oOc0QQWm4RtRVc4iK52oKIQcpgP1koUlbWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Bell <grbell@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0067/1276] selftests/bpf: Use local type for flow_offload_tuple_rhash in xdp_flowtable
Date: Tue, 21 Jul 2026 17:08:30 +0200
Message-ID: <20260721152447.587348980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Gregory Bell <grbell@redhat.com>

[ Upstream commit ac985e7bf840e34a8dafe0808cc571fd85896c30 ]

Define flow_offload_tuple_rhash___local and use it in place of the
forward-declared kernel type for the bpf_xdp_flow_lookup kfunc return
type and tuplehash variable. This is consistent with how
bpf_flowtable_opts___local is already handled in the same file and
avoids relying on a forward declaration of the struct.

Fixes: eeb23b54e447 ("selftests/bpf: fix compilation failure when CONFIG_NF_FLOW_TABLE=m")
Signed-off-by: Gregory Bell <grbell@redhat.com>
Link: https://lore.kernel.org/r/20260417154122.2558890-2-grbell@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/xdp_flowtable.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_flowtable.c b/tools/testing/selftests/bpf/progs/xdp_flowtable.c
index 7fdc7b23ee7498..e67daa02749d54 100644
--- a/tools/testing/selftests/bpf/progs/xdp_flowtable.c
+++ b/tools/testing/selftests/bpf/progs/xdp_flowtable.c
@@ -15,7 +15,10 @@ struct bpf_flowtable_opts___local {
 	s32 error;
 };
 
-struct flow_offload_tuple_rhash *
+struct flow_offload_tuple_rhash___local {
+};
+
+struct flow_offload_tuple_rhash___local *
 bpf_xdp_flow_lookup(struct xdp_md *, struct bpf_fib_lookup *,
 		    struct bpf_flowtable_opts___local *, u32) __ksym;
 
@@ -67,7 +70,7 @@ int xdp_flowtable_do_lookup(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	struct bpf_flowtable_opts___local opts = {};
-	struct flow_offload_tuple_rhash *tuplehash;
+	struct flow_offload_tuple_rhash___local *tuplehash;
 	struct bpf_fib_lookup tuple = {
 		.ifindex = ctx->ingress_ifindex,
 	};
-- 
2.53.0



