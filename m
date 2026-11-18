Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022984;
	b=47+XjvFdkSH4YcD7w3Ons+Qvj9J4nzm489h5KJlLEK3Hjnqx0FdT2RV95m1WX/bSz9t2
	 C2XjbrkXpgUsjfsjrT9phrygIrdJv7or6T1O7p7v5oHQwBdaskGb1mEwDllsdW0keGBbJ
	 4NOaz7sNKJF/+GfhraXXgp9J7166/rgkeOkVFxo97yIud4c3bROEnXdiT9VNzXO7Zj+0O
	 eedyzoVyvTz1CIcytMiRBy6NFDtENo0VC/WQYoLiDThpcrtyraMcWH9bsPMygedNq5ANC
	 ImBBtE0P5WWdJ0yBSBu/yLdg9ECgXuTiIGJZmhgYTh81W2szydywDXNhfZG381k/S+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vboQe7ZR13xIl3IDog+n6gEkbIoN0rnb3C1VM9kn6ws=;
	b=IaeY6GP2/b0U7TNLmbRU6yZP+GR97hE8VNW6BR9u8Olib57FQSBG4+YHolQF8vNdpJNt
	 7URcDs+73VHYpFjEmmsVdVW++uHWdRgMbn2ABcxvcF4ptJ1UXvezj/9Yw+kKLEaLTAYdf
	 ExMWuorBTAWBMrTPn3pHoPzVTvy1fppOpVu8bxrzkqQbJ8392MZUulpWl7SB9/WdVX4nF
	 v/4MuxeDtlQMz0SxQdDXsgeVAlJ/0n5uXSdJUckJrH3p0VCrs9JtPNmCeLdbqrIAkEqaE
	 ugXKI6g06ArLHmnWnUSKG73M0sBbv3l89oYZUWi1W01HsyfQEKbArbq7fjKNzBCtyQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkZeCJf1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17BF606A31C;
	Wed, 18 Nov 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkZeCJf1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62111F000C4;
	Wed, 18 Nov 2026 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022984;
	bh=vboQe7ZR13xIl3IDog+n6gEkbIoN0rnb3C1VM9kn6ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkZeCJf1ixMrj7mGnN2ESRJ+uDry4gVnyUEZmje2IC+tTy+kiiIWEZW91wAp1U3Gd
	 O4YPRGBnJa0qY1h1UpnQPvDzlG1xQuz3FDR2WA07+6U3H1LeoO1CezVAAm7anNjwIh
	 qw695K6YfO0bpJofhGEDSr5rP068m+6N/Msn7Gwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0207/2151] bpftool: Set BPF_F_XDP_DEV_BOUND_ONLY flag non-destructively
Date: Wed, 18 Nov 2026 15:32:22 +0100
Message-ID: <20261118150129.322267077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6daf19809ca4a..86ea90cd45408 100644
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



