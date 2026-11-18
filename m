Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039274;
	b=3mig/z56Tebp3L/G1P82Ej0XUaDLpyIB8t300o17QR9/qaLx/5vWFc67OwSoHEw8slTD
	 zVyLt1ebBb3hZIOYdkfM/KcJqq/9+rguAXObeK0tCA1cak/hGNboQD6Hx2JLOo0Qg5EYI
	 VMA3WTCAtC/4WsyxnvYm1TBp3VZlKEAnij0ORaxNPOMm9LCDzJv8ZPrqs/ausnTdNpstM
	 YbV+/mdi7rfsKJXhB8EsvvXzyvhgVSr/43BpPQM5uFtlKwgiDBBscTBdjjMpf3pQO89Hm
	 iYYdP6F8uV+RH5hlFQ3N393Jf/h23FlSoblZjMZlaFDX4wqA46PcLcIAji7EJdE0skg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VJ/4LeUkOVUB8s1sw2WA4VoRi2lLO43s5Fy0RekjdmI=;
	b=pjDROsGTBOVkFQ9/yUxqrTeWPnBOM8hcSmgw0To/2q1nbmHrd/1D5MM0v+XOolld+y/x
	 eEdapdk83gisJuan23+itqAy4rKGMnfKTjzFMlcbFWLIYC2YiMs2RXUZyd4zjMMMhWnw6
	 dq5KznFkk+R4W3AQE2nRB+JoCSZJokF6h+0FmhHeMdWLmcYy8kre5XMiND+jTDwut7Pzf
	 Rop74SLWSghF+tDWpC+UktkHAbZx9/b4s/b0GFCxN5S14X20SCm0FehQBgQ35B6GLJ5eD
	 WwSZCcTYSKWJYFTnHNkInjJeUpYI/RlIO/SEAh7kiXAOe93WWblyNvI6TYOPsUtPExg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uCTa9+Zn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CE1606A320;
	Wed, 18 Nov 2026 22:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uCTa9+Zn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1501F000C5;
	Wed, 18 Nov 2026 22:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039274;
	bh=VJ/4LeUkOVUB8s1sw2WA4VoRi2lLO43s5Fy0RekjdmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCTa9+ZneITnVhZhDY0BOYgp2GyeckHB6JgrWvhhv4LXXVy4qhufFPTuwmgX+0nnH
	 gs236cNHsEUSQjjN2gU2VN/vSG0h7KqXrYXNF2lp4RqX7WJeT79m/dhZhXCJXq8VwC
	 ZtcVW+TjZ0tdHWmFHRs7ZcY1uRy/+NQvlkGobQ68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2041/3318] bpftool: Set BPF_F_XDP_DEV_BOUND_ONLY flag non-destructively
Date: Wed, 18 Nov 2026 15:44:23 +0100
Message-ID: <20261118150423.274370618@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90fa7a8d0f4b3..43419df690b65 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1709,7 +1709,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 
 		if (prog_type == BPF_PROG_TYPE_XDP && xdpmeta_ifindex) {
-			bpf_program__set_flags(pos, BPF_F_XDP_DEV_BOUND_ONLY);
+			bpf_program__set_flags(pos, bpf_program__flags(pos) | BPF_F_XDP_DEV_BOUND_ONLY);
 			bpf_program__set_ifindex(pos, xdpmeta_ifindex);
 		} else {
 			bpf_program__set_ifindex(pos, offload_ifindex);
-- 
2.53.0



