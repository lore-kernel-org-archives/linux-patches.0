Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063908;
	b=uQwfF4JK5f0BwcJgcNu8oLNPhqeq3R8bhVW2VV3DhDM9JgMIbaLEqSb840tAD7DqDisI
	 gFcy4E+GbTYav1E8s3qROzCwgE3QFiDEAHEtvsFhhnnOx66oVIW/YNLmMHTOfmLE5YuU8
	 lKodvV0fO5AkKYm/16e2RY2iyOHF4hTdJH3YNZye+N6hXK1qEmEvCaLW4+uV5YzuqZNzG
	 tCIkWwVV0ZeULagVnu3yFniOVLZU0mz3t8foM2QiGuYH/SXEqdOsZcA8/Jc4/zgq4NNiQ
	 BQCo7KJgv4WP21JfNjqAN7JE0T4GmjRJPemsB31MpaLO5FiGHSdVktmepN81odpt9sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPsqLW5Fda+jw2FddMzeQPSe5f3guTbYOgd1V46x2l0=;
	b=Tx4ZQ9MuSt/FnpD2tgXHEC/LARVJ64cGp1LcZWYlCVUNaOy4WdgAGs1egz6gVSqnv1M9
	 irX+sQxahNS6ck3Wbuyyd8m34q07EZLM0a8TwJ7Y7Ymgip8olxcOO0lF/Vd7acGusin0k
	 bO9S0rJ+Z6xvUFJSnM63ctg3Sz01oKiTJ0bdsWg9M+aN1xTKlHDfTyK1qvhS7QHsIhJ9X
	 HvgZKekj52ddzy23ZE8IgIvUAiRbUAIYeq9uss05XQTINgSoc/wIF0vw/b64czTZLvOSW
	 JT475orZ7lJmoIPTQvZ6RNlDx7L/3qf+ZBsyhPMb2I5em+HvUs2teg5ucJ6KC/ci1Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OE8HGy9S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F2D606D81A;
	Sat,  7 Nov 2026 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OE8HGy9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1035D1F0089F;
	Sat,  7 Nov 2026 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063908;
	bh=ZPsqLW5Fda+jw2FddMzeQPSe5f3guTbYOgd1V46x2l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OE8HGy9SDWUJFusNkAilLH9MTth8Lnx3NNeR0daMWB0wgHLsXCpusDm2AaI5Otgs4
	 +OU6KeUV7iQyk0TWOJ3kWRP8BK2lqAgLOEVYnwPOvNSRELE97v6DtonLTlqC1Qcow5
	 3pramx585ajhclr96S9J0SXkysdVVDexb6ne1+fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Wang Yan <wangyan01@kylinos.cn>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0107/1257] perf powerpc-vpadtl: Fix off-by-one in auxtrace_info minimum size check
Date: Sat,  7 Nov 2026 08:40:03 -0500
Message-ID: <20261107134942.311060662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit d9c7e2ede92ce258a5d4a6cbc55f75acd379c97d ]

min_sz is set to sizeof(u64) * POWERPC_VPADTL_TYPE, but the code reads
auxtrace_info->priv[POWERPC_VPADTL_TYPE], which needs at least
POWERPC_VPADTL_TYPE + 1 elements.  POWERPC_VPADTL_TYPE is the first
enumerator of the priv index enum (0), so min_sz evaluates to 0 and the
check validates only the perf_record_auxtrace_info header itself.  A
PERF_RECORD_AUXTRACE_INFO event carrying a zero-length priv array then
passes the size check, and the subsequent priv[POWERPC_VPADTL_TYPE]
read runs one u64 past the validated region.

This is the same off-by-one fixed for Intel PT by commit c4362d5e1a5e
("perf intel-pt: Fix off-by-one in auxtrace_info minimum size check")
and for Intel BTS by commit b9fb8225951c ("perf intel-bts: Fix off-by-one
in auxtrace_info minimum size check").

Use sizeof(u64) * (POWERPC_VPADTL_TYPE + 1) so the highest accessed
priv index is covered by the minimum-size validation.

Fixes: c4bbd4ec2e50a9ed ("perf powerpc: Process auxtrace events and display in 'perf report -D'")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/powerpc-vpadtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/powerpc-vpadtl.c b/tools/perf/util/powerpc-vpadtl.c
index af6783cfdb53d..032864e3884af 100644
--- a/tools/perf/util/powerpc-vpadtl.c
+++ b/tools/perf/util/powerpc-vpadtl.c
@@ -683,7 +683,7 @@ int powerpc_vpadtl_process_auxtrace_info(union perf_event *event,
 				  struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * POWERPC_VPADTL_TYPE;
+	size_t min_sz = sizeof(u64) * (POWERPC_VPADTL_TYPE + 1);
 	struct powerpc_vpadtl *vpa;
 	int err;
 
-- 
2.53.0



