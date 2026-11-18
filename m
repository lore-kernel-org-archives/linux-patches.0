Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015455;
	b=OmvgWSOeEUkWKst08QKTtkKR9LgnG8lZGEXM7NKPt3wx1iGVGPZFI9JQ61uVSAv0DSBk
	 Vb3odc8qavrAaEuoEPeq1vLzr7hU6yBPl+MZ6wxGgtmebnkQMpmqeNufdxX4J4lqFY4LM
	 BDg5eLrd/qcmq5cqCRJX567EeRSMvmN6kcx0BVyEA18dLU5J2BQ4gsUU1OiTEybPnX6gR
	 FlUrpZW2Sd65X93iOIrsxqnUaKZDJEm+JujXEQToFufeLK7mCIsbuaee0qQFlc2EsqzW/
	 YzQuDzMJCKQEr2PE7a69V1QnjUyJzP4dKvhklYSEZCKKqS3CdpEkBEShvAs+I6qE3DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CPEHp+mOLFtV3w4FgrLjEAO9Nk8YvR+GrSXpAQ7n8tU=;
	b=d+YqhP8mCUnV7ng3Z3yz+tDwex2vSGYuDGGz7KFiAgjr7fC3uv5HGZsc+5k3s+zWh9Z7
	 vrek9nz5YqzIdmLHVjAYMpqfYNZDFV2hlVD7eze8mb+q9myQwzHvrJEPy1K6Qyjk+7B7I
	 94K0SjaAgJx/Ww8zyTHSns+xZjZ1sCLBDOBEGJY+YcaBz3Wg8aKOCleawmXWzxHw8IX4+
	 01ZwqhI7w4eXVvxE8BL/YqTq02gAWmib+/H87OrUkz5/vzpADhBFUzo7ekTEo07re5zMz
	 dBIcDjSvG4EmVyXkc/pz3lnEJbeg5XqrRynSIRu6zCXLfTxr8mauA97ZpWbnBGszePg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPBMDrOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E9A606A325;
	Wed, 18 Nov 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPBMDrOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57AC1F000C4;
	Wed, 18 Nov 2026 15:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015454;
	bh=CPEHp+mOLFtV3w4FgrLjEAO9Nk8YvR+GrSXpAQ7n8tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPBMDrOfsP6kQdpnixlHSkLOTesnpzyNupNU0Pb21s9rqz1KIay+YbUAsxbGfgDks
	 tOL3dKCL5LVr9IaWR7hz+I9l4zLGrJORHXeFJilfMLsK/fAf9TIg3bNhUECwUrcvo9
	 dBjmdfTuk6QpxmWPHi9Ciwvf2RkYFLWFPqbzB0So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0179/2651] bpftool: Set BPF_F_XDP_DEV_BOUND_ONLY flag non-destructively
Date: Wed, 18 Nov 2026 15:23:39 +0100
Message-ID: <20261118150254.310037450@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 06d6f845c4bda857a6ae864690f35321b878e827 ]

When setting the XDP hints ifname, bpftool would set the
BPF_F_XDP_DEV_BOUND_ONLY without looking at the existing program flags,
overriding any other flag values. This was always a destructive action,
but after we change libbpf to carry the frags section flag in
prog_flags, this can impact bpftool loading of XDP frags programs.

Change the flag setting to be non-destructive by OR'ing it with the
existing flags.

Fixes: f46392ee3dec ("bpftool: Specify XDP Hints ifname when loading program")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://lore.kernel.org/bpf/20260901-libbpf-frags-flags-v3-1-4eb6f14968b0@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index a9f730d407a92..8c2f9255b36d7 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1769,7 +1769,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 
 		if (prog_type == BPF_PROG_TYPE_XDP && xdpmeta_ifindex) {
-			bpf_program__set_flags(pos, BPF_F_XDP_DEV_BOUND_ONLY);
+			bpf_program__set_flags(pos, bpf_program__flags(pos) | BPF_F_XDP_DEV_BOUND_ONLY);
 			bpf_program__set_ifindex(pos, xdpmeta_ifindex);
 		} else {
 			bpf_program__set_ifindex(pos, offload_ifindex);
-- 
2.53.0



