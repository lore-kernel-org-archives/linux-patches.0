Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029052;
	b=w6K2tbrdu6rs7FMhdfYo5kQC0OUYp42YOjuQeqtoymVelj4myb9Ial/3GcHgGY4zSnm2
	 onxe4NrGvw/r0JLD00899o6OaIVBO1UlFh+4zOFV/+SMPlHGtrUKCZhFfHeFiQ0SClN68
	 Zhd00SnHK25PBkJhj1lDsO84Uc0kGR2PAM4mdq4rauWAmQkFjSlBTxwX89sqAODU8MgjC
	 Gl7nSAxYqLqHxXfvcSV+1t4ERst90KXbeXOBQtbImaWYGMRGhbbHMXk0DX6iTqHWvI1T0
	 qeZL47Y9evm6cmsG4q3XmXtxEa4JCND03W32638pODAn79JX60nQCWcaW6g9FMU6Bjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T4s2ZYqr5DBqBZyuJteCr9hrKGLj6r7q41k9o2xrg9Y=;
	b=xtzWZvBclvXR/X201KpREMbHwq4q70HotpDkVopQhaAM0DmINr0bHsM+YvRzFfvKqctF
	 IHYnW8ucK96VcF/6aIlkZ+YJmSnTxvKTBRuEjoWzE/m1HOvgBG45JSCtFSghNmnP3JXyE
	 tD3VTBwDe+hIMadZzPnXMFjOtxRACmFBc0sz7AAgJNgeYmDxluYVg6CIhe3A9248eU3ox
	 p3c0UQzTejGsj2qppygxCd17Z0PgzmFgbrqMCG2IdOd8mArWn3FLkR7JthCoX6P6bEzUS
	 QJYwMGP277mGsrfwteXXxkP4GhiF0c7wqYtzXbwoTRA6hDh2yHqpG5oXrVfikh2RaKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYlO0w13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23313606A31C;
	Wed, 18 Nov 2026 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYlO0w13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B7B1F000C4;
	Wed, 18 Nov 2026 19:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029052;
	bh=T4s2ZYqr5DBqBZyuJteCr9hrKGLj6r7q41k9o2xrg9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYlO0w13gtYuShI+2e96dDIo01c4Hu2+UvlCbAvjiY65oDMsDp06mKmGp6oYa0eLk
	 fxZW+Gv0KpysTokaYUf9+ynfFUtsF6kqxe1ACyYZB5M3MWYWHYpMbLCHzgf2Xnm2Ch
	 kTx58tNqF5MRzrhZ09G11Y5FY4xWUwkrfRA8Tkjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0210/1756] bpftool: Set BPF_F_XDP_DEV_BOUND_ONLY flag non-destructively
Date: Wed, 18 Nov 2026 15:38:57 +0100
Message-ID: <20261118150016.708111935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e095a3afc046..ee91c256d4fbd 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1713,7 +1713,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 
 		if (prog_type == BPF_PROG_TYPE_XDP && xdpmeta_ifindex) {
-			bpf_program__set_flags(pos, BPF_F_XDP_DEV_BOUND_ONLY);
+			bpf_program__set_flags(pos, bpf_program__flags(pos) | BPF_F_XDP_DEV_BOUND_ONLY);
 			bpf_program__set_ifindex(pos, xdpmeta_ifindex);
 		} else {
 			bpf_program__set_ifindex(pos, offload_ifindex);
-- 
2.53.0



