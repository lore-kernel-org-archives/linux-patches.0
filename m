Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623937;
	b=ZW+Nf8dD9DnSze6UehwA1qQ4mBDBdFqVxHXtBtqTza2J3tX24DHI3CNYW7/Wrk2LQuJB
	 sNWMuC50T0y2Ubp7DRSgX7wFoGa9O+TQUA6DAb+mUKCybwttCF8hVFE8so2+HSlZnYFnq
	 mzxPVUllco/EA0b6/DCEE0U7rJOwiodxYZ/xF0akDw4m7nxeN30KbsFXmVy0551Lg8FmZ
	 6E9+VYTSy6x9wRuoIaxP0dI5w/ZdBl37N0FHe3FglQB3gCxrxNKOMsEFhcb+NMGVx/q6f
	 aG9i6Yc7jwDH/QLTEXedW6BD1CS+Nl8gvnlA4/yJipt4Vhey2rTBDEigelIPCjAZJzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KL2CiuggNKOcBnAhg3sJTnHDXEPnWbnziVsWNp6EHLw=;
	b=D0yTvrylMg+aTVPBKW9ZvFX32aUi/rFQVrxK2wvISRa/u8sZy/reTa85T6+z6uuu84SK
	 mjjQ17jz6W/r8GCg9WlZb0S4VCwMGKr5/lhWRTPtAgft/pjluO/yceWGFcsI/GvDde0bM
	 lk7SJuvLIUjZBPHctFSaua552M2GJ1dKn38YyGs4iwOIJ0KS4M2RhfERnFf6j4OOKfOrz
	 YM//O7kmHYQNya8Z1JNY4MWWZXq33Oq7vVs09Vj1NmVol+1JGvzcVIZXvAeXsvz3q9AjY
	 8nxMmvVhn1yJV/9nGvxItz5/6eMqSAvsF+nTtYjHk4q0/AVjd0+z2pmP28szs3q/mgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1osJewOF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72415606A321;
	Wed, 25 Nov 2026 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1osJewOF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E41F000C0;
	Wed, 25 Nov 2026 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623937;
	bh=KL2CiuggNKOcBnAhg3sJTnHDXEPnWbnziVsWNp6EHLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1osJewOFAD3qQ3QHPWAzD2dJvSaj5+5UjUOwbJiN2BDPizrp/uVU4OW8CeEwV20cr
	 rGexY06n5uq5J5UO7NXGFkdoxtRnZctW7EU1Bl+5z+tRk/Xd+B0WoSvSJC+ggtdClK
	 Am1oooCVk+NMWsy7VG0+xFz3+pdj36Xb1+XIuSDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Marchand <jmarchan@redhat.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/816] bpf: Specify access type of bpf_sysctl_get_name args
Date: Wed, 25 Nov 2026 15:25:57 +0100
Message-ID: <20261125143849.432749414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Marchand <jmarchan@redhat.com>

[ Upstream commit 2eb7648558a7911f2208e8940cd22ca40e93cc76 ]

The second argument of bpf_sysctl_get_name() helper is a pointer to a
buffer that is being written to. However that isn't specify in the
prototype.

Until commit 37cce22dbd51a ("bpf: verifier: Refactor helper access
type tracking"), all helper accesses were considered as a possible
write access by the verifier, so no big harm was done. However, since
then, the verifier might make wrong asssumption about the content of
that address which might lead it to make faulty optimizations (such as
removing code that was wrongly labeled dead). This is what happens in
test_sysctl selftest to the tests related to sysctl_get_name.

Add MEM_WRITE flag the second argument of bpf_sysctl_get_name().

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250619140603.148942-2-jmarchan@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 0674785e86767..bd47c4cb19910 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -2284,7 +2284,7 @@ static const struct bpf_func_proto bpf_sysctl_get_name_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
-- 
2.53.0



