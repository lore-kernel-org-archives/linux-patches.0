Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617882;
	b=zGFVTsTqayq0UHNUUj7Xal/p1T4hqX1wXiFest4Pb6rwfVZ+8KcKVMK9Bje4yPNp3mG0
	 kBQ6vg/0HBsdfxvczT855zYDaS7UGfU1sGJKsB4I6XxJM+wKVvEd8ae4tHpWVsDAAs/t8
	 kiAu10IYOuZgdP1AGWCx5dOha902IbHVZebvAsW7ZMsYEfnd7FYlz8iUcgno7mWZD01j5
	 o89qr7MOiwtAgTIcMU20wi4I9TciTGOibNTrtDvUrYmkUmnt5rFweEAQUj2t4xUaKWI3W
	 V2rVoRMJMmnKp9n5WJ7I1QVNMkpT7+bB/pc/j3eWzUdvp8HooATp7j/gsXTvJL5VtbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gglje0zxPcunjOpzGCJtr8wjvOfsfFR3KCjKVGRJzLc=;
	b=eXabZ3Vi04Wq1RRg9xTzSyGjh+Rx/NlqMlls39kIXhF3smUzjPs3+BDYDiGcJRkmxXMr
	 yTAx0p+Z9tgsH5Rdz6NE4db45KOrrtyTt1YjvOQg6cn5fLVS9GjMG8Mx77Vb/O+YifASk
	 kykga8/AJQf98SK1kfTLV6HcZbgPKpvz+c0ZrQX6MRf5q7bSlLtVHsO2yT+tKQLYeoD+5
	 fgwIS0+C6ThatAD9Ko1EpjToOUidZOzDpnWucc+G3y4hqOVn6YmlI5bkHBHXJqZFCNJJG
	 7obv8t8HVO33QcBx496MA2/0Jq7Tnh+xxZX7Nu9icLm45hDbWHR8QFj7ynJ1YzyWTgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2BSkdCF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F658606A323;
	Wed, 25 Nov 2026 14:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2BSkdCF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4271F000E6;
	Wed, 25 Nov 2026 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617882;
	bh=gglje0zxPcunjOpzGCJtr8wjvOfsfFR3KCjKVGRJzLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2BSkdCFWG9BDWdc2kCgH/a4JbaVdT6HyODbXIwz1ZZudMWHoIYyteX+/nja8otc0
	 VQsBeDpq/f9APblK703Ct6eouGL9vTsiLkhGAzPR8+AyxU50ErXjFSzfu5iXzmpHGG
	 n5ggWRrBphjB4nnvnQbwFLmy9dve7oilqC21fv+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0104/1005] bpf: Require prog fd or capability for cgroup detach
Date: Wed, 25 Nov 2026 15:24:02 +0100
Message-ID: <20261125143824.182227205@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 2962329f7c86fc51c177d4049c0f15a95ebd270c ]

Since the commit below a cgroup prog detach does not require CAP_NET_ADMIN.
The fd of the attached prog gives the permission instead. But the detach
requires this fd only with BPF_F_ALLOW_MULTI. Without this flag a cgroup
has only one prog per attach type. Then find_detach_entry() returns this
prog and does not compare it with the prog of the caller. Thus the kernel
detaches this prog for a caller with neither the fd nor a capability.

Compare the two progs. If they are different, require CAP_NET_ADMIN or
CAP_SYS_ADMIN in the initial user namespace. The error is -EPERM. A detach
from tcx or netkit without a prog fd already requires these capabilities.
With BPF_F_ALLOW_MULTI nothing changes.

Without these capabilities, a caller of bpf_prog_detach() of libbpf must
now use bpf_prog_detach2() with the fd of the attached prog.

Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-14-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 149672c76c49c..84a3d9cc52b76 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1125,9 +1125,14 @@ static struct bpf_prog_list *find_detach_entry(struct hlist_head *progs,
 			return ERR_PTR(-ENOENT);
 
 		/* to maintain backward compatibility NONE and OVERRIDE cgroups
-		 * allow detaching with invalid FD (prog==NULL) in legacy mode
+		 * allow detaching with invalid FD (prog==NULL) in legacy mode.
+		 * Without the FD of the attached program the caller needs
+		 * CAP_NET_ADMIN or CAP_SYS_ADMIN in the initial user namespace.
 		 */
-		return hlist_entry(progs->first, typeof(*pl), node);
+		pl = hlist_entry(progs->first, typeof(*pl), node);
+		if (pl->prog != prog && !bpf_net_capable())
+			return ERR_PTR(-EPERM);
+		return pl;
 	}
 
 	if (!prog && !link)
-- 
2.53.0



